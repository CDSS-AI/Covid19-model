import json

import networkx as nx
import numpy as np

from EdgesInfection import *
from EdgesProgression import *
from utils import *
from Virus import *


class Config: 
    def __init__(self):
        self.configValues = {}
        self.readJSONFile()
        self.generateMatrixFile()

    def readJSONFile(self, filename = "ConfigFileArrows.json"):
        #Reading JSON file
        with open(filename) as f:
            data = json.load(f)

        #Reading Virus information
        virusList = {}
        for virus in data["Variants"]["Virus"]:
            virusObj = Virus(
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

        self.configValues['Model'] = {}
        graph = nx.DiGraph()
        graphProgression = nx.DiGraph()
        graphInfection = nx.DiGraph()
        try: 
            self.configValues['Model']["Compartements"] = data["Model"]["Compartements"]
            for node in self.configValues['Model']["Compartements"]: 
                graph.add_node(node)
        except ValueError as e:
            print("Error in parsing the compartment. Please verify that the compartments are well defined.")
            print("Node: " + str(e))
        edgePorgressionDict = {}
        edgeInfectionDict = {}
        sojournTimesDict = {}
        try: 
            for edgePorgression in data["Model"]["EdgesProgression"]:
                edgeName = edgePorgression["name"]
                destinationDict = {}
                destinations = edgePorgression["destinations"]
                for destination in destinations: 
                    destinationDict[destination["name"]] = destination["weight"]
                    graph.add_edge(edgeName, destination["name"], weight=destination["weight"])
                    graphProgression.add_edge(edgeName, destination["name"], weight=destination["weight"])
                edgePorgressionObj = EdgesProgression(
                    sojournTime=edgePorgression["sojournTime"],
                    infectionRatio=edgePorgression["infectionRatio"],
                    destinations=destinationDict
                    )
                sojournTimesDict[edgeName] = edgePorgression["sojournTime"]
                edgePorgressionDict[edgeName] = edgePorgressionObj

            self.configValues['Model']["EdgesProgression"] = edgePorgressionDict
            self.configValues['Model']['SojournTime'] = sojournTimesDict
        except ValueError as e:
            print("Error in parsing the progression edges. Please verify that these edges correspond to existing nodes.")
            print("Edge: " + str(e))
        
        
        try: 
            self.configValues['Model']["EdgesInfection"] = data["Model"]["EdgesInfection"]

            for edgeInfection in data["Model"]["EdgesInfection"]:
                edgeName = edgeInfection["name"]
                edgeInfectionObj = EdgesInfection(
                    resistanceLevel=edgeInfection["resistanceLevel"],
                    destinations=edgeInfection["destination"]
                    )
                edgeInfectionDict[edgeName] = edgeInfectionObj
                graph.add_edge(edgeName, edgeInfection["destination"], weight=edgeInfection["resistanceLevel"])
                graphInfection.add_edge(edgeName, edgeInfection["destination"], weight=edgeInfection["resistanceLevel"])
            self.configValues['Model']["EdgesInfection"] = edgeInfectionDict
        except ValueError as e:
            print("Error in parsing the infection edges. Please verify that these edges correspond to existing nodes.")
            print("Edge: " + str(e))

        self.configValues['Model']["graph"] = graph
        self.configValues['Model']["GraphProgression"] = edgePorgressionDict
        self.configValues['Model']["GraphInfection"] = graphInfection
        
        self.configValues["adjacencyMatrix"] = nx.adjacency_matrix(graph, nodelist=self.configValues['Model']["Compartements"]).todense().astype(int)

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
        
