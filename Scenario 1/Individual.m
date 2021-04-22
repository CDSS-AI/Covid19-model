classdef Individual
   properties
        Immunity = []
        ageGroup = 0 
        socialInteractionFraction = 0
   end
   methods
      function ind = Population(ageGroup)
          ind.ageGroup = ageGroup;
          ind.socialInteractionFraction = randn(1,1); 
      end
   end
end