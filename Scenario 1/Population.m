classdef Population
   properties
        nbOfGroups = 2 %default
        transitionMatrix = []  
   end
   methods
      function pop = Population(nbOfGroups)
        if nbOfGroups > 2 
            pop.nbOfGroups = nbOfGroups;
        end
        pop.transitionMatrix = randn(pop.nbOfGroups,pop.nbOfGroups);
      end 
   end
end