function [sucess,failure] =CheckPointsInGrid(lati,latNext,longes,spec)
   
   sucess = 0;
   failure = 0;
   
   firstSpecIndex = find(spec(:,1) > lati & spec(:,1) < latNext ,2,'first');
   if length(firstSpecIndex) > 1
       
       firstSpecIndex = firstSpecIndex(1);
       i = firstSpecIndex;
       while(i <= length(spec(:,1)) && spec(i,1) < latNext)
           i = i+1;
       end
       lastSpecIndex = i-1;

       specLonges = sort(spec(firstSpecIndex:lastSpecIndex),2);
       for j = 1:1:(length(longes)-1)
            %inRange = find(specLonges > longes(j) & specLonges < longes(j+1),1,'first');
            %inRange = binSearchCondition(longes(j),longes(j+1),specLonges);
            if inRange
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

    