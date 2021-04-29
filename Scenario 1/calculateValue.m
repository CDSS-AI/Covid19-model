 function prob = calculateValue(diseaseStatus, variantIdx, compartmentListIdx) 
    prob = 0;
    if (diseaseStatus == "S")
        if (variantIdx == 1)
            if(compartmentListIdx == 1)
            	prob = 0.1; 
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        elseif (variantIdx == 2) 
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        end
    elseif (diseaseStatus == "I_1")
        if (variantIdx == 1)
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
         elseif (variantIdx == 2) 
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        end
    elseif (diseaseStatus == "I_2")
        if (variantIdx == 1)
           if(compartmentListIdx == 1)
               prob = 0.1;
           elseif(compartmentListIdx == 2)
               prob = 0.1;
           elseif(compartmentListIdx == 3)
               prob = 0.1;
           elseif(compartmentListIdx == 4)
               prob = 0.1;
           elseif(compartmentListIdx == 5)
               prob = 0.1;
           end
        elseif (variantIdx == 2) 
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        end
    elseif (diseaseStatus == "R_1")
        if(variantIdx == 1)
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        elseif (variantIdx == 2) 
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
           end
        end
    elseif (diseaseStatus == "R_2")
        if (variantIdx == 1)
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        elseif (variantIdx == 2) 
            if(compartmentListIdx == 1)
                prob = 0.1;
            elseif(compartmentListIdx == 2)
                prob = 0.1;
            elseif(compartmentListIdx == 3)
                prob = 0.1;
            elseif(compartmentListIdx == 4)
                prob = 0.1;
            elseif(compartmentListIdx == 5)
                prob = 0.1;
            end
        end
   end
end