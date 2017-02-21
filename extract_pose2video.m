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
    %clear, close all
    type = 'jpeg';
    filein =  'C:\Users\labmember\Desktop\data';    

    time = cputime;
    
    writerObj = VideoWriter('worm.avi');
    writerObj.FrameRate = 25;
    writerObj.Quality = 100; 
    open(writerObj);
   
    % get the names of all files of the specified type in the input folder 'filepath'
    filepath = sprintf('%s/*.%s',filein,type);
    names = dir(filepath);
    names = {names.name};
    map = cell(1,length(names));
    
    [~,~,~,d,~,~] =analysis.get_better_cmaps;
    

    cbrew_init=colorbrewer.div.RdBu{length(colorbrewer.div.RdBu)};
    CT=interpolate_cbrewer(cbrew_init, 'PCHIP', 100);
    CT=CT./255;
    
    
    %M(length(names)) = struct('cdata',[],'colormap',[]);
    for ii = 1:1000%length(names)
        %% Process the image and get releavant properties           
        fprintf('processing image #%i\n',ii)
        fnum = ii;
        Ori = im2double(imread(sprintf('%s/%s',filein,names{fnum}))); 
        IM = Ori;
        thresh = 0.15; %mean(IM(:)) - 2*sqrt(var(IM(:))); %calculate the threshold
        IM = analysis.process(IM,thresh,15,1); % process 
        IM = bwlabel(IM);
        % get rid of particles that are not the largest
        temp = [];
        if max(IM(:)) > 1
            for k = 1:max(IM(:))
                temp(k) = length(IM(IM == k));
            end
           IM(IM ~= find(temp == max(temp))) = 0;
        end   
        boundary = bwperim(IM); % get boundary
        center = bwmorph(IM,'thin',Inf); % get center line       
        %center = bwmorph(center,'spur',20);  
        center = analysis.removeSpurs(center);
        ends = bwmorph(center,'endpoints'); % get endpoints
        boundaries = bwboundaries(center);
        [xend,yend] = find( bwmorph(center,'endpoints') == 1 );
        b1 = find(boundaries{1}(:,1) == xend(1) & boundaries{1}(:,2) == yend(1));
        b2 = find(boundaries{1}(:,1) == xend(2) & boundaries{1}(:,2) == yend(2));
        pixelLine = boundaries{1}(min(b1,b2):max(b1,b2),:);
        y2 = pixelLine(:,1);
        x2 = pixelLine(:,2);
        map{ii}.center = [x2,y2];
        [y1,x1] = find(boundary == 1);
        map{ii}.boundary = [x1,y1];
              
        
        %if ii == 1 || size(find(IM == 1),1) > 45000
            map{ii}.head = analysis.endpointvalues(ends,center,(Ori.*IM),20); %
        %else
            %[y,x] = find(ends == 1);
           % X = [y,x];
            %map{ii}.head = X(knnsearch(X,map{ii-1}.head),:);
        %end
           

        % fit b spline
        [tX,tY,Bx,By] = analysis.B_spline(x2,y2,4);
        % get angles
        if tX(end)-map{ii}.head(2) < tX(1)-map{ii}.head(2)
            tX = flipud(tX);
            tY = flipud(tY);
        end
        [angles(:,ii), head_angles(:,ii)] = analysis.get_angles(tX,tY);

        
        %h = bwtraceboundary(center,[map{ii}.head(1),map{ii}.head(2)],'W',8,length(center));
        intensity = Ori.*IM;
        hInt = zeros(length(tX),1);
        for xx = 1:length(tX)
           hInt(xx) = intensity(round(tY(xx)),round(tX(xx)));
        end
%% plot          
            
                   
%             plot(map{ii}.boundary(2,:),map{ii}.boundary(1,:),'k.'), hold on % plot boundary 
%             %plot(map{ii}.center(2,:),map{ii}.center(1,:),'r.') % plot center          
%             plot(tY,tX,'r.')
%             plot(map{ii}.hrot(2,:),map{ii}.hrot(1,:),'b.','MarkerSize',10), axis equal % plot ends points
                         
            if ii>50
                h = figure; set(h, 'Visible', 'off'); hold on
                set(gca,'nextplot','replacechildren');
                set(h,'renderer','painters');
                subplot(3,2,1:2:3)
                    imagesc(Ori.*IM), axis equal, axis off, title(sprintf('image # %i',ii)),colormap(gca,d)
                subplot(3,2,2:2:4)
                    plot(map{ii}.boundary(:,1),map{ii}.boundary(:,2),'k.','MarkerSize',0.5), hold on % plot boundary
                    plot(map{ii}.center(:,1),map{ii}.center(:,2),'k','MarkerSize',0.5), axis equal % plot center
                    plot(tX,tY,'ro','MarkerSize',2)
                    plot(map{ii}.head(2),map{ii}.head(1),'b.','MarkerSize',8), axis equal, axis off % plot ends points
                    plot(tX(1),tY(1),'kx',tX(end),tY(end),'go')
                    title(sprintf('pixel volume = %i',size(find(IM == 1),1)))
                subplot(3,2,5:6)
                     imagesc(abs(angles(:,ii-50:ii))), colormap(gca,d), colorbar,caxis([0,pi]), axis off
%                 subplot(4,2,5:6)
%                     plot(1:length(angles),angles,'.k'), title('angles of the worm pose'),xlim([0,length(angles)]), ylim([-pi,pi]) % plot angles
%                 subplot(4,2,7)
%                     plot(1:length(hInt),hInt,'.k'), ylim([0,1]), xlim([0,length(hInt)]),title('head intensities')
%                     %imagesc(hInt'),ylim([-2,4]),axis off,title('head intensities')
%                 subplot(4,2,8)
%                     plot(flipud(head_angles),1:length(head_angles),'k.'), title('angles of the worm head'),ylim([0,length(head_angles)+5]), xlim([-pi,pi])
            drawnow;
            frame = getframe(h);
            writeVideo(writerObj,frame);
           end
    end % end of image file loop
%     v = VideoWriter('motion.avi');
%     open(v);
%     writeVideo(v,M)f
%     close(v)

    close(writerObj);
    fprintf('%6.2f seconds per frame\n',cputime-time/ii)
    
