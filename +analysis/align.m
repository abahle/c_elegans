function map = align(theta,boundary,center)
% this function takes vectors describing the positions of the worm outline
% and worm centerline and aligns them to the x axis by rotating by an angle
% theta
    [y1,x1] = find(boundary == 1);
    aB = vertcat(x1',y1'); 
    map.boundary = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aB;


    [y2,x2] = find(center == 1);
    aC = vertcat(x2',y2');
    map.center = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aC;

    % Center the rotated outline and centerline
    map.center(1,:) = map.center(1,:) - min(map.center(1,:)) + (min(map.center(1,:))-min(map.boundary(1,:)));
    map.center(2,:) = map.center(2,:) - min(map.center(2,:)) + (min(map.center(2,:))-min(map.boundary(2,:)));

    map.boundary(1,:) = map.boundary(1,:) - min(map.boundary(1,:));
    map.boundary(2,:) = map.boundary(2,:) - min(map.boundary(2,:));
end