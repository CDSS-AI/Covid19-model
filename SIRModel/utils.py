import json
import random

import numpy as np
import plotly.express as px
import plotly.graph_objects as go

from Virus import Virus


def graph(x, target=[], title='Graph', xaxis_title='x', yaxis_title='y'): 
    fig = go.Figure()
    font_size_axes = 35

    for y_obj in target:
        fig.add_trace(go.Scatter(
            x=x,        
            y=y_obj[0], 
            name=y_obj[1],
            )
        )
    fig.update_layout(title=title,
                      xaxis_title=xaxis_title,
                      yaxis_title= yaxis_title,
                      font_family="Times New Roman",
                      title_font_family="Times New Roman",
                      title_font_size=30,
                      template='plotly_white')
    fig.update_layout( yaxis = dict( tickfont = dict(size=font_size_axes)))
    fig.update_layout( xaxis = dict( tickfont = dict(size=font_size_axes)))
    fig.update_layout( yaxis_title = dict( font = dict(size=font_size_axes)))
    fig.update_layout( xaxis_title = dict( font = dict(size=font_size_axes)))
    fig.show()

def sortNodes(nodes): 
    sortedNodes = {}
    susceptible = []
    exposed = []
    infected = []
    hospitalized = []
    recovered = []
    for node in nodes: 
        if ('s' in node[0].lower()): 
            susceptible.append(node)
        elif('e' in node[0].lower()): 
            exposed.append(node)
        elif('i' in node[0].lower()): 
            infected.append(node)
        elif('h' in node[0].lower()): 
            hospitalized.append(node)
        elif('r' in node[0].lower()): 
            recovered.append(node)
    sortedNodes['susceptible'] = susceptible
    sortedNodes['exposed'] = exposed
    sortedNodes['infected'] = infected
    sortedNodes['hospitalized'] = hospitalized
    sortedNodes['recovered'] = recovered

    return sortedNodes

def MergeDicts(dict1, dict2):
    return {**dict1, **dict2}

def makeLatexFrac(numerator, denominator, indexNumerator=-1, negative=False): 
    strindexNumerator = str(indexNumerator)
    strNumerator = str(numerator)
    strDenominator = str(denominator)
    strName = ""
    if ("_" in strNumerator or "_" in strDenominator):
        strList = numerator.split('_')
        if (len(strList) > 2): 
            if (indexNumerator != -1): 
                strNumerator = strList[0] + "\_" + strList[1].lower() + "\_" + strList[2].lower() + '_{' + strindexNumerator + '}'
            else:
                strNumerator = strList[0] + "\_" + strList[1].lower() + '\_' + strList[2].lower()
            strName += r'\frac{' + strNumerator + r'}{' +  strDenominator + '}'
        elif (len(strList) > 1): 
            if (indexNumerator != -1): 
                strNumerator = strList[0] + '\_' + strList[1].lower() + '_{' + strindexNumerator + '}' 
            else:
                strNumerator = strList[0] + '\_' + strList[1].lower() 
            strName += r'\frac{' + strNumerator + r'}{' +  strDenominator + '}'
    else: 
        if (indexNumerator != -1): 
            strNumerator = strNumerator + '_{' + strindexNumerator + '}'
        strName += r'\frac{' + strNumerator + r'}{' +  strDenominator + '}'

    if (negative):
        strName = "-" + strName
    
    return strName


def makeLatexVariable(negative, variableName, idx): 
    strName = " "
    if (negative): 
        strName += '-' + '\\' + variableName + '_{' + str(idx) + '}'
    else: 
        strName += '\\' + variableName + '_{' + str(idx) + '}'
    return strName

def makeLatexVariableName(name, nameIndex=-1): 
    strName = ""
    strNameIndex = str(nameIndex)
    if "_" in name:
        strList = name.split('_')
        strName = ""
        if (len(strList) > 2): 
            if (nameIndex != -1):
                strName += strList[0] + "\_{" + strList[1].lower() + '}' + "\_{" + strList[2].lower() + '}' + "_{" + strNameIndex + '}'
            else: 
                strName += strList[0] + "\_{" + strList[1].lower() + '}' + '\_{' + strList[2].lower() + '}'
        elif (len(strList) > 1): 
            if (nameIndex != -1):
                strName += strList[0] + "\_{" + strList[1].lower() + '}' + "_{" + strNameIndex + '}'  
            else:
                strName += strList[0] + '\_{' + strList[1].lower() + '}' 
    else:
        if (nameIndex != -1):
            strName = name + "_{" + strNameIndex + "}"
        else:
            strName = name

    return strName

def calculateTheta(sojournTime): 
    return (-1/sojournTime)

def calculateMu(sojournTimeParent, weight): 
    if (weight): 
        return ((1/sojournTimeParent) * weight)
    else: 
        return 0

def calculateLambda(resistantLevel, virusIndex, N, crossResistanceMatrix): 
    return ((1-(crossResistanceMatrix[virusIndex][virusIndex] * resistantLevel))/N)

def calculateBeta(virus: Virus, node):
    pass

def calculateDelta(virus: Virus, t): 
    return (virus.apparitionRate * (int(t >= virus.apparitionPeriod[0]) *  int(t < virus.apparitionPeriod[1])))
 
        
