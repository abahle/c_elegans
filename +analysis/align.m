function [B,C,Hrot] = align(theta,boundary,center,head)
% this function takes vectors describing the positions of the worm outline
% and worm centerline and aligns them to the x axis by rotating by an angle
% theta
    
    [y1,x1] = find(boundary == 1);
    aB = vertcat(x1',y1'); 
    B = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aB;


    [y2,x2] = find(center == 1);
    aC = vertcat(x2',y2');
    C = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aC;

    y3 = head(1);
    x3 = head(2);
    aD = vertcat(x3',y3');
    Hrot = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aD;
    

    % Center the rotated outline and centerline
    C(1,:) = C(1,:) - min(C(1,:)) + (min(C(1,:))-min(B(1,:)));
    C(2,:) = C(2,:) - min(C(2,:)) + (min(C(2,:))-min(B(2,:)));
    
    Hrot(1,:) = Hrot(1,:) - min(Hrot(1,:)) + (min(Hrot(1,:))-min(B(1,:)));
    Hrot(2,:) = Hrot(2,:) - min(Hrot(2,:)) + (min(Hrot(2,:))-min(B(2,:)));

    B(1,:) = B(1,:) - min(B(1,:));
    B(2,:) = B(2,:) - min(B(2,:));
    
    if abs(Hrot(1) - max(C(:,1))) > abs(Hrot(1) - min(C(:,1))) % head is far from zero
        % rotate everthing 180 deg
        theta = pi;
        B = [cos(theta),-sin(theta);sin(theta),cos(theta)]*B;
        C = [cos(theta),-sin(theta);sin(theta),cos(theta)]*C;
        Hrot = [cos(theta),-sin(theta);sin(theta),cos(theta)]*Hrot;
    end
end