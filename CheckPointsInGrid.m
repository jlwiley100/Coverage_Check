function [sucess,failure,lastSpecIndex] =CheckPointsInGrid(lati,latNext,longes,spec,lst)
   
   sucess = 0;
   failure = 0;
   
   if lst == 0
        firstSpecIndex = find(spec(:,1) > lati & spec(:,1) < latNext ,1,'first');
   else 
        firstSpecIndex = lst + 1;
   end
   
   if ~isempty(firstSpecIndex)
       i = firstSpecIndex;
       while(i <= length(spec(:,1)) && spec(i,1) < latNext)
            i = i+1;
       end
           lastSpecIndex = i-1;
   else
       firstSpecIndex = 0;
       lastSpecIndex = 0;
   end
   
   if lastSpecIndex-firstSpecIndex > 1
       

       specLonges = sort(spec(firstSpecIndex:lastSpecIndex,2));
       for j = 1:1:(length(longes)-1)
            %inRange = find(specLonges > longes(j) & specLonges < longes(j+1),1,'first');
            inRange = binSearchCondition(longes(j),longes(j+1),specLonges);
            if inRange
                sucess = sucess +1;
            else
                failure = failure +1;
            end
        end
   elseif lastSpecIndex-firstSpecIndex == 1
           sucess = 1;
           failure = length(longes)-2;
   else
            failure = length(longes)-1;
   end
end

    