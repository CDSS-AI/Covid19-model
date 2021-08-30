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
        y_array_exposed = []
        for index, name in enumerate(compartments, start=0):
            virusIndex = re.sub("[^0-9]", "", name)
            nameDisplay = matchNameDict(name,'name') + ": " + str(virusIndex)
            y_array.append([results[index], nameDisplay])
            if ("Exposed" in nameDisplay): 
                y_array_exposed.append([results[index], nameDisplay])
           

        makeGraph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')
        makeGraph(time, y_array_exposed, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')



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
                    
                    if (successorsNodes): 
                        for successorNode in successorsNodes: 
                          outputToFileDebug("//////////////////////////")
                          edgeData = graphInfection.get_edge_data(node, successorNode)
                          outputToFileDebug("SuccessorNode (var): " + str(successorNode) + " // node (status) : " + str(node) + " // virusIndexNode (status): " + str(virusIndexNode))
                          resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                          outputToFileDebug("Resistance Level: " + str(resistanceLevelInfection))
                          variantOfSuccessorNodeIndex = getNodeVariantIndex(successorNode)
                          outputToFileDebug("Variant of successorNode (var): " + str(variantOfSuccessorNodeIndex))
                          allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)
                          
                          tempVal3 = calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=variantOfSuccessorNodeIndex, status=virusIndexNode, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N)  * compartmentsDict.get(node)
                          dCompartments[diffName] -= tempVal3
                          outputToFileDebug("Removed " + str(tempVal3) + " from: " + str(node))
                          #self.equations[latexName] += makeLatexCoefficient(True, matchNameDict(node,'variable'), virusIndexNode) + " * " +  makeLatexVariableName(node, virusIndexNode) 
                          nbOfTermsPerLine[latexName] +=1
                        
                          if (hasVariant(node) == False): 
                            delta1 = calculateDelta(variantOfSuccessorNodeIndex, viruses, t)
                            dCompartments[diffName] -= delta1
                          
                          #self.equations[latexName] += makeLatexCoefficient(True, matchNameDict(node,'variable'),virusIndexNode)  
                          nbOfTermsPerLine[latexName] +=1
                          outputToFileDebug("//////////////////////////")

                    elif (hasVariant(node)):
                        for parentNode in predessorsNodes: 
                            outputToFileDebug("//////////////////////////")
                            edgeData = graphInfection.get_edge_data(parentNode, node)
                            outputToFileDebug("ParentNode (status): " + str(parentNode) + " // node: " + str(node) + " // virusIndexNode (var): " + str(virusIndexNode))
                            resistanceLevelInfection = edgeData.get(RESISTANCE_LEVEL)
                            outputToFileDebug("Resistance Level: " + str(resistanceLevelInfection))
                            variantOfParentNodeIndex = getNodeVariantIndex(parentNode)
                            outputToFileDebug("Variant of parent node (status): " + str(variantOfParentNodeIndex))
                            allVariantsCompartements = getAllCompartementsWithVariants(variantOfSuccessorNodeIndex, compartmentsDict)
                            lambda4 = calculateLambda(compartements = compartmentsDict, crossResistanceRatio=crossResistanceRatio, var=virusIndexNode, status=variantOfParentNodeIndex, resistanceLevel=resistanceLevelInfection, infectionRatioDict=infectionRatioDict, viruses=viruses, N=N) 
                            tempVal4 = lambda4 * compartmentsDict.get(parentNode)
                            outputToFileDebug("Addded " + str(tempVal4) + str(node))
                            dCompartments[diffName] += tempVal4 
                            if (hasVariant(parentNode) == False): 
                                dCompartments[diffName] += calculateDelta(virusIndexNode, viruses, t)
                            outputToFileDebug("//////////////////////////")
                                                         
                            
                            # nbOfTermsPerLine[latexName] +=1
                            # if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                            #     self.equations[latexName] += " \\\ " + "&"
                            #     nbOfTermsPerLine[latexName]

                             # self.equations[latexName] += makeLatexCoefficient(False, (matchNameDict(parentNode,'variable')),(indexVirus +1)) + " * " +  makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                            # nbOfTermsPerLine[latexName] +=1
                            

                      # if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                            #     self.equations[latexName] += " \\\ " + "&"
                            #     nbOfTermsPerLine[latexName] = 0
                sum = 0
                for n in compartements: 
                    sum+= compartmentsDict.get(n)
                sum = round(sum, 0)
                if (abs(sum - N) > 5): 
                    print('LEAK')
                    print(sum)

                outputToFileDebug("////////////////////////////////////////////////////////////////////////////////////////////////////////")

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
