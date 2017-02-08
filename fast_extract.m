% fast_extract works just like extract pose except it drops all but the
% algorithms to find the centerline
% Usage
% image_data = extract_pose('/Users/andrewbahle/Dropbox/PHD/Flavell Rotation/Projects/Tracking/crapJPEGs'...
% 'jpeg','/Users/andrewbahle/Dropbox/PHD/Flavell Rotation/Projects/Tracking/test3');
%
% -------------------------------------------------------------------------
% INPUT
% filein:   a path to a file containing your image files
%
% <options> 
% type: this is a string specifying the file type that you have saved your
% images - default is 'jpg'
% 
% fileout:  a path to a file where you would like to save your output if
% this is specified then the output will be plotted and saved as an output
% 
% OUTPUT
% 
% map:  map is a struct that contains the positions of the aligned worm
% center and outline as well as the profile values of the center of the
% worm and the angles between each segment of a fitted spline

%[map,M] = fast_extract(filein,varargin)
    clear, close all
    type = 'jpeg';
    filein =  'C:\Users\labmember\Desktop\copper_ring_test';    

    time = cputime;
    
    writerObj = VideoWriter('worm.avi');
    writerObj.FrameRate = 10;
    writerObj.Quality = 100; 
    open(writerObj);
   
    % get the names of all files of the specified type in the input folder 'filepath'
    filepath = sprintf('%s/*.%s',filein,type);
    names = dir(filepath);
    names = {names.name};
    map = cell(1,length(names));
    %M(length(names)) = struct('cdata',[],'colormap',[]);
    for ii = 1:500%length(names)
        %% Process the image and get releavant properties           
        fprintf('processing image #%i\n',ii)
        fnum = ii;
        Ori = im2double(imread(sprintf('%s/%s',filein,names{fnum}))); 
        IM = Ori;
        thresh = 0.2; %mean(IM(:)) - 2*sqrt(var(IM(:))); %calculate the threshold
        IM = analysis.process(IM,thresh,15,1); % process 
        IM = bwlabel(IM);
        % get rid of particles that are not the largest
        if max(IM(:)) > 1
            for k = 1:max(IM(:))
                temp(k) = length(IM(IM == k));
            end
           IM(IM ~= find(temp == max(temp))) = 0;
        end
        [boxes,~] = analysis.imOrientedBox(IM);
        theta = -deg2rad(boxes(5));      
        boundary = bwperim(IM); % get boundary
        center = bwmorph(IM,'thin',Inf); % get center line
        
        center = bwmorph(center,'spur',5);
        
        ends = bwmorph(center,'endpoints'); % get endpoints
        
        if ii == 1
            map{ii}.head = analysis.endpointvalues(ends,center,Ori,200); %
        else
            [y,x] = find(ends == 1);
            X = [y,x];
            map{ii}.head = X(knnsearch(X,map{ii-1}.head),:);
        end
           
        [map{ii}.boundary,map{ii}.center,map{ii}.hrot] = analysis.align(theta,boundary,center,map{ii}.head); % align
        
        % fit b spline
        [tX,tY,Bx,By] = analysis.B_spline(map{ii}.center(1,:)',map{ii}.center(2,:)',4);
        % get angles
        angles = analysis.get_angles(tX,tY);

%% plot          
            
                   
%             plot(map{ii}.boundary(2,:),map{ii}.boundary(1,:),'k.'), hold on % plot boundary 
%             %plot(map{ii}.center(2,:),map{ii}.center(1,:),'r.') % plot center          
%             plot(tY,tX,'r.')
%             plot(map{ii}.hrot(2,:),map{ii}.hrot(1,:),'b.','MarkerSize',10), axis equal % plot ends points
                         
                
                h = figure; set(h, 'Visible', 'off'); hold on
                set(gca,'nextplot','replacechildren');
                set(h,'renderer','painters');
                subplot(3,2,1:2:3)
                    imagesc(Ori), axis equal, axis off, title(sprintf('image # %i',ii))
                subplot(3,2,2:2:4)
                    plot(map{ii}.boundary(2,:),map{ii}.boundary(1,:),'k.','MarkerSize',0.5), hold on % plot boundary
                    plot(map{ii}.center(2,:),map{ii}.center(1,:),'k','MarkerSize',0.5), axis equal % plot center
                    plot(tY,tX,'r.','MarkerSize',0.5)
                    plot(tY(1),tX(1),'co',tY(end),tX(end),'go')
                    plot(map{ii}.hrot(2,:),map{ii}.hrot(1,:),'bo','MarkerSize',1), axis equal, axis off % plot ends points                      
                subplot(3,2,5:6)
                    plot(1:length(angles),angles,'.k'), title('angles of the worm pose'),xlim([0,length(angles)]), ylim([-pi,pi]) % plot angles
            drawnow;
            frame = getframe(h);
            writeVideo(writerObj,frame);

    end % end of image file loop
%     v = VideoWriter('motion.avi');
%     open(v);
%     writeVideo(v,M)
%     close(v)

    close(writerObj);
    fprintf('time elapsed = %6.2f\n',cputime-time)
    
    
%     %% Functions
%     
%     function [B,C,Hrot] = align(theta,boundary,center,head)
%     % this function takes vectors describing the positions of the worm outline
%     % and worm centerline and aligns them to the x axis by rotating by an angle
%     % theta
%     
%     [y1,x1] = find(boundary == 1);
%     aB = vertcat(x1',y1'); 
%     B = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aB;
% 
% 
%     [y2,x2] = find(center == 1);
%     aC = vertcat(x2',y2');
%     C = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aC;
% 
%     y3 = head(1);
%     x3 = head(2);
%     aD = vertcat(x3',y3');
%     Hrot = [cos(theta),-sin(theta);sin(theta),cos(theta)]*aD;
%     
% 
%     % Center the rotated outline and centerline
%     C(1,:) = C(1,:) - min(C(1,:)) + (min(C(1,:))-min(B(1,:)));
%     C(2,:) = C(2,:) - min(C(2,:)) + (min(C(2,:))-min(B(2,:)));
%     
%     Hrot(1,:) = Hrot(1,:) - min(Hrot(1,:)) + (min(Hrot(1,:))-min(B(1,:)));
%     Hrot(2,:) = Hrot(2,:) - min(Hrot(2,:)) + (min(Hrot(2,:))-min(B(2,:)));
% 
%     B(1,:) = B(1,:) - min(B(1,:));
%     B(2,:) = B(2,:) - min(B(2,:));
%     
%         if abs(Hrot(1) - max(C(:,1))) > abs(Hrot(1) - min(C(:,1))) % head is far from zero
%             % rotate everthing 180 deg
%             theta = pi;
%             B = [cos(theta),-sin(theta);sin(theta),cos(theta)]*B;
%             C = [cos(theta),-sin(theta);sin(theta),cos(theta)]*C;
%             Hrot = [cos(theta),-sin(theta);sin(theta),cos(theta)]*Hrot;
%         end
%     end
%     
%     
%     function head = endpointvalues(ends,center,Ori,N)
%     % estimates where the head is
%     [y,x] = find(ends == 1);
%     c1 = bwtraceboundary(center,[y(1),x(1)],'W',8,N);
%     c2 = bwtraceboundary(center,[y(2),x(2)],'W',8,N);
%         for i = 1:N
%             int1(i) = Ori(c1(i,1),c1(i,2)); %get intensities along one direction
%             int2(i) = Ori(c2(i,1),c2(i,2)); % and the other
%         end
% 
%         if median(int1)> median(int2)
%             head = [y(1),x(1)];
%         else
%             head = [y(2),x(2)];
%         end
%     end
%     
%     function IM_out = process(IM,thresh,n,width)
%     % this function takes an image and outputs and inverted binary images which
%     % has been dilated and eroded. (for use in c_elegans processing)
% 
%     % TODO : add hole filling, smoothing and particle detection
% 
%     % IM = imgaussfilt(IM,2);               
%     IM(IM < thresh) = 0; % Threshold 
%     IM = imbinarize(IM); % Make binary 
%     IM = bwareafilt(IM,1); % keep only the largest particle 
%     se = strel('disk',width);
%     for i = 1:n
%         IM = imerode(IM,se); % Erode N times
%     end                    
%     for i = 1:n    
%         IM = imdilate(IM,se); % Dilate N times
%     end            
%     for i = 1:length(IM(:))% INVERT image
%         if IM(i) == 0
%             IM(i)=1;
%         else
%             IM(i) = 0;
%         end
%     end
%     IM = imfill(IM,'holes');  % fill holes    
%     IM_out = IM;
% end
