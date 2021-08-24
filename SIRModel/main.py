import getopt
import json
import sys

import numpy as np

import Virus
from Config import *
from EquationsGenerator import EquationsGenerator
from GraphGenerator import GraphGenerator
from Model import Model
from utils import *


def main(argv):
    clearDebugFile()
    config = Config()
    config.readMatrixFile()
    config.generateMatrixFile()
    model = Model(config)
    equations = model.getEquations()

    #EquationsGenerator(equations)
    #GraphGenerator(config.configValues['Model']["Compartements"], config.configValues["adjacencyMatrix"])

if __name__ == "__main__":
    main(sys.argv[1:])
