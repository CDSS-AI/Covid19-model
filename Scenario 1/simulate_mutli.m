function simulate_mutli(scenfile,simmethod,fitmethod,plotmethod,simiterations,simtimelimit,simfile)
% scenfile,simmethod,fitmethod,plotmethod,simiterations,simtimelimit,simfile
%     print(scenfile);
%     print(simmethod);
%     print(fitmethod);
%     print(plotmethod);
%     print(simiterations);
%     print(simtimelimit);
%     print(simfile);
    
    
    counters = ["S","E","I_pre","I_1_s","I_2_s","I_1_m","I_2_m","I_1_a","I_2_a","H_s","H_m","R_lt","R_st",...
    "S_iso","E_iso","I_iso_pre","I_1_iso_s","I_2_iso_s","I_1_iso_m","I_2_iso_m","I_1_iso_a","I_2_iso_a","H_iso_s","H_iso_m","R_iso_lt","R_iso_st",...
    "S_vacc","E_vacc","I_vacc_pre","I_1_vacc_s","I_2_vacc_s","I_1_vacc_m","I_2_vacc_m","I_1_vacc_a","I_2_vacc_a","H_vacc_s","H_vacc_m","R_vacc_lt","R_vacc_st",...
    "S_boost","E_boost","I_boost_pre","I_1_boost_s","I_2_boost_s","I_1_boost_m","I_2_boost_m","I_1_boost_a","I_2_boost_a","H_boost_s","H_boost_m","R_boost_lt","R_boost_st",...
    "S_vi","E_vi","I_vi_pre","I_1_vi_s","I_2_vi_s","I_1_vi_m","I_2_vi_m","I_1_vi_a","I_2_vi_a","H_vi_s","H_vi_m","R_vi_lt","R_vi_st",...
    "S_bi","E_bi","I_bi_pre","I_1_bi_s","I_2_bi_s","I_1_bi_m","I_2_bi_m","I_1_bi_a","I_2_bi_a","H_bi_s","H_bi_m","R_bi_lt","R_bi_st",...
    "num_inf","num_inf_pre","num_inf_asym","num_inf_sym","num_inf_hosp","num_hosp","num_rec","num_covid","num_back","num_arr","num_vacc","num_boost",...
    "num_inf_iso","num_inf_pre_iso","num_inf_asym_iso","num_inf_sym_iso","num_inf_hosp_iso","num_hosp_iso","num_rec_iso","num_covid_iso","num_back_iso","num_arr_iso","num_vacc_iso","num_boost_iso",...
    "num_inf_nonvacc","num_inf_vacc","num_inf_boost","num_inf_nonvi","num_inf_vi","num_inf_bi",...
    "num_inf_sev_nonvacc","num_inf_mild_nonvacc","num_inf_asym_nonvacc","num_inf_sev_vacc","num_inf_mild_vacc","num_inf_asym_vacc",...
    "num_inf_sev_boost","num_inf_mild_boost","num_inf_asym_boost","num_inf_sev_vi","num_inf_mild_vi","num_inf_asym_vi",...
    "num_inf_sev_bi","num_inf_mild_bi","num_inf_asym_bi"];
    
    groups = containers.Map;
    groups("N_comm") = ["S","E","I_pre","I_1_s","I_2_s","I_1_m","I_2_m","I_1_a","I_2_a","R_lt","R_st"];
    groups("N_vacc_comm") = ["S_vacc","E_vacc","I_vacc_pre","I_1_vacc_s","I_2_vacc_s","I_1_vacc_m","I_2_vacc_m","I_1_vacc_a","I_2_vacc_a","R_vacc_lt","R_vacc_st"];
    groups("N_boost_comm") = ["S_boost","E_boost","I_boost_pre","I_1_boost_s","I_2_boost_s","I_1_boost_m","I_2_boost_m","I_1_boost_a","I_2_boost_a","R_boost_lt","R_boost_st"];
    groups("N_iso_comm") = ["S_iso","E_iso","I_iso_pre","I_1_iso_s","I_2_iso_s","I_1_iso_m","I_2_iso_m","I_1_iso_a","I_2_iso_a","R_iso_lt","R_iso_st"];
    groups("N_vi_comm") = ["S_vi","E_vi","I_vi_pre","I_1_vi_s","I_2_vi_s","I_1_vi_m","I_2_vi_m","I_1_vi_a","I_2_vi_a","R_vi_lt","R_vi_st"];
    groups("N_bi_comm") = ["S_bi","E_bi","I_bi_pre","I_1_bi_s","I_2_bi_s","I_1_bi_m","I_2_bi_m","I_1_bi_a","I_2_bi_a","R_bi_lt","R_bi_st"];
    groups("N_hosp") = ["H_s","H_m"];
    groups("N_vacc_hosp") = ["H_vacc_s","H_vacc_m"];
    groups("N_boost_hosp") = ["H_boost_s","H_boost_m"];
    groups("N_iso_hosp") = ["H_iso_s","H_iso_m"];
    groups("N_vi_hosp") = ["H_vi_s","H_vi_m"];
    groups("N_bi_hosp") = ["H_bi_s","H_bi_m"];
    
    groups("Susceptible") = ["S","S_vacc","S_boost","S_iso","S_vi","S_bi"]; 
    groups("Susceptible-novacc") = ["S","S_iso"]; 
    groups("Susceptible-vacc") = ["S_vacc","S_vi"]; 
    groups("Susceptible-boost") = ["S_boost","S_bi"]; 
    groups("Recovered") = ["R_lt","R_st","R_vacc_lt","R_vacc_st","R_boost_lt","R_boost_st","R_iso_lt","R_iso_st","R_vi_lt","R_vi_st","R_bi_lt","R_bi_st"];
    groups("Exposed") = ["E","E_vacc","E_boost","E_iso","E_vi","E_bi"];
    groups("Infectious-pre") = ["I_pre","I_vacc_pre","I_boost_pre","I_iso_pre","I_vi_pre","I_bi_pre"];
    groups("Infectious-a") = ["I_1_a","I_2_a","I_1_vacc_a","I_2_vacc_a","I_1_boost_a","I_2_boost_a","I_1_iso_a","I_2_iso_a","I_1_vi_a","I_2_vi_a","I_1_bi_a","I_2_bi_a"];
    groups("Infectious-m-nhosp") = ["I_1_m","I_2_m","I_1_vacc_m","I_2_vacc_m","I_1_boost_m","I_2_boost_m","I_1_iso_m","I_2_iso_m","I_1_vi_m","I_2_vi_m","I_1_bi_m","I_2_bi_m"];
    groups("Infectious-s-nhosp") = ["I_1_s","I_2_s","I_1_vacc_s","I_2_vacc_s","I_1_boost_s","I_2_boost_s","I_1_iso_s","I_2_iso_s","I_1_vi_s","I_2_vi_s","I_1_bi_s","I_2_bi_s"];
    groups("Infectious-m-hosp") = ["H_m","H_vacc_m","H_boost_m","H_iso_m","H_vi_m","H_bi_m"];
    groups("Infectious-s-hosp") = ["H_s","H_vacc_s","H_boost_s","H_iso_s","H_vi_s","H_bi_s"];
    groups("Infectious-m-all") = [groups("Infectious-m-nhosp"),"H_m","H_vacc_m","H_boost_m","H_iso_m","H_v","R_vacc_lt","R_vacc_st"];
    groups("N_boost_comm") = ["S_boost","E_boost","I_boost_pre","I_1_boost_s","I_2_boost_s","I_1_boost_m","I_2_boost_m","I_1_boost_a","I_2_boost_a","R_boost_lt","R_boost_st"];
    groups("N_iso_comm") = ["S_iso","E_iso","I_iso_pre","I_1_iso_s","I_2_iso_s","I_1_iso_m","I_2_iso_m","I_1_iso_a","I_2_iso_a","R_iso_lt","R_iso_st"];
    groups("N_vi_comm") = ["S_vi","E_vi","I_vi_pre","I_1_vi_s","I_2_vi_s","I_1_vi_m","I_2_vi_m","I_1_vi_a","I_2_vi_a","R_vi_lt","R_vi_st"];
    groups("N_bi_comm") = ["S_bi","E_bi","I_bi_pre","I_1_bi_s","I_2_bi_s","I_1_bi_m","I_2_bi_m","I_1_bi_a","I_2_bi_a","R_bi_lt","R_bi_st"];
    groups("N_hosp") = ["H_s","H_m"];
    groups("N_vacc_hosp") = ["H_vacc_s","H_vacc_m"];
    groups("N_boost_hosp") = ["H_boost_s","H_boost_m"];
    groups("N_iso_hosp") = ["H_iso_s","H_iso_m"];
    groups("N_vi_hosp") = ["H_vi_s","H_vi_m"];
    groups("N_bi_hosp") = ["H_bi_s","H_bi_m"];
    
    groups("Susceptible") = ["S","S_vacc","S_boost","S_iso","S_vi","S_bi"]; 
    groups("Susceptible-novacc") = ["S","S_iso"]; 
    groups("Susceptible-vacc") = ["S_vacc","S_vi"]; 
    groups("Susceptible-boost") = ["S_boost","S_bi"]; 
    groups("Recovered") = ["R_lt","R_st","R_vacc_lt","R_vacc_st","R_boost_lt","R_boost_st","R_iso_lt","R_iso_st","R_vi_lt","R_vi_st","R_bi_lt","R_bi_st"];
    groups("Exposed") = ["E","E_vacc","E_boost","E_iso","E_vi","E_bi"];
    groups("Infectious-pre") = ["I_pre","I_vacc_pre","I_boost_pre","I_iso_pre","I_vi_pre","I_bi_pre"];
    groups("Infectious-a") = ["I_1_a","I_2_a","I_1_vacc_a","I_2_vacc_a","I_1_boost_a","I_2_boost_a","I_1_iso_a","I_2_iso_a","I_1_vi_a","I_2_vi_a","I_1_bi_a","I_2_bi_a"];
    groups("Infectious-m-nhosp") = ["I_1_m","I_2_m","I_1_vacc_m","I_2_vacc_m","I_1_boost_m","I_2_boost_m","I_1_iso_m","I_2_iso_m","I_1_vi_m","I_2_vi_m","I_1_bi_m","I_2_bi_m"];
    groups("Infectious-s-nhosp") = ["I_1_s","I_2_s","I_1_vacc_s","I_2_vacc_s","I_1_boost_s","I_2_boost_s","I_1_iso_s","I_2_iso_s","I_1_vi_s","I_2_vi_s","I_1_bi_s","I_2_bi_s"];
    groups("Infectious-m-hosp") = ["H_m","H_vacc_m","H_boost_m","H_iso_m","H_vi_m","H_bi_m"];
    groups("Infectious-s-hosp") = ["H_s","H_vacc_s","H_boost_s","H_iso_s","H_vi_s","H_bi_s"];
    groups("Infectious-m-all") = [groups("Infectious-m-nhosp"),"H_m","H_vacc_m","H_boost_m","H_iso_m","H_vi_m","H_bi_m"];
    groups("Infectious-s-all") = [groups("Infectious-s-nhosp"),"H_s","H_vacc_s","H_boost_s","H_iso_s","H_vi_s","H_bi_s"];
    groups("Infectious-nhosp") = [groups("Infectious-s-nhosp"),groups("Infectious-m-nhosp")];
    groups("Infectious-all") = [groups("Infectious-s-all"),groups("Infectious-m-all"),groups("Infectious-a"),groups("Infectious-pre")];
    groups("COVID-all") = [groups("Infectious-s-all"),groups("Infectious-m-all"),groups("Infectious-a"),groups("Infectious-pre"),groups("Exposed")];
    groups("COVID-sympt") = [groups("Infectious-s-all"),groups("Infectious-m-all")];
    groups("Hospitalized") = [groups("N_hosp"),groups("N_vacc_hosp"),groups("N_boost_hosp"),groups("N_iso_hosp"),groups("N_vi_hosp"),groups("N_bi_hosp")];
    groups("Vaccinated") = [groups("N_vacc_comm"),groups("N_vacc_hosp"),groups("N_vi_comm"),groups("N_vi_hosp")];i_m","H_bi_m"];
    groups("Infectious-s-all") = [groups("Infectious-s-nhosp"),"H_s","H_vacc_s","H_boost_s","H_iso_s","H_vi_s","H_bi_s"];
    groups("Infectious-nhosp") = [groups("Infectious-s-nhosp"),groups("Infectious-m-nhosp")];
    groups("Infectious-all") = [groups("Infectious-s-all"),groups("Infectious-m-all"),groups("Infectious-a"),groups("Infectious-pre")];
    groups("COVID-all") = [groups("Infectious-s-all"),groups("Infectious-m-all"),groups("Infectious-a"),groups("Infectious-pre"),groups("Exposed")];
    groups("COVID-sympt") = [groups("Infectious-s-all"),groups("Infectious-m-all")];
    groups("Hospitalized") = [groups("N_hosp"),groups("N_vacc_hosp"),groups("N_boost_hosp"),groups("N_iso_hosp"),groups("N_vi_hosp"),groups("N_bi_hosp")];
    groups("Vaccinated") = [groups("N_vacc_comm"),groups("N_vacc_hosp"),groups("N_vi_comm"),groups("N_vi_hosp")];
    groups("Boosted") = [groups("N_boost_comm"),groups("N_boost_hosp"),groups("N_bi_comm"),groups("N_bi_hosp")];
    groups("Non-Isolated") = [groups("N_comm"),groups("N_hosp"),groups("N_vacc_comm"),groups("N_vacc_hosp"),groups("N_boost_comm"),groups("N_boost_hosp")];
    groups("Isolated") = [groups("N_iso_comm"),groups("N_iso_hosp"),groups("N_vi_comm"),groups("N_vi_hosp"),groups("N_bi_comm"),groups("N_bi_hosp")];
    
    groups("N") = [groups("Susceptible"),groups("COVID-all"),groups("Recovered")]; 
    groups("System") = [groups("N"), "num_covid","num_back"];
    
    NB_VARIANTS = 10; 
    NB_AGE_GROUPS = 5;
    AGE_GROUPS = 10;
    
    
    dims = size(counters);
    sizeOfCounters = dims(2);
    %myArray = [1:1:sizeOfCounters]

    %imwrite(rgbImage, 'fubar.png');
    
    timelimit = simtimelimit;
    disp(timelimit);
    %whos timelimit
    if(simmethod)
        disp('TRUE');
        %scenario array
        sarray = load(scenfile,"scen","scengroups");
        %Scenarios 
        scen = sarray.scen;
        %Scenario groups 
        scengroups = sarray.scengroups;
        %number of scenarios (length = empty array) 
        numsc = length(scen);
        
        scsim.scenario = [];
        scsim.simulation = [];
        scensim = repmat(scsim,1,numsc);
        
        
        init = zeros(1,length(counters));
        init(id("S")) = pm.Sinit;
        init(id("E")) =pm.Einit;
        init(id("I_pre")) =pm.IPREinit;
        init(id("I_1_s")) = pm.I1Sinit;
        init(id("H_s")) = pm.Hinit;
        init(id("I_1_m")) = pm.I1Minit;
        init(id("I_2_m")) = pm.I2Minit;
        init(id("I_1_a")) = pm.I1Ainit;
        init(id("I_2_a")) = pm.I2Ainit;
        init(id("R_lt")) = pm.Rinit;
                
        init = zeros(1,length(counters));
        init(id("S")) = 0.5*pm.Sinit;
        init(id("E")) =0.5*pm.Einit;
        init(id("I_pre")) =0.5*pm.IPREinit;
        init(id("I_1_s")) = 0.5*pm.I1Sinit;
        init(id("H_s")) = 0.5*pm.Hinit;
        init(id("I_1_m")) = 0.5*pm.I1Minit;
        init(id("I_2_m")) = 0.5*pm.I2Minit;
        init(id("I_1_a")) = 0.5*pm.I1Ainit;
        init(id("I_2_a")) = 0.5*pm.I2Ainit;
        init(id("R_lt")) = 0.5*pm.Rinit;
                 
        %iso
        init(id("S_iso")) = 0.5*pm.Sinit;
        init(id("E_iso")) =0.5*pm.Einit;
        init(id("I_iso_pre")) =0.5*pm.IPREinit;
        init(id("I_1_iso_s")) = 0.5*pm.I1Sinit;
        init(id("H_iso_s")) = 0.5*pm.Hinit;
        init(id("I_1_iso_m")) = 0.5*pm.I1Minit;
        init(id("I_2_iso_m")) = 0.5*pm.I2Minit;
        init(id("I_1_iso_a")) = 0.5*pm.I1Ainit;
        init(id("I_2_iso_a")) = 0.5*pm.I2Ainit;
        init(id("R_iso_lt")) = 0.5*pm.Rinit;
        
          %SIMULATION
                %[t,y] = ode45(odefun,tspan,y0), where tspan = [t0 tf], 
                %integrates the system of differential equations y′=f(t,y) 
                %from t0 to tf with initial conditions y0. Each row in the 
                %solution array y corresponds to a value returned in column vector t.
                [time,solution] = ode45(@f,0:1:timelimit,init);
                simset(iter).time = time;
                simset(iter).sol = transpose(solution);
                simset(iter).fit = -1;
                simset(iter).select = 1;
                if(fitmethod=="fit1")
                    simset(iter).fit = calculatefit(simset(iter).time,simset(iter).sol);
                    simset(iter).select = simset(iter).fit < 5;
                end
            end 
            scensim(sc).scenario = cursc;
            scensim(sc).simulation = simset;
            scensim(sc).maxiter = maxiter;
        end
        

        
    end

end