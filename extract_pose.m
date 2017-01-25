close all
clear
names = dir('/Users/andrewbahle/Dropbox/PHD/Flavell Rotation/Projects/Tracking/crapJPEGs/*.jpeg');
names = {names.name};

for ii = 1:100%length(names)
    %Ori = im2double(imread(names{randi(length(names),1)}));
    Ori = im2double(imread(names{ii}));
    IM = (Ori);
        %% Threshold - use lower and upper threshold as specified in user controls
        IM(IM < 3*sqrt(var(IM(:)))) = 0;
        
        %% Apply gaussian filter       
        %IM = imgaussfilt(IM,2);
        
        %% MAKE BINARY
        IM = imbinarize(IM);        
            %% Erode 10 times
        se = strel('disk',1);
        for i = 1:10
            IM = imerode(IM,se);
        end

        %imagesc(IM), %xlim([450,850]),ylim([450,850]) 

        
        %% Dilate 10 times
        se = strel('disk',1);
        for i = 1:10    
            IM = imdilate(IM,se);
        end
        
        %% INVERT image
        for i = 1:length(IM(:))
            if IM(i) == 0
                IM(i)=1;
            else
                IM(i) = 0;
            end
        end
        %subplot(2,2,1)
        %imagesc(IM)
        %% Hole filling
        IM = imfill(IM,'holes');
        %% Trace
        Boundary = bwperim(IM);
        center = bwmorph(IM,'thin',Inf);
        cProfile = Ori.*center;

        %% Get center line
%         IM2 =  bwmorph(IM,'skel',Inf);
%         IM3 = bwdist(IM2); %to get the distance from the centerline to the edge.
%         IM2.*IM3;    %Then multiply them to get the centerline where every point on the centerline is the distance to the edge.
        %% FIT LINEAR REGRESSION FOR ROTATION (must be better way) Change to Total least squares
%         [y,x] = find(center == 1);
%         % y(x) = w1*x+w2 where x = the position of the 
%         F = horzcat(x,ones(length(x),1)); %create matrix of variables
%         r = (F'*F)\(F'*y); % perform regression
%         yp = F*r; % get predicted values

        
        %% FIT TOTAL LEAST SQUARES
        [y,x] = find(Boundary == 1);
        [m,n] = size(x);    % n is the width of X (X is m by n)
        Z = [x,y];          % Z is X augmented with Y.
        [u,s,v] = svd(Z);   % find the SVD of Z.
        VXY = v(1:n,1+n:end);     % Take the block of V consisting of the first n rows and the n+1 to last column
        VYY = v(1+n:end,1+n:end); % Take the bottom-right block of V.
        B = -VXY/VYY;

         %yp = x*-B; % get predicted values
         %figure, plot(x,y,'.k',x,yp,'.r')
      
        %% Rotate outline
        [y,x] = find(Boundary == 1);
        c = vertcat(x',y');
        theta = 2*pi-atan(-B);
        %theta = 2*pi-atan(r(1));
        rot2 = [cos(theta),-sin(theta);sin(theta),cos(theta)]*c;

        
        %% Rotate center towards plane
        [y,x] = find(center == 1);
        c = vertcat(x',y');
        
        %theta = 2*pi-atan(r(1));
        rot = [cos(theta),-sin(theta);sin(theta),cos(theta)]*c;
        
        %% Center the rotated outline and centerline
        rot(1,:) = rot(1,:) - min(rot(1,:)) + (min(rot(1,:))-min(rot2(1,:)));
        rot(2,:) = rot(2,:) - min(rot(2,:)) + (min(rot(2,:))-min(rot2(2,:)));

        rot2(1,:) = rot2(1,:) - min(rot2(1,:));
        rot2(2,:) = rot2(2,:) - min(rot2(2,:));
        %% Fit interpolating spline
            N = 101;
        xx = linspace(min(rot(1,:)),max(rot(1,:)),N);
        yy = spline(rot(1,:),rot(2,:),xx);        
%         
%% FIT 2D interpolating spline

%fnplt(cscvn([rot(1,:)',rot(2,:)']),'r',2)
        %% Fit smoothing spline with FIT
%         [curve, goodness, output] = fit(rot(1,:)',rot(2,:)','smoothingspline');
%         plot(curve,rot(1,:),rot(2,:));
        %% Fit smoothing spline
%         N = length(rot);
%         xx = linspace(0,max(rot(1,:)),N);
%         pp = csaps(rot(1,:),rot(2,:),0.99, [],xx);
%         fnplt(pp)
%         yy = fnval(csaps(rot(1,:),rot(2,:)),xx);
        %% OR FIT POLYNOMIAL
%         N = 101;
%         n = 10;
%         p = polyfit(rot(1,:),rot(2,:),n);
%         
%         xx = linspace(0,floor(max(rot(1,:))),N);
%         yy = polyval(p,xx);

        %% get angles
        %N = length(rot);
        ang = zeros(N-1,1);      
            for i = 1:N-1
                ang(i) = atan((yy(i+1)-yy(i))/(xx(i+1)-xx(i)));
                %ang(i) = atan((rot(2,i+1)-rot(2,i))/(rot(1,i+1)-rot(1,i)));
                
            end
        
        
                %% plot
        %h = figure; set(h, 'Visible', 'off'); hold on
        figure
        subplot(3,2,1), axis equal
            imagesc(Ori)
        subplot(3,2,2), axis equal
            imagesc(IM)
        subplot(3,2,3:4)
            plot(rot2(1,:),rot2(2,:),'k.'), hold on     
            plot(rot(1,:),rot(2,:),'r.'), axis equal
            %fnplt(pp,'bo')
%             plot(xx,yy,'bo'), axis equal
            %fnplt(cscvn([rot(1,1:100:end);rot(2,1:100:end)]),'bo',2)
        subplot(3,2,5:6)
            plot(1:N-1,ang), title('angles of the worm pose')
%         subplot(4,2,7:8)
%             
%             imagesc(cProfile)
%             

        %% Particle measurement - Theshold by area of connected components
fpath  = sprintf('/Users/andrewbahle/Dropbox/PHD/Flavell Rotation/Projects/Tracking/test3/');
saveas(gca, fullfile(fpath, sprintf('%i',ii)),'jpeg');
close all
end