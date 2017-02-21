% function tipReduced = removeSpurs(thinnedImage)
%     numEndPoints = sum(sum(bwmorph(thinnedImage, 'endpoints')));
%     tipReduced = thinnedImage;
%     if numEndPoints == 2
%         return
%     end 
%     
%     while (numEndPoints > 2)
%         tipReduced = bwmorph(tipReduced, 'spur',1);
%         numEndPoints = sum(sum(bwmorph(tipReduced, 'endpoints')));
%     end
%    
%     [ex, ey] = find(bwmorph(tipReduced,'endpoints') == 1);
%     for i=1:2
%         nnn = sum(sum(thinnedImage(ex(i) + (-1:1), ey(i) + (-1:1))));
%         while (nnn==3)
%             [dx, dy] = find(thinnedImage(ex(i) + (-1:1), ey(i) + (-1:1)) & ~tipReduced(ex(i) + (-1:1), ey(i) + (-1:1)));
%             ex(i) = ex(i)+dx-2;
%             ey(i) = ey(i)+dy-2;
%             tipReduced(ex(i), ey(i)) = 1;
%             nnn = sum(sum(thinnedImage(ex(i) + (-1:1), ey(i) + (-1:1))));
%         end
%     end
% end

function tipReduced = removeSpurs(thinnedImage)
    numEndPoints = sum(sum(bwmorph(thinnedImage, 'endpoints')));
    tipReduced = thinnedImage;
    if (numEndPoints<=2)
        return
    end
   
    
    while (numEndPoints > 2)
        tipReduced = bwmorph(tipReduced, 'spur',1);
        numEndPoints = sum(sum(bwmorph(tipReduced, 'endpoints')));
    end

    [ex, ey] = find(bwmorph(tipReduced,'endpoints') == 1);
   
    for i=1:2
        xi = max(ex(i)-1,1):min(ex(i)+1,size(tipReduced,1)); % handle boundary cases
        yi = max(ey(i)-1,1):min(ey(i)+1,size(tipReduced,2));
        nnn = sum(sum(thinnedImage(xi, yi)));
        while (nnn==3)
            [dx, dy] = find(thinnedImage(xi, yi) & ~tipReduced(xi, yi));
            ex(i) = ex(i)+dx-2;
            ey(i) = ey(i)+dy-2;
            tipReduced(ex(i), ey(i)) = 1;
            xi = max(ex(i)-1,1):min(ex(i)+1,size(tipReduced,1)); % handle boundary cases
            yi = max(ey(i)-1,1):min(ey(i)+1,size(tipReduced,2));
            nnn = sum(sum(thinnedImage(ex(i) + (-1:1), ey(i) + (-1:1))));
        end
    end
end