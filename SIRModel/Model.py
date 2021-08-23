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
            graph = self.config.configValues['Model']['graph'],
            graphProgression = self.config.configValues['Model']["GraphProgression"], 
            graphInfection = self.config.configValues['Model']["GraphInfection"], 
            sojournTimesDict = self.config.configValues['Model']['SojournTime']
            )


    def makePlot(self, results, compartments, time):
        y_array = []
        for index, name in enumerate(compartments, start=0):
            nameDisplay = NAME_DICTIONNARY[name]['name']
            y_array.append([results[index], nameDisplay])

        graph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')


    def simulate(self, totPop, numberOfDays, viruses, crossResistanceRatio, compartements, edgesProgression, edgesInfection, graph, graphProgression, graphInfection, sojournTimesDict):
        N = totPop
        sortedNodes = sortNodes(compartements)
        S0 = [N]
        E0 = [0] * len(sortedNodes["exposed"])
        I0 = [0] * len(sortedNodes["infected"])
        H0 = [0] * len(sortedNodes["hospitalized"])
        R0 = [0] * len(sortedNodes["recovered"])

        y0 = S0 + E0 + I0 + H0 + R0

        def defSolver(y, t, N, viruses, graph, graphProgression, graphInfection, compartements, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict):
            compartments = {}
            dCompartments = {}
            yArray = []
            nbOfTermsPerLine = {}
            
            for idx, key in enumerate(y, start=0):  
                 yArray.append(y[idx])
            for node in compartements: 
                if (node != "S"):
                    for indexVirus, virus in enumerate(viruses, start=0):
                        compartments[node] = yArray[0]
                        diffName = ("d" + node)
                        dCompartments[diffName] = 0
                        latexName = makeLatexFrac(diffName, "dt", (indexVirus+1)) 
                        self.equations[latexName] = ""
                        nbOfTermsPerLine[latexName] = 0


            diffName = ("d" + "S")
            dCompartments[diffName] = 0
            NodeS = compartements[0]
            latexName = makeLatexFrac(diffName, "dt")
            self.equations[latexName] = ""
            connectedNodesS = nx.all_neighbors(graph, NodeS)
            for connectedNodeS in connectedNodesS: 
                for indexVirus, virus in enumerate(viruses, start=0):
                    dCompartments[diffName] += ((-1 * compartments.get(connectedNodeS)) * virus.infectionRate * (-1 * (virus.apparitionRate * (int(t >= virus.apparitionPeriod[0]) *  int(t < virus.apparitionPeriod[1])))))
                    negative = False
                    if (connectedNodeS == "E"): 
                        negative = True
                    self.equations[latexName] += (makeLatexFrac(connectedNodeS, "N", indexNumerator=(indexVirus+1), negative=negative) + makeLatexVariable(False, "delta", "", (indexVirus + 1)))
                


            for idx, compartementNode in enumerate(compartements, start=0):
                for indexVirus, virus in enumerate(viruses, start=0): 
                    if (compartementNode != "S"):
                        diffName = ("d" + compartementNode)
                        latexName = makeLatexFrac(diffName, "dt", (indexVirus + 1))
                        connectedNodes = nx.all_neighbors(graph, compartementNode)
                        predessorsNodes = list(graph.predecessors(compartementNode))

                        edgesProgressionNode = edgesProgression[compartementNode]
                        sojournTimeNode = edgesProgressionNode.sojournTime #epsilon
                        infectionRatioNode = edgesProgressionNode.infectionRatio #theta
                        destinationNodes = edgesProgressionNode.destinations 

                        dCompartments[diffName] += (calculateTheta(sojournTimeNode) * compartments.get(compartementNode))
                        self.equations[latexName] += makeLatexVariable(True, "Theta", compartementNode, (indexVirus +1)) + makeLatexVariableName(compartementNode, (indexVirus +1)) + " + "

                        for indexParentNode, parentNode in enumerate(predessorsNodes, start=0): 
                            if (parentNode != "S"):
                                variableNode = NAME_DICTIONNARY[compartementNode]['variable']
                                variableParent = NAME_DICTIONNARY[parentNode]['variable']
                                edgeData = graph.get_edge_data(parentNode, compartementNode)
                                weightParent = edgeData.get("weight")
                                sojournParentNode = sojournTimesDict[parentNode]
                                dCompartments[diffName] += (calculateMu(sojournParentNode, weightParent) * compartments.get(compartementNode))
                                self.equations[latexName] += makeLatexVariable(False, variableNode, compartementNode, (indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1))
                                nbOfTermsPerLine[latexName] +=1
                                if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                    self.equations[latexName] += " \\\ " + "&"
                                    nbOfTermsPerLine[latexName] = 0

                                if ((indexParentNode+1) < len(predessorsNodes)):
                                        self.equations[latexName] += " + "
                                
                                if (parentNode == "S" or parentNode == "R"):
                                    if (compartementNode == "R"): 
                                        print(predessorsNodes)
                                    edgeInfection = edgesInfection[parentNode]
                                    destinationInfection = edgeInfection.destinations
                                    resistanceLevelInfection = edgeInfection.resistanceLevel
                                    self.equations[latexName] += " + "

                                    dCompartments[diffName] += (calculateLambda(compartments.get(parentNode), virus, resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartments.get(parentNode))
                                    self.equations[latexName] += makeLatexVariable(False, variableParent, parentNode,(indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0
                                  
                                    dCompartments[diffName] += calculateDelta(virus, t)
                                    self.equations[latexName] += makeLatexVariable(False, variableNode, compartementNode, (indexVirus +1)) 
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0

                                    dCompartments[diffName] -= (calculateLambda(compartments.get(compartementNode), virus, resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartments.get(compartementNode))
                                    self.equations[latexName] += makeLatexVariable(True, "Lambda", compartementNode, (indexVirus +1)) + makeLatexVariableName(compartementNode, (indexVirus +1)) 
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0

                                    dCompartments[diffName] -= calculateDelta(virus, t)
                                    self.equations[latexName] += makeLatexVariable(True, variableNode, compartementNode,(indexVirus +1))  
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0
                                # else: 
                                #     dCompartments[diffName] -= (calculateLambda(compartments.get(compartementNode), virus, resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartments.get(compartementNode))
                                #     self.equations[latexName] += makeLatexVariable(True, "Lambda", (indexVirus +1)) + makeLatexVariableName(compartementNode, (indexVirus +1)) 
                                #     nbOfTermsPerLine[latexName] +=1
                                #     if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                #         self.equations[latexName] += " \\\ " + "&"
                                #         nbOfTermsPerLine[latexName] = 0

                                #     dCompartments[diffName] -= calculateDelta(virus, t)
                                #     self.equations[latexName] += makeLatexVariable(True, "delta", (indexVirus +1))  
                                #     nbOfTermsPerLine[latexName] +=1
                                #     if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                #         self.equations[latexName] += " \\\ " + "&"
                                #         nbOfTermsPerLine[latexName] = 0

                                    # if ((indexParentNode+1) < len(predessorsNodes)):
                                    #     self.equations[latexName] += " + "

            items = list(dCompartments.values())
            return (items)
        
        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, viruses, graph, graphProgression, graphInfection, compartements, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict))
        results = ret.T
        print(type(results))
        print(results.shape)
        self.makePlot(results, compartements, t)
        
   
    def getEquations(self):
        return self.equations
