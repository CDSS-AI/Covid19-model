function r0 = func_r0(vt,pm)
    
    nt = length(vt);
     r0 = zeros(1,nt);
     for i = 1:nt
         t = vt(i);
         ava2 = func_c_eff(t,pm)*pm.beta_a/pm.gamma_2_a;
        ava1 = func_c_eff(t,pm)*pm.beta_a/pm.gamma_1_a;
        avm2 = func_c_eff(t,pm)*pm.beta_m/pm.gamma_2_m;
        avm1 = func_c_eff(t,pm)*pm.beta_m/pm.gamma_1_m;
        avhs = pm.c_hosp*pm.beta_H_s/pm.gamma_H_s;
        avs1 = func_c_eff(t,pm)*pm.beta_s/pm.h_1_s;
        avpre = func_c_eff(t,pm)*pm.beta_pre/pm.gamma_pre;
        r0(i) = avpre + pm.f_a_pre*(ava1+ava2) +  pm.f_m_pre*(avm1+avm2)  +  pm.f_s_pre*(avs1+avhs);
         %make ifelse for other types as needed, also in c_eff
     end     


    
    
end

