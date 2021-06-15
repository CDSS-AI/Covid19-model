import matplotlib.pyplot as plt
from diagrams import Cluster, Diagram
from diagrams.custom import Custom

#REF: https://diagrams.mingrammer.com/docs/nodes/custom


class GraphGenerator:

    def __init__(self, viruses):
        with Diagram("COVID19 Model Diagram", show=False, filename="model_diagram"):
            s_box = Custom("Susceptible", "./my_resources/s_box.png")
            infectedBoxes = {}
            recoveredBoxes = {}
            for idx, virus in enumerate(viruses, start=0):
                infectedBoxes[("I" + str(idx))]= Custom(("Infected" + str(idx)), "./my_resources/i_box.png")
            for idx, virus in enumerate(viruses, start=0):
                recoveredBoxes[idx] = Custom(("Recovered" + str(idx)), "./my_resources/r_box.png")
            
            #with Cluster("Non Commercial"):
            #  non_commercial = [Custom("Y", "./my_resources/cc_nc-jp.png") - Custom("E", "./my_resources/cc_nc-eu.png") - Custom("S", "./my_resources/cc_nc.png")]
            for key in infectedBoxes: 
                s_box >> infectedBoxes.get(key)
            
            idx = 0
            for key in infectedBoxes: 
                infectedBoxes.get(key) >> recoveredBoxes.get(idx)
                for idx2 in range(0, len(recoveredBoxes.keys())): 
                    recoveredBoxes.get(idx2) >> infectedBoxes.get(key)
                idx += 1
                
                
