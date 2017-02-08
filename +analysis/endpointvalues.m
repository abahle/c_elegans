function head = endpointvalues(ends,center,Ori,N)
% estimates where the head is
[y,x] = find(ends == 1);
c1 = bwtraceboundary(center,[y(1),x(1)],'W',8,N);
c2 = bwtraceboundary(center,[y(2),x(2)],'W',8,N);
% figure, hold on
%         subplot(3,1,1)
%         imagesc(Ori)
    for ii = 1:N
        % go through every pixel         
        mask1 = zeros(size(Ori));
        mask2 = zeros(size(Ori));
        for i = -20:20
            for j = -20:20
                if  1 <= c1(ii,1)+i && c1(ii,1)+i < size(Ori,1) && 1 < c1(ii,2)+j && c1(ii,2)+j < size(Ori,2)
                    mask1(c1(ii,1)+i,c1(ii,2)+j) = 1;
                end
                if  1 <= c2(ii,1)+i && c2(ii,1)+i < size(Ori,1) && 1 < c2(ii,2)+j && c2(ii,2)+j < size(Ori,2)
                    mask2(c2(ii,1)+i,c2(ii,2)+j) = 1;
                end
            end
        end
        temp1 = Ori.*mask1; 
%         subplot(3,1,2)
%         imagesc(temp1)
        temp2 = Ori.*mask2;
%         subplot(3,1,3)
%         imagesc(temp2);
%         pause(0.1)
        int1(ii) = sum(temp1(:))/100;
        int2(ii) = sum(temp2(:))/100;              
        %int1(i) = Ori(c1(i,1),c1(i,2)); %get intensities along one direction
        %int2(i) = Ori(c2(i,1),c2(i,2)); % and the other
    end
    
    if mean(int1)> mean(int2)
        head = [y(1),x(1)];
    else
        head = [y(2),x(2)];
    end
end