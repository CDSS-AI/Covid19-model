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

                   
                    tempVal1 = (calculateRate(sojournTimeNode) * compartmentsDict.get(node))
                    dCompartments[diffName] -= tempVal1
                 
                    #self.equations[latexName] += makeLatexCoefficient(True, matchNameDict(node, VARIABLE), virusIndexNode) + " * " + makeLatexVariableName(node, virusIndexNode) + " + "
                    #nbOfTermsPerLine[latexName] +=1


                    for indexParentNode, parentNode in enumerate(parentNodes, start=0):
                        edgeData = graphProgression.get_edge_data(parentNode, node)
                        sojournTimeParentNode = sojourtimeDict[parentNode]
                        infectioRatioParentNode = infectionRatioDict[parentNode]
                        weightParent = edgeData.get(WEIGHT)
                        virusIndexParent = getNodeVariantIndex(parentNode)
                        variableParent = matchNameDict(parentNode, VARIABLE)
                       
                        tempVal2 = (calculateRate(sojournTimeParentNode) * compartmentsDict.get(parentNode) * weightParent)
                        dCompartments[diffName] += tempVal2
                        
                        #self.equations[latexName] += makeLatexCoefficient(False, matchNameDict(node, VARIABLE), virusIndexNode) + " * " + makeLatexVariableName(parentNode, virusIndexNode)
                        nbOfTermsPerLine[latexName] +=1
                        
                        # if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                        #     self.equations[latexName] += " \\\ " + "&"
                        #     nbOfTermsPerLine[latexName] = 0
                        # if ((indexParentNode+1) < len(parentNodes)):
                        #         self.equations[latexName] += " + "
        


            def getInfectionNodes():
                infectionCompartments = list(graphInfection.nodes())
                for idx, node in enumerate(infectionCompartments, start=0): 

                    predessorsNodes = list(graphInfection.predecessors(node))
                    successorsNodes = list(graphInfection.successors(node))
                    diffName = ('d' + node)
                    latexName = makeLatexFrac(diffName, "dt")
                    virusIndexNode = getNodeVariantIndex(node)
                    infectionRatioNode = infectionRatioDict.get(node)
                    
                    if (successorsNodes): #OK _ CHECK
                        for successorNode in successorsNodes: 
                          edgeData = graphInfection.get_edge_data(node, successorNode)
                          destinationInfection = edgeData.get(DESTINATIONS)
                          resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                          variantOfSuccessorNodeIndex = getNodeVariantIndex(successorNode)
                          allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)
                          
                          tempVal3 = calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=variantOfSuccessorNodeIndex, status=virusIndexNode, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N)  * compartmentsDict.get(node)
                          if (node =='R_1'):
                              outputToFileDebug('THIS MUCH IN R: ' + str(compartmentsDict.get(node)))
                              outputToFileDebug('REMOVED FROM R:' + str(tempVal3))
                          dCompartments[diffName] -= tempVal3
                          #self.equations[latexName] += makeLatexCoefficient(True, matchNameDict(node,'variable'), virusIndexNode) + " * " +  makeLatexVariableName(node, virusIndexNode) 
                          nbOfTermsPerLine[latexName] +=1
                        
                          delta1 = calculateDelta(variantOfSuccessorNodeIndex, viruses, t)
                          if (hasVariant(node) == False): 
                            print(node)
                            dCompartments[diffName] -= delta1
                          
                          #self.equations[latexName] += makeLatexCoefficient(True, matchNameDict(node,'variable'),virusIndexNode)  
                          nbOfTermsPerLine[latexName] +=1

                    elif (hasVariant(node)):
                        for parentNode in predessorsNodes: 
                            edgeData = graphInfection.get_edge_data(parentNode, node)
                            destinationInfection = edgeData.get(DESTINATIONS)
                            resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                            variantOfParentNodeIndex = getNodeVariantIndex(successorNode)
                            allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)

                            lambda4 = calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=virusIndexNode, status=variantOfParentNodeIndex, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N) 
                            tempVal4 = lambda4 * compartmentsDict.get(parentNode)
                            
                            dCompartments[diffName] += tempVal4 
                            TempVal5 = calculateDelta(virusIndexNode, viruses, t)
                            dCompartments[diffName] += TempVal5                           
                            
                            # nbOfTermsPerLine[latexName] +=1
                            # if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                            #     self.equations[latexName] += " \\\ " + "&"
                            #     nbOfTermsPerLine[latexName]

                             # self.equations[latexName] += makeLatexCoefficient(False, (matchNameDict(parentNode,'variable')),(indexVirus +1)) + " * " +  makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                            # nbOfTermsPerLine[latexName] +=1
                            

                      # if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                            #     self.equations[latexName] += " \\\ " + "&"
                            #     nbOfTermsPerLine[latexName] = 0
                #outputToFileDebug("//////////////////////////")
                sum = 0
                for n in compartements: 
                    sum+= compartmentsDict.get(n)
                sum = round(sum, 2)
                if (sum != 1000): 
                    print('LEAK')
                    print(sum)
                #outputToFileDebug("SUM: " + str(sum))


                outputToFileDebug("//////////////////////////")
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

            getInfectionNodes()
            getProgressionNodes()
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
