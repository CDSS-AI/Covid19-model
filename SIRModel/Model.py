import json
import math
import re

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from scipy.integrate import odeint

import Virus
from Constants import *
from Math import *
from utils import *

NUMBER_OF_PARAMETERS = 7


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
            graphProgression = self.config.configValues['Model']["GraphProgression"], 
            graphInfection = self.config.configValues['Model']["GraphInfection"], 
            compartements=self.config.configValues['Model']['Compartements'], 
            sojourtimeDict=self.config.configValues['Model'][SOJOURN_TIME], 
            infectionRatioDict = self.config.configValues['Model'][INFECTION_RATIO]
            )


    def makePlot(self, results, compartments, time):
        y_array = []
        for index, name in enumerate(compartments, start=0):
            virusIndex = re.sub("[^0-9]", "", name)
            nameDisplay = matchNameDict(name,'name') + ": " + str(virusIndex)
            y_array.append([results[index], nameDisplay])

        makeGraph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')


    def simulate(self, totPop, numberOfDays, viruses, crossResistanceRatio, graphProgression, graphInfection, compartements, sojourtimeDict, infectionRatioDict):
        def defSolver(y, t, N, viruses, graphProgression, graphInfection, crossResistanceRatio, compartements, sojourtimeDict, infectionRatioDict):
            
            def getProgressionNodes():  
                progressionCompartements = list(graphProgression.nodes())
                for idx, node in enumerate(progressionCompartements, start=0):
                    sojournTimeNode = sojourtimeDict.get(node)
                    infectioRatioNode = infectionRatioDict.get(node)
                    virusIndexNode = getNodeVariantIndex(node)
                    parentNodes = list(graphProgression.predecessors(node))
                    variableNode = matchNameDict(node, VARIABLE)
                    diffName = ('d' + node)
                    latexName = makeLatexFrac(diffName, "dt")

                   
                    dCompartments[diffName] -= (calculateRate(sojournTimeNode) * compartmentsDict.get(node))
                    self.equations[latexName] += makeLatexCoefficient(True, variableNode, index=virusIndexNode) + " " + makeLatexVariableName(node)
                    nbOfTermsPerLine[latexName] += 1

                    for indexParentNode, parentNode in enumerate(parentNodes, start=0):
                        edgeData = graphProgression.get_edge_data(parentNode, node)
                        sojournTimeParentNode = sojourtimeDict[parentNode]
                        infectioRatioParentNode = infectionRatioDict[parentNode]
                        weightParent = edgeData.get(WEIGHT)
                        virusIndexParent = getNodeVariantIndex(parentNode)
                        variableParent = matchNameDict(parentNode, VARIABLE)
                        self.equations[latexName] += " + "
                        dCompartments[diffName] += (calculateRate(sojournTimeParentNode) * compartmentsDict.get(parentNode) * weightParent)
                        self.equations[latexName] += makeLatexCoefficient(False, variableParent, index=virusIndexParent) + " " + makeLatexVariableName(parentNode)
                        nbOfTermsPerLine[latexName] +=1

                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                        self.equations[latexName] += " \\\ " + "&"
                        nbOfTermsPerLine[latexName] = 0

            def getInfectionNodes():
                infectionCompartments = list(graphInfection.nodes())
                for idx, node in enumerate(infectionCompartments, start=0): 

                    predessorsNodes = list(graphInfection.predecessors(node))
                    successorsNodes = list(graphInfection.successors(node))
                    diffName = ('d' + node)
                    latexName = makeLatexFrac(diffName, "dt")
                    virusIndexNode = getNodeVariantIndex(node)
                    infectionRatioNode = infectionRatioDict.get(node)
                    
                    if (successorsNodes): 
                        for successorNode in successorsNodes: 
                            edgeData = graphInfection.get_edge_data(node, successorNode)
                            destinationInfection = edgeData.get(DESTINATIONS)
                            resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                            variantOfSuccessorNodeIndex = getNodeVariantIndex(successorNode)
                            allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)

                            dCompartments[diffName] -= calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=variantOfSuccessorNodeIndex, status=virusIndexNode, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N)  * compartmentsDict.get(node)
                            if (hasVariant(node)):
                                self.equations[latexName] += makeLatexCoefficient(True, 'Lambda', index=virusIndexNode) + " " +  makeLatexVariableName(node) 
                                nbOfTermsPerLine[latexName] += 1
                        
   
                            self.equations[latexName] += " "
                            dCompartments[diffName] -= calculateDelta(variantOfSuccessorNodeIndex, viruses, t)
                            self.equations[latexName] += makeLatexCoefficient(True, 'delta', index=variantOfSuccessorNodeIndex)                         
                            nbOfTermsPerLine[latexName] +=1
                        
                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                 self.equations[latexName] += " \\\ " + "&"
                                 nbOfTermsPerLine[latexName] = 0

                    elif (hasVariant(node)):
                        for parentNode in predessorsNodes: 
                            edgeData = graphInfection.get_edge_data(parentNode, node)
                            destinationInfection = edgeData.get(DESTINATIONS)
                            resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                            variantOfParentNodeIndex = getNodeVariantIndex(successorNode)
                            allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)

                            self.equations[latexName] += " + "   
                            dCompartments[diffName] += calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=virusIndexNode, status=variantOfParentNodeIndex, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N)  * compartmentsDict.get(parentNode)
                            self.equations[latexName] += makeLatexCoefficient(False, 'Lambda') + " " +  makeLatexVariableName(parentNode) 
                            if (hasVariant(parentNode) == False): 
                                print('here')
                                dCompartments[diffName] += calculateDelta(virusIndexNode, viruses, t)
                                self.equations[latexName] += " + "
                                self.equations[latexName] += makeLatexCoefficient(False, 'delta', index=virusIndexNode)  
                                nbOfTermsPerLine[latexName] += 1

                            if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS): 
                                self.equations[latexName] += " \\\ " + "&"
                                nbOfTermsPerLine[latexName] = 0

                outputToFileDebug('////////////////////////////')
                sum = 0
                for n in compartements:
                    sum += compartmentsDict.get(n)
                sum = round(sum, 0)
                if (abs(sum - N) > 5):
                    print("LEAK")
                    print(sum)                


            compartmentsDict = {}
            dCompartments = {}
            yArray = []
            nbOfTermsPerLine = {}
            yArray = y.copy()


            for idx, node in enumerate(compartements, start=0): 
                compartmentsDict[node] = yArray[idx]
                diffName = ("d" + node)
                dCompartments[diffName] = 0
                latexName = makeLatexFrac(diffName, "dt") 
                self.equations[latexName] = ""
                nbOfTermsPerLine[latexName] = 0

            getProgressionNodes()
            getInfectionNodes()
            items = list(dCompartments.values())
            return (items)
        
        N = totPop
        sortedNodes, nodes = sortNodes(compartements)
        S0 = [N]
        E0 = [0] * len(sortedNodes["exposed"])
        I0 = [0] * len(sortedNodes["infected"])
        H0 = [0] * len(sortedNodes["hospitalized"])
        R0 = [0] * len(sortedNodes["recovered"])
        y0 = S0 + E0 + I0 + H0 + R0

        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, viruses, graphProgression, graphInfection, crossResistanceRatio, nodes, sojourtimeDict, infectionRatioDict))
        results = ret.T
        self.makePlot(results, compartements, t)
        
   
    def getEquations(self):
        return self.equations
