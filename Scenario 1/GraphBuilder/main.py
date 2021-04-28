import getopt
import sys

import numpy as np
import plotly.express as px
import plotly.graph_objects as go


def main(argv):
    print ('Number of arguments:', len(sys.argv), 'arguments.')
    print ('Argument List:', str(sys.argv))
    try:
        opts, args = getopt.getopt(argv,"hi:o:",["ifile=","ofile="])
    except getopt.GetoptError:
        print ('main.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print ('main.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            inputfile = arg
        elif opt in ("-o", "--ofile"):
            outputfile = arg

    x = np.arange(0,11,1)
    y1 = x**2
    y2 = x**3
    fig = go.Figure()

    for y in [y1, y2]:
        fig.add_trace(go.Scatter(
            x=x,        
            y=y
            )
        )
    fig.update_layout(title='Sample Graph',
                      xaxis_title='x',
                      yaxis_title='y',
                      template='plotly_white')
    fig.show()

if __name__ == "__main__":
    main(sys.argv[1:])
