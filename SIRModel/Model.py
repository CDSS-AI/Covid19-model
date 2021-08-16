import json

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
from scipy.integrate import odeint

import Virus
from utils import *


class Model: 
    def __init__(self, config):
        self.N = 0
        self.equations = {}
        self.config = config
        self.simulate(
            totPop = self.config.configValues['Setting']["totalPopulation"],
            numberOfDays = self.config.configValues['Setting']["numberOfDays"], 
            viruses = list(self.config.configValues['viruses'].values()), 
            crossInfectionMatrix = self.config.configValues['CrossResistanceRatio'], 
            nodes = self.config.configValues['Model']['Compartements'],
            flowMatrix = self.config.configValues["adjacencyMatrix"],
            graph = self.config.configValues["graph"]
            )


    def makePlot(self, susceptible, viruses, recovered, time):
        y_array = []
        y_array.append([susceptible, "Susceptible"])
        for idx, virus in enumerate(viruses, start=0):  
             y_array.append([virus, ("Infected " + str(idx))])
        for idx, recover in enumerate(recovered, start=0):  
             y_array.append([recover, ("Recovered " + str(idx))])
        graph(time, y_array, 'Epidemiological Model in a population', 'Time (Days)', 'Number of persons')


    def simulate(self, totPop, numberOfDays, viruses, crossInfectionMatrix, nodes, flowMatrix, graph):
        N = totPop
        sortedNodes = sortNodes(nodes)
        S0 = [N]
        E0 = [0] * len(sortedNodes["exposed"])
        I0 = [0] * len(sortedNodes["infected"])
        H0 = [0] * len(sortedNodes["hospitalized"])
        R0 = [0] * len(sortedNodes["recovered"])
  
        infectionRates = []
        apparitionPeriod = []
        apparitionRate = []
        for idx, virus in enumerate(viruses, start=0):  
            infectionRates.append(virus.infectionRate) 
            apparitionPeriod.append(virus.apparitionPeriod)
            apparitionRate.append(virus.apparitionRate)
        
        y0 = S0 + E0 + I0 + H0 + R0

        def defSolver(y, t, N, infectionRates, apparitionPeriod, apparitionRate, sortedNodes):
            compartments = {}
            dCompartments = {}
            yArray = []

            for idx, key in enumerate(y, start=0):  
                 yArray.append(y[idx])

            for key, value in sortedNodes.items(): 
                for node in sortedNodes[key]:  
                    compartments[node] = yArray[0]
                    diffName = ("d" + node)
                    dCompartments[diffName] = 0
                    latexName = r'\frac{' + diffName + r'}{dt}' 
                    self.equations[latexName] = ""

            #compartments
            #dCompartments
            #infectionRates
            #apparitionPeriod
            #apparitionRate
            susceptible = sortedNodes["susceptible"]
            exposed = sortedNodes['exposed']
            infected = sortedNodes['infected']
            hospitalized = sortedNodes['hospitalized']
            recovered = sortedNodes['recovered'] 

            for idx, node in enumerate(susceptible, start=0): 
                diffName = ("d" + node)
                latexName = r'\frac{' + diffName + r'}{dt}' 
                #fixed constant
                self.equations[latexName] += (r'\frac{' + node + r'}{N}') + "-" + " \delta_{" + str(idx) + "}" + " "
                connectedNodes = nx.all_neighbors(graph, node)
                for index, node in enumerate(connectedNodes, start=0): 
                    dCompartments[diffName] += (compartments.get(node) * compartments.get("S") / N)
                     #- (apparitionRate[index] * (int(t >= apparitionPeriod[index][0]) *  int(t < apparitionPeriod[index][1])))
                    self.equations[latexName] += (" * ") + (r'-\beta_{' + str(index + 1)) + "}" + "*" + str(node)
            
            for idx, node in enumerate(exposed, start=0): 
                diffName = ("d" + node)
                latexName = r'\frac{' + diffName + r'}{dt}' 
                #fixed constant
                self.equations[latexName] += (r'\frac{' + node + r'}{N}') + "-" + " \delta_{" + str(idx) + "}" + " "
                connectedNodes = nx.all_neighbors(graph, node)
                for index, node in enumerate(connectedNodes, start=0): 
                    dCompartments[diffName] += compartments.get(node)
                     #- (apparitionRate[index] * (int(t >= apparitionPeriod[index][0]) *  int(t < apparitionPeriod[index][1])))
                    self.equations[latexName] += (" * ") + (r'-\beta_{' + str(index + 1)) + "}" + "*" + str(node)
            
            for idx, node in enumerate(infected, start=0): 
                diffName = ("d" + node)
                latexName = r'\frac{' + diffName + r'}{dt}' 
                #fixed constant
                self.equations[latexName] += (r'\frac{' + node + r'}{N}') + "-" + " \delta_{" + str(idx) + "}" + " "
                connectedNodes = nx.all_neighbors(graph, node)
                for index, node in enumerate(connectedNodes, start=0): 
                    try: 
                        dCompartments[diffName] += compartments.get(node) 
                        #- (apparitionRate[index] * (int(t >= apparitionPeriod[index][0]) *  int(t < apparitionPeriod[index][1])))
                        self.equations[latexName] += (" * ") + (r'-\beta_{' + str(index + 1)) + "}" + "*" + str(node)
                    except: 
                        print("error in building the equation")

            # for idx, node in enumerate(hospitalized, start=0): 
            #     diffName = ("d" + node)
            #     latexName = r'\frac{' + diffName + r'}{dt}' 
            #     #fixed constant
            #     self.equations[latexName] += (r'\frac{' + node + r'}{N}') + "-" + " \delta_{" + str(idx) + "}" + " "
            #     connectedNodes = nx.all_neighbors(graph, node)
            #     for index, node in enumerate(connectedNodes, start=0): 
            #         dCompartments[diffName] += compartments.get(node) 
            #          #- (apparitionRate[index] * (int(t >= apparitionPeriod[index][0]) *  int(t < apparitionPeriod[index][1])))
            #         self.equations[latexName] += (" * ") + (r'-\beta_{' + str(index + 1)) + "}" + "*" + str(node)

            # for idx, node in enumerate(recovered, start=0): 
            #     diffName = ("d" + node)
            #     latexName = r'\frac{' + diffName + r'}{dt}' 
            #     #fixed constant
            #     self.equations[latexName] += (r'\frac{' + node + r'}{N}') + "-" + " \delta_{" + str(idx) + "}" + " "
            #     connectedNodes = nx.all_neighbors(graph, node)
            #     for index, node in enumerate(connectedNodes, start=0): 
            #         dCompartments[diffName] += compartments.get(node) 
            #          #- (apparitionRate[index] * (int(t >= apparitionPeriod[index][0]) *  int(t < apparitionPeriod[index][1])))
            #         self.equations[latexName] += (" * ") + (r'-\beta_{' + str(index + 1)) + "}" + "*" + str(node)

            print(self.equations)
            #print(dCompartments)
            items = list(dCompartments.values())
            return (items)
        
        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, infectionRates, apparitionPeriod, apparitionRate, sortedNodes))
        results = ret.T
        #self.makePlot(S, viruses, recovered, t)
        
   
    def getEquations(self):
        return self.equations
