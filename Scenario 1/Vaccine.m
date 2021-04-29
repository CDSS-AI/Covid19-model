classdef Vaccine
   properties
       nbOfDose = 1
       coverage = 0.5
   end
   methods
      function vac = Vaccine(nbOfDose, coverage)
          vac.nbOfDose = nbOfDose;
          vac.coverage = coverage;
      end
   end
end