function inRange = binSearchCondition(lowerBound,upperBound,arr)
    
 a = 1;
 b = length(arr);
    while a < b
        mid = floor((a + b) / 2);
        if arr(mid) < lowerBound
            a = mid + 1;
        else
            b = mid;
        end
    end
 if(arr(a) > lowerBound && arr(a) < upperBound)
     inRange = true;
 else
     inRange = false;
 

end
