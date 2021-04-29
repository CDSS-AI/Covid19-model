function sim_multi(simtimelimit)
%     scenfile,simmethod,fitmethod,plotmethod,simiterations,simtimelimit,simfile,
%     disp(scenfile)
%     disp(simmethod)
%     disp(fitmethod)
%     disp(plotmethod)
%     disp(simiterations)
%     disp(simfile)
%     disp(simtimelimit)
    nb_variants=2;
    nb_pop=5;
    
%     
%     counters = ["S","E","I_pre","I_1_s","I_2_s","I_1_m","I_2_m","I_1_a","I_2_a","H_s","H_m","R_lt","R_st",...
%     "S_iso","E_iso","I_iso_pre","I_1_iso_s","I_2_iso_s","I_1_iso_m","I_2_iso_m","I_1_iso_a","I_2_iso_a","H_iso_s","H_iso_m","R_iso_lt","R_iso_st",...
%     "S_vacc","E_vacc","I_vacc_pre","I_1_vacc_s","I_2_vacc_s","I_1_vacc_m","I_2_vacc_m","I_1_vacc_a","I_2_vacc_a","H_vacc_s","H_vacc_m","R_vacc_lt","R_vacc_st",...
%     "S_boost","E_boost","I_boost_pre","I_1_boost_s","I_2_boost_s","I_1_boost_m","I_2_boost_m","I_1_boost_a","I_2_boost_a","H_boost_s","H_boost_m","R_boost_lt","R_boost_st",...
%     "S_vi","E_vi","I_vi_pre","I_1_vi_s","I_2_vi_s","I_1_vi_m","I_2_vi_m","I_1_vi_a","I_2_vi_a","H_vi_s","H_vi_m","R_vi_lt","R_vi_st",...
%     "S_bi","E_bi","I_bi_pre","I_1_bi_s","I_2_bi_s","I_1_bi_m","I_2_bi_m","I_1_bi_a","I_2_bi_a","H_bi_s","H_bi_m","R_bi_lt","R_bi_st",...
%     "num_inf","num_inf_pre","num_inf_asym","num_inf_sym","num_inf_hosp","num_hosp","num_rec","num_covid","num_back","num_arr","num_vacc","num_boost",...
%     "num_inf_iso","num_inf_pre_iso","num_inf_asym_iso","num_inf_sym_iso","num_inf_hosp_iso","num_hosp_iso","num_rec_iso","num_covid_iso","num_back_iso","num_arr_iso","num_vacc_iso","num_boost_iso",...
%     "num_inf_nonvacc","num_inf_vacc","num_inf_boost","num_inf_nonvi","num_inf_vi","num_inf_bi",...
%     "num_inf_sev_nonvacc","num_inf_mild_nonvacc","num_inf_asym_nonvacc","num_inf_sev_vacc","num_inf_mild_vacc","num_inf_asym_vacc",...
%     "num_inf_sev_boost","num_inf_mild_boost","num_inf_asym_boost","num_inf_sev_vi","num_inf_mild_vi","num_inf_asym_vi",...
%     "num_inf_sev_bi","num_inf_mild_bi","num_inf_asym_bi"];


    disease_steps = ["S","I_1", "I_2", "R"];
    
     function v = id(g)
        %Inputs
        %g : vector of compartment names
        %Output
        %v : indices of elements of group in counters
        [s,v] = intersect(disease_steps,g,'stable');
    end
    
    variants = zeros(1, nb_variants);
    for counter = 1:nb_variants
        variants(counter) = counter;
    end
    
    populations = zeros(1, (100/nb_pop));
    for counter2 = 1: (100/nb_pop)
        populations(counter) = counter2;
    end
    
    compartmentList = zeros(length(disease_steps), length(variants), length(populations));
    
    for i=1 : length(disease_steps) 
        for j=1: length(variants)
            for k = 1 : length(populations)
                compartmentList(i,j,k) = calculateValue(disease_steps(i),variants(j),populations(k));
            end
        end    
    end
    
    parameters_vector = [disease_steps variants populations];
    
    transition_matrix = zeros(length(parameters_vector), length(parameters_vector));
    
    for i=1:length(transition_matrix)
        for j=1:length(transition_matrix)
            transition_matrix(i,j) = 0.1;
        end 
    end
    
    
%     disp('TRANSITION MATRIX:');
%     disp(transition_matrix)
%     disp('______________________________________________');
    
    
    
    timelimit = simtimelimit;
   
     %Init 
    pm = InitParams();
    init.S = pm.Sinit;
    init.I_1 =pm.I1init;
    init.I_2 =pm.I2init;
    init.R = pm.Rinit;
    
  
    initVec = zeros(1,length(disease_steps)); 
    
    
    function dx = defSolver(t,x)
        dx = zeros(length(x),1);
        vals = [init.S, init.I_1, init.I_2, init.R];

       %Equations
       d1 = (pm.beta_s * vals(1)) - (pm.delta * (x*vals(1))) - (pm.lambda * (x*vals(2))) - (pm.lambda * (x*vals(3))) - (pm.r*x);
       dx(1) = sum(d1);
       
       d2 = (pm.beta_s*vals(1)) - (pm.delta * (x*vals(2))) - (pm.r * (x*vals(2)));
       dx(2) = sum(d2);
       
       d3 = (pm.delta*vals(1)) - (pm.delta  *(x*vals(2))) - pm.r * (x*vals(3));
       dx(3) = sum(d3);
       
       d4 = (pm.r*vals(2) + pm.r*vals(3)) - (pm.delta * pm.r) - (pm.r * x); 
       dx(4) = sum(d4);
       
   
    end
    
    [time,solution] = ode45(@defSolver,0:1:timelimit, initVec);
    s_end = solution(:,1);
    I_1_end = solution(:,2);
    I_2_end = solution(:,3);
    R_end = solution(:,4);
    
    graphsBuilder(time, s_end); 
    graphsBuilder(time, I_1_end); 
    graphsBuilder(time, I_2_end);
    graphsBuilder(time, R_end); 
    
end