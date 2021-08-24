from utils import *


def calculateSojournTime(sojournTime): 
    if (sojournTime):
        return (1/sojournTime)
    else:
        return 0

def calculateBeta(virus: Virus, infectionRatio):
    if (virus and infectionRatio): 
        return (virus.infectionRate * infectionRatio) 
    return 0

def calculateLambda(node, crossResistanceRatio, status, var, resistanceLevel, infectionRatio, viruses, N): 
    sumBetas = 0
    Lambda = 0
    virus = getVariantFromIndex(var, viruses)
    if (node == 'R_1'):
        print()
    if (not infectionRatio): 
        infectionRatio = 0
    betaTemp = (calculateBeta(virus, infectionRatio) * node)
    sumBetas += betaTemp
    
    variantCoeff = ((1-(crossResistanceRatio[int(status)][int(var)] * resistanceLevel)) /N)
    Lambda = ( variantCoeff* sumBetas)
    #outputToFileDebug('NODE: ' + str(node) + ' LAMBDA: ' + str(Lambda))
    return Lambda
   

def calculateDelta(virusIndex, viruses, t): 
    virus = getVariantFromIndex(virusIndex, viruses)
    if (virus):
        return (virus.apparitionRate * (int(t >= virus.apparitionPeriod[0]) *  int(t < virus.apparitionPeriod[1])))
    return 0

def normalizeWeights(weights):
    totalWeight = sum(weights) 
    weightList = []
    for weight in weights: 
        weightList.append(float(weight/totalWeight))
    return weightList
