import getopt
import json
import sys

import numpy as np

import Virus
from EquationsGenerator import EquationsGenerator
from GraphGenerator import GraphGenerator
from Model import Model
from utils import *


def readConfig(): 
    virusesParsed = []
    totalPopulation = 0
    numberOfDays = 0
    with open('ModelConfigs.json') as json_file:
        data = json.load(json_file)
        viruses = data['Virus']
        totalPopulation = data['totalPopulation']
        numberOfDays = data['numberOfDays']
        crossInfectionMatrix = data["CrossInfectionMatrix"]
        for virus in viruses: 
            virusesParsed.append(Virus(virus.get('infectionRate'), virus.get('recoveryRate'), virus.get('numberInitInfected'), virus.get('apparitionPeriod'), virus.get('apparitionRate')))
    
    return totalPopulation, numberOfDays, virusesParsed, crossInfectionMatrix

def main(argv):
    #print ('Number of arguments:', len(sys.argv), 'arguments.')
    #print ('Argument List:', str(sys.argv))
    # try:
    #     opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    #     numberOfVariants = args[0]
    #     ModelConfig = args[1]
    # except getopt.GetoptError:
    #     print ('main.py numberVariants -v')
    #     sys.exit(2)
    # for opt, arg in opts:
    #     if opt == '-h':
    #         print ('main.py numberVariants -v')
    #         sys.exit()
    #     elif opt in ("-v"):
    #         numberOfVariants = arg
    # with open('ModelConfigs.json', 'r') as f:
    #     config = json.load(f)
    #     nbPopulationsGroups = len(config['PopulationsGroups'])
    #     nbVariants = len(config['Virus'])
    #     model = Model(nbPopulationsGroups=nbPopulationsGroups,nbVariants=nbVariants) 
    
    totalPop, numberOfDays, viruses, crossInfectionMatrix = readConfig()
    model = Model(totalPop, numberOfDays, viruses, crossInfectionMatrix)
    equations = model.getEquations()

    EquationsGenerator(equations)
    GraphGenerator(viruses, crossInfectionMatrix)

if __name__ == "__main__":
    main(sys.argv[1:])
