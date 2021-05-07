import json

from scipy.integrate import solve_ivp

from PopulationGroup import PopulationGroup
from utils import *
from Virus import Virus

MOBILITY_FACTOR_MIN = 0.1
MOBILITY_FACTOR_MAX =  0.9

INFECTION_RATE_FACTOR_MIN = 0.25
INFECTION_RATE_FACTOR_MAX = 0.9

MORTALITY_FACTOR_MIN = 0.1
MORTALITY_FACTOR_MAX = 0.3



class Model: 
    def __init__(self, nbPopulationsGroups, nbVariants):
        self.populationsGroups = [] 
        self.variants = []
        self.setRandomParameters(nbPopulationsGroups, nbVariants)


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
                print(name)
                infected.append({"name": ('infected_' + name), "importFlow": [], "exportFlow": [] })
       
        with open('ModelConfigs.json','r+') as file:
            file_data = json.load(file)
        # Join new_dat3a with file_data
            file_data.update(new_data)
        # Sets file's current position at offset.
        file.seek(0)
        # convert back to json.
        json.dump(file_data, file, indent = 4)
        with open('ModelConfigs.json', '') as f:
            for element in infected: 
                config['Populations'].append(element)
        

    def loadSettings(self): 
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)
            print(config)
            self.populationsGroups = config['PopulationsGroups']
            self.variants = config['Virus']
     
    @classmethod
    def ode45(cls, func, span=[], y0=[]): 
        sol = solve_ivp(func, span, y0, method='RK45',t_eval=None, dense_output=False, events=None, vectorized=False,)
        print(sol.t)
        print(sol.y)




    
