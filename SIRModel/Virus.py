import re


class Virus: 
    def __init__(self, name, infectionRate=0, apparitionPeriod=[], apparitionRate=0):
        self.name = name
        self.infectionRate = infectionRate
        self.apparitionPeriod = apparitionPeriod
        self.apparitionRate = apparitionRate
        self.index = self.getIndex()

    def getIndex(self):
        return re.sub("[^0-9]", "", self.name)
      
