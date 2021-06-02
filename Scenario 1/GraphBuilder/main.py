import getopt
import sys

import numpy as np

from infectedY1 import infected_y1
from infectedY2 import infected_y2
from infectedY3 import infected_y3
from Model import Model
from recoveredY import recovered_y
from susceptibleY import susceptible_y
from utils import *


def readConfig(): 
    print("Reading the config file")
    

def main(argv):
    print ('Number of arguments:', len(sys.argv), 'arguments.')
    print ('Argument List:', str(sys.argv))
    numberOfVariants = 0
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
        numberOfVariants = args[0]
        ModelConfig = args[1]
    except getopt.GetoptError:
        print ('main.py numberVariants -v')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('main.py numberVariants -v')
            sys.exit()
        elif opt in ("-v"):
            numberOfVariants = arg
    with open('ModelConfigs.json', 'r') as f:
        config = json.load(f)
        nbPopulationsGroups = len(config['PopulationsGroups'])
        nbVariants = len(config['Virus'])
        model = Model(nbPopulationsGroups=nbPopulationsGroups,nbVariants=nbVariants) 
    if (str(ModelConfig) == "T"): 
        readConfig()
    x = np.arange(0,401,1)
    y1 = [susceptible_y, 'Susceptible']
    y2 = [infected_y1, 'Infected Variant 1']
    y5 = [recovered_y, 'Recovered']
    if (int(numberOfVariants) > 2):
        y3 = [infected_y2, 'Infected Variant 2']
        y4 = [infected_y3, 'Infected Variant 3']
        graph(x, [y1, y2, y3, y4, y5], 'COVID19 Infections in a population with ' + str(numberOfVariants) + ' variants', 'Time', 'Number of Infections')
    elif (int(numberOfVariants) > 1):
        y3 = [infected_y2, 'Infected Variant 2']
        graph(x, [y1, y2, y3, y5], 'COVID19 Infections in a population with ' + str(numberOfVariants) + ' variants', 'Time', 'Number of Infections')
    else:
        graph(x, [y1, y2, y5], 'COVID19 Infections in a population with ' + str(numberOfVariants) + ' variants', 'Time', 'Number of Infections')



if __name__ == "__main__":
    main(sys.argv[1:])
