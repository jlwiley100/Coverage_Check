function [sucess,failure] =CheckPointsInGrid(lati,latNext,longes,spec)
   
   sucess = 0;
   failure = 0;
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
            end
        end
   else
       if isempty(firstSpecIndex)
          failure = length(longes)-1;
       else
           sucess = 1;
           failure = length(longes)-2;
       end
   end
end
