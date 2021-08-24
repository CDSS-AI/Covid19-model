from utils import *


def calculateRate(sojournTime): 
    if (sojournTime):
        return (1/sojournTime)
    else:
        return 0

def calculateBeta(virus: Virus, infectionRatio):
    if (virus and infectionRatio): 
        return virus.infectionRate * infectionRatio
    return 0

def calculateLambda(crossResistanceRatio, compartements, status, var, resistanceLevel, infectionRatioDict, viruses, N): 
    sumBetas = 0
    Lambda = 0
    if (not status): 
        status = 0
    virus = getVariantFromIndex(var, viruses)
    for compartementVar in getAllCompartementsWithVariants(var, compartements): 
        infectionRatio = infectionRatioDict[compartementVar]
        betaTemp = (calculateBeta(virus, infectionRatio) * compartements.get(compartementVar))
        sumBetas += betaTemp
    variantCoeff = ((1-(crossResistanceRatio[int(status)][int(var)] * resistanceLevel)) /N)
    Lambda = ( variantCoeff* sumBetas)
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
