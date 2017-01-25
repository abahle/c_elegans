function  r = total_ls(x,y)           
% FIT TOTAL LEAST SQUARES to a binary image in order to rotate that image
% and align it along the x axis. This is so that a spline can be easily fit
% and the angle measured for each segment 

    [~,n] = size(x);    % n is the width of X (X is m by n)
    Z = [x,y];          % Z is X augmented with Y.
    [~,~,v] = svd(Z);   % find the SVD of Z.
    VXY = v(1:n,1+n:end);     % Take the block of V consisting of the first n rows and the n+1 to last column
    VYY = v(1+n:end,1+n:end); % Take the bottom-right block of V.
    r = -VXY/VYY;
end