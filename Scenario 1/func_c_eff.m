
% Counterfactual type1 (Main scenario):  
% Counterfactual type2: contact reduction based on Rt INSPQ
% Counterfactual type3: contact reduction (type2) till 8th march, then December contact rate
% Counterfactual type4: contact reduction till 8th march, then Rt=1 
% Counterfactual type5: Pre-COVID number of contact (8)
% Counterfactual type6: 100% reduction of contact 
% Counterfactual type7: 50% reduction of number of contacts 
% Counterfactual type8: 0% reduction of number of contacts 
% Counterfactual type9: CONNECT 


function c = func_c_eff(vt,pm)
    

     nt = length(vt);
     c = zeros(1,nt);
     for i = 1:nt
        t = vt(i); %if t is needed
        if(pm.func_c_eff_type == 1)
            c(i) = pm.c_base*pm.p_base;
            
        elseif(pm.func_c_eff_type == 2)%contact reduction based on Rt INSPQ
            lineA = 1 - (0.25/16)*(t-24);
            lineB = 0.75+(0.10/8)*(t-48);
            c(i)= pm.c_base*pm.p_base*((t<24)+(t>=24)*(t<40)*lineA + (t>=40)*(t<48)*0.75 + (t>=48)*(t<56)*lineB + (t>=56)*0.85);
        
        elseif(pm.func_c_eff_type == 3)%contact reduction till 8th march, then December contact rate
            lineA = 1 - (0.25/16)*(t-24);
            lineB = 0.75+(0.10/8)*(t-48);
           c(i)= pm.c_base*pm.p_base*((t<24)+(t>=24)*(t<40)*lineA + (t>=40)*(t<48)*0.75 + (t>=48)*(t<56)*lineB + (t>=56)*(t<98)*0.85+(t>=98));
       
        elseif(pm.func_c_eff_type == 4)%contact reduction till 8th march, then Rt=1 
            lineA = 1 - (0.25/16)*(t-24);
            lineB = 0.75+(0.10/8)*(t-48);
            dc = 1/pm.rtfeb;
            c(i)= pm.c_base*pm.p_base*((t<24)+(t>=24)*(t<40)*lineA + (t>=40)*(t<48)*0.75 + (t>=48)*(t<56)*lineB + (t>=56)*(t<98)*0.85+(t>=98)*dc);
            
        elseif(pm.func_c_eff_type == 5)%precovid
            c(i) = pm.c_base;
            
        elseif(pm.func_c_eff_type == 6)%100% reduction of contact every month
            c(i)= pm.c_base*pm.p_base*(1-floor(mod(t/30,2))*0.99999);
            
        elseif(pm.func_c_eff_type == 7)%50% reduction of contact every month
          
            c(i)=pm.c_base*pm.p_base*(1-floor(mod(t/30,2))*(0.50));
            
        elseif(pm.func_c_eff_type == 8)%0% reduction of contact every month
                 
                c(i)=pm.c_base*(pm.p_base+floor(mod(t/30,2))*(1-pm.p_base));
        
        elseif(pm.func_c_eff_type == 9)%CONNECT(1Dec-30Jan)
             c(i)=((t<17)*0.865+(t>=17)*(t<32)*0.6+(t>=32)*(t<40)*0.56+(t>=40)*0.66)*(pm.c_base*pm.p_base);
        
        
        end
        %make ifelse for other types as needed, also in c_iso_eff
     end
 
end

