function simulate(scenfile,simmethod,fitmethod,plotmethod,simiterations,simtimelimit,simfile)
    
    colors = {[0, 0.4470, 0.7410],[0.8500, 0.3250, 0.0980],[0.9290, 0.6940, 0.1250],[0.4940, 0.1840, 0.5560],[0.4660, 0.6740, 0.1880],[0.3010, 0.7450, 0.9330],[0.6350, 0.0780, 0.1840]};
    
    %counters = ["S","E","I_pre","I_1_s","I_2_s","I_1_m","I_2_m","I_1_a","I_2_a","H_s","H_m","R_lt","R_st","num_inf","num_inf_pre","num_inf_asym","num_inf_sym","num_inf_hosp","num_hosp","num_rec","num_covid","num_back","num_arr"];
   
    
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
    groups("Infectious-m-all") = [groups("Infectious-m-nhosp"),"H_m","H_vacc_m","H_boost_m","H_iso_m","H_vi_m","H_bi_m"];
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


    timelimit = simtimelimit;
    
    if(simmethod == "sim")
        sarray = load(scenfile,"scen","scengroups");
        scen = sarray.scen;
        scengroups = sarray.scengroups;
        numsc = length(scen);
        scsim.scenario = [];
        scsim.simulation = [];
        scensim = repmat(scsim,1,numsc);
        
        for sc = 1:numsc
            cursc = scen(sc);
            disp("Current scenario : " + cursc.name);
            
    
            maxiter = simiterations;
            sim.pm = [];
            sim.time = [];
            sim.sol = [];
            simset = repmat(sim,1,maxiter);
            
            
         
            

            for iter = 1:maxiter
                curpm = cursc.pm(iter);
                
                iter
                simset(iter).pm = curpm;
                pm = curpm;
                
                 %counters = ["S","E","I_pre","I_1_s","I_2_s","I_1_m","I_2_m","I_1_a","I_2_a","H_s","H_m","R_lt","R_st","num_inf","num_inf_pre","num_inf_asym","num_inf_sym","num_inf_hosp","num_hosp","num_rec","num_covid","num_back","num_arr"];
   
                %INITIALIZATION
                
                
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
                
%                 init = zeros(1,length(counters));
%                 init(id("S")) = 0.5*pm.Sinit;
%                 init(id("E")) =0.5*pm.Einit;
%                 init(id("I_pre")) =0.5*pm.IPREinit;
%                 init(id("I_1_s")) = 0.5*pm.I1Sinit;
%                 init(id("H_s")) = 0.5*pm.Hinit;
%                 init(id("I_1_m")) = 0.5*pm.I1Minit;
%                 init(id("I_2_m")) = 0.5*pm.I2Minit;
%                 init(id("I_1_a")) = 0.5*pm.I1Ainit;
%                 init(id("I_2_a")) = 0.5*pm.I2Ainit;
%                 init(id("R_lt")) = 0.5*pm.Rinit;
%                 
%                 %iso
%                 init(id("S_iso")) = 0.5*pm.Sinit;
%                 init(id("E_iso")) =0.5*pm.Einit;
%                 init(id("I_iso_pre")) =0.5*pm.IPREinit;
%                 init(id("I_1_iso_s")) = 0.5*pm.I1Sinit;
%                 init(id("H_iso_s")) = 0.5*pm.Hinit;
%                 init(id("I_1_iso_m")) = 0.5*pm.I1Minit;
%                 init(id("I_2_iso_m")) = 0.5*pm.I2Minit;
%                 init(id("I_1_iso_a")) = 0.5*pm.I1Ainit;
%                 init(id("I_2_iso_a")) = 0.5*pm.I2Ainit;
%                 init(id("R_iso_lt")) = 0.5*pm.Rinit;
                
                %SIMULATION
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
        
        save(simfile,"scengroups","scensim");
    elseif(simmethod == "load")
        load(simfile,"scengroups","scensim");
    end
    
    makeplots();
    %makestats();
    
    function makeplots()
        scenkeys = keys(scengroups);
        for k = 1 : length(scenkeys)
            curgr = scengroups(scenkeys{k});
            plotlist(curgr,scenkeys{k});
        end
    end

    %function makestats()
        %scenkeys = keys(scengroups);
        %for k = 1 : length(scenkeys)
            %curgr = scengroups(scenkeys{k});
            %statlist(curgr,scenkeys{k});
        %end
    %end
    
    function plotlist(gr,name)
        s = getscen(gr);
        
        %%plotcountfit(s,"num_covid","Cumulative count of COVID deaths",[25 150])
        plotratio(s,"Exposed","COVID-all",100,"Fraction of exposed person(%)",name)
        
        plotrt(s,"Susceptible","N","Real time reproduction number",name)
        
        plotcount(s,"Boosted","Prevalence count of boosted",name)
        plotratio(s,"Boosted","N",100,"Fraction of boosted persons (%)",name)
        plotcount(s,"Vaccinated","Number of vaccinated persons",name)
        plotratio(s,"Vaccinated","N",100,"Fraction of vaccinated persons (%)",name)
        plotcount(s,"num_boost","Cumulative count of boost dose",name)
        plotcount(s,"num_vacc","Cumulative count of vaccine dose",name)
       
        
        plotcount(s,"Susceptible-novacc","Number of susceptible non vaccinated persons",name)
        plotratio(s,"Susceptible-novacc","N",100,"Fraction of susceptible non vaccinated persons (%)",name)
        plotcount(s,"Susceptible-boost","Number of susceptible boosted persons",name)
        
        plotcount(s,"num_covid","Cumulative count of COVID deaths",name)
        plotcountdaily(s,"num_covid","Daily count of COVID deaths",name)    
        plotcountdaily(s,"num_hosp","Daily count of hospitalizations",name)
        plotcount(s,"COVID-all","Prevalence count of COVID+ persons",name)
        plotcount(s,"Hospitalized","Number of persons currently hospitalized for COVID",name)
        plotcount(s,"num_hosp","Cumulative count of COVID hospitalizations",name)
        plotratio(s,"num_covid","N",100000,"Cumulative count of COVID deaths (per 100k persons)",name)
        plotratio(s,"COVID-all","N",100,"Prevalence fraction of COVID+ persons (%)",name)
        plotcount(s,"N","Total population size",name)
        plotcount(s,"num_inf","Cumulative count of COVID infections",name)
        plotcount(s,"num_inf_sym","Cumulative count of symptomatic COVID infections",name)
        plotratio(s,"num_inf_sym","N",100000,"Cumulative count of symptomatic COVID infections (per 100k persons)",name)
        plotcountdaily(s,"num_inf_sym","Daily number of symptomatic COVID infections",name)
        plotratio(s,"num_inf","N",100000,"Cumulative count of COVID infections (per 100k persons)",name)
        plotratio(s,"num_hosp","N",100000,"Cumulative count of COVID hospitalizations (per 100k persons)",name)
        plotcountdaily(s,"num_inf","Daily number of COVID infections",name)
        
        
        
        
        plotratio(s,"COVID-sympt","N",100,"Prevalence fraction of Symptomatic COVID infections (%)",name)
        plotratio(s,"Hospitalized","N",100,"Prevalence fraction of Hospitalization(%)",name)
        
        plotcount(s,"num_inf_vacc","Cumulative count of COVID infections in vaccinated persons",name)
        plotcount(s,"num_inf_boost","Cumulative count of COVID infections in boosted persons",name)
        plotcount(s,"num_inf_nonvacc","Cumulative count of COVID infections in non vaccinated persons",name)
        plotcountdaily(s,"num_inf_vacc","Daily count of COVID infections in vaccinated persons",name)
        plotcountdaily(s,"num_inf_boost","Daily count of COVID infections in boosted persons",name)
        plotcountdaily(s,"num_inf_nonvacc","Daily count of COVID infections in non vaccinated persons",name)
        
        plotcount(s,"num_inf_sev_vacc","Cumulative count of severe symptomatic COVID infections in vaccinated persons",name)
        plotcount(s,"num_inf_sev_boost","Cumulative count of severe symptomatic COVID infections in boosted persons",name)
        plotcount(s,"num_inf_sev_nonvacc","Cumulative count of severe symptomatic COVID infections in non vaccinated persons",name)
        plotcountdaily(s,"num_inf_sev_vacc","Daily count of  severe symptomatic COVID infections in vaccinated persons",name)
        plotcountdaily(s,"num_inf_sev_boost","Daily count of severe symptomatic COVID  infections in boosted persons",name)
        plotcountdaily(s,"num_inf_sev_nonvacc","Daily count of severe symptomatic COVID infections in non vaccinated persons",name)
        
        plotcount(s,"num_inf_mild_vacc","Cumulative count of mild symptomatic COVID infections in vaccinated persons",name)
        plotcount(s,"num_inf_mild_boost","Cumulative count of mild symptomatic COVID infections in boosted persons",name)
        plotcount(s,"num_inf_mild_nonvacc","Cumulative count of mild symptomatic COVID infections in non vaccinated persons",name)
        plotcountdaily(s,"num_inf_mild_vacc","Daily count of  mild symptomatic COVID infections in vaccinated persons",name)
        plotcountdaily(s,"num_inf_mild_boost","Daily count of  mild symptomatic COVID infections in boosted persons",name)
        plotcountdaily(s,"num_inf_mild_nonvacc","Daily count of  mild symptomatic COVID infections in non vaccinated persons",name)
        
        plotcount(s,"num_inf_asym_vacc","Cumulative count of asymptomatic COVID infections in vaccinated persons",name)
        plotcount(s,"num_inf_asym_boost","Cumulative count of asymptomatic COVID infections in boosted persons",name)
        plotcount(s,"num_inf_asym_nonvacc","Cumulative count of asymptomatic COVID infections in non vaccinated persons",name)
        plotcountdaily(s,"num_inf_asym_vacc","Daily count of  asymptomatic COVID infections in vaccinated persons",name)
        plotcountdaily(s,"num_inf_asym_boost","Daily count of asymptomatic COVID infections in boosted persons",name)
        plotcountdaily(s,"num_inf_asym_nonvacc","Daily count of asymptomatic COVID infections in non vaccinated persons",name)
        
        plotcount(s,"Isolated","Prevalence count of isolated",name)
        
        plotcount(s,"Recovered","Number of COVID-recovered persons",name)
        plotratio(s,"Recovered","N",100,"Fraction of COVID-recovered persons (%)",name)
        
        plotcount(s,"System","Population and deaths in system",name)
%         
    end

function statlist(gr,name)
        s = getscen(gr);
        %plotcountdaily(s,"num_inf","Daily number of COVID infections",name)
        %%plotcountfit(s,"num_covid","Cumulative count of COVID deaths",[25 150])
        stattime = 50;
        statcount(s,"num_covid","Cumulative count of COVID deaths",name,stattime)
        statcount(s,"num_hosp","Cumulative count of COVID hospitalizations",name,stattime)
        statcount(s,"num_inf","Cumulative count of COVID infections",name,stattime)
        
    end

    function s = getscen(gr)
        v = zeros(1,length(gr));
        found = 0;
        
        for n = 1:length(scensim)
            if(sum(scensim(n).scenario.name==gr)>0)
                found = found+1;
                v(found) = n;
            end
        end

        se.scenario = [];
        se.simulation = [];
        se.maxiter = [];
        s = repmat(se,1,length(gr));
        
       
        for n = 1:length(gr)
            s(n) = scensim(v(n));
        end
    end
    
    function statcount(s,A,titl,scname,sttime)
            vnames = repmat("",1,length(s));
            statnames = repmat("",1,4);
            statnames(1) = "mean";
            statnames(2) = "std";
            statnames(3) = "median";
            statnames(4) = "iqr";
            matr = zeros(length(s), 4);
            
            for pl = 1 : length(s) 
                vnames(pl) = s(pl).scenario.name;
                vs = zeros(1,s(pl).maxiter);
                for it = 1 : s(pl).maxiter
                    vc = count(s(pl).simulation(it).sol,A);
                    vt = s(pl).simulation(it).time;
                    idxt = find(vt == sttime);
                    vs(it) = vc(idxt);
                end
                matr(pl,1) = mean(vs);
                matr(pl,2) = std(vs);
                matr(pl,3) = median(vs);
                matr(pl,4) = iqr(vs);
                
            end
            %save somehow
            matr
            
            %imwrite(frame2im(getframe(gcf)),extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").png",'WriteMode','overwrite');
        
            
    end
    
    function plotcount(s,A,titl,scname)

        col = get(gca,'colororder');
        

        %hold on
        
        if(plotmethod=="lines")
            
            vnames = repmat("",1,length(s));
            varNames = ["Scen"];
            varTypes = ["string"];
            for i = 0:timelimit
                varNames = [varNames,strcat('J',string(i))];
                varTypes = [varTypes,"double"];
            end
            
            sz = [3 length(varNames)];
            tabPlots = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
            for pl = 1 : length(s)
                vnames(pl) = s(pl).scenario.name;
                vc = count(s(pl).simulation(1).sol,A);
                %plot(s(pl).simulation(1).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2)
                
                tabPlots(pl,1) = {string(vnames(pl))};
                tabPlots(pl,2:1+length(vc)) = num2cell(vc);
            end   
            for pl = 1 : length(s) 
                if(s(pl).maxiter > 1)
                    for it = 2 : s(pl).maxiter
                        vc = count(s(pl).simulation(it).sol,A);
                        %plot(s(pl).simulation(it).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
                        %tabPlots(1,:) = {};
                    end
                end
            end
            %legend(vnames);
            %title({scname,titl});
            %xlabel("Simulation day");
        elseif(plotmethod=="boxes")
            vec = [];
            scvec = [];
            cvec = [];
            vnames = repmat("",1,length(s));
            for pl = 1 : length(s)
                vnames(pl) = s(pl).scenario.name;
                cvec = [cvec;col(1+mod(pl,7),:)];
                for itm = 1:floor(simtimelimit/30)
                    for it = 1 : s(pl).maxiter
                        vc =  count(s(pl).simulation(it).sol,A);  
                        vec = [vec;vc(1+30*itm)];
                        scvec = [scvec; strcat("Mth ", num2str(itm)," (", vnames(pl),")")];
                    end 
                end
            end
            cvecm = [];
            for itm = 1:floor(simtimelimit/30)
                cvecm = [cvecm;cvec];
            end
            %boxplot(vec,scvec,'GroupOrder',unique(scvec,"sorted"),'Colors',cvecm);
            %legend(vnames);
            %title({scname,titl});
            %xlabel("Month");
        end
        
        %hold off
        %imwrite(frame2im(getframe(gcf)),extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").png",'WriteMode','overwrite');
        writetable(tabPlots,extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").csv");
        close;
    end

    function plotrt(s,A,B,titl,scname)

        col = get(gca,'colororder');
        vnames = repmat("",1,length(s));
        varNames = ["Scen"];
        varTypes = ["string"];
        for i = 0:timelimit
            varNames = [varNames,strcat('J',string(i))];
            varTypes = [varTypes,"double"];
        end

        sz = [3 length(varNames)];
        tabPlots = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        %hold on
        for pl = 1 : length(s)
            vnames(pl) = s(pl).scenario.name;
          
            vc = s(pl).simulation(1).pm.r0(s(pl).simulation(1).time,s(pl).simulation(1).pm).*ratio(s(pl).simulation(1).sol,A,B);
            
            %plot(s(pl).simulation(1).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
            tabPlots(pl,1) = {string(vnames(pl))};
            tabPlots(pl,2:1+length(vc)) = num2cell(vc);
           
        
        end
        for pl = 1 : length(s) 
            if(s(pl).maxiter > 1)
                for it = 2 : s(pl).maxiter
                    vc = s(pl).simulation(it).pm.r0(s(pl).simulation(it).time,s(pl).simulation(it).pm).*ratio(s(pl).simulation(it).sol,A,B);
                    %plot(s(pl).simulation(it).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2)
                    %tabPlots(1,:) = {};
                end
            end
        end

        %legend(vnames);
        %title({scname,titl});
        %xlabel("Simulation day");
        %hold off
        %imwrite(frame2im(getframe(gcf)),extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").png",'WriteMode','overwrite');
        writetable(tabPlots,extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").csv");
        close;
    end


    function plotcountdaily(s,A,titl,scname)
        col = get(gca,'colororder');
        vnames = repmat("",1,length(s));
        varNames = ["Scen"];
        varTypes = ["string"];
        for i = 1:timelimit
            varNames = [varNames,strcat('J',string(i))];
            varTypes = [varTypes,"double"];
        end

        sz = [3 length(varNames)];
        tabPlots = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        %hold on
        for pl = 1 : length(s)
            vnames(pl) = s(pl).scenario.name;
            vc = count(s(pl).simulation(1).sol,A);
            %plot(s(pl).simulation(1).time(2:end),vc(2:end)-vc(1:end-1),'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
            tabPlots(pl,1) = {string(vnames(pl))};
            tabPlots(pl,2:length(vc)) = num2cell(vc(2:end)-vc(1:end-1));
        end
        for pl = 1 : length(s)
            if(s(pl).maxiter > 1)
                for it = 2 : s(pl).maxiter
                    vc = count(s(pl).simulation(it).sol,A);
                    %plot(s(pl).simulation(it).time(2:end),vc(2:end)-vc(1:end-1),'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
                end
            end
        
        end
        %legend(vnames);
        %title({scname,titl});
        %xlabel("Simulation day");
        %hold off
        %imwrite(frame2im(getframe(gcf)),extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").png",'WriteMode','overwrite');
        writetable(tabPlots,extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").csv");
        close;
        
    end

    

    function plotcountfit(s,A,titl,pt)
        figure
        %hold on
        for it = 1 : length(simset)
            %plot(simset(it).time,count(simset(it).sol,A)) 
        end
        scatter(pt(1),pt(2),'k*');
        %title(titl);
        %xlabel("Simulation time (days)");
        %hold off
        close;
    end

    function plotratio(s,A,B,scale,titl,scname)
        
        col = get(gca,'colororder');
        vnames = repmat("",1,length(s));

        varNames = ["Scen"];
        varTypes = ["string"];
        for i = 0:timelimit
            varNames = [varNames,strcat('J',string(i))];
            varTypes = [varTypes,"double"];
        end

        sz = [3 length(varNames)];
        tabPlots = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
        %hold on
        for pl = 1 : length(s)
            vnames(pl) = s(pl).scenario.name;

            vc = scale*ratio(s(pl).simulation(1).sol,A,B);
            %plot(s(pl).simulation(1).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
            tabPlots(pl,1) = {string(vnames(pl))};
            tabPlots(pl,2:1+length(vc)) = num2cell(vc);
        
        end
        for pl = 1 : length(s)
            if(s(pl).maxiter > 1)
                for it = 2 : s(pl).maxiter
                    vc = scale*ratio(s(pl).simulation(it).sol,A,B);
                    %plot(s(pl).simulation(it).time,vc,'-ko', 'Color', col(1+mod(pl,7),:),'MarkerSize',2) 
                end
            end
        
        end
        %legend(vnames);
        %title({scname,titl});
        %xlabel("Simulation day");
        %hold off
        %imwrite(frame2im(getframe(gcf)),extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").png",'WriteMode','overwrite');
        writetable(tabPlots,extractBefore(simfile,".mat")+"_("+scname+" -- "+titl+").csv");
        close;
    end

    
    function v = id(g)
        %Inputs
        %g : vector of compartment names
        %Output
        %v : indices of elements of group in counters
        [s,v] = intersect(counters,g,'stable');
    end

    function s = count(sol,g)
        %s = zeros(1,length(time));
        %gr = groups(name);
        %for i = 1 : length(gr)
        %    s = s + sol(idx(gr{i}),:);
        %end
        if(isKey(groups,g))
            s = sum(sol(id(groups(g)),:),1);
        else
            s = sol(id(g),:);
        end
    end

    function s = ratio(sol,g1,g2)
        s = count(sol,g1)./count(sol,g2);
    end

    function dx = f(t,x)
        function v = xid(g)
            %Input
            %g : compartment or group name
            %Output
            %v : elements of x for g
            if(isKey(groups,g))
                v = x(id(groups(g)));
            else
                v = x(id(g));
            end
        end
        function s = xsum(g)
            %Input
            %g : group name
            %Output
            %s : sum of elements of x for g
            s = sum(xid(g));
        end
        
        dx = zeros(length(x),1);
        
        
        %aaa=0.5;
        %pm.c_base = 11/(1+exp(aaa*(t-30))) + 5*(1/(1+exp(-aaa*(t-30))) - 1/(1+exp(-aaa*(t-45))))+ 5*(1/(1+exp(-aaa*(t-45))) - 1/(1+exp(-aaa*(t-60))))+ 4*(1/(1+exp(-aaa*(t-60)))-1/(1+exp(-aaa*(t-75))))+ 3.5*(1/(1+exp(-aaa*(t-75)))-1/(1+exp(-aaa*(t-90))))+ 2*(1/(1+exp(-aaa*(t-90)))-1/(1+exp(-aaa*(t-120))))+ 5*(1/(1+exp(-aaa*(t-120)))-1/(1+exp(-aaa*(t-150))))+ 4*(1/(1+exp(-aaa*(t-150)))-1/(1+exp(-aaa*(t-180))))+ 8*(1/(1+exp(-aaa*(t-180)))-1/(1+exp(-aaa*(t-195))))+ 7*(1/(1+exp(-aaa*(t-195)))-1/(1+exp(-aaa*(t-210))))+ 4.5*(1/(1+exp(-aaa*(t-210))));
        %pm.prop_out = 0.15/(1+exp(aaa*(t-35-90))) + 0.75*(1/(1+exp(-aaa*(t-35-90))) - 1/(1+exp(-aaa*(t-35-180))))+ 0.15*(1/(1+exp(-aaa*(t-35-180))));
        %if(t<60%)
        %    pm.c_base = 12;
        %elseif(t>=60 && t < 60+90)
        %    pm.c_base = 3;
        %elseif(t>=60+90 && t < 60+180)
        %%    pm.c_base = 6;
       %     pm.prop_out = 0.75;
       % else
       %     pm.c_base = 6;
       %     pm.prop_out = 0.25;
       % end
        
       
           
   
        N_adj = pm.c_eff(t,pm)*xsum("N_comm") + pm.c_vacc_eff(t,pm)*xsum("N_vacc_comm") + pm.c_boost_eff(t,pm)*xsum("N_boost_comm") + pm.c_iso_eff(t,pm)*xsum("N_iso_comm") + pm.c_vi_eff(t,pm)*xsum("N_vi_comm") + pm.c_bi_eff(t,pm)*xsum("N_bi_comm") + pm.c_hosp*xsum("N_hosp") + pm.c_vacc_eff(t,pm)*xsum("N_vacc_hosp") + pm.c_boost_eff(t,pm)*xsum("N_boost_hosp") + pm.c_iso_eff(t,pm)*xsum("N_iso_hosp") + pm.c_vi_eff(t,pm)*xsum("N_vi_hosp") + pm.c_bi_eff(t,pm)*xsum("N_bi_hosp");
        LAMB = pm.c_eff(t,pm)*(pm.beta_pre*xid("I_pre") + pm.beta_s*(xid("I_1_s")+xid("I_2_s")) + pm.beta_m*(xid("I_1_m")+xid("I_2_m")) + pm.beta_a*(xid("I_1_a")+xid("I_2_a")));
        LAMB = LAMB + pm.c_vacc_eff(t,pm)*(pm.beta_vacc_pre*xid("I_vacc_pre") + pm.beta_vacc_s*(xid("I_1_vacc_s")+xid("I_2_vacc_s")) + pm.beta_vacc_m*(xid("I_1_vacc_m")+xid("I_2_vacc_m")) + pm.beta_vacc_a*(xid("I_1_vacc_a")+xid("I_2_vacc_a")));
        LAMB = LAMB + pm.c_boost_eff(t,pm)*(pm.beta_boost_pre*xid("I_boost_pre") + pm.beta_boost_s*(xid("I_1_boost_s")+xid("I_2_boost_s")) + pm.beta_boost_m*(xid("I_1_boost_m")+xid("I_2_boost_m")) + pm.beta_boost_a*(xid("I_1_boost_a")+xid("I_2_boost_a")));
        LAMB = LAMB + pm.c_iso_eff(t,pm)*(pm.beta_pre*xid("I_iso_pre") + pm.beta_s*(xid("I_1_iso_s")+xid("I_2_iso_s")) + pm.beta_m*(xid("I_1_iso_m")+xid("I_2_iso_m")) + pm.beta_a*(xid("I_1_iso_a")+xid("I_2_iso_a")));
        LAMB = LAMB + pm.c_vi_eff(t,pm)*(pm.beta_vi_pre*xid("I_vi_pre") + pm.beta_vi_s*(xid("I_1_vi_s")+xid("I_2_vi_s")) + pm.beta_vi_m*(xid("I_1_vi_m")+xid("I_2_vi_m")) + pm.beta_vi_a*(xid("I_1_vi_a")+xid("I_2_vi_a")));
        LAMB = LAMB + pm.c_bi_eff(t,pm)*(pm.beta_bi_pre*xid("I_bi_pre") + pm.beta_bi_s*(xid("I_1_bi_s")+xid("I_2_bi_s")) + pm.beta_bi_m*(xid("I_1_bi_m")+xid("I_2_bi_m")) + pm.beta_bi_a*(xid("I_1_bi_a")+xid("I_2_bi_a")));
        LAMB = LAMB + pm.c_hosp*(pm.beta_H_s*xid("H_s") + pm.beta_H_m*xid("H_m"));
        LAMB = LAMB + pm.c_vacc_hosp*(pm.beta_H_vacc_s*xid("H_vacc_s") + pm.beta_H_vacc_m*xid("H_vacc_m"));
        LAMB = LAMB + pm.c_boost_hosp*(pm.beta_H_boost_s*xid("H_boost_s") + pm.beta_H_boost_m*xid("H_boost_m"));
        LAMB = LAMB + pm.c_iso_hosp*(pm.beta_H_s*xid("H_iso_s") + pm.beta_H_m*xid("H_iso_m"));
        LAMB = LAMB + pm.c_vi_hosp*(pm.beta_H_vacc_s*xid("H_vi_s") + pm.beta_H_vacc_m*xid("H_vi_m"));
        LAMB = LAMB + pm.c_bi_hosp*(pm.beta_H_boost_s*xid("H_bi_s") + pm.beta_H_boost_m*xid("H_bi_m"));
        
        lambda = (pm.c_eff(t,pm)/N_adj)*LAMB;
        lambda_lt = (1-pm.phi_lt)*(pm.c_eff(t,pm)/N_adj)*LAMB;
        lambda_st = (1-pm.phi_st)*(pm.c_eff(t,pm)/N_adj)*LAMB;
        lambda_vacc = (1-pm.E_vacc_acq)*(pm.c_vacc_eff(t,pm)/N_adj)*LAMB;
        lambda_vacc_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vacc_eff(t,pm)/N_adj)*LAMB;
        lambda_vacc_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vacc_eff(t,pm)/N_adj)*LAMB;
        lambda_boost = (1-pm.E_boost_acq)*(pm.c_boost_eff(t,pm)/N_adj)*LAMB;
        lambda_boost_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_boost_eff(t,pm)/N_adj)*LAMB;
        lambda_boost_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_boost_eff(t,pm)/N_adj)*LAMB;
        lambda_iso = (pm.c_iso_eff(t,pm)/N_adj)*LAMB;
        lambda_iso_lt = (1-pm.phi_lt)*(pm.c_iso_eff(t,pm)/N_adj)*LAMB;
        lambda_iso_st = (1-pm.phi_st)*(pm.c_iso_eff(t,pm)/N_adj)*LAMB;
        lambda_vi = (1-pm.E_vacc_acq)*(pm.c_vi_eff(t,pm)/N_adj)*LAMB;
        lambda_vi_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vi_eff(t,pm)/N_adj)*LAMB;
        lambda_vi_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vi_eff(t,pm)/N_adj)*LAMB;
        lambda_bi = (1-pm.E_boost_acq)*(pm.c_bi_eff(t,pm)/N_adj)*LAMB;
        lambda_bi_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_bi_eff(t,pm)/N_adj)*LAMB;
        lambda_bi_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_bi_eff(t,pm)/N_adj)*LAMB;
        
        dx(id("num_inf")) = lambda*xid("S") + lambda_st*xid("R_st") + lambda_lt*xid("R_lt") + ...
            lambda_vacc*xid("S_vacc") + lambda_vacc_st*xid("R_vacc_st") + lambda_vacc_lt*xid("R_vacc_lt") + ...
            lambda_boost*xid("S_boost") + lambda_boost_st*xid("R_boost_st") + lambda_boost_lt*xid("R_boost_lt") + ...
            lambda_iso*xid("S_iso") + lambda_iso_st*xid("R_iso_st") + lambda_iso_lt*xid("R_iso_lt") + ...
            lambda_vi*xid("S_vi") + lambda_vi_st*xid("R_vi_st") + lambda_vi_lt*xid("R_vi_lt") + ...
            lambda_bi*xid("S_bi") + lambda_bi_st*xid("R_bi_st") + lambda_bi_lt*xid("R_bi_lt");

          
        
        dx(id("num_inf_nonvacc")) = lambda*xid("S") + lambda_st*xid("R_st") + lambda_lt*xid("R_lt");
        dx(id("num_inf_vacc")) = lambda_vacc*xid("S_vacc") + lambda_vacc_st*xid("R_vacc_st") + lambda_vacc_lt*xid("R_vacc_lt");
        dx(id("num_inf_boost")) = lambda_boost*xid("S_boost") + lambda_boost_st*xid("R_boost_st") + lambda_boost_lt*xid("R_boost_lt");
        dx(id("num_inf_nonvi")) = lambda_iso*xid("S_iso") + lambda_iso_st*xid("R_iso_st") + lambda_iso_lt*xid("R_iso_lt");
        dx(id("num_inf_vi")) = lambda_vi*xid("S_vi") + lambda_vi_st*xid("R_vi_st") + lambda_vi_lt*xid("R_vi_lt");
        dx(id("num_inf_bi")) = lambda_bi*xid("S_bi") + lambda_bi_st*xid("R_bi_st") + lambda_bi_lt*xid("R_bi_lt");
        
        %presympto only count
        PRELAMB = pm.c_eff(t,pm)*(pm.beta_pre*xid("I_pre")) + pm.c_vacc_eff(t,pm)*(pm.beta_vacc_pre*xid("I_vacc_pre")) + pm.c_boost_eff(t,pm)*(pm.beta_boost_pre*xid("I_boost_pre")) + pm.c_iso_eff(t,pm)*(pm.beta_pre*xid("I_iso_pre")) + pm.c_vi_eff(t,pm)*(pm.beta_vi_pre*xid("I_vi_pre")) + pm.c_bi_eff(t,pm)*(pm.beta_bi_pre*xid("I_bi_pre"));
        
        prelambda = (pm.c_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_lt = (1-pm.phi_lt)*(pm.c_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_st = (1-pm.phi_st)*(pm.c_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vacc = (1-pm.E_vacc_acq)*(pm.c_vacc_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vacc_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vacc_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vacc_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vacc_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_boost = (1-pm.E_boost_acq)*(pm.c_boost_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_boost_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_boost_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_boost_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_boost_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_iso = (pm.c_iso_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_iso_lt = (1-pm.phi_lt)*(pm.c_iso_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_iso_st = (1-pm.phi_st)*(pm.c_iso_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vi = (1-pm.E_vacc_acq)*(pm.c_vi_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vi_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vi_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_vi_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vi_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_bi = (1-pm.E_boost_acq)*(pm.c_bi_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_bi_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_bi_eff(t,pm)/N_adj)*PRELAMB;
        prelambda_bi_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_bi_eff(t,pm)/N_adj)*PRELAMB;
        
        dx(id("num_inf_pre")) = prelambda*xid("S") + prelambda_st*xid("R_st")+ prelambda_lt*xid("R_lt") + prelambda_vacc*xid("S_vacc") + prelambda_vacc_st*xid("R_vacc_st")+ prelambda_vacc_lt*xid("R_vacc_lt") + prelambda_boost*xid("S_boost") + prelambda_boost_st*xid("R_boost_st")+ prelambda_boost_lt*xid("R_boost_lt") + prelambda_iso*xid("S_iso") + prelambda_iso_st*xid("R_iso_st") + prelambda_iso_lt*xid("R_iso_lt") + prelambda_vi*xid("S_vi") + prelambda_vi_st*xid("R_vi_st")+ prelambda_vi_lt*xid("R_vi_lt") + prelambda_bi*xid("S_bi") + prelambda_bi_st*xid("R_bi_st")+ prelambda_bi_lt*xid("R_bi_lt");
        
        %masoumeh (inf_pre_...)
%         dx(id("num_inf_pre_nonvacc")) = prelambda*xid("S")+prelambda_st*xid("R_st")+ prelambda_lt*xid("R_lt");
%         dx(id("num_inf_pre_vacc")) = prelambda_vacc*xid("S_vacc")+prelambda_vacc_st*xid("R_vacc_st")+ prelambda_vacc_lt*xid("R_vacc_lt");
%         dx(id("num_inf_pre_boost")) = prelambda_boost*xid("S_boost")+prelambda_boost_st*xid("R_boost_st")+ prelambda_boost_lt*xid("R_boost_lt");
%         dx(id("num_inf_pre_nonvi"))= prelambda_iso*xid("S_iso")+ prelambda_iso_st*xid("R_iso_st") + prelambda_iso_lt*xid("R_iso_lt");
%         dx(id("num_inf_pre_vi"))= prelambda_vi*xid("S_vi") + prelambda_vi_st*xid("R_vi_st")+ prelambda_vi_lt*xid("R_vi_lt");
%         dx(id("num_inf_pre_bi"))= prelambda_bi*xid("S_bi")+prelambda_bi_st*xid("R_bi_st")+ prelambda_bi_lt*xid("R_bi_lt");
        
        %asympto only count
        ASYLAMB = pm.c_eff(t,pm)*(pm.beta_a*(xid("I_1_a")+xid("I_2_a"))) + pm.c_vacc_eff(t,pm)*(pm.beta_vacc_a*(xid("I_1_vacc_a")+xid("I_2_vacc_a"))) + pm.c_boost_eff(t,pm)*(pm.beta_boost_a*(xid("I_1_boost_a")+xid("I_2_boost_a"))) + pm.c_iso_eff(t,pm)*(pm.beta_a*(xid("I_1_iso_a")+xid("I_2_iso_a"))) + pm.c_vi_eff(t,pm)*(pm.beta_vi_a*(xid("I_1_vi_a")+xid("I_2_vi_a"))) + pm.c_bi_eff(t,pm)*(pm.beta_bi_a*(xid("I_1_bi_a")+xid("I_2_bi_a")));
        
        asylambda = (pm.c_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_lt = (1-pm.phi_lt)*(pm.c_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_st = (1-pm.phi_st)*(pm.c_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vacc = (1-pm.E_vacc_acq)*(pm.c_vacc_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vacc_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vacc_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vacc_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vacc_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_boost = (1-pm.E_boost_acq)*(pm.c_boost_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_boost_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_boost_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_boost_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_boost_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_iso = (pm.c_iso_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_iso_lt = (1-pm.phi_lt)*(pm.c_iso_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_iso_st = (1-pm.phi_st)*(pm.c_iso_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vi = (1-pm.E_vacc_acq)*(pm.c_vi_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vi_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vi_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_vi_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vi_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_bi = (1-pm.E_boost_acq)*(pm.c_bi_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_bi_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_bi_eff(t,pm)/N_adj)*ASYLAMB;
        asylambda_bi_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_bi_eff(t,pm)/N_adj)*ASYLAMB;
        
        dx(id("num_inf_asym")) = asylambda*xid("S") + asylambda_st*xid("R_st")+ asylambda_lt*xid("R_lt") + asylambda_vacc*xid("S_vacc") + asylambda_vacc_st*xid("R_vacc_st")+ asylambda_vacc_lt*xid("R_vacc_lt") + asylambda_boost*xid("S_boost") + asylambda_boost_st*xid("R_boost_st")+ asylambda_boost_lt*xid("R_boost_lt") + asylambda_iso*xid("S_iso") + asylambda_iso_st*xid("R_iso_st") + asylambda_iso_lt*xid("R_iso_lt") + asylambda_vi*xid("S_vi") + asylambda_vi_st*xid("R_vi_st")+ asylambda_vi_lt*xid("R_vi_lt") + asylambda_bi*xid("S_bi") + asylambda_bi_st*xid("R_bi_st")+ asylambda_bi_lt*xid("R_bi_lt");
        
        %masoumeh(inf_asym_...)
%         dx(id("num_inf_asym_nonvacc")) = asylambda*xid("S") + asylambda_st*xid("R_st")+ asylambda_lt*xid("R_lt");
%         dx(id("num_inf_asym_vacc")) = asylambda_vacc*xid("S_vacc") + asylambda_vacc_st*xid("R_vacc_st")+ asylambda_vacc_lt*xid("R_vacc_lt");
%         dx(id("num_inf_asym_boost")) = asylambda_boost*xid("S_boost") + asylambda_boost_st*xid("R_boost_st")+ asylambda_boost_lt*xid("R_boost_lt");
%         dx(id("num_inf_asym_nonvi")) = asylambda_iso*xid("S_iso") + asylambda_iso_st*xid("R_iso_st") + asylambda_iso_lt*xid("R_iso_lt");
%         dx(id("num_inf_asym_vi")) = asylambda_vi*xid("S_vi") + asylambda_vi_st*xid("R_vi_st")+ asylambda_vi_lt*xid("R_vi_lt");
%         dx(id("num_inf_asym_bi")) = asylambda_bi*xid("S_bi") + asylambda_bi_st*xid("R_bi_st")+ asylambda_bi_lt*xid("R_bi_lt");
        
        
        %hospital only count
        HOSPLAMB = pm.c_hosp*(pm.beta_H_s*xid("H_s") + pm.beta_H_m*xid("H_m"));
        HOSPLAMB = HOSPLAMB + pm.c_vacc_hosp*(pm.beta_H_vacc_s*xid("H_vacc_s") + pm.beta_H_vacc_m*xid("H_vacc_m"));
        HOSPLAMB = HOSPLAMB + pm.c_boost_hosp*(pm.beta_H_boost_s*xid("H_boost_s") + pm.beta_H_boost_m*xid("H_boost_m"));
        HOSPLAMB = HOSPLAMB + pm.c_iso_hosp*(pm.beta_H_s*xid("H_iso_s") + pm.beta_H_m*xid("H_iso_m"));
        HOSPLAMB = HOSPLAMB + pm.c_vi_hosp*(pm.beta_H_vacc_s*xid("H_vi_s") + pm.beta_H_vacc_m*xid("H_vi_m"));
        HOSPLAMB = HOSPLAMB + pm.c_bi_hosp*(pm.beta_H_boost_s*xid("H_bi_s") + pm.beta_H_boost_m*xid("H_bi_m"));
        
        hosplambda = (pm.c_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_lt = (1-pm.phi_lt)*(pm.c_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_st = (1-pm.phi_st)*(pm.c_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vacc = (1-pm.E_vacc_acq)*(pm.c_vacc_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vacc_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vacc_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vacc_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vacc_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_boost = (1-pm.E_boost_acq)*(pm.c_boost_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_boost_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_boost_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_boost_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_boost_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_iso = (pm.c_iso_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_iso_lt = (1-pm.phi_lt)*(pm.c_iso_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_iso_st = (1-pm.phi_st)*(pm.c_iso_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vi = (1-pm.E_vacc_acq)*(pm.c_vi_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vi_lt = (1-max(pm.E_vacc_acq,pm.phi_lt))*(pm.c_vi_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_vi_st = (1-max(pm.E_vacc_acq,pm.phi_st))*(pm.c_vi_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_bi = (1-pm.E_boost_acq)*(pm.c_bi_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_bi_lt = (1-max(pm.E_boost_acq,pm.phi_lt))*(pm.c_bi_eff(t,pm)/N_adj)*HOSPLAMB;
        hosplambda_bi_st = (1-max(pm.E_boost_acq,pm.phi_st))*(pm.c_bi_eff(t,pm)/N_adj)*HOSPLAMB;
        
        dx(id("num_inf_hosp")) = hosplambda*xid("S") + hosplambda_st*xid("R_st")+ hosplambda_lt*xid("R_lt") + hosplambda_vacc*xid("S_vacc") + hosplambda_vacc_st*xid("R_vacc_st")+ hosplambda_vacc_lt*xid("R_vacc_lt") + hosplambda_boost*xid("S_boost") + hosplambda_boost_st*xid("R_boost_st")+ hosplambda_boost_lt*xid("R_boost_lt") + hosplambda_iso*xid("S_iso") + hosplambda_iso_st*xid("R_iso_st") + hosplambda_iso_lt*xid("R_iso_lt") + hosplambda_vi*xid("S_vi") + hosplambda_vi_st*xid("R_vi_st")+ hosplambda_vi_lt*xid("R_vi_lt") + hosplambda_bi*xid("S_bi") + hosplambda_bi_st*xid("R_bi_st")+ hosplambda_bi_lt*xid("R_bi_lt");
        
%         if(xsum("N_comm")>0)
%             lambda = lambda + (pm.c_eff(t,pm)/xsum("N")) * (pm.beta_pre*xid("I_pre") + pm.beta_s*(xid("I_1_s")+xid("I_2_s")) + pm.beta_m*(xid("I_1_m")+xid("I_2_m")) + pm.beta_a*(xid("I_1_a")+xid("I_2_a")));
%             dx(id("num_inf_pre")) = (pm.c_eff(t,pm)/xsum("N")) * pm.beta_pre*xid("I_pre")*(xid("S") + (1-pm.phi_st)*xid("R_st") + (1-pm.phi_lt)*xid("R_lt"));
%             dx(id("num_inf_asym")) = (pm.c_eff(t,pm)/xsum("N")) * pm.beta_a*(xid("I_1_a")+xid("I_2_a"))*(xid("S") + (1-pm.phi_st)*xid("R_st") + (1-pm.phi_lt)*xid("R_lt"));
%         end
%         if(xsum("N_hosp")>0)
%             lambda = lambda + (pm.c_hosp/xsum("N")) * (pm.beta_H_s*xid("H_s") + pm.beta_H_m*xid("H_m"));
%             dx(id("num_inf_hosp")) = (pm.c_hosp/xsum("N")) * (pm.beta_H_s*xid("H_s") + pm.beta_H_m*xid("H_m"))*(xid("S") + (1-pm.phi_st)*xid("R_st") + (1-pm.phi_lt)*xid("R_lt"));
%         end
        
        
        dx(id("num_inf_sym")) = dx(id("num_inf")) - dx(id("num_inf_pre")) - dx(id("num_inf_asym"));
        
        %masoumeh
%         dx(id("num_inf_sym_nonvacc"))=dx(id("num_inf_nonvacc")) - dx(id("num_inf_pre_nonvacc")) - dx(id("num_inf_asym_nonvacc"));
%         dx(id("num_inf_sym_vacc"))=dx(id("num_inf_vacc")) - dx(id("num_inf_pre_vacc")) - dx(id("num_inf_asym_vacc"));
%         dx(id("num_inf_sym_boost"))=dx(id("num_inf_boost")) - dx(id("num_inf_pre_boost")) - dx(id("num_inf_asym_boost"));
%         dx(id("num_inf_sym_nonvi"))=dx(id("num_inf_nonvi")) - dx(id("num_inf_pre_nonvi")) - dx(id("num_inf_asym_nonvi"));
%         dx(id("num_inf_sym_vi"))=dx(id("num_inf_vi")) - dx(id("num_inf_pre_vi")) - dx(id("num_inf_asym_vi"));
%         dx(id("num_inf_sym_bi"))=dx(id("num_inf_bi")) - dx(id("num_inf_pre_bi")) - dx(id("num_inf_asym_bi"));
%   
        
        %Base strata
        dx(id("S")) = pm.pi*xsum("N") + (1-pm.f_R_s)*(pm.r_H_s*xid("H_s")+pm.r_s*xid("I_2_s")) + (1-pm.f_R_m)*(pm.r_H_m*xid("H_m")+pm.r_m*xid("I_2_m")) + (1-pm.f_R_a)*pm.gamma_2_a*xid("I_2_a") +pm.omega_R_st*xid("R_st")+pm.omega_R_lt*xid("R_lt") - (lambda+pm.mu)*xid("S");
        dx(id("E")) = lambda*xid("S") + lambda_st*xid("R_st")+ lambda_lt*xid("R_lt") - (pm.sigma + pm.mu)*xid("E");
        dx(id("I_pre")) = pm.sigma*xid("E") - (pm.gamma_pre + pm.mu)*xid("I_pre");
        dx(id("I_1_s")) = pm.f_s_pre*pm.gamma_pre*xid("I_pre") - (pm.g_1_s + pm.h_1_s + pm.mu)*xid("I_1_s");
        dx(id("I_2_s")) = pm.g_1_s*xid("I_1_s") - (pm.r_s + pm.mu + pm.mu_s)*xid("I_2_s");
        dx(id("H_s")) = pm.h_1_s*xid("I_1_s") - (pm.r_H_s + pm.mu + pm.mu_H_s)*xid("H_s");
        dx(id("I_1_m")) = pm.f_m_pre*pm.gamma_pre*xid("I_pre") - (pm.g_1_m + pm.h_1_m + pm.mu)*xid("I_1_m");
        dx(id("I_2_m")) = pm.g_1_m*xid("I_1_m") - (pm.r_m + pm.mu + pm.mu_m)*xid("I_2_m");
        dx(id("H_m")) = pm.h_1_m*xid("I_1_m") - (pm.r_H_m + pm.mu + pm.mu_H_m)*xid("H_m");
        dx(id("I_1_a")) = pm.f_a_pre*pm.gamma_pre*xid("I_pre") - (pm.gamma_1_a + pm.mu)*xid("I_1_a");
        dx(id("I_2_a")) = pm.gamma_1_a*xid("I_1_a") - (pm.gamma_2_a + pm.mu)*xid("I_2_a");
        dx(id("R_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_s*xid("H_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_m*xid("H_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_s*xid("I_2_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_m*xid("I_2_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_a*xid("I_2_a") - (lambda_st+pm.omega_R_st+pm.mu)*xid("R_st");
        dx(id("R_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_s*xid("H_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_m*xid("H_m") + pm.f_R_s*pm.f_lt_s*pm.r_s*xid("I_2_s") + pm.f_R_m*pm.f_lt_m*pm.r_m*xid("I_2_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_a*xid("I_2_a") - (lambda_lt+pm.omega_R_lt+pm.mu)*xid("R_lt");
        
        %Vaccinated strata
        dx(id("S_vacc")) = (1-pm.f_R_s)*(pm.r_H_vacc_s*xid("H_vacc_s")+pm.r_vacc_s*xid("I_2_vacc_s")) + (1-pm.f_R_m)*(pm.r_H_vacc_m*xid("H_vacc_m")+pm.r_vacc_m*xid("I_2_vacc_m")) + (1-pm.f_R_a)*pm.gamma_2_vacc_a*xid("I_2_vacc_a") +pm.omega_R_st*xid("R_vacc_st")+pm.omega_R_lt*xid("R_vacc_lt") - (lambda_vacc+pm.mu)*xid("S_vacc");
        dx(id("E_vacc")) = lambda_vacc*xid("S_vacc") + lambda_vacc_st*xid("R_vacc_st")+ lambda_vacc_lt*xid("R_vacc_lt") - (pm.sigma_vacc + pm.mu)*xid("E_vacc");
        dx(id("I_vacc_pre")) = pm.sigma_vacc*xid("E_vacc") - (pm.gamma_vacc_pre + pm.mu)*xid("I_vacc_pre");
        dx(id("I_1_vacc_s")) = pm.f_s_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre") - (pm.g_1_vacc_s + pm.h_1_vacc_s + pm.mu)*xid("I_1_vacc_s");
        dx(id("I_2_vacc_s")) = pm.g_1_vacc_s*xid("I_1_vacc_s") - (pm.r_vacc_s + pm.mu + pm.mu_vacc_s)*xid("I_2_vacc_s");
        dx(id("H_vacc_s")) = pm.h_1_vacc_s*xid("I_1_vacc_s") - (pm.r_H_vacc_s + pm.mu + pm.mu_H_vacc_s)*xid("H_vacc_s");
        dx(id("I_1_vacc_m")) = pm.f_m_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre") - (pm.g_1_vacc_m + pm.h_1_vacc_m + pm.mu)*xid("I_1_vacc_m");
        dx(id("I_2_vacc_m")) = pm.g_1_vacc_m*xid("I_1_vacc_m") - (pm.r_vacc_m + pm.mu + pm.mu_vacc_m)*xid("I_2_vacc_m");
        dx(id("H_vacc_m")) = pm.h_1_vacc_m*xid("I_1_vacc_m") - (pm.r_H_vacc_m + pm.mu + pm.mu_H_vacc_m)*xid("H_vacc_m");
        dx(id("I_1_vacc_a")) = pm.f_a_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre") - (pm.gamma_1_vacc_a + pm.mu)*xid("I_1_vacc_a");
        dx(id("I_2_vacc_a")) = pm.gamma_1_vacc_a*xid("I_1_vacc_a") - (pm.gamma_2_vacc_a + pm.mu)*xid("I_2_vacc_a");
        dx(id("R_vacc_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_vacc_s*xid("H_vacc_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_vacc_m*xid("H_vacc_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_vacc_s*xid("I_2_vacc_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_vacc_m*xid("I_2_vacc_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_vacc_a*xid("I_2_vacc_a") - (lambda_vacc_st+pm.omega_R_st+pm.mu)*xid("R_vacc_st");
        dx(id("R_vacc_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_vacc_s*xid("H_vacc_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_vacc_m*xid("H_vacc_m") + pm.f_R_s*pm.f_lt_s*pm.r_vacc_s*xid("I_2_vacc_s") + pm.f_R_m*pm.f_lt_m*pm.r_vacc_m*xid("I_2_vacc_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_vacc_a*xid("I_2_vacc_a") - (lambda_vacc_lt+pm.omega_R_lt+pm.mu)*xid("R_vacc_lt");
        
        %Boosted strata
        dx(id("S_boost")) = (1-pm.f_R_s)*(pm.r_H_boost_s*xid("H_boost_s")+pm.r_boost_s*xid("I_2_boost_s")) + (1-pm.f_R_m)*(pm.r_H_boost_m*xid("H_boost_m")+pm.r_boost_m*xid("I_2_boost_m")) + (1-pm.f_R_a)*pm.gamma_2_boost_a*xid("I_2_boost_a") +pm.omega_R_st*xid("R_boost_st")+pm.omega_R_lt*xid("R_boost_lt") - (lambda_boost+pm.mu)*xid("S_boost");
        dx(id("E_boost")) = lambda_boost*xid("S_boost") + lambda_boost_st*xid("R_boost_st")+ lambda_boost_lt*xid("R_boost_lt") - (pm.sigma_boost + pm.mu)*xid("E_boost");
        dx(id("I_boost_pre")) = pm.sigma_boost*xid("E_boost") - (pm.gamma_boost_pre + pm.mu)*xid("I_boost_pre");
        dx(id("I_1_boost_s")) = pm.f_s_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre") - (pm.g_1_boost_s + pm.h_1_boost_s + pm.mu)*xid("I_1_boost_s");
        dx(id("I_2_boost_s")) = pm.g_1_boost_s*xid("I_1_boost_s") - (pm.r_boost_s + pm.mu + pm.mu_boost_s)*xid("I_2_boost_s");
        dx(id("H_boost_s")) = pm.h_1_boost_s*xid("I_1_boost_s") - (pm.r_H_boost_s + pm.mu + pm.mu_H_boost_s)*xid("H_boost_s");
        dx(id("I_1_boost_m")) = pm.f_m_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre") - (pm.g_1_boost_m + pm.h_1_boost_m + pm.mu)*xid("I_1_boost_m");
        dx(id("I_2_boost_m")) = pm.g_1_boost_m*xid("I_1_boost_m") - (pm.r_boost_m + pm.mu + pm.mu_boost_m)*xid("I_2_boost_m");
        dx(id("H_boost_m")) = pm.h_1_boost_m*xid("I_1_boost_m") - (pm.r_H_boost_m + pm.mu + pm.mu_H_boost_m)*xid("H_boost_m");
        dx(id("I_1_boost_a")) = pm.f_a_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre") - (pm.gamma_1_boost_a + pm.mu)*xid("I_1_boost_a");
        dx(id("I_2_boost_a")) = pm.gamma_1_boost_a*xid("I_1_boost_a") - (pm.gamma_2_boost_a + pm.mu)*xid("I_2_boost_a");
        dx(id("R_boost_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_boost_s*xid("H_boost_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_boost_m*xid("H_boost_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_boost_s*xid("I_2_boost_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_boost_m*xid("I_2_boost_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_boost_a*xid("I_2_boost_a") - (lambda_boost_st+pm.omega_R_st+pm.mu)*xid("R_boost_st");
        dx(id("R_boost_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_boost_s*xid("H_boost_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_boost_m*xid("H_boost_m") + pm.f_R_s*pm.f_lt_s*pm.r_boost_s*xid("I_2_boost_s") + pm.f_R_m*pm.f_lt_m*pm.r_boost_m*xid("I_2_boost_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_boost_a*xid("I_2_boost_a") - (lambda_boost_lt+pm.omega_R_lt+pm.mu)*xid("R_boost_lt");
        
        
        %Isolated strata
        dx(id("S_iso")) = (1-pm.f_R_s)*(pm.r_H_s*xid("H_iso_s")+pm.r_s*xid("I_2_iso_s")) + (1-pm.f_R_m)*(pm.r_H_m*xid("H_iso_m")+pm.r_m*xid("I_2_iso_m")) + (1-pm.f_R_a)*pm.gamma_2_a*xid("I_2_iso_a") +pm.omega_R_st*xid("R_iso_st")+pm.omega_R_lt*xid("R_iso_lt") - (lambda_iso+pm.mu)*xid("S_iso");
        dx(id("E_iso")) = lambda_iso*xid("S_iso") + lambda_iso_st*xid("R_iso_st")+ lambda_iso_lt*xid("R_iso_lt") - (pm.sigma + pm.mu)*xid("E_iso");
        dx(id("I_iso_pre")) = pm.sigma*xid("E_iso") - (pm.gamma_pre + pm.mu)*xid("I_iso_pre");
        dx(id("I_1_iso_s")) = pm.f_s_pre*pm.gamma_pre*xid("I_iso_pre") - (pm.g_1_s + pm.h_1_s + pm.mu)*xid("I_1_iso_s");
        %dx(id("I_2_iso_s")) = pm.g_1_s*xid("I_1_iso_s") - (pm.r_s + pm.mu + pm.mu_iso_s)*xid("I_2_iso_s");
        dx(id("I_2_iso_s")) = pm.g_1_s*xid("I_1_iso_s") - (pm.r_s + pm.mu + pm.mu_s)*xid("I_2_iso_s");
        dx(id("H_iso_s")) = pm.h_1_s*xid("I_1_iso_s") - (pm.r_H_s + pm.mu + pm.mu_H_s)*xid("H_iso_s");
        dx(id("I_1_iso_m")) = pm.f_m_pre*pm.gamma_pre*xid("I_iso_pre") - (pm.g_1_m + pm.h_1_m + pm.mu)*xid("I_1_iso_m");
        dx(id("I_2_iso_m")) = pm.g_1_m*xid("I_1_iso_m") - (pm.r_m + pm.mu + pm.mu_m)*xid("I_2_iso_m");
        dx(id("H_iso_m")) = pm.h_1_m*xid("I_1_iso_m") - (pm.r_H_m + pm.mu + pm.mu_H_m)*xid("H_iso_m");
        dx(id("I_1_iso_a")) = pm.f_a_pre*pm.gamma_pre*xid("I_iso_pre") - (pm.gamma_1_a + pm.mu)*xid("I_1_iso_a");
        dx(id("I_2_iso_a")) = pm.gamma_1_a*xid("I_1_iso_a") - (pm.gamma_2_a + pm.mu)*xid("I_2_iso_a");
        dx(id("R_iso_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_s*xid("H_iso_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_m*xid("H_iso_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_s*xid("I_2_iso_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_m*xid("I_2_iso_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_a*xid("I_2_iso_a") - (lambda_iso_st+pm.omega_R_st+pm.mu)*xid("R_iso_st");
        dx(id("R_iso_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_s*xid("H_iso_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_m*xid("H_iso_m") + pm.f_R_s*pm.f_lt_s*pm.r_s*xid("I_2_iso_s") + pm.f_R_m*pm.f_lt_m*pm.r_m*xid("I_2_iso_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_a*xid("I_2_iso_a") - (lambda_iso_lt+pm.omega_R_lt+pm.mu)*xid("R_iso_lt");
        
        %Vi strata
        dx(id("S_vi")) = (1-pm.f_R_s)*(pm.r_H_vacc_s*xid("H_vi_s")+pm.r_vacc_s*xid("I_2_vi_s")) + (1-pm.f_R_m)*(pm.r_H_vacc_m*xid("H_vi_m")+pm.r_vacc_m*xid("I_2_vi_m")) + (1-pm.f_R_a)*pm.gamma_2_vacc_a*xid("I_2_vi_a") +pm.omega_R_st*xid("R_vi_st")+pm.omega_R_lt*xid("R_vi_lt") - (lambda_vi+pm.mu)*xid("S_vi");
        dx(id("E_vi")) = lambda_vi*xid("S_vi") + lambda_vi_st*xid("R_vi_st")+ lambda_vi_lt*xid("R_vi_lt") - (pm.sigma_vacc + pm.mu)*xid("E_vi");
        dx(id("I_vi_pre")) = pm.sigma_vacc*xid("E_vi") - (pm.gamma_vacc_pre + pm.mu)*xid("I_vi_pre");
        dx(id("I_1_vi_s")) = pm.f_s_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre") - (pm.g_1_vacc_s + pm.h_1_vacc_s + pm.mu)*xid("I_1_vi_s");
        dx(id("I_2_vi_s")) = pm.g_1_vacc_s*xid("I_1_vi_s") - (pm.r_vacc_s + pm.mu + pm.mu_vacc_s)*xid("I_2_vi_s");
        dx(id("H_vi_s")) = pm.h_1_vacc_s*xid("I_1_vi_s") - (pm.r_H_vacc_s + pm.mu + pm.mu_H_vacc_s)*xid("H_vi_s");
        dx(id("I_1_vi_m")) = pm.f_m_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre") - (pm.g_1_vacc_m + pm.h_1_vacc_m + pm.mu)*xid("I_1_vi_m");
        dx(id("I_2_vi_m")) = pm.g_1_vacc_m*xid("I_1_vi_m") - (pm.r_vacc_m + pm.mu + pm.mu_vacc_m)*xid("I_2_vi_m");
        dx(id("H_vi_m")) = pm.h_1_vacc_m*xid("I_1_vi_m") - (pm.r_H_vacc_m + pm.mu + pm.mu_H_vacc_m)*xid("H_vi_m");
        dx(id("I_1_vi_a")) = pm.f_a_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre") - (pm.gamma_1_vacc_a + pm.mu)*xid("I_1_vi_a");
        dx(id("I_2_vi_a")) = pm.gamma_1_vacc_a*xid("I_1_vi_a") - (pm.gamma_2_vacc_a + pm.mu)*xid("I_2_vi_a");
        dx(id("R_vi_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_vacc_s*xid("H_vi_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_vacc_m*xid("H_vi_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_vacc_s*xid("I_2_vi_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_vacc_m*xid("I_2_vi_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_vacc_a*xid("I_2_vi_a") - (lambda_vi_st+pm.omega_R_st+pm.mu)*xid("R_vi_st");
        dx(id("R_vi_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_vacc_s*xid("H_vi_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_vacc_m*xid("H_vi_m") + pm.f_R_s*pm.f_lt_s*pm.r_vacc_s*xid("I_2_vi_s") + pm.f_R_m*pm.f_lt_m*pm.r_vacc_m*xid("I_2_vi_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_vacc_a*xid("I_2_vi_a") - (lambda_vi_lt+pm.omega_R_lt+pm.mu)*xid("R_vi_lt");
        
        %Bi strata
        dx(id("S_bi")) = (1-pm.f_R_s)*(pm.r_H_boost_s*xid("H_bi_s")+pm.r_boost_s*xid("I_2_bi_s")) + (1-pm.f_R_m)*(pm.r_H_boost_m*xid("H_bi_m")+pm.r_boost_m*xid("I_2_bi_m")) + (1-pm.f_R_a)*pm.gamma_2_boost_a*xid("I_2_bi_a") +pm.omega_R_st*xid("R_bi_st")+pm.omega_R_lt*xid("R_bi_lt") - (lambda_bi+pm.mu)*xid("S_bi");
        dx(id("E_bi")) = lambda_bi*xid("S_bi") + lambda_bi_st*xid("R_bi_st")+ lambda_bi_lt*xid("R_bi_lt") - (pm.sigma_boost + pm.mu)*xid("E_bi");
        dx(id("I_bi_pre")) = pm.sigma_boost*xid("E_bi") - (pm.gamma_boost_pre + pm.mu)*xid("I_bi_pre");
        dx(id("I_1_bi_s")) = pm.f_s_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre") - (pm.g_1_boost_s + pm.h_1_boost_s + pm.mu)*xid("I_1_bi_s");
        dx(id("I_2_bi_s")) = pm.g_1_boost_s*xid("I_1_bi_s") - (pm.r_boost_s + pm.mu + pm.mu_boost_s)*xid("I_2_bi_s");
        dx(id("H_bi_s")) = pm.h_1_boost_s*xid("I_1_bi_s") - (pm.r_H_boost_s + pm.mu + pm.mu_H_boost_s)*xid("H_bi_s");
        dx(id("I_1_bi_m")) = pm.f_m_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre") - (pm.g_1_boost_m + pm.h_1_boost_m + pm.mu)*xid("I_1_bi_m");
        dx(id("I_2_bi_m")) = pm.g_1_boost_m*xid("I_1_bi_m") - (pm.r_boost_m + pm.mu + pm.mu_boost_m)*xid("I_2_bi_m");
        dx(id("H_bi_m")) = pm.h_1_boost_m*xid("I_1_bi_m") - (pm.r_H_boost_m + pm.mu + pm.mu_H_boost_m)*xid("H_bi_m");
        dx(id("I_1_bi_a")) = pm.f_a_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre") - (pm.gamma_1_boost_a + pm.mu)*xid("I_1_bi_a");
        dx(id("I_2_bi_a")) = pm.gamma_1_boost_a*xid("I_1_bi_a") - (pm.gamma_2_boost_a + pm.mu)*xid("I_2_bi_a");
        dx(id("R_bi_st")) = pm.f_R_s*(1-pm.f_lt_s)*pm.r_H_boost_s*xid("H_bi_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_H_boost_m*xid("H_bi_m") + pm.f_R_s*(1-pm.f_lt_s)*pm.r_boost_s*xid("I_2_bi_s") + pm.f_R_m*(1-pm.f_lt_m)*pm.r_boost_m*xid("I_2_bi_m") + pm.f_R_a*(1-pm.f_lt_a)*pm.gamma_2_boost_a*xid("I_2_bi_a") - (lambda_bi_st+pm.omega_R_st+pm.mu)*xid("R_bi_st");
        dx(id("R_bi_lt")) = pm.f_R_s*pm.f_lt_s*pm.r_H_boost_s*xid("H_bi_s") + pm.f_R_m*pm.f_lt_m*pm.r_H_boost_m*xid("H_bi_m") + pm.f_R_s*pm.f_lt_s*pm.r_boost_s*xid("I_2_bi_s") + pm.f_R_m*pm.f_lt_m*pm.r_boost_m*xid("I_2_bi_m") + pm.f_R_a*pm.f_lt_a*pm.gamma_2_boost_a*xid("I_2_bi_a") - (lambda_bi_lt+pm.omega_R_lt+pm.mu)*xid("R_bi_lt");
        
        
        %Imported cases
        pi_E = 0;
        pi_pre = 0;
        pi_1_s = 0;
        pi_2_s = 0;
        pi_1_m = 0;
        pi_2_m = 0;
        pi_1_a = 0;
        pi_2_a = 0;
        
        dx(id("E")) = dx(id("E")) + pi_E;
        dx(id("I_pre")) = dx(id("I_pre")) + pi_pre;
        dx(id("I_1_s")) = dx(id("I_1_s")) + pi_1_s;
        dx(id("I_2_s")) = dx(id("I_2_s")) + pi_2_s;
        dx(id("I_1_m")) = dx(id("I_1_m")) + pi_1_m;
        dx(id("I_2_m")) = dx(id("I_2_m")) + pi_2_m;
        dx(id("I_1_a")) = dx(id("I_1_a")) + pi_1_a;
        dx(id("I_2_a")) = dx(id("I_2_a")) + pi_2_a;
        
        
        %Isolation flows
        
        delta_iso = 0;
        delta_iso_E = 0;
        delta_iso_pre = 0;
        delta_1_iso_s = 0;
        delta_2_iso_s = 0;
        delta_iso_H_s = 0;
        delta_1_iso_m = 0;
        delta_2_iso_m = 0;
        delta_iso_H_m = 0;
        delta_1_iso_a = 0;
        delta_2_iso_a = 0;
        delta_iso_st = 0;
        delta_iso_lt = 0;
        
        delta_vi = 0;
        delta_vi_E = 0;
        delta_vi_pre = 0;
        delta_1_vi_s = 0;
        delta_2_vi_s = 0;
        delta_vi_H_s = 0;
        delta_1_vi_m = 0;
        delta_2_vi_m = 0;
        delta_vi_H_m = 0;
        delta_1_vi_a = 0;
        delta_2_vi_a = 0;
        delta_vi_st = 0;
        delta_vi_lt = 0;
        
        delta_bi = 0;
        delta_bi_E = 0;
        delta_bi_pre = 0;
        delta_1_bi_s = 0;
        delta_2_bi_s = 0;
        delta_bi_H_s = 0;
        delta_1_bi_m = 0;
        delta_2_bi_m = 0;
        delta_bi_H_m = 0;
        delta_1_bi_a = 0;
        delta_2_bi_a = 0;
        delta_bi_st = 0;
        delta_bi_lt = 0;
        
        dd = delta_iso - pm.tau_iso*xid("S_iso");
        dx(id("S")) = dx(id("S")) - dd;
        dx(id("S_iso")) = dx(id("S_iso")) + dd;
        
        dd = delta_iso_E - pm.tau_iso_E*xid("E_iso");
        dx(id("E")) = dx(id("E")) - dd;
        dx(id("E_iso")) = dx(id("E_iso")) + dd;
        
        dd = delta_iso_pre - pm.tau_iso_pre*xid("I_iso_pre");
        dx(id("I_pre")) = dx(id("I_pre")) - dd;
        dx(id("I_iso_pre")) = dx(id("I_iso_pre")) + dd;
        
        dd = delta_1_iso_s - pm.tau_1_iso_s*xid("I_1_iso_s");
        dx(id("I_1_s")) = dx(id("I_1_s")) - dd;
        dx(id("I_1_iso_s")) = dx(id("I_1_iso_s")) + dd;
        
        dd = delta_2_iso_s - pm.tau_2_iso_s*xid("I_2_iso_s");
        dx(id("I_2_s")) = dx(id("I_2_s")) - dd;
        dx(id("I_2_iso_s")) = dx(id("I_2_iso_s")) + dd;
        
        dd = delta_iso_H_s - pm.tau_iso_H_s*xid("H_iso_s");
        dx(id("H_s")) = dx(id("H_s")) - dd;
        dx(id("H_iso_s")) = dx(id("H_iso_s")) + dd;
        
        dd = delta_1_iso_m - pm.tau_1_iso_m*xid("I_1_iso_m");
        dx(id("I_1_m")) = dx(id("I_1_m")) - dd;
        dx(id("I_1_iso_m")) = dx(id("I_1_iso_m")) + dd;
        
        dd = delta_2_iso_m - pm.tau_2_iso_m*xid("I_2_iso_m");
        dx(id("I_2_m")) = dx(id("I_2_m")) - dd;
        dx(id("I_2_iso_m")) = dx(id("I_2_iso_m")) + dd;
        
        dd = delta_iso_H_m - pm.tau_iso_H_m*xid("H_iso_m");
        dx(id("H_m")) = dx(id("H_m")) - dd;
        dx(id("H_iso_m")) = dx(id("H_iso_m")) + dd;
        
        dd = delta_1_iso_a - pm.tau_1_iso_a*xid("I_1_iso_a");
        dx(id("I_1_a")) = dx(id("I_1_a")) - dd;
        dx(id("I_1_iso_a")) = dx(id("I_1_iso_a")) + dd;
        
        dd = delta_2_iso_a - pm.tau_2_iso_a*xid("I_2_iso_a");
        dx(id("I_2_a")) = dx(id("I_2_a")) - dd;
        dx(id("I_2_iso_a")) = dx(id("I_2_iso_a")) + dd;
        
        dd = delta_iso_st - pm.tau_iso_st*xid("R_iso_st");
        dx(id("R_st")) = dx(id("R_st")) - dd;
        dx(id("R_iso_st")) = dx(id("R_iso_st")) + dd;
        
        dd = delta_iso_lt - pm.tau_iso_lt*xid("R_iso_lt");
        dx(id("R_lt")) = dx(id("R_lt")) - dd;
        dx(id("R_iso_lt")) = dx(id("R_iso_lt")) + dd;
        
        
   
        dd = delta_vi - pm.tau_vi*xid("S_vi");
        dx(id("S_vacc")) = dx(id("S_vacc")) - dd;
        dx(id("S_vi")) = dx(id("S_vi")) + dd;
        
        dd = delta_vi_E - pm.tau_vi_E*xid("E_vi");
        dx(id("E_vacc")) = dx(id("E_vacc")) - dd;
        dx(id("E_vi")) = dx(id("E_vi")) + dd;
        
        dd = delta_vi_pre - pm.tau_vi_pre*xid("I_vi_pre");
        dx(id("I_vacc_pre")) = dx(id("I_vacc_pre")) - dd;
        dx(id("I_vi_pre")) = dx(id("I_vi_pre")) + dd;
        
        dd = delta_1_vi_s - pm.tau_1_vi_s*xid("I_1_vi_s");
        dx(id("I_1_vacc_s")) = dx(id("I_1_vacc_s")) - dd;
        dx(id("I_1_vi_s")) = dx(id("I_1_vi_s")) + dd;
        
        dd = delta_2_vi_s - pm.tau_2_vi_s*xid("I_2_vi_s");
        dx(id("I_2_vacc_s")) = dx(id("I_2_vacc_s")) - dd;
        dx(id("I_2_vi_s")) = dx(id("I_2_vi_s")) + dd;
        
        dd = delta_vi_H_s - pm.tau_vi_H_s*xid("H_vi_s");
        dx(id("H_vacc_s")) = dx(id("H_vacc_s")) - dd;
        dx(id("H_vi_s")) = dx(id("H_vi_s")) + dd;
        
        dd = delta_1_vi_m - pm.tau_1_vi_m*xid("I_1_vi_m");
        dx(id("I_1_vacc_m")) = dx(id("I_1_vacc_m")) - dd;
        dx(id("I_1_vi_m")) = dx(id("I_1_vi_m")) + dd;
        
        dd = delta_2_vi_m - pm.tau_2_vi_m*xid("I_2_vi_m");
        dx(id("I_2_vacc_m")) = dx(id("I_2_vacc_m")) - dd;
        dx(id("I_2_vi_m")) = dx(id("I_2_vi_m")) + dd;
        
        dd = delta_vi_H_m - pm.tau_vi_H_m*xid("H_vi_m");
        dx(id("H_vacc_m")) = dx(id("H_vacc_m")) - dd;
        dx(id("H_vi_m")) = dx(id("H_vi_m")) + dd;
        
        dd = delta_1_vi_a - pm.tau_1_vi_a*xid("I_1_vi_a");
        dx(id("I_1_vacc_a")) = dx(id("I_1_vacc_a")) - dd;
        dx(id("I_1_vi_a")) = dx(id("I_1_vi_a")) + dd;
        
        dd = delta_2_vi_a - pm.tau_2_vi_a*xid("I_2_vi_a");
        dx(id("I_2_vacc_a")) = dx(id("I_2_vacc_a")) - dd;
        dx(id("I_2_vi_a")) = dx(id("I_2_vi_a")) + dd;
        
        dd = delta_vi_st - pm.tau_vi_st*xid("R_vi_st");
        dx(id("R_vacc_st")) = dx(id("R_vacc_st")) - dd;
        dx(id("R_vi_st")) = dx(id("R_vi_st")) + dd;
        
        dd = delta_vi_lt - pm.tau_vi_lt*xid("R_vi_lt");
        dx(id("R_vacc_lt")) = dx(id("R_vacc_lt")) - dd;
        dx(id("R_vi_lt")) = dx(id("R_vi_lt")) + dd;
        
        
        
        dd = delta_bi - pm.tau_bi*xid("S_bi");
        dx(id("S_boost")) = dx(id("S_boost")) - dd;
        dx(id("S_bi")) = dx(id("S_bi")) + dd;
        
        dd = delta_bi_E - pm.tau_bi_E*xid("E_bi");
        dx(id("E_boost")) = dx(id("E_boost")) - dd;
        dx(id("E_bi")) = dx(id("E_bi")) + dd;
        
        dd = delta_bi_pre - pm.tau_bi_pre*xid("I_bi_pre");
        dx(id("I_boost_pre")) = dx(id("I_boost_pre")) - dd;
        dx(id("I_bi_pre")) = dx(id("I_bi_pre")) + dd;
        
        dd = delta_1_bi_s - pm.tau_1_bi_s*xid("I_1_bi_s");
        dx(id("I_1_boost_s")) = dx(id("I_1_boost_s")) - dd;
        dx(id("I_1_bi_s")) = dx(id("I_1_bi_s")) + dd;
        
        dd = delta_2_bi_s - pm.tau_2_bi_s*xid("I_2_bi_s");
        dx(id("I_2_boost_s")) = dx(id("I_2_boost_s")) - dd;
        dx(id("I_2_bi_s")) = dx(id("I_2_bi_s")) + dd;
        
        dd = delta_bi_H_s - pm.tau_bi_H_s*xid("H_bi_s");
        dx(id("H_boost_s")) = dx(id("H_boost_s")) - dd;
        dx(id("H_bi_s")) = dx(id("H_bi_s")) + dd;
        
        dd = delta_1_bi_m - pm.tau_1_bi_m*xid("I_1_bi_m");
        dx(id("I_1_boost_m")) = dx(id("I_1_boost_m")) - dd;
        dx(id("I_1_bi_m")) = dx(id("I_1_bi_m")) + dd;
        
        dd = delta_2_bi_m - pm.tau_2_bi_m*xid("I_2_bi_m");
        dx(id("I_2_boost_m")) = dx(id("I_2_boost_m")) - dd;
        dx(id("I_2_bi_m")) = dx(id("I_2_bi_m")) + dd;
        
        dd = delta_bi_H_m - pm.tau_bi_H_m*xid("H_bi_m");
        dx(id("H_boost_m")) = dx(id("H_boost_m")) - dd;
        dx(id("H_bi_m")) = dx(id("H_bi_m")) + dd;
        
        dd = delta_1_bi_a - pm.tau_1_bi_a*xid("I_1_bi_a");
        dx(id("I_1_boost_a")) = dx(id("I_1_boost_a")) - dd;
        dx(id("I_1_bi_a")) = dx(id("I_1_bi_a")) + dd;
        
        dd = delta_2_bi_a - pm.tau_2_bi_a*xid("I_2_bi_a");
        dx(id("I_2_boost_a")) = dx(id("I_2_boost_a")) - dd;
        dx(id("I_2_bi_a")) = dx(id("I_2_bi_a")) + dd;
        
        dd = delta_bi_st - pm.tau_bi_st*xid("R_bi_st");
        dx(id("R_boost_st")) = dx(id("R_boost_st")) - dd;
        dx(id("R_bi_st")) = dx(id("R_bi_st")) + dd;
        
        dd = delta_bi_lt - pm.tau_bi_lt*xid("R_bi_lt");
        dx(id("R_boost_lt")) = dx(id("R_boost_lt")) - dd;
        dx(id("R_bi_lt")) = dx(id("R_bi_lt")) + dd;
        
        %Vaccine dose daily count 
        %(enforce contraints that compartments be non-negative)
        
        delta_vacc = min(pm.delta_vacc(t),xid("S"));
        delta_vacc_E = 0;
        delta_vacc_pre = 0;
        delta_1_vacc_s = 0;
        delta_2_vacc_s = 0;
        delta_vacc_H_s = 0;
        delta_1_vacc_m = 0;
        delta_2_vacc_m = 0;
        delta_vacc_H_m = 0;
        delta_1_vacc_a = 0;
        delta_2_vacc_a = 0;
        delta_vacc_st = 0;
        delta_vacc_lt = 0;
        
        %Booster dose daily count
        %(enforce contraints that compartments be non-negative)
        if (pm.boost_option == "sc1")
            delta_boost = min(pm.delta_boost(t),xid("S_vacc"));
        else
            delta_boost = pm.delta_boost*xid("S_vacc");
        end
            
        delta_boost_E = 0;
        delta_boost_pre = 0;
        delta_1_boost_s = 0;
        delta_2_boost_s = 0;
        delta_boost_H_s = 0;
        delta_1_boost_m = 0;
        delta_2_boost_m = 0;
        delta_boost_H_m = 0;
        delta_1_boost_a = 0;
        delta_2_boost_a = 0;
        delta_boost_st = 0;
        delta_boost_lt = 0;
        
        
        %Vaccine flows (vaccine dose and waning, non isolated)
        
        dd = delta_vacc - pm.omega_vacc*xid("S_vacc");
        dx(id("S")) = dx(id("S")) - dd;
        dx(id("S_vacc")) = dx(id("S_vacc")) + dd;
        
        dd = delta_vacc_E - pm.omega_vacc*xid("E_vacc");
        dx(id("E")) = dx(id("E")) - dd;
        dx(id("E_vacc")) = dx(id("E_vacc")) + dd;
        
        dd = delta_vacc_pre - pm.omega_vacc*xid("I_vacc_pre");
        dx(id("I_pre")) = dx(id("I_pre")) - dd;
        dx(id("I_vacc_pre")) = dx(id("I_vacc_pre")) + dd;
        
        dd = delta_1_vacc_s - pm.omega_vacc*xid("I_1_vacc_s");
        dx(id("I_1_s")) = dx(id("I_1_s")) - dd;
        dx(id("I_1_vacc_s")) = dx(id("I_1_vacc_s")) + dd;
        
        dd = delta_2_vacc_s - pm.omega_vacc*xid("I_2_vacc_s");
        dx(id("I_2_s")) = dx(id("I_2_s")) - dd;
        dx(id("I_2_vacc_s")) = dx(id("I_2_vacc_s")) + dd;
        
        dd = delta_vacc_H_s - pm.omega_vacc*xid("H_vacc_s");
        dx(id("H_s")) = dx(id("H_s")) - dd;
        dx(id("H_vacc_s")) = dx(id("H_vacc_s")) + dd;
        
        dd = delta_1_vacc_m - pm.omega_vacc*xid("I_1_vacc_m");
        dx(id("I_1_m")) = dx(id("I_1_m")) - dd;
        dx(id("I_1_vacc_m")) = dx(id("I_1_vacc_m")) + dd;
        
        dd = delta_2_vacc_m - pm.omega_vacc*xid("I_2_vacc_m");
        dx(id("I_2_m")) = dx(id("I_2_m")) - dd;
        dx(id("I_2_vacc_m")) = dx(id("I_2_vacc_m")) + dd;
        
        dd = delta_vacc_H_m - pm.omega_vacc*xid("H_vacc_m");
        dx(id("H_m")) = dx(id("H_m")) - dd;
        dx(id("H_vacc_m")) = dx(id("H_vacc_m")) + dd;
        
        dd = delta_1_vacc_a - pm.omega_vacc*xid("I_1_vacc_a");
        dx(id("I_1_a")) = dx(id("I_1_a")) - dd;
        dx(id("I_1_vacc_a")) = dx(id("I_1_vacc_a")) + dd;
        
        dd = delta_2_vacc_a - pm.omega_vacc*xid("I_2_vacc_a");
        dx(id("I_2_a")) = dx(id("I_2_a")) - dd;
        dx(id("I_2_vacc_a")) = dx(id("I_2_vacc_a")) + dd;
        
        dd = delta_vacc_st - pm.omega_vacc*xid("R_vacc_st");
        dx(id("R_st")) = dx(id("R_st")) - dd;
        dx(id("R_vacc_st")) = dx(id("R_vacc_st")) + dd;
        
        dd = delta_vacc_lt - pm.omega_vacc*xid("R_vacc_lt");
        dx(id("R_lt")) = dx(id("R_lt")) - dd;
        dx(id("R_vacc_lt")) = dx(id("R_vacc_lt")) + dd;
        
        
        %Vaccine flows (vaccine waning, isolated)
        
        dd = pm.omega_vacc*xid("S_vi");
        dx(id("S_iso")) = dx(id("S_iso")) + dd;
        dx(id("S_vi")) = dx(id("S_vi")) - dd;
        
        dd = pm.omega_vacc*xid("E_vi");
        dx(id("E_iso")) = dx(id("E_iso")) + dd;
        dx(id("E_vi")) = dx(id("E_vi")) - dd;
        
        dd = pm.omega_vacc*xid("I_vi_pre");
        dx(id("I_iso_pre")) = dx(id("I_iso_pre")) + dd;
        dx(id("I_vi_pre")) = dx(id("I_vi_pre")) - dd;
        
        dd = pm.omega_vacc*xid("I_1_vi_s");
        dx(id("I_1_iso_s")) = dx(id("I_1_iso_s")) + dd;
        dx(id("I_1_vi_s")) = dx(id("I_1_vi_s")) - dd;
        
        dd = pm.omega_vacc*xid("I_2_vi_s");
        dx(id("I_2_iso_s")) = dx(id("I_2_iso_s")) + dd;
        dx(id("I_2_vi_s")) = dx(id("I_2_vi_s")) - dd;

        dd = pm.omega_vacc*xid("H_vi_s");
        dx(id("H_iso_s")) = dx(id("H_iso_s")) + dd;
        dx(id("H_vi_s")) = dx(id("H_vi_s")) - dd;
        
        dd = pm.omega_vacc*xid("I_1_vi_m");
        dx(id("I_1_iso_m")) = dx(id("I_1_iso_m")) + dd;
        dx(id("I_1_vi_m")) = dx(id("I_1_vi_m")) - dd;
        
        dd = pm.omega_vacc*xid("I_2_vi_m");
        dx(id("I_2_iso_m")) = dx(id("I_2_iso_m")) + dd;
        dx(id("I_2_vi_m")) = dx(id("I_2_vi_m")) - dd;
        
        dd = pm.omega_vacc*xid("H_vi_m");
        dx(id("H_iso_m")) = dx(id("H_iso_m")) + dd;
        dx(id("H_vi_m")) = dx(id("H_vi_m")) - dd;
        
        dd = pm.omega_vacc*xid("I_1_vi_a");
        dx(id("I_1_iso_a")) = dx(id("I_1_iso_a")) + dd;
        dx(id("I_1_vi_a")) = dx(id("I_1_vi_a")) - dd;
        
        dd = pm.omega_vacc*xid("I_2_vi_a");
        dx(id("I_2_iso_a")) = dx(id("I_2_iso_a")) + dd;
        dx(id("I_2_vi_a")) = dx(id("I_2_vi_a")) - dd;
        
        dd = pm.omega_vacc*xid("R_vi_st");
        dx(id("R_iso_st")) = dx(id("R_iso_st")) + dd;
        dx(id("R_vi_st")) = dx(id("R_vi_st")) - dd;
        
        dd = pm.omega_vacc*xid("R_vi_lt");
        dx(id("R_iso_lt")) = dx(id("R_iso_lt")) + dd;
        dx(id("R_vi_lt")) = dx(id("R_vi_lt")) - dd;
        
        
        %Boosted flows (booster dose, non isolated)
        
        dx(id("S_vacc")) = dx(id("S_vacc")) - delta_boost;
        dx(id("S_boost")) = dx(id("S_boost")) + delta_boost;
       
        dx(id("E_vacc")) = dx(id("E_vacc")) - delta_boost_E;
        dx(id("E_boost")) = dx(id("E_boost")) + delta_boost_E;
        
        dx(id("I_vacc_pre")) = dx(id("I_vacc_pre")) - delta_boost_pre;
        dx(id("I_boost_pre")) = dx(id("I_boost_pre")) + delta_boost_pre;
        
        dx(id("I_1_vacc_s")) = dx(id("I_1_vacc_s")) - delta_1_boost_s;
        dx(id("I_1_boost_s")) = dx(id("I_1_boost_s")) + delta_1_boost_s;
        
        dx(id("I_2_vacc_s")) = dx(id("I_2_vacc_s")) - delta_2_boost_s;
        dx(id("I_2_boost_s")) = dx(id("I_2_boost_s")) + delta_2_boost_s;
        
        dx(id("H_vacc_s")) = dx(id("H_vacc_s")) - delta_boost_H_s;
        dx(id("H_boost_s")) = dx(id("H_boost_s")) + delta_boost_H_s;
        
        dx(id("I_1_vacc_m")) = dx(id("I_1_vacc_m")) - delta_1_boost_m;
        dx(id("I_1_boost_m")) = dx(id("I_1_boost_m")) + delta_1_boost_m;
        
        dx(id("I_2_vacc_m")) = dx(id("I_2_vacc_m")) - delta_2_boost_m;
        dx(id("I_2_boost_m")) = dx(id("I_2_boost_m")) + delta_2_boost_m;
        
        dx(id("H_vacc_m")) = dx(id("H_vacc_m")) - delta_boost_H_m;
        dx(id("H_boost_m")) = dx(id("H_boost_m")) + delta_boost_H_m;
        
        dx(id("I_1_vacc_a")) = dx(id("I_1_vacc_a")) - delta_1_boost_a;
        dx(id("I_1_boost_a")) = dx(id("I_1_boost_a")) + delta_1_boost_a;
       
        dx(id("I_2_vacc_a")) = dx(id("I_2_vacc_a")) - delta_2_boost_a;
        dx(id("I_2_boost_a")) = dx(id("I_2_boost_a")) + delta_2_boost_a;
       
        dx(id("R_vacc_st")) = dx(id("R_vacc_st")) - delta_boost_st;
        dx(id("R_boost_st")) = dx(id("R_boost_st")) + delta_boost_st;
        
        dx(id("R_vacc_lt")) = dx(id("R_vacc_lt")) - delta_boost_lt;
        dx(id("R_boost_lt")) = dx(id("R_boost_lt")) + delta_boost_lt;
        
        
        %Booster flows (booster waning, non isolated)

        dd = pm.omega_boost*xid("S_boost");
        dx(id("S")) = dx(id("S")) + dd;
        dx(id("S_boost")) = dx(id("S_boost")) - dd;
        
        dd = pm.omega_boost*xid("E_boost");
        dx(id("E")) = dx(id("E")) + dd;
        dx(id("E_boost")) = dx(id("E_boost")) - dd;
        
        dd = pm.omega_boost*xid("I_boost_pre");
        dx(id("I_pre")) = dx(id("I_pre")) + dd;
        dx(id("I_boost_pre")) = dx(id("I_boost_pre")) - dd;
        
        dd = pm.omega_boost*xid("I_1_boost_s");
        dx(id("I_1_s")) = dx(id("I_1_s")) + dd;
        dx(id("I_1_boost_s")) = dx(id("I_1_boost_s")) - dd;
        
        dd = pm.omega_boost*xid("I_2_boost_s");
        dx(id("I_2_s")) = dx(id("I_2_s")) + dd;
        dx(id("I_2_boost_s")) = dx(id("I_2_boost_s")) - dd;

        dd = pm.omega_boost*xid("H_boost_s");
        dx(id("H_s")) = dx(id("H_s")) + dd;
        dx(id("H_boost_s")) = dx(id("H_boost_s")) - dd;
        
        dd = pm.omega_boost*xid("I_1_boost_m");
        dx(id("I_1_m")) = dx(id("I_1_m")) + dd;
        dx(id("I_1_boost_m")) = dx(id("I_1_boost_m")) - dd;
        
        dd = pm.omega_boost*xid("I_2_boost_m");
        dx(id("I_2_m")) = dx(id("I_2_m")) + dd;
        dx(id("I_2_boost_m")) = dx(id("I_2_boost_m")) - dd;
        
        dd = pm.omega_boost*xid("H_boost_m");
        dx(id("H_m")) = dx(id("H_m")) + dd;
        dx(id("H_boost_m")) = dx(id("H_boost_m")) - dd;
        
        dd = pm.omega_boost*xid("I_1_boost_a");
        dx(id("I_1_a")) = dx(id("I_1_a")) + dd;
        dx(id("I_1_boost_a")) = dx(id("I_1_boost_a")) - dd;
        
        dd = pm.omega_boost*xid("I_2_boost_a");
        dx(id("I_2_a")) = dx(id("I_2_a")) + dd;
        dx(id("I_2_boost_a")) = dx(id("I_2_boost_a")) - dd;
        
        dd = pm.omega_boost*xid("R_boost_st");
        dx(id("R_st")) = dx(id("R_st")) + dd;
        dx(id("R_boost_st")) = dx(id("R_boost_st")) - dd;
        
        dd = pm.omega_boost*xid("R_boost_lt");
        dx(id("R_lt")) = dx(id("R_lt")) + dd;
        dx(id("R_boost_lt")) = dx(id("R_boost_lt")) - dd;
        
        %Booster flows (booster waning, isolated)
        
        dd = pm.omega_boost*xid("S_bi");
        dx(id("S_iso")) = dx(id("S_iso")) + dd;
        dx(id("S_bi")) = dx(id("S_bi")) - dd;
        
        dd = pm.omega_boost*xid("E_bi");
        dx(id("E_iso")) = dx(id("E_iso")) + dd;
        dx(id("E_bi")) = dx(id("E_bi")) - dd;
        
        dd = pm.omega_boost*xid("I_bi_pre");
        dx(id("I_iso_pre")) = dx(id("I_iso_pre")) + dd;
        dx(id("I_bi_pre")) = dx(id("I_bi_pre")) - dd;
        
        dd = pm.omega_boost*xid("I_1_bi_s");
        dx(id("I_1_iso_s")) = dx(id("I_1_iso_s")) + dd;
        dx(id("I_1_bi_s")) = dx(id("I_1_bi_s")) - dd;
        
        dd = pm.omega_boost*xid("I_2_bi_s");
        dx(id("I_2_iso_s")) = dx(id("I_2_iso_s")) + dd;
        dx(id("I_2_bi_s")) = dx(id("I_2_bi_s")) - dd;

        dd = pm.omega_boost*xid("H_bi_s");
        dx(id("H_iso_s")) = dx(id("H_iso_s")) + dd;
        dx(id("H_bi_s")) = dx(id("H_bi_s")) - dd;
        
        dd = pm.omega_boost*xid("I_1_bi_m");
        dx(id("I_1_iso_m")) = dx(id("I_1_iso_m")) + dd;
        dx(id("I_1_bi_m")) = dx(id("I_1_bi_m")) - dd;
        
        dd = pm.omega_boost*xid("I_2_bi_m");
        dx(id("I_2_iso_m")) = dx(id("I_2_iso_m")) + dd;
        dx(id("I_2_bi_m")) = dx(id("I_2_bi_m")) - dd;
        
        dd = pm.omega_boost*xid("H_bi_m");
        dx(id("H_iso_m")) = dx(id("H_iso_m")) + dd;
        dx(id("H_bi_m")) = dx(id("H_bi_m")) - dd;
        
        dd = pm.omega_boost*xid("I_1_bi_a");
        dx(id("I_1_iso_a")) = dx(id("I_1_iso_a")) + dd;
        dx(id("I_1_bi_a")) = dx(id("I_1_bi_a")) - dd;
        
        dd = pm.omega_boost*xid("I_2_bi_a");
        dx(id("I_2_iso_a")) = dx(id("I_2_iso_a")) + dd;
        dx(id("I_2_bi_a")) = dx(id("I_2_bi_a")) - dd;
        
        dd = pm.omega_boost*xid("R_bi_st");
        dx(id("R_iso_st")) = dx(id("R_iso_st")) + dd;
        dx(id("R_bi_st")) = dx(id("R_bi_st")) - dd;
        
        dd = pm.omega_boost*xid("R_bi_lt");
        dx(id("R_iso_lt")) = dx(id("R_iso_lt")) + dd;
        dx(id("R_bi_lt")) = dx(id("R_bi_lt")) - dd;
        
        
        %completer les compteurs et fixer dans word...
            
        dx(id("num_hosp")) = pm.h_1_s*xid("I_1_s")+pm.h_1_vacc_s*xid("I_1_vacc_s")+pm.h_1_boost_s*xid("I_1_boost_s")+pm.h_1_s*xid("I_1_iso_s")+pm.h_1_vacc_s*xid("I_1_vi_s")+pm.h_1_boost_s*xid("I_1_bi_s") + pm.h_1_m*xid("I_1_m")+pm.h_1_vacc_m*xid("I_1_vacc_m")+pm.h_1_boost_m*xid("I_1_boost_m")+pm.h_1_m*xid("I_1_iso_m")+pm.h_1_vacc_m*xid("I_1_vi_m")+pm.h_1_boost_m*xid("I_1_bi_m");
        dx(id("num_rec")) = pm.f_R_s*pm.r_H_s*xid("H_s") + pm.f_R_m*pm.r_H_m*xid("H_m") + pm.f_R_s*pm.r_s*xid("I_2_s") + pm.f_R_m*pm.r_m*xid("I_2_m") + pm.f_R_a*pm.gamma_2_a*xid("I_2_a") + pm.f_R_s*pm.r_H_vacc_s*xid("H_vacc_s") + pm.f_R_m*pm.r_H_vacc_m*xid("H_vacc_m") + pm.f_R_s*pm.r_vacc_s*xid("I_2_vacc_s") + pm.f_R_m*pm.r_vacc_m*xid("I_2_vacc_m") + pm.f_R_a*pm.gamma_2_vacc_a*xid("I_2_vacc_a") + pm.f_R_s*pm.r_H_boost_s*xid("H_boost_s") + pm.f_R_m*pm.r_H_boost_m*xid("H_boost_m") + pm.f_R_s*pm.r_boost_s*xid("I_2_boost_s") + pm.f_R_m*pm.r_boost_m*xid("I_2_boost_m") + pm.f_R_a*pm.gamma_2_boost_a*xid("I_2_boost_a") + pm.f_R_s*pm.r_H_s*xid("H_iso_s") + pm.f_R_m*pm.r_H_m*xid("H_iso_m") + pm.f_R_s*pm.r_s*xid("I_2_iso_s") + pm.f_R_m*pm.r_m*xid("I_2_iso_m") + pm.f_R_a*pm.gamma_2_a*xid("I_2_iso_a") + pm.f_R_s*pm.r_H_vacc_s*xid("H_vi_s") + pm.f_R_m*pm.r_H_vacc_m*xid("H_vi_m") + pm.f_R_s*pm.r_vacc_s*xid("I_2_vi_s") + pm.f_R_m*pm.r_vacc_m*xid("I_2_vi_m") + pm.f_R_a*pm.gamma_2_vacc_a*xid("I_2_vi_a") + pm.f_R_s*pm.r_H_boost_s*xid("H_bi_s") + pm.f_R_m*pm.r_H_boost_m*xid("H_bi_m") + pm.f_R_s*pm.r_boost_s*xid("I_2_bi_s") + pm.f_R_m*pm.r_boost_m*xid("I_2_bi_m") + pm.f_R_a*pm.gamma_2_boost_a*xid("I_2_bi_a");
        dx(id("num_covid")) = pm.mu_H_s*xid("H_s") +  pm.mu_H_m*xid("H_m") + pm.mu_s*xid("I_2_s") +  pm.mu_m*xid("I_2_m") + pm.mu_H_vacc_s*xid("H_vacc_s") +  pm.mu_H_vacc_m*xid("H_vacc_m") + pm.mu_vacc_s*xid("I_2_vacc_s") +  pm.mu_vacc_m*xid("I_2_vacc_m") + pm.mu_H_boost_s*xid("H_boost_s") +  pm.mu_H_boost_m*xid("H_boost_m") + pm.mu_boost_s*xid("I_2_boost_s") +  pm.mu_boost_m*xid("I_2_boost_m") + pm.mu_H_s*xid("H_iso_s") +  pm.mu_H_m*xid("H_iso_m") + pm.mu_s*xid("I_2_iso_s") +  pm.mu_m*xid("I_2_iso_m") + pm.mu_H_vacc_s*xid("H_vi_s") +  pm.mu_H_vacc_m*xid("H_vi_m") + pm.mu_vacc_s*xid("I_2_vi_s") +  pm.mu_vacc_m*xid("I_2_vi_m") + pm.mu_H_boost_s*xid("H_bi_s") +  pm.mu_H_boost_m*xid("H_bi_m") + pm.mu_boost_s*xid("I_2_bi_s") +  pm.mu_boost_m*xid("I_2_bi_m");
        dx(id("num_back")) = pm.mu*xsum("N");
        dx(id("num_arr")) = pm.pi*xsum("N");
        dx(id("num_vacc")) = delta_vacc+delta_vacc_E+delta_vacc_pre+ ...
        delta_1_vacc_s+delta_2_vacc_s+delta_vacc_H_s+...
        delta_1_vacc_m+delta_2_vacc_m+delta_vacc_H_m+...
        delta_1_vacc_a+delta_2_vacc_a+...
        delta_vacc_st+delta_vacc_lt;
        dx(id("num_boost")) = delta_boost+delta_boost_E+delta_boost_pre+ ...
        delta_1_boost_s+delta_2_boost_s+delta_boost_H_s+...
        delta_1_boost_m+delta_2_boost_m+delta_boost_H_m+...
        delta_1_boost_a+delta_2_boost_a+...
        delta_boost_st+delta_boost_lt;
        
        dx(id("num_inf_sev_nonvacc"))= pm.f_s_pre*pm.gamma_pre*xid("I_pre");
        dx(id("num_inf_mild_nonvacc"))= pm.f_m_pre*pm.gamma_pre*xid("I_pre");
        dx(id("num_inf_asym_nonvacc"))= pm.f_a_pre*pm.gamma_pre*xid("I_pre");
        
        dx(id("num_inf_sev_vacc")) = pm.f_s_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre");
        dx(id("num_inf_mild_vacc")) = pm.f_m_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre");
        dx(id("num_inf_asym_vacc")) = pm.f_a_vacc_pre*pm.gamma_vacc_pre*xid("I_vacc_pre");
        
        dx(id("num_inf_sev_boost")) = pm.f_s_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre");
        dx(id("num_inf_mild_boost")) = pm.f_m_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre");
        dx(id("num_inf_asym_boost")) = pm.f_a_boost_pre*pm.gamma_boost_pre*xid("I_boost_pre");
        
        dx(id("num_inf_sev_iso_nonvacc")) = pm.f_s_pre*pm.gamma_pre*xid("I_iso_pre");
        dx(id("num_inf_mild_iso_nonvacc")) = pm.f_m_pre*pm.gamma_pre*xid("I_iso_pre");
        dx(id("num_inf_asym_iso_nonvacc")) = pm.f_a_pre*pm.gamma_pre*xid("I_iso_pre");
       
        dx(id("num_inf_sev_vi")) = pm.f_s_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre");
        dx(id("num_inf_mild_vi")) = pm.f_m_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre");
        dx(id("num_inf_asym_vi")) = pm.f_a_vacc_pre*pm.gamma_vacc_pre*xid("I_vi_pre");
       
        dx(id("num_inf_sev_bi")) = pm.f_s_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre");
        dx(id("num_inf_mild_bi")) = pm.f_m_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre");
        dx(id("num_inf_asym_bi")) = pm.f_a_boost_pre*pm.gamma_boost_pre*xid("I_bi_pre");
       
       
       
       
       
    end

    function fv = calculatefit(time,sol)
        vec = count(sol,"num_inf");
        daily = vec(2:end)-vec(1:end-1);
        o = ones(1,10);
        target = exp(4*time(2:end)./50);
        daily = daily(1:length(target));
        fv = sum((transpose(daily)-target).^2);
        fv = 0
    end

end