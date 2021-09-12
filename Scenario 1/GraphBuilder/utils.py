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



        
