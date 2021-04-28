function dx = defSolver(t,x, pm)
    dx = zeros(length(x),1);
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
    
    %Equations
    dx(ds) = pm.beta_s*xid("S") - pm.delta(x*pm.id("S")) - pm.lambda(x*pm.id("I")) - pm.r*x;
    dx(dI_1) = pm.beta_s*xid("S") - pm.delta(x*pm.id("I")) - pm.r(x*pm.id("I"));
    dx(dI_2) = pm.delta*xid("S") - pm.delta(x*pm.id("I")) - pm.r(x*pm.id("I"));
    dx(dR) = pm.delta_s*xid("S") - (pm.delta * pm.r) - pm.delta(x*pm.id("R"));
   
end