import json

from scipy.integrate import solve_ivp

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



class Model: 
    def __init__(self, nbPopulationsGroups, nbVariants):
        self.populationsGroups = [] 
        self.variants = []
        self.Populations = [Population('susceptible', 1, [], []), Population('recovered', 2, [], [])]
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
                self.Populations.append(Population(('infected_' + name), 2, [], []))
        
        self.fillImportFlows()


    def loadSettings(self): 
        with open('ModelConfigs.json', 'r') as f:
            config = json.load(f)
            print(config)
            self.populationsGroups = config['PopulationsGroups']
            self.variants = config['Virus']


    def fillImportFlows(self): 
        for population in self.Populations: 
            if population.type == 1: 
                population.importFlow.append(SUSCEPTIBLE_BETA)
                population.exportFlow.append(SIUSCEPTIBLE_DELTA)
            if population.type == 2: 
                print('Infected ! ')

    def fillExportmportFlows(self): 
        pass
     
   
    # def  dx = defSolver(t,x)
    #    dx = zeros(length(x),1);

    #    %Equations
    #    d1 = (pm.beta) - (pm.delta_1 * (x(1))) - (pm.lambda * (x(1))) - (pm.theta*(x(1)));
    #    dx(1) = sum(d1);
       
    #    %S * I Missing 
    #    d2 = (pm.lambda*x(1)) - (pm.delta_2 * (x(2))) - (pm.phi * (x(2)));
    #    dx(2) = sum(d2);
       
    #    d3 = (pm.lambda*x(1)) - (pm.delta_4  *(x(3))) - (pm.phi_2 * (x(3)));
    #    dx(3) = sum(d3);
       
    #    d4 = ((pm.phi*x(2) + pm.phi_2*x(3))); %- (pm.delta_3 * x(4)) - (pm.theta * x(4)); 
    #    dx(4) = sum(d4);
    
    @classmethod  
    def ode45(cls, func, span=[], y0=[]): 
        sol = solve_ivp(func, span, y0, method='RK45',t_eval=None, dense_output=False, events=None, vectorized=False,)
        print(sol.t)
        print(sol.y)




    
