RESISTANCE_LEVEL = "resistanceLevel"
INFECTION_RATIO = "infectionRatio"
SOJOURN_TIME = "sojournTime"
WEIGHT = "weight"
VARIABLE = "variable"
NAME = "name"
DESTINATIONS = "destinations"


NAME_DICTIONNARY = {
    "S": {"name": "Susceptible", "variable": "-",'eqName': 'S', "symbol": "s", 'function': 'f'}, 
    "E": {"name": "Exposed", "variable": "nu", 'eqName': 'E', "symbol": "e", 'function': 'f'}, 
    "I_PRE": {"name": "Infected Presymptomatic", "variable": "gamma_{pre}", "eqName": "I_{pre}", 'symbol': 'pre', 'function': 'f'}, 
    "I_SYMPS": {"name": "Infected Symptomatic Serious", "variable": "gamma_{s}", 'eqName': "I_{s}", "symbol": "s",'function': 'f'}, 
    "I_SYMPM": {"name": "Infected Symptomatic Mild", "variable": "gamma_{m}", 'eqName': "I_{m}", "symbol": "m", 'function': 'f'}, 
    "I_ASYMP": {"name": "Infected Asymptomatic", "variable": "gamma_{a}", 'eqName': "I_{a}", "symbol": "a", 'function': 'f'}, 
    "HOSP_M": {"name": "Hospitalized Mild", "variable": "theta_{m}", 'eqName': 'H_{m}', "symbol": "H", 'function': 'f'},
    "HOSP_S": {"name": "Hospitalized Serious", "variable": "theta_{s}", 'eqName': 'H_{s}', "symbol": "H", 'function': 'f'},
    "R": {"name": "Recovered", "variable": "omega", 'eqName': 'R', "symbol": "R", 'function': 'f'} 
}
