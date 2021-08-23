MOBILITY_FACTOR_MIN = 0.1
MOBILITY_FACTOR_MAX =  0.9

INFECTION_RATE_FACTOR_MIN = 0.25
INFECTION_RATE_FACTOR_MAX = 0.9

MORTALITY_FACTOR_MIN = 0.1
MORTALITY_FACTOR_MAX = 0.3

SUSCEPTIBLE_BETA = 0.5
SIUSCEPTIBLE_DELTA = 0.1

INFECTECTION_DELTA = 0.0

RECOEVERD_DELTA = 0.0

INFECTION_DELTA_1 = 0.05
INFECTION_DELTA_2 = 0.05
INFECTION_DELTA_3 = 0.04
INFECTION_DELTA_4 = 0.04
INFECTTION_LAMBDA = 0.50
INFECTION_PHI_1 = 0.7
INFECTION_PHI_2 = 0.7
THETA = 0.001


NAME_DICTIONNARY = {
    "S": {"name": "Susceptible", "variable": "mu"}, 
    "E": {"name": "Exposed", "variable": "nu"}, 
    "I_PRE": {"name": "Infected Presymptomatic", "variable": "gamma"}, 
    "I_SYMP_S": {"name": "Infected Symptomatic Serious", "variable": "gamma"}, 
    "I_SYMP_M": {"name": "Infected Symptomatic Mild", "variable": "gamma"},
    "I_ASYMP": {"name": "Infected Asymptomatic", "variable": "gamma"},
    "HOSP_M": {"name": "Hospitalized Mild", "variable": "theta"},
    "HOSP_S": {"name": "Hospitalized Serious", "variable": "theta"},
    "R": {"name": "Recovered", "variable": "omega"}, 
}
