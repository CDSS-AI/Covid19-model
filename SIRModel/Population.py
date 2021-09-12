from PopulationType import PopulationType


class Population: 
    def __init__(self, name, popType:PopulationType, importFlow=[], exportFlow=[]):
        self.name = name
        self.importFlow = importFlow
        self.exportFlow = importFlow
        self.type = popType
