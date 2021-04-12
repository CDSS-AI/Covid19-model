
%=================scenario specificaions
sc=["Esym60","Esym70","Esym90","Esym95","Esev60","Esev70","Esev90","Esev95"];%k
NPI = ["NPI1","NPI2","NPI3"];%n
Cov=["Cov1","Cov2","Cov3"];%d

numdose = [12000,19000,33000];%d from 1s march
type = [2,3,4];%n type of contact rate
Effsym = [0.60, 0.70, 0.90, 0.95, 0, 0, 0, 0];%k
Effsev = [0, 0, 0, 0, 0.60, 0.70, 0.90, 0.95];%k

%==============generate parameters for scenario

for d = 1 : length(numdose)
    for n = 1 : length(type)
       for k = 1 : length(Effsym)

    load("scenfit_19-02-2021_fitdecember.mat");

   vec = [34,67,136,206,231,301,307,327,370,377,411,448,451,479,506,507,519];%selected runs
   %Rt for J98 NPI1
   rtvec=[0.93393527438053,0.900546753746151,0.896434620911024,0.896020164724363,0.910811769370522,0.936667137496388,0.914060757076784,0.904593494769939,0.921905610147689,0.902704680808975,0.92493624021506,0.906905737818405,0.923750353952131,0.945591530969557,0.944188512395993,0.953438443957932,0.849881882535915];
   
   scenselect = scen(vec);
   listscennames = repmat("A",1,length(vec));

for i = 1 : length(vec)
      curpm = scenselect(i).pm;

      curpm.func_c_eff_type = type(n);%modify for each type
    if (curpm.func_c_eff_type == 4)
         curpm.rtfeb=rtvec(i);
     end    
        

 %parameters for the vaccin scenario:
% %========================================SC1
    curpm.delta_vacc = @(t) 0*(t<90) + numdose(d)*(t>=90); %TIME VARYING:modify numdose
%     curpm.boost_option = "sc1";
%     curpm.delta_boost = @(t) 0*(t<90+14) +numdose(2)*(t>=90+14);%TIME VARYING:modify numdose
    curpm.boost_option = "rate";
    curpm.delta_boost = 1/14;
    curpm.omega_vacc = 0;
    curpm.omega_boost = 0;
% %Scenarios Eff=================================
    curpm.E_vacc_acq = 0;
    curpm.E_vacc_inf = 0;
    curpm.E_vacc_sympt = 0;
    curpm.E_vacc_sev = 0;
    curpm.E_boost_acq = 0;%modify for different efficacy 
    curpm.E_boost_inf = 0 ;%modify for different efficacy 
    curpm.E_boost_sympt = Effsym(k);%modify for different efficacy 
    curpm.E_boost_sev = Effsev(k);%modify for different efficacy 
% %===============================================================================
% %=======================================
    curpm.beta_vacc_pre = (1-curpm.E_vacc_inf)*curpm.beta_pre;
    curpm.beta_vacc_s = (1-curpm.E_vacc_inf)*curpm.beta_s;
    curpm.beta_vacc_m = (1-curpm.E_vacc_inf)*curpm.beta_m;
    curpm.beta_vacc_a = (1-curpm.E_vacc_inf)*curpm.beta_a;
    curpm.beta_H_vacc_s = (1-curpm.E_vacc_inf)*curpm.beta_H_s;
    curpm.beta_H_vacc_m = (1-curpm.E_vacc_inf)*curpm.beta_H_m;
    curpm.beta_boost_pre = (1-curpm.E_boost_inf)*curpm.beta_pre;
    curpm.beta_boost_s = (1-curpm.E_boost_inf)*curpm.beta_s;
    curpm.beta_boost_m = (1-curpm.E_boost_inf)*curpm.beta_m;
    curpm.beta_boost_a = (1-curpm.E_boost_inf)*curpm.beta_a;
    curpm.beta_H_boost_s = (1-curpm.E_boost_inf)*curpm.beta_H_s;
    curpm.beta_H_boost_m = (1-curpm.E_boost_inf)*curpm.beta_H_m;
    
    curpm.f_vacc_sev = (1-curpm.E_vacc_sev)*curpm.f_sev;
    curpm.f_a_vacc_pre = 1-(1-curpm.E_vacc_sympt)*(curpm.f_m_pre + curpm.f_s_pre);
    curpm.f_m_vacc_pre = (1-curpm.f_vacc_sev)*(1-curpm.E_vacc_sympt)*(curpm.f_m_pre + curpm.f_s_pre);
    curpm.f_s_vacc_pre = curpm.f_vacc_sev*(1-curpm.E_vacc_sympt)*(curpm.f_m_pre + curpm.f_s_pre);
    curpm.f_boost_sev = (1-curpm.E_boost_sev)*curpm.f_sev;
    curpm.f_a_boost_pre = 1-(1-curpm.E_boost_sympt)*(curpm.f_m_pre + curpm.f_s_pre);
    curpm.f_m_boost_pre = (1-curpm.f_boost_sev)*(1-curpm.E_boost_sympt)*(curpm.f_m_pre + curpm.f_s_pre);
    curpm.f_s_boost_pre = curpm.f_boost_sev*(1-curpm.E_boost_sympt)*(curpm.f_m_pre + curpm.f_s_pre);

%=========================================================================   
    scenselect(i).pm = curpm;
    scenselect(i).name = scenselect(i).name + append(sc(k),"-",NPI(n),"-",Cov(d));
   
    listscennames(i) = scenselect(i).name;
end
scenselectgroups = containers.Map;
scenselectgroups(append("Fit-",sc(k),"-",NPI(n),"-",Cov(d))) = listscennames;

scen = scenselect;
scengroups = scenselectgroups;


file_name= append("scenfit_vaccine_",sc(k),"-",NPI(n),"-",Cov(d),".mat");

save(file_name,"scen","scengroups")
       
       end
   end
end
