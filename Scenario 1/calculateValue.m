 function prob = calculateValue(disease, variantIdx, compartmentListIdx) 
    prob = 0;
    if (disease == "S")
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
    elseif (disease == "I_1")
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
    elseif (disease == "I_2")
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
    elseif (disease == "R_1")
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
    elseif (disease == "R_2")
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