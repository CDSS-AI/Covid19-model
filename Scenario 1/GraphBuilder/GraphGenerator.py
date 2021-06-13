from igraph import *

#DOC: https://igraph.org/python/doc/tutorial/tutorial.html

class GraphGenerator:

    def __init__(self, numberVertices, edges):
        print(igraph.__version__)
        g = Graph(directed=True)
        g.add_vertices(numberVertices)
        g.add_edges(edges) #edges: [(0,1), (1,2)]
        visual_style = {}
        out_name = "Model.png"
        # Set bbox and margin
        visual_style["bbox"] = (400,400)
        visual_style["margin"] = 27
        # Set vertex colours
        g.vs['color'] = ["red", "green", "blue", "yellow", "orange"]
        # Set vertex size
        visual_style["vertex_size"] = 45
        # Set vertex lable size
        visual_style["vertex_label_size"] = 22
        # Don't curve the edges
        visual_style["edge_curved"] = False
        # Set the layout
        my_layout = g.layout_lgl()
        visual_style["layout"] = my_layout
        # Plot the graph
        plot(g, out_name, **visual_style)
        
      

    def getGraphInfo(graph): 
        print("Number of vertices in the graph:", graph.vcount())
        print("Number of edges in the graph", graph.ecount())
        print("Is the graph directed:", graph.is_directed())
        print("Maximum degree in the graph:", graph.maxdegree())
        print("Adjacency matrix:\n", graph.get_adjacency())
