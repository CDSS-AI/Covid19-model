import json

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from scipy.integrate import odeint

import Virus
from Constants import *
from utils import *

NUMBER_OF_PARAMETERS = 4


class Model: 
    def __init__(self, config):
        self.N = 0
        self.equations = {}
        self.config = config
        self.simulate(
            totPop = self.config.configValues['Setting']["totalPopulation"],
            numberOfDays = self.config.configValues['Setting']["numberOfDays"], 
            viruses = list(self.config.configValues['viruses'].values()), 
            crossResistanceRatio = self.config.configValues['CrossResistanceRatio'], 
            compartements = self.config.configValues['Model']['Compartements'],
            edgesProgression = self.config.configValues['Model']["EdgesProgression"],
            edgesInfection = self.config.configValues['Model']["EdgesInfection"], 
            graphProgression = self.config.configValues['Model']["GraphProgression"], 
            graphInfection = self.config.configValues['Model']["GraphInfection"], 
            sojournTimesDict = self.config.configValues['Model']['SojournTime']
            )


    def makePlot(self, results, compartments, time):
        y_array = []
        for index, name in enumerate(compartments, start=0):
            nameDisplay = NAME_DICTIONNARY[name]['name']
            y_array.append([results[index], nameDisplay])

        makeGraph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')


    def simulate(self, totPop, numberOfDays, viruses, crossResistanceRatio, compartements, edgesProgression, edgesInfection, graphProgression, graphInfection, sojournTimesDict):
        N = totPop
        sortedNodes = sortNodes(compartements)
        S0 = [N]
        E0 = [0] * len(sortedNodes["exposed"])
        I0 = [0] * len(sortedNodes["infected"])
        H0 = [0] * len(sortedNodes["hospitalized"])
        R0 = [0] * len(sortedNodes["recovered"])

        y0 = S0 + E0 + I0 + H0 + R0

        def defSolver(y, t, N, viruses, graphProgression, graphInfection, compartments, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict):
            compartmentsDict = {}
            dCompartments = {}
            yArray = []
            nbOfTermsPerLine = {}
            
            for idx, key in enumerate(y, start=0):  
                 yArray.append(y[idx])
            for node in compartments: 
                for indexVirus, virus in enumerate(viruses, start=0):
                    compartmentsDict[node] = yArray[0]
                    diffName = ("d" + node)
                    dCompartments[diffName] = 0
                    latexName = makeLatexFrac(diffName, "dt", (indexVirus+1)) 
                    self.equations[latexName] = ""
                    nbOfTermsPerLine[latexName] = 0

            progressionCompartemnts = list(graphInfection.nodes())
            for idx, node in enumerate(progressionCompartemnts, start=0): 
                predessorsNodes = list(graphInfection.predecessors(node))
                for parentNode in predessorsNodes: 
                    if (parentNode in edgesInfection):
                        for indexVirus, virus in enumerate(viruses, start=0): 
                            edgeInfection = edgesInfection[parentNode]
                            destinationInfection = edgeInfection.destinations
                            resistanceLevelInfection = edgeInfection.resistanceLevel
                            self.equations[latexName] += ""
                            dCompartments[diffName] += (calculateLambda(compartmentsDict.get(parentNode), virus, resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartmentsDict.get(parentNode))
                            self.equations[latexName] += makeLatexCoefficient(False, (NAME_DICTIONNARY[parentNode]['variable']),(indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                            nbOfTermsPerLine[latexName] +=1
                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                self.equations[latexName] += " \\\ " + "&"
                                nbOfTermsPerLine[latexName] = 0

                            dCompartments[diffName] += calculateDelta(virus, t)
                            self.equations[latexName] += makeLatexCoefficient(False, (NAME_DICTIONNARY[node]['variable']), (indexVirus +1)) 
                            nbOfTermsPerLine[latexName] +=1
                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                self.equations[latexName] += " \\\ " + "&"
                                nbOfTermsPerLine[latexName]
                            dCompartments[diffName] -= (calculateLambda(compartmentsDict.get(node), virus, resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartmentsDict.get(node))
                            self.equations[latexName] += makeLatexCoefficient(True, (NAME_DICTIONNARY[node]['variable']), (indexVirus +1)) + makeLatexVariableName(node, (indexVirus +1)) 
                            nbOfTermsPerLine[latexName] +=1
                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                self.equations[latexName] += " \\\ " + "&"
                                nbOfTermsPerLine[latexName]
                            dCompartments[diffName] -= calculateDelta(virus, t)
                            self.equations[latexName] += makeLatexCoefficient(True, (NAME_DICTIONNARY[node]['variable']),(indexVirus +1))  
                            nbOfTermsPerLine[latexName] +=1
                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                self.equations[latexName] += " \\\ " + "&"
                                nbOfTermsPerLine[latexName] = 0



#graphProgression
            pogressionCompartemnts = list(graphProgression.nodes())
            for idx, node in enumerate(pogressionCompartemnts, start=0):
                parentNodes = list(graphProgression.predecessors(node))
                #print("Node: " + str(node))
                #print("Parent nodes: " + str(parentNodes))
                #print("//////////////////////////////////")
                for indexVirus, virus in enumerate(viruses, start=0): 
                        diffName = ("d" + node)
                        latexName = makeLatexFrac(diffName, "dt", (indexVirus + 1))
                        if (node in edgesProgression):
                            edgeProgressionNode = edgesProgression[node]
                            sojournTimeNode = edgeProgressionNode.sojournTime #epsilon
                            infectionRatioNode = edgeProgressionNode.infectionRatio #theta
                            destinationNodes = edgeProgressionNode.destinations 

                            dCompartments[diffName] += (calculateTheta(sojournTimeNode) * compartmentsDict.get(node))
                            self.equations[latexName] += makeLatexCoefficient(True, ( NAME_DICTIONNARY[node]['variable']), (indexVirus +1)) + makeLatexVariableName(node, (indexVirus +1)) + " + "

                            for indexParentNode, parentNode in enumerate(parentNodes, start=0): 
                                variableNode = NAME_DICTIONNARY[node]['variable']
                                variableParent = NAME_DICTIONNARY[parentNode]['variable']
                                edgeData = graphProgression.get_edge_data(parentNode, node)
                                weightParent = edgeData.get("weight")
                                sojournParentNode = sojournTimesDict[parentNode]
                                dCompartments[diffName] += (calculateMu(sojournParentNode, weightParent) * compartmentsDict.get(node))
                                self.equations[latexName] += makeLatexCoefficient(False, ( NAME_DICTIONNARY[node]['variable']), (indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1))
                                nbOfTermsPerLine[latexName] +=1
                                if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                    self.equations[latexName] += " \\\ " + "&"
                                    nbOfTermsPerLine[latexName] = 0
                                if ((indexParentNode+1) < len(predessorsNodes)):
                                        self.equations[latexName] += " + "

            items = list(dCompartments.values())
            return (items)
        
        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, viruses, graphProgression, graphInfection, compartements, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict))
        results = ret.T
        print(type(results))
        print(results.shape)
        self.makePlot(results, compartements, t)
        
   
    def getEquations(self):
        return self.equations
