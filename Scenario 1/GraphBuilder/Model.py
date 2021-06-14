import json

import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import odeint

import Virus
from utils import *


class Model: 
    N = 0
    equations = {}

    def makePlot(self, susceptible, viruses, recovered, time):
        y_array = []
        y_array.append([susceptible, "Susceptible"])
        for idx, virus in enumerate(viruses, start=0):  
             y_array.append([virus, ("Infected " + str(idx))])
        for idx, recover in enumerate(recovered, start=0):  
             y_array.append([recover, ("Recovered " + str(idx))])
        graph(time, y_array, 'COVID19 Infections in a population with ' + str(len(viruses)) + ' variants', 'Time (Days)', 'Number of people')


    def __init__(self, totPop, numberOfDays, viruses):
        N = totPop
        numberInitInfectedTot = 0
        I0 = []
        R0 = []
        infectionRates = []
        recoveryRates = []
        for idx, virus in enumerate(viruses, start=0):  
            numberInitInfectedTot += virus.numberInitInfected
            I0.append(virus.numberInitInfected)
            infectionRates.append(virus.infectionRate) 
            recoveryRates.append(virus.recoveryRate)
        for idx, virus in enumerate(viruses, start=0):
            R0.append(0)  
        S0 = [(N - numberInitInfectedTot)]
        y0 = S0 + I0 + R0

        def defSolver(y, t, N, infectionRates, recoveryRates):
            compartments = {}
            dCompartments = {}
            yArray = []
            for idx, key in enumerate(y, start=0):  
                 yArray.append(y[idx])
            
            compartments["S"] = yArray[0]
            dCompartments["dS"] = 0
            self.equations[r'\frac{dS}{dt}' ] = ""

            halfLength = (len(yArray))/2
            viruses = yArray[0:int(halfLength)]

            for idx, virus in enumerate(viruses, start=0):
                compartments[("I" + str(idx))] = virus
                dCompartments[("dI" + str(idx))] = 0
                self.equations[(r'\frac{dI_{' + str(idx) + r'}}{dt}')] = ""
            
            recovered = yArray [(int(halfLength)+1):]
            for idx, recover in enumerate(recovered, start=0):  
                compartments[("R" + str(idx))] = recover
                dCompartments[("dR" + str(idx))] = 0
                self.equations[(r'\frac{dR_{' + str(idx) + r'}}{dt}')]  = ""
              
            for idx, virus in enumerate(viruses, start=0):
                dCompartments["dS"] += -infectionRates[idx] * compartments.get("I" + str(idx)) * compartments.get("S") / N
                self.equations[r'\frac{dS}{dt}'] += (" ") + (r'-\beta_{' + str(idx)) + "}" + "*" + ("I_{" + str(idx)) + "}"  + " * " + (r'\frac{S}{N}')
            
            for idx, virus in enumerate(viruses, start=0):
                dCompartments[("dI" + str(idx))] += (infectionRates[idx] * compartments.get("I" + str(idx)) * compartments.get("S") / N) - (recoveryRates[idx] * compartments.get("I" + str(idx)))
                self.equations[(r'\frac{dI_{' + str(idx) + r'}}{dt}')] += (" ") + (r'\beta_{' + str(idx)) + "}" + "*" + ("I_{" + str(idx)) + "}"  + " * " + (r'\frac{S}{N}') + (' -\gamma_{' + str(idx) + "}") + ("I_{" + str(idx) + "}")

            for idx, recover in enumerate(recovered, start=0):
                dCompartments[("dR" + str(idx))] += recoveryRates[idx] * compartments.get("I" + str(idx))
                self.equations[(r'\frac{dR_{' + str(idx) + r'}}{dt}')]  += (" ") + (' \gamma_{' + str(idx) + "}") + "*" + ("I_{" + str(idx) + "}") 
           
            items = list(dCompartments.values())
            return (items)
        
        t = np.linspace(0, numberOfDays, numberOfDays)
        ret = odeint(defSolver, y0, t, args=(N, infectionRates, recoveryRates))
        results = ret.T
        S = results[0]
        results_left = results[1:]
        halfLength = (len(results_left - 1))/2
        viruses, recovered = np.split(results_left, 2)
        self.makePlot(S, viruses, recovered, t)
        
   
    def getEquations(self):
        return self.equations
       
          
   




    
