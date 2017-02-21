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
function [angles, head_angles, bound, cent, hd] = get_pose_features2(Input)

%     type = 'jpeg';
%     filein =  'C:\Users\labmember\Desktop\data';    
    time = cputime;

    % get the names of all files of the specified type in the input folder 'filepath'
%     filepath = sprintf('%s/*.%s',filein,type);
%     names = dir(filepath);
%     names = {names.name};
    nfiles = length(Input);
    
    map = cell(1,nfiles);%length(names));
    cent  = cell(1,nfiles);
    bound = cell(1,nfiles);
    hd = cell(1,nfiles);
    

%% Start analysis loop    
    for ii = 1:nfiles       
        %% Set up image         
        fprintf('processing image #%i\n',ii)
        fnum = ii;
        Ori = Input{fnum}; 
        %% Process the image and get releavant properties    
        IM = Ori;
        thresh = 0.15; % hard coded threshold?
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
        %% save boundary, head, angles and spine smoothed center
        %boundary(:,ii) = [x1,y1]; 
        bound{ii} = zeros(length(x1),2);
        bound{ii}(:,1) = x1;
        bound{ii}(:,2) = y1;
        headout = analysis.endpointvalues(ends,center,(Ori.*IM),20);
        hd{ii} = zeros(1,2);
        hd{ii}(1) = headout(1);
        hd{ii}(2) = headout(2);
        % fit b spline
        [tX,tY,~,~] = analysis.B_spline(x2,y2,4); %B are the coefficients
        cent{ii} = zeros(length(tX),2);
        cent{ii}(:,1) = tX;
        cent{ii}(:,2) = tY;
        % get angles
        if tX(end)-hd{ii}(2) < tX(1)-hd{ii}(2)
            tX = flipud(tX);
            tY = flipud(tY);
        end
        [angles(:,ii), head_angles(:,ii)] = analysis.get_angles(tX,tY);

        
        %h = bwtraceboundary(center,[map{ii}.head(1),map{ii}.head(2)],'W',8,length(center));
        intensity = Ori.*IM;
        map{ii}.hInt = zeros(length(tX),1);
        for xx = 1:length(tX)
           hy = max(1,round(tY(xx)));
           if hy >= size(Ori,1)
               hy = hy - 1;
           end
           hx = max(1,round(tX(xx)));
           if hx >= size(Ori,1)
               hx = hx - 1;
           end
           map{ii}.hInt(xx) = intensity(hy,hx);
        end


    end % end of image file loop
    


    fprintf('%6.2f seconds per frame\n',(cputime-time)/(ii*1000))
    