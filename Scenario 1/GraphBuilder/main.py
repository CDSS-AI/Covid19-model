import getopt
import sys

import numpy as np

from Model import Model
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
        print(config['Populations'])
    # x = np.arange(0,11,1)
    # y1 = x**2
    # y2 = x**3  
    # graph(x, [y1, y2], 'Graph') 








if __name__ == "__main__":
    main(sys.argv[1:])
