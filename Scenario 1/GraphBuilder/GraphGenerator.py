import igraph as ig
import matplotlib.pyplot as plt

#DOC: https://igraph.org/python/doc/tutorial/tutorial.html

class GraphGenerator:

    def __init__(self, viruses):
        print(ig.__version__)
        g = ig.Graph(directed=True)
        g.add_vertices(1) #susceptible
        g.add_vertices(len(viruses) * 2)
        visual_style = {}
        out_name = "Model.png"
        visual_style["bbox"] = (400,400)
        visual_style["margin"] = 27
        g.vs['color'] = ["red", "green", "blue", "yellow", "orange"]
        visual_style["vertex_size"] = 45
        visual_style["vertex_label_size"] = 22
        visual_style["edge_curved"] = False
        my_layout = g.layout_lgl()
        visual_style["layout"] = my_layout
        ig.plot(g, out_name, **visual_style)
        
      

    def getGraphInfo(graph): 
        print("Number of vertices in the graph:", graph.vcount())
        print("Number of edges in the graph", graph.ecount())
        print("Is the graph directed:", graph.is_directed())
        print("Maximum degree in the graph:", graph.maxdegree())
        print("Adjacency matrix:\n", graph.get_adjacency())
