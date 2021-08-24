import json

import networkx as nx
import numpy as np

from EdgesInfection import *
from EdgesProgression import *
from Math import *
from utils import *
from Virus import *


class Config: 
    def __init__(self):
        self.configValues = {}
        self.readJSONFile()
        self.generateMatrixFile()

    def readJSONFile(self, filename = "ConfigFileArrows.json"):
        def readFile():
            with open(filename) as f:
                data = json.load(f)
            return data


        def readViruses(data): 
            virusList = {}
            for virus in data["Variants"]["Virus"]:
                virusObj = Virus(
                    name = virus["name"],
                    infectionRate=virus['transmissionRate'], 
                    apparitionPeriod=virus['onsetPeriod'], 
                    apparitionRate=virus['onsetRate']
                    )
                virusList[virus["name"]] = virusObj

            self.configValues['viruses'] = virusList
            self.configValues['CrossResistanceRatio'] = data["Variants"]["CrossResistanceRatio"]

            self.configValues['Setting'] = {
                "totalPopulation" : data["Variants"]["totalPopulation"],
                "numberOfDays" : data["Variants"]["numberOfDays"]
            }
            return virusList
        

        def readModel(data, virusList): 
            self.configValues['Model'] = {}
            graph = nx.DiGraph()
            graphProgression = nx.DiGraph()
            graphInfection = nx.DiGraph()
            nodeList = list()
            try: 
                for node in data["Model"]["Compartements"]: 
                    for indexVirus, virus in enumerate(virusList, start=1):
                        nodeName = makeNodeName(node, str(indexVirus))
                        if (nodeName not in  nodeList):
                            graph.add_node(nodeName)
                            nodeList.append(nodeName)
                    self.configValues['Model']["Compartements"] = nodeList
            except ValueError as e:
                ("Error in parsing the compartment. Please verify that the compartments are well defined.")
                print("Node: " + str(e))
            
            self.configValues["adjacencyMatrix"] = nx.adjacency_matrix(graph, nodelist=self.configValues['Model']["Compartements"]).todense().astype(int)
            return graph, graphProgression, graphInfection
        

        def readProgressionEdges(data, virusList, graphProgression): 
            sojournTimeDict = {}
            infectionRatioDict = {}
            try: 
                for edgePorgression in data["Model"]["EdgesProgression"]:
                    for indexVirus, virus in enumerate(virusList, start=1):
                        edgeName = makeNodeName(edgePorgression[NAME], str(indexVirus))
                        destinations = edgePorgression[DESTINATIONS]
                        weights = []
                        for destination in destinations: 
                            weights.append(destination[WEIGHT])
                        weightNormalized = normalizeWeights(weights)
                        for indexDestination, destination in enumerate(destinations, start=0): 
                            destinationName = makeNodeName(destination[NAME], str(indexVirus))
                            graphProgression.add_edge(edgeName, destinationName, weight=weightNormalized[indexDestination])
                        sojournTimeDict[edgeName] = edgePorgression[SOJOURN_TIME]
                        infectionRatioDict[edgeName] = edgePorgression[INFECTION_RATIO]
                self.configValues['Model']["GraphProgression"] = graphProgression
                self.configValues['Model'][SOJOURN_TIME] = sojournTimeDict
                self.configValues['Model'][INFECTION_RATIO] = infectionRatioDict
            except ValueError as e:
                print("Error in parsing the progression edges. Please verify that these edges correspond to existing nodes.")
                print("Edge: " + str(e))
    
            
        def readInfectionEdges(data, virusList, graphInfection):
            try: 
                self.configValues['Model']["EdgesInfection"] = data["Model"]["EdgesInfection"]
                for edgeInfection in data["Model"]["EdgesInfection"]:
                    for indexVirus, virus in enumerate(virusList, start=1):
                        edgeName = makeNodeName(edgeInfection[NAME], str(indexVirus))
                        destinationName = makeNodeName(edgeInfection[DESTINATIONS],str(indexVirus))
                        resistanceLevel = edgeInfection[RESISTANCE_LEVEL]
                        graphInfection.add_edge(edgeName, destinationName, resistanceLevel=resistanceLevel)
                self.configValues['Model']["GraphInfection"] = graphInfection
            except ValueError as e:
                print("Error in parsing the infection edges. Please verify that these edges correspond to existing nodes.")
                print("Edge: " + str(e))

       
        data = readFile()
        virusList = readViruses(data)
        graph,graphProgression, graphInfection = readModel(data, virusList)
        readProgressionEdges(data, virusList, graphProgression)
        readInfectionEdges(data, virusList, graphInfection)


    def readMatrixFile(self, filename = "ConfigFileMatrix_Generated.txt"):
        f = open(filename, "r")
        keeping = False
        matrix = []
        for x in f:
            if keeping == True:
                values = x.replace("\n", "").split()
                matrix.append([float(i) for i in values])
            if x == "InfecionMatrix:\n":
                keeping = True
        self.configValues["adjacencyMatrix"] = np.asmatrix(np.array(matrix))




    def generateMatrixFile(self):
        f = open("ConfigFileMatrix_Generated.txt", "w")
        f.write("##########################################" + "\n")
        f.write("##########################################"+ "\n" + "\n")
        f.write("##This is a generated text file to represent the model structure in a sparse matrix form. "+ "\n")
        f.write("##COL x COL, 0=NoLink, 1=FowardLink "+ "\n" + "\n")
        f.write("##Columns :  "+ "\n")
        f.write(str(self.configValues['Model']["Compartements"])+ "\n")
        f.write("##########################################"+ "\n")
        f.write("##########################################"+ "\n" + "\n")
        f.write("InfecionMatrix:"+ "\n")
        for line in self.configValues["adjacencyMatrix"]:
            np.savetxt(f, line, fmt='%.0f')
        f.close()
        
