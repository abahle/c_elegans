function  r = regular_ls(x,y)         
% FIT LEAST SQUARES to a binary image in order to rotate that image
% and align it along the x axis. This is so that a spline can be easily fit
% and the angle measured for each segment 
% the model to be fit is: 
% y(x) = w1*x+w2 where x = the position of the 
        %[y,x] = find(IM == 1);   
        x = x'; y = y';
        F = horzcat(x,ones(length(x),1)); %create matrix of variables
        r = (F'*F)\(F'*y); % perform regression            
end