import matplotlib.pyplot as plt
from diagrams import Cluster, Diagram
from diagrams.custom import Custom

#REF: https://diagrams.mingrammer.com/docs/nodes/custom


class GraphGenerator:

    def __init__(self, viruses, CrossInfectionMatrix):
        print(viruses)
        print(CrossInfectionMatrix)
        diagram_attr = {
            "fontsize": "32",
            "fontname": "Sans serif",
        }
        node_attr = {
            "fontname": "Sans-Serif",
            "fontsize": "24",
        }
        with Diagram("S-I-R Model Diagram", graph_attr=diagram_attr, node_attr=node_attr, show=False, filename="model_diagram", direction="LR"):
            s_box = Custom("Susceptible", "./my_resources/s_box.png")
            infectedBoxes = {}
            recoveredBoxes = {}
            for idx, virus in enumerate(viruses, start=0):
                infectedBoxes[("I" + str(idx))]= Custom(("Infected" + str(idx)), "./my_resources/i_box.png")
            for idx, virus in enumerate(viruses, start=0):
                recoveredBoxes[idx] = Custom(("Recovered" + str(idx)), "./my_resources/r_box.png")
            
            for key in infectedBoxes: 
                s_box >> infectedBoxes.get(key)
            
            idx = 0
            for i, key in enumerate(infectedBoxes, start=0): 
                infectedBoxes.get(key) >> recoveredBoxes.get(idx)
                for j in range(0, len(recoveredBoxes.keys())): 
                    if (CrossInfectionMatrix[j][i] != 0):
                        recoveredBoxes.get(j) >> infectedBoxes.get(key)
                idx += 1
                
                
