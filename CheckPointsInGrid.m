function [sucess,failure, missingSpecs] =CheckPointsInGrid(lati,latNext,longes,spec)
   
   sucess = 0;
   failure = 0;

   missingSpecs = zeros(length(longes)-1,2);

   firstSpecIndex = find(spec(:,1) > lati & spec(:,1) < latNext,2,'first');
   if length(firstSpecIndex) > 1
       lastSpecIndex = find(spec(:,1) > lati & spec(:,1) < latNext,1,'last');
       specLonges = spec(firstSpecIndex:lastSpecIndex,2);
       
        for j = 1:1:(length(longes)-1)
            inRange = find(specLonges > longes(j) & specLonges < longes(j+1),1,'first');
  
            if ~isempty(inRange)
                sucess = sucess +1;
            else
                failure = failure +1;

                missingSpecs(j,1) = (lati+latNext)/2;
                missingSpecs(j,2) = (longes(j)+longes(j+1))/2;
            end
        end
   else
       if isempty(firstSpecIndex)
          failure = length(longes)-1;

          longAvg = (longes + [longes(1,2:end),0])/2;
          longAvg = longAvg(1,1:(end-1))';
          
          missingSpecs(:,1) = (lati+latNext)/2;
          missingSpecs(:,2) = longAvg;
       else
           sucess = 1;
           failure = length(longes)-2;

           longAvg = (longes + [longes(1,2:end),0])/2;
           longAvg = longAvg(1,1:(end-1))';
           
           [~,minIndex] = min(abs(longAvg-spec(firstSpecIndex)));
           
           missingSpecs(1:minIndex,1) = (lati+latNext)/2;
           missingSpecs(1:minIndex,2) = longes(1:minIndex)';
           
           missingSpecs(minIndex+1:end,1) = (lati+latNext)/2;
           missingSpecs(minIndex,2) = longes(1:minIndex)';
       end
   end
end

    