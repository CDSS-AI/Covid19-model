RESISTANCE_LEVEL = "resistanceLevel"
INFECTION_RATIO = "infectionRatio"
SOJOURN_TIME = "sojournTime"
WEIGHT = "weight"
VARIABLE = "variable"
NAME = "name"
DESTINATIONS = "destinations"


NAME_DICTIONNARY = {
    "S": {"name": "Susceptible", "variable": "mu"}, 
    "E": {"name": "Exposed", "variable": "nu"}, 
    "I_PRE": {"name": "Infected Presymptomatic", "variable": "gamma"}, 
    "I_SYMPS": {"name": "Infected Symptomatic Serious", "variable": "gamma"}, 
    "I_SYMPM": {"name": "Infected Symptomatic Mild", "variable": "gamma"},
    "I_ASYMP": {"name": "Infected Asymptomatic", "variable": "gamma"},
    "HOSP_M": {"name": "Hospitalized Mild", "variable": "theta"},
    "HOSP_S": {"name": "Hospitalized Serious", "variable": "theta"},
    "R": {"name": "Recovered", "variable": "omega"}, 
}
