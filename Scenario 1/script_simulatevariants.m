function simulate_variants()

    %S : susceptible is root concept
    %In other terms, careful about the order... it is always something like
    %E_var1_pop2" so it's disease type then virus type then pop type
    diseaseTypes = ["E","Ia","Is","H","R"];
    virusTypes = ["_hist","_var1","_var2"];
    popTypes = ["_pop1","_pop2"];
    
    %for auxiliary variables the order is auxiliary type then virus type
    %then pop type
    auxiliaryTypes = ["newinf","newhosp","newcvdth","newbgdth"];
    
    compartmentVariables = [];
    for pop_i = 1 : length(popTypes)
        compartmentVariables = [compartmentVariables,strcat("S",popTypes(pop_i))];
        for  dis_i = 1 : length(diseaseTypes)
            for vir_i = 1 : length(virusTypes)
                compartmentVariables = [compartmentVariables,strcat(diseaseTypes(dis_i),virusTypes(vir_i),popTypes(pop_i))];
            end
        end
    end
    
    auxiliaryVariables = [];
    for aux_i = 1 : length(auxiliaryTypes)
       for vir_i = 1 : length(virusTypes)
            for pop_i = 1 : length(popTypes)
                auxiliaryVariables = [auxiliaryVariables,strcat(auxiliaryTypes(aux_i),virusTypes(vir_i),popTypes(pop_i))];
            end
       end
    end

    counters = [compartmentVariables,auxiliaryVariables];
    
    ncompartments = length(compartmentVariables);
    nauxiliary = length(auxiliaryVariables);
    ncounters = length(counters);
   
    
    
    %%%% COMPUTATION OF BASELINE PARAMETERS
    
    %Setting rate flows
    %E->Ia or E->Is with some proportion, Ia->R, Is->H or Is->R with some proportion, R->S
    prob_symptoms = 0.6;
    prob_hospit = 0.1;
    daysE = 4;
    daysIa = 10;
    daysIs = 10;
    daysH = 12;
    daysR = Inf;
    
    %order of indices is : (1) source, (2) destination
    rateflowmatrix = zeros(ncompartments,ncompartments);
    for pop_i = 1 : length(popTypes)
        for vir_i = 1 : length(virusTypes)
            %E->Ia
            sourceComp = strcat("E",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("Ia",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (1-prob_symptoms)*(1/daysE);
        
            %E->Is
            sourceComp = strcat("E",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("Is",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (prob_symptoms)*(1/daysE);
            
            %Ia->R
            sourceComp = strcat("Ia",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("R",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (1/daysIa);
        
            %Is->R
            sourceComp = strcat("Is",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("R",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (1-prob_hospit)*(1/daysIs);
            
            %Is->H
            sourceComp = strcat("Is",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("H",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (prob_hospit)*(1/daysIs);
            
            %H->R
            sourceComp = strcat("H",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("R",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (1/daysH);
            
            %R->S
            sourceComp = strcat("R",virusTypes(vir_i),popTypes(pop_i));
            destinComp = strcat("S",virusTypes(vir_i),popTypes(pop_i));
            rateflowmatrix(id(sourceComp),id(destinComp)) = (1/daysR);
        end
    end
    
    
    
    
    %infection hypermatrix : order of indices is 
    % (1) source of infection flow (someone who acquires the infection),
    % (2) destination of infection flow (passing to exposed compartment),
    % (3) transmitter of the infection (someone who transmits the infection)
    infectionhypermatrix = zeros(ncompartments,ncompartments,ncompartments);
    
    
    %denominator matrix : order of indices is 
    % (1) a given compartment (will only be useful for transmitters, but we
    % build matrix for all)
    % (2) all compartments who are of the same population as the given
    % compartment
    denominatormatrix = false(ncompartments,ncompartments);
    for comp_i = 1:ncompartments
        for comp_j = 1:ncompartments
            first_split = split(counters(comp_i),"_");
            second_split = split(counters(comp_j),"_");
            
            first_pop = "INVALID";
            second_pop = "INVALID";
            
            for split_i = 1 : length(first_split)
                if(strlength(first_split(split_i))>=3)
                    if(extractBetween(first_split(split_i),1,3)=="pop")
                        first_pop = first_split(split_i);
                    end
                end
            end
            for split_i = 1 : length(second_split)
                if(strlength(second_split(split_i))>=3)
                    if(extractBetween(second_split(split_i),1,3)=="pop")
                        second_pop = second_split(split_i);
                    end
                end
            end
           
            if((first_pop == "INVALID") || (second_pop == "INVALID"))
                error("Invalid string, no population!");
            end
           
            if(first_pop==second_pop)
                denominatormatrix(comp_i,comp_j) = true();
            end
        end
    end
    
    
    %cross immunity matrix : order of indices is
    % (1) last resistance acquired
    % (2) type of virus infecting
    crossimmunitymatrix = zeros(length(virusTypes),length(virusTypes));
    for vir_i = 1 : length(virusTypes)
        for vir_j = 1 : length(virusTypes)
            if(vir_i == vir_j)
                %Hypothesis that a virus confers 100% protection against
                %itself
                crossimmunitymatrix(vir_i,vir_j) = 1; 
            else
                %Hypothesis that a virus confers 0% protection against
                %other versions
                crossimmunitymatrix(vir_i,vir_j) = 0;
            end
        end
    end
    
    %contact matrix : level of contact in different populations, SYMMETRIC
    contactmatrix = zeros(length(popTypes),length(popTypes));
    for pop_i = 1 : length(popTypes)
        for pop_j = 1 : length(popTypes)
            if(pop_i == pop_j)
                contactmatrix(pop_i,pop_j) = 8;
            else
                %Hypothesis of two parallel populations that do not
                %interact
                contactmatrix(pop_i,pop_j) = 0;
            end
        end
    end
    
        
    %some arbitrary infection probability assuming someone with symptoms
    %sheds more virus
    prob_infect_E = 0;
    prob_infect_Ia = 1.33*0.02;
    prob_infect_Is = 1.33*0.05;
    prob_infect_H = 0;
    for pop_i = 1 : length(popTypes) %population of the source
        for vir_j = 1 : length(virusTypes) %virus of the transmitter
            for pop_j = 1 : length(popTypes) %population of the transmitter
                %S -> E
                sourceComp = strcat("S",popTypes(pop_i));
                destinComp = strcat("E",virusTypes(vir_j),popTypes(pop_i));
                transmComp = strcat("E",virusTypes(vir_j),popTypes(pop_j));
                infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = contactmatrix(pop_i,pop_j)*prob_infect_E;
                transmComp = strcat("Ia",virusTypes(vir_j),popTypes(pop_j));
                infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = contactmatrix(pop_i,pop_j)*prob_infect_Ia;
                transmComp = strcat("Is",virusTypes(vir_j),popTypes(pop_j));
                infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = contactmatrix(pop_i,pop_j)*prob_infect_Is;
                transmComp = strcat("H",virusTypes(vir_j),popTypes(pop_j));
                infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = contactmatrix(pop_i,pop_j)*prob_infect_H;



                %R -> E
                for vir_i = 1 : length(virusTypes) %Resistant having gone through virus i, infection to virus j
                    sourceComp = strcat("R",virusTypes(vir_i),popTypes(pop_i));
                    destinComp = strcat("E",virusTypes(vir_j),popTypes(pop_i));
                    transmComp = strcat("E",virusTypes(vir_j),popTypes(pop_j));
                    infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = (1-crossimmunitymatrix(vir_i,vir_j))*contactmatrix(pop_i,pop_j)*prob_infect_E;
                    transmComp = strcat("Ia",virusTypes(vir_j),popTypes(pop_j));
                    infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = (1-crossimmunitymatrix(vir_i,vir_j))*contactmatrix(pop_i,pop_j)*prob_infect_Ia;
                    transmComp = strcat("Is",virusTypes(vir_j),popTypes(pop_j));
                    infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = (1-crossimmunitymatrix(vir_i,vir_j))*contactmatrix(pop_i,pop_j)*prob_infect_Is;
                    transmComp = strcat("H",virusTypes(vir_j),popTypes(pop_j));
                    infectionhypermatrix(id(sourceComp),id(destinComp),id(transmComp)) = (1-crossimmunitymatrix(vir_i,vir_j))*contactmatrix(pop_i,pop_j)*prob_infect_H;
                end
            end
        end
    end
    
    
    %IMPORTATION OF CASES, elements are time-dependent
    %most of other param structures should be recast as time-dependent
    %
    %We are going to draw imported cases from the corresponding susceptible
    importflow = cell(ncompartments,ncompartments);
    for comp_i = 1 : ncompartments
        for comp_j = 1 : ncompartments
            importflow{comp_i,comp_j} = @(t)0; %initialized value is function 0 for all t
        end
    end
    %Special values
    importflow{id("S_pop1"),id("E_hist_pop1")} = @(t) 10*(t>=5)*(t<12); %3 persons per day for 1 week starting at day 5
    importflow{id("S_pop1"),id("E_var1_pop1")} = @(t) 10*(t>=105)*(t<112); %3 persons per day for 1 week starting at day 105
    importflow{id("S_pop1"),id("E_var2_pop1")} = @(t) 10*(t>=205)*(t<212); %3 persons per day for 1 week starting at day 205
    %no infections in pop2 here
    
    
    %covid death flows
    cvdeathflow = zeros(ncompartments,1);
    cvdeathflow(id("H_hist_pop1")) = 0;
    cvdeathflow(id("H_hist_pop2")) = 0;
    cvdeathflow(id("H_var1_pop1")) = 0;
    cvdeathflow(id("H_var1_pop2")) = 0;
    cvdeathflow(id("H_var2_pop1")) = 0;
    cvdeathflow(id("H_var2_pop2")) = 0;
    
    %background death flows
    bgdeathflow = zeros(ncompartments,1);
    
    
    %%%% COMPUTATION OF SPECIAL PARAMETERS
    %... for example, we would put here
    % - variants having a greater probability of infection
    % - etc
  
    init = zeros(1,length(counters));
    init(id("S_pop1")) = 900000;
    init(id("E_hist_pop1")) = 0;
    init(id("S_pop2")) = 100000;
    timelimit = 365;
    [time,solution] = ode45(@f,0:1:timelimit,init);
    
    %plotting number of exposed for each variant in population 1
    
    figure,
    hold on
    plot(time,solution(:,id("E_hist_pop1"))+solution(:,id("Ia_hist_pop1"))+solution(:,id("Is_hist_pop1")));
    title("Active cases (unhospitalized), historical virus");
    hold off
    
    figure,
    hold on
    plot(time,solution(:,id("E_var1_pop1"))+solution(:,id("Ia_var1_pop1"))+solution(:,id("Is_var1_pop1")));
    title("Active cases (unhospitalized), variant 1");
    hold off
    
    figure,
    hold on
    plot(time,solution(:,id("E_var2_pop1"))+solution(:,id("Ia_var2_pop1"))+solution(:,id("Is_var2_pop1")));
    title("Active cases (unhospitalized), variant 2");
    hold off
    
    figure,
    hold on
    plot(time,solution(:,id("H_hist_pop1")));
    title("Active cases (hospitalized), historical virus");
    hold off
    
    figure,
    hold on
    plot(time,solution(:,id("H_var1_pop1")));
    title("Active cases (hospitalized), variant 1");
    hold off
    figure,
    hold on
    plot(time,solution(:,id("H_var2_pop1")));
    title("Active cases (hospitalized), variant 2");
    hold off
    
    
  
    function v = id(g)
            %Inputs
            %g : vector of compartment names
            %Output
            %v : indices of elements of group in counters
            [s,v] = intersect(counters,g,'stable');
    end

    function dx = f(t,x)
        t
        function v = xid(g)
            v = x(id(g));
        end
        
        dx = zeros(ncounters,1);
        dxc = zeros(ncompartments,1);
        dxa = zeros(nauxiliary,1);
        
        xc = x(1:ncompartments);
        xa = x((ncompartments+1):ncounters);
        
        %rate flow
        for i = 1 : ncompartments
            %we substract the total outflow rate of compartment i (a matrix line) multiplied by
            %xc(i) which is the content of that compartment
            %we add the scalar product of x with the inflow rates (rates
            %from all other compartments)
            dxc(i) = dxc(i) - sum(rateflowmatrix(i,:))*xc(i) + sum(rateflowmatrix(:,i).*xc);
        end
     
        
        
        %on-the-fly computation of infectionflowmatrix
         %(will need to be adjusted for balancing contacts rate, we will
        %need to look into that
        infectionflowmatrix = zeros(ncompartments,ncompartments);
        for i = 1 : ncompartments
            for j = 1 : ncompartments
                for k = 1 : ncompartments
                    infectionflowmatrix(i,j) = infectionflowmatrix(i,j) + infectionhypermatrix(i,j,k)*xc(k)./sum(xc(denominatormatrix(k,:)));
                end
            end
        end
        
        %infection flows
        for i = 1 : ncompartments
            %infection computed like rates via the infectionflowmatrix
            dxc(i) = dxc(i) - sum(infectionflowmatrix(i,:))*xc(i) + sum(infectionflowmatrix(:,i).*xc);
        end
        
        %import flows
        for i = 1 : ncompartments
            for j = 1 : ncompartments
                dxc(i) = dxc(i) - importflow{i,j}(t) + importflow{j,i}(t);
            end
        end
        
        %covid death flow and background death flow
        for i = 1 : ncompartments
            dxc(i) = dxc(i) - cvdeathflow(i)*xc(i) - bgdeathflow(i)*xc(i);
        end
        
        
        %auxiliary variables
       %"newinf_hist_pop1","newhosp_hist_pop1","newdth_hist_pop1","newinf_var1_pop1","newhosp_var1_pop1","newdth_var1_pop1","newinf_var2_pop1","newhosp_var2_pop1","newdth_var2_pop1"
        %needs to be done
        
        
       dx = [dxc;dxa];
    end

end