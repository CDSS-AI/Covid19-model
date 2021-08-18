import json

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from scipy.integrate import odeint

import Virus
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
            sojournTimesDict = self.config.configValues['Model']['SojournTime']
            )


    def makePlot(self, results, time):
        
        y_array = []
        y_array.append([results[0], ("Susceptible")])
        y_array.append([results[1], ("Exposed")])
        y_array.append([results[2], ("InfectedPresymptomatic")])
        y_array.append([results[3], ("InfectedSymtpmaticSevere")])
        y_array.append([results[4], ("InfectedSymtpmaticMild")])
        y_array.append([results[5], ("InfectedAsymptomatic")])
        y_array.append([results[6], ("HospitalizedMild")])
        y_array.append([results[7], ("HospitalizedServe")])
        y_array.append([results[7], ("Recovered")])

       # "S", "E", "I_PRE", "I_SYMP_S", "I_SYMP_M", "I_ASYMP", "HOSP_M", "HOSP_S", "R"
        

       


        # for idx, virus in enumerate(viruses, start=0):  
        #      y_array.append([virus, ("Infected " + str(idx))])
        # for idx, recover in enumerate(recovered, start=0):  
        #      y_array.append([recover, ("Recovered " + str(idx))])
        graph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')


    def simulate(self, totPop, numberOfDays, viruses, crossResistanceRatio, compartements, edgesProgression, edgesInfection, graph, sojournTimesDict):
        N = totPop
        sortedNodes = sortNodes(compartements)
        S0 = [N]
        E0 = [0] * len(sortedNodes["exposed"])
        I0 = [0] * len(sortedNodes["infected"])
        H0 = [0] * len(sortedNodes["hospitalized"])
        R0 = [0] * len(sortedNodes["recovered"])

        y0 = S0 + E0 + I0 + H0 + R0
        # print(crossResistanceRatio)
        # print(edgesProgression)
        # print(edgesInfection)

        def defSolver(y, t, N, viruses, graph, compartements, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict):
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
                    self.equations[latexName] += (makeLatexFrac(connectedNodeS, "N", indexNumerator=(indexVirus+1), negative=negative) + makeLatexVariable(False, "delta", (indexVirus + 1)))
                


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
                        self.equations[latexName] += makeLatexVariable(False, "Theta", (indexVirus +1)) + makeLatexVariableName(compartementNode, (indexVirus +1)) + " + "

                        for indexParentNode, parentNode in enumerate(predessorsNodes, start=0): 
                            if (parentNode != "S"):
                                edgeData = graph.get_edge_data(parentNode, compartementNode)
                                weightParent = edgeData.get("weight")
                                sojournParentNode = sojournTimesDict[parentNode]
                                dCompartments[diffName] += (calculateMu(sojournParentNode, weightParent) * compartments.get(compartementNode))
                                self.equations[latexName] += makeLatexVariable(False, "mu", (indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                                nbOfTermsPerLine[latexName] +=1
                                if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                    self.equations[latexName] += " \\\ " + "&"
                                    nbOfTermsPerLine[latexName] = 0
                                
                                if (parentNode == "S" or parentNode == "R"):
                                    edgeInfection = edgesInfection[parentNode]
                                    destinationInfection = edgeInfection.destinations
                                    resistanceLevelInfection = edgeInfection.resistanceLevel

                                    dCompartments[diffName] += (calculateLambda(resistanceLevelInfection, indexVirus, N, crossResistanceRatio) * compartments.get(compartementNode))
                                    self.equations[latexName] += makeLatexVariable(False, "Lambda", (indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1)) + " + "
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0
                                  
                                    dCompartments[diffName] += calculateDelta(virus, t)
                                    self.equations[latexName] += makeLatexVariable(False, "delta", (indexVirus +1))  + " - "
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0

                                    dCompartments[diffName] -= 1
                                    self.equations[latexName] += makeLatexVariable(False, "Lambda", (indexVirus +1)) + makeLatexVariableName(parentNode, (indexVirus +1)) + " - "
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0

                                    dCompartments[diffName] -= calculateDelta(virus, t)
                                    self.equations[latexName] += makeLatexVariable(False, "delta", (indexVirus +1))  
                                    nbOfTermsPerLine[latexName] +=1
                                    if (nbOfTermsPerLine[latexName] > NUMBER_OF_PARAMETERS ): 
                                        self.equations[latexName] += " \\\ " + "&"
                                        nbOfTermsPerLine[latexName] = 0

                                    if ((indexParentNode+1) < len(predessorsNodes)):
                                        self.equations[latexName] += " + "

            items = list(dCompartments.values())
            return (items)
        
        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, viruses, graph, compartements, crossResistanceRatio, edgesProgression, edgesInfection, sojournTimesDict))
        results = ret.T
        print(type(results))
        print(results.shape)

        self.makePlot(results, t)
        
   
    def getEquations(self):
        return self.equations
