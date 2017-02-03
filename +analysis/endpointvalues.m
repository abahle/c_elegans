function head = endpointvalues(ends,center,Ori,N)
% estimates where the head is
[y,x] = find(ends == 1);
c1 = bwtraceboundary(center,[y(1),x(1)],'W',8,N);
c2 = bwtraceboundary(center,[y(2),x(2)],'W',8,N);
    for i = 1:N
        int1(i) = Ori(c1(i,1),c1(i,2)); %get intensities along one direction
        int2(i) = Ori(c2(i,1),c2(i,2)); % and the other
    end
    
    if median(int1)> median(int2)
        head = [y(1),x(1)];
    else
        head = [y(2),x(2)];
    end
end