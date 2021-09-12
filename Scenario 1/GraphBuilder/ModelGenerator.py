import Model
import Virus
from Population import Population
from PopulationGroup import PopulationGroup
from utils import *
from Virus import Virus

MOBILITY_FACTOR_MIN = 0.1
MOBILITY_FACTOR_MAX =  0.9

INFECTION_RATE_FACTOR_MIN = 0.25
INFECTION_RATE_FACTOR_MAX = 0.9

MORTALITY_FACTOR_MIN = 0.1
MORTALITY_FACTOR_MAX = 0.3

SUSCEPTIBLE_BETA = 0.5
SIUSCEPTIBLE_DELTA = 0.1


class ModelGenerator:
    def __init__(self):
        pass

    def setRandomParameters(self, nbPopulationsGroups=1, nbVariants=1): 
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)

            for i in range(0, nbPopulationsGroups):
                mobilityFactor = random.uniform(MOBILITY_FACTOR_MIN, MOBILITY_FACTOR_MAX)
                config['PopulationsGroups'][i] = PopulationGroup(contactMatrix=[], mobilityFactor=mobilityFactor)

            for j in range(0, nbVariants):
                infectionRate = random.uniform(INFECTION_RATE_FACTOR_MIN, INFECTION_RATE_FACTOR_MAX)
                mortality = random.uniform(MORTALITY_FACTOR_MIN, MORTALITY_FACTOR_MAX)
                config['Virus'][j] = Virus(infectionRate, mortality, None)
        self.setPopulations()

    def setParameters(self, PopulationsGroups=[], Variants=[]):
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)

            for i in range(0, len(PopulationsGroups)):
                config['PopulationsGroups'][i] = PopulationsGroups[i]

            for i in range(0, len(Variants)):
                config['Virus'][i] = Variants[i]
        self.setPopulations()

    def setPopulations(self): 
        infected = []
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)
            variants = config['Virus']
            
            for variant in variants:
                name = variant.get('name')
                self.Populations.append(Population(('infected_' + name), 2, [], []))
        
        self.fillImportFlows()

    def loadSettings(self): 
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)
            self.populationsGroups = config['PopulationsGroups']
            self.variants = config['Virus']

