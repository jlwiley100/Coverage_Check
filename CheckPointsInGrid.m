function [sucess,failure,lastSpecIndex] =CheckPointsInGrid(lati,latNext,longes,spec,lst)
   %intialization
   sucess = 0;
   failure = 0;
   
   firstSpecIndex = lst + 1;
   
   
   %find the last specular point in the list within the lattiude band
   %if there are no lastSpec Index will be one less than firstSpecIndex
    
   lastSpecIndex = find(spec(:,1) > lati & spec(:,1) < latNext,1,'last');
   
   %if there are at least 2 specular points
   if lastSpecIndex-firstSpecIndex >= 1
       
       %sort  for bianary search
       specLonges = sort(spec(firstSpecIndex:lastSpecIndex,2));
       
       %for all the longitude bands
       for j = 1:1:(length(longes)-1)
            %inRange = find(specLonges > longes(j) & specLonges < longes(j+1),1,'first');
            
            %see if any specular points are within the longitude band
            inRange = binSearchCondition(longes(j),longes(j+1),specLonges);
            
            if inRange
                sucess = sucess +1;
            else
                failure = failure +1;
            end
            
       end
   %if there is only one specular point
   elseif lastSpecIndex-firstSpecIndex == 0
           sucess = 1;
           failure = length(longes)-2;
   %no specular points
   else
            failure = length(longes)-1;
   end
end

    