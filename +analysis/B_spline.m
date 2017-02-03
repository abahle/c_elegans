function [tX,tY,Bx,By] = B_spline(x,y,k)
    % get x,y coordinates
    %[y,x] = find(center == 1);

    % get x knots
    %kxi = horzcat(1,floor((length(x)*[0.05:0.05:1])));
    ki = (length(x)*[0:0.05:1]);
    knot = augknt(ki,k); 

    % get y knots
    %kyi = horzcat(1,floor((length(y)*[0.1:0.05:1])));  
    %yknot = augknt(kyi,k); 

    % get the points to evaluate spline at

    xpts = (linspace(min(knot),max(knot),length(x)));
    ypts = (linspace(min(knot),max(knot),length(y)));


    [X,~] = analysis.basis_matrix(k,knot,xpts);
    Bx = (X'*X)\(X'*x);

    [Y,~] = analysis.basis_matrix(k,knot,ypts);
    By = (Y'*Y)\(Y'*y);

    tX = X*Bx;
    tY = Y*By;

    % figure, hold on
    % plot(x,y,'.k',tX,tY,'or')

end