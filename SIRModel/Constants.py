RESISTANCE_LEVEL = "resistanceLevel"
INFECTION_RATIO = "infectionRatio"
SOJOURN_TIME = "sojournTime"
WEIGHT = "weight"
VARIABLE = "variable"
NAME = "name"
DESTINATIONS = "destinations"
TOTAL_CASES = 'total_cases'
ICU_PATIENTS = 'icu_patients'
HOSP_PATIENTS = 'hosp_patients'


NAME_DICTIONNARY = {
    "S": {"name": "Susceptible", "variable": "-",'eqName': 'S', "symbol": "s", 'function': 'f'}, 
    "E": {"name": "Exposed", "variable": "nu", 'eqName': 'E', "symbol": "e", 'function': 'f'}, 
    "I_pre": {"name": "Infected Presymptomatic", "variable": "gamma_{pre}", "eqName": "I_{pre}", 'symbol': 'pre', 'function': 'f'}, 
    "I_s": {"name": "Infected Symptomatic Serious", "variable": "gamma_{s}", 'eqName': "I_{s}", "symbol": "s",'function': 'f'}, 
    "I_m": {"name": "Infected Symptomatic Mild", "variable": "gamma_{m}", 'eqName': "I_{m}", "symbol": "m", 'function': 'f'}, 
    "I_a": {"name": "Infected Asymptomatic", "variable": "gamma_{a}", 'eqName': "I_{a}", "symbol": "a", 'function': 'f'}, 
    "H_m": {"name": "Hospitalized Mild", "variable": "theta_{m}", 'eqName': 'H_{m}', "symbol": "H", 'function': 'f'},
    "H_s": {"name": "Hospitalized Serious", "variable": "theta_{s}", 'eqName': 'H_{s}', "symbol": "H", 'function': 'f'},
    "R": {"name": "Recovered", "variable": "omega", 'eqName': 'R', "symbol": "R", 'function': 'f'}, 
    "total_cases": {'name': 'Infected'}, 
    "icu_patients": {"name": 'ICU Patients'}, 
    'hosp_patients': {'name': 'Hospitalized Patients'}
}

MATCHING_DICTIONNARY = {
    "E" : TOTAL_CASES, 
    "H_s" : ICU_PATIENTS, 
    "H" : HOSP_PATIENTS
}
