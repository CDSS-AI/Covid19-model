import json
import random

import numpy as np
import plotly.express as px
import plotly.graph_objects as go

from PopulationGroup import PopulationGroup
from Virus import Virus


def graph(x, target=[], title='Graph'): 
    fig = go.Figure()

    for y in target:
        fig.add_trace(go.Scatter(
            x=x,        
            y=y
            )
        )
    fig.update_layout(title=title,
                      xaxis_title='x',
                      yaxis_title='y',
                      template='plotly_white')
    fig.show()



        
