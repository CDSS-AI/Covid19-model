import json
import random
import re

import numpy as np
import plotly.express as px
import plotly.graph_objects as go
import requests

from Constants import *
from Virus import Virus

POPULATION_URL = 'https://countriesnow.space/api/v0.1/countries/population'


def makeGraph(x, target=[], title='Graph', xaxis_title='x', yaxis_title='y'): 
    fig = go.Figure()
    font_size_axes = 15

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
        if('e' in node[0].lower()): 
            exposed.append(node)
        elif('i' in node[0].lower()): 
            infected.append(node)
        elif('h' in node[0].lower()): 
            hospitalized.append(node)
        elif('r' in node[0].lower()): 
            recovered.append(node)
    
    sortedNodes['susceptible'] = ['S']
    sortedNodes['exposed'] = exposed
    sortedNodes['infected'] = infected
    sortedNodes['hospitalized'] = hospitalized
    sortedNodes['recovered'] = recovered

    nodes =  ['S'] + exposed + infected + hospitalized + recovered

    return sortedNodes, nodes

def MergeDicts(dict1, dict2):
    return {**dict1, **dict2}

def makeLatexFrac(numerator, denominator, indexNumerator=-1, negative=False): 
    strindexNumerator = str(indexNumerator)
    strNumerator = str(numerator)
    strDenominator = str(denominator)
    strName = ""
    if ("_" in strNumerator or "_" in strDenominator):
        variable = strNumerator[1:]
        index = getNodeVariantIndex(variable)
        eqName = matchNameDict(variable, 'eqName')
        strNumerator = 'd' + eqName + '^{' + str(index) + '}'
        strName += r'\frac{' + strNumerator + r'}{' +  strDenominator + '}'
    else: 
        if (indexNumerator != -1): 
            strNumerator = strNumerator + '_{' + strindexNumerator + '}'
        strName += r'\frac{' + strNumerator + r'}{' +  strDenominator + '}'

    if (negative):
        strName = "-" + strName

    return strName

def makeLatexFunctionCoeff(index, node, parentNode):
    nodeList = str.split(node, "_") 
    parentNodeList = str.split(parentNode, '_')
    if (node == 'S' or parentNode == 'S'):
        return ''
    else:
        symbol = matchNameDict(node, 'symbol')
        symbolParent = matchNameDict(parentNode, 'symbol')
        function = matchNameDict(node, 'function')
        return (function + '_{' + symbolParent + ',' + symbol + '}^{' + index + '}')


def makeLatexCoefficient(negative: bool, coefficient: str, index=-1, hat="", node="", eqName=""):
    strName = " "
    if (coefficient == 'omega'): 
        node = ""
    if (hat == "S"):
        hat = ""
    hatList = str.split(hat, "_") 
    if (hatList[0] == 'R'):
        hat = getNodeVariantIndex(hat)
    if (eqName == ""):
        if (node != "" and node != "S"):
            nodeList = str.split(node, "_")
            if nodeList[0] == 'E':
                nodeStr = nodeList[1]
            else:
                nodeStr = ("".join(nodeList)).lower()
            if (negative): 
                strName += '-' + "\\" + str(coefficient) 
            else: 
                strName +=  "\\" + str(coefficient) 
            return strName
        else:
            if (coefficient != "" and hat == ""):
                if (negative): 
                    if (index != -1):
                         strName += '-' + "\\" + str(coefficient) + '^{' + str(index) + '}'
                    else:
                        strName += '-' + "\\" + str(coefficient) 
                else: 
                    if (index != -1):
                        strName +=  "\\" + str(coefficient) + '^{' + str(index) + '}'
                    else:
                        strName +=  "\\" + str(coefficient) 
                return strName
            elif (coefficient != "" and hat != ""):
                if (negative): 
                    if (index != -1):
                         strName += '-' + "\\" + str(coefficient) + '_{' + hat + '}' + '^{' + index + '}'
                    else:
                        strName += '-' + "\\" + str(coefficient) + '^{' + hat + '}'
                else: 
                    if (index != -1):
                        strName +=  "\\" + str(coefficient) + '_{' + hat + '}' + '^{' + index + '}'
                    else:
                        strName +=  "\\" + str(coefficient) + '^{' + hat + '}'
                return strName
            else:
                return ""
    else: 
        if (index != -1):
            if (negative):
                strName += '-' + "\\" + str(coefficient) + '^{' + index + '}'
            else:
                strName += "\\" + str(coefficient) + '^{' + index + '}'
        else:
            if (negative):
                strName += '-' + "\\" + str(coefficient)
            else:
                strName += "\\" + str(coefficient)
        return strName

def makeLatexVariableName(variable): 
    strName = ""
    index = getNodeVariantIndex(variable)
    if index:
        eqName = matchNameDict(variable, 'eqName')
        strName = ""
        strName += eqName + '^{' + str(index) + '}'
        return strName
    else:
        return variable
   


def getVariantFromIndex(virusIndex, viruses):
    for virus in viruses: 
        if (virusIndex == getNodeVariantIndex(virus.name)):
            return virus
    return None
 
def outputToFileDebug(line): 
    with open("debug.txt", "a") as text_file:
        text_file.write(str(line))
        text_file.write("\n")

def clearDebugFile():
    with open("debug.txt", "w") as text_file:
        text_file.write("")

def matchNameDict(name:str, field:str):
    if ("_" in name):
        nameList = name.split("_")
        nameList.pop()
        realName = '_'.join(nameList)
        return NAME_DICTIONNARY[realName][field]
    else: 
        return NAME_DICTIONNARY[name][field]

def makeNodeName(name:str, index): 
    if ('s' == name.lower()):
        return ('S')
    else: 
        return (name + "_" + str(index))

def getNodeVariantIndex(node):
    if (node):
        return re.sub("[^0-9]", "", node)
    else:
        return 0

def getAllCompartementsWithVariants(variantOfNode, compartements): 
    variantCompartements = []
    for compartement in compartements: 
        if (getNodeVariantIndex(compartement) == variantOfNode): 
            variantCompartements.append(compartement)

    return variantCompartements


def hasVariant(node):
    return any(char.isdigit() for char in node)


def getPopulationForCountry(location):
      req = requests.request(method='get', url=POPULATION_URL)
      populationList = (req.json().get("data"))
      populationDict = {}
      for poplationObj in populationList: 
          if (poplationObj.get('country').lower() == location.lower()):
              populationCountList = poplationObj.get('populationCounts') 
              for popObj in populationCountList: 
                  populationDict[popObj.get('year')] = popObj.get('value')
      max_year = max(populationDict, key=populationDict.get)
      return populationDict.get(max_year)


def makeNameDictGraph(name): 
    obj = NAME_DICTIONNARY.get(name)
    return obj['name']
      
    

    
  
    

