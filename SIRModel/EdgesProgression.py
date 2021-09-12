class EdgesProgression: 
    def __init__(self, nodeName="", sojournTime=0, infectionRatio=1, destinations = {}):
        self.name = nodeName
        self.sojournTime = sojournTime
        self.infectionRatio = infectionRatio
        self.destinations = destinations
