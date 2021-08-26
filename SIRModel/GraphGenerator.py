import matplotlib.pyplot as plt
from diagrams import Cluster, Diagram
from diagrams.custom import Custom

from utils import *

#REF: https://diagrams.mingrammer.com/docs/nodes/custom


class GraphGenerator:
    def __init__(self, nodes, flowMatrix):
        diagram_attr = {
            "fontsize": "32",
            "fontname": "Sans serif",
        }
        node_attr = {
            "fontname": "Sans-Serif",
            "fontsize": "24",
        }
        sortedNodes, nodes = sortNodes(nodes)
           
        with Diagram("S-I-R Model Diagram", graph_attr=diagram_attr, node_attr=node_attr, show=False, filename="new_model_diagram", direction="LR"):
            boxes = {}
            number = 0
            for idx, node in enumerate(sortedNodes.get('susceptible'), start=number):
                boxes[idx]= Custom(node, "./my_resources/s_box.png")
                number = number+1
            for idx, node in enumerate(sortedNodes.get('exposed'), start=number):
                boxes[idx]= Custom(node, "./my_resources/e_box.png")
                number = number+1
            for idx, node in enumerate(sortedNodes.get('infected'), start=number):
                boxes[idx]= Custom(node, "./my_resources/i_box.png")
                number = number+1
            for idx, node in enumerate(sortedNodes.get('hospitalized'), start=number):
                boxes[idx]= Custom(node, "./my_resources/h_box.png")
                number = number+1
            for idx, node in enumerate(sortedNodes.get('recovered'), start=number):
                boxes[idx] = Custom(node, "./my_resources/r_box.png")
                number = number+1

            rows = flowMatrix.shape[0]
            cols = flowMatrix.shape[1]
            for i in range(0, rows):
                for j in range(0, cols): 
                    if (flowMatrix[i,j] == 1): 
                        boxes.get(i) >> boxes.get(j)
