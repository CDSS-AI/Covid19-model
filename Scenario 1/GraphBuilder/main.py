import getopt
import sys

import numpy as np

from infectedY1 import infected_y1
from infectedY2 import infected_y2
from Model import Model
from recoveredY import recovered_y
from susceptibleY import susceptible_y
from utils import *


def main(argv):
    print ('Number of arguments:', len(sys.argv), 'arguments.')
    print ('Argument List:', str(sys.argv))
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('main.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('main.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    with open('ModelConfigs.json', 'r') as f:
        config = json.load(f)
        nbPopulationsGroups = len(config['PopulationsGroups'])
        nbVariants = len(config['Virus'])
        model = Model(nbPopulationsGroups=nbPopulationsGroups,nbVariants=nbVariants) 
        print(model.Populations)
    x = np.arange(0,401,1)
    y1 = [susceptible_y, 'Susceptible']
    y2 = [infected_y1, 'Infected Variant 1']
    y3 = [infected_y2, 'Infected Variant 2']
    y4 = [recovered_y, 'Recovered']
    
    graph(x, [y1, y2, y3, y4], 'COVID19 Infections in a population with two variants', 'Time', 'Number of Infections')








if __name__ == "__main__":
    main(sys.argv[1:])
