function IM_out = process(IM,thresh,n,width)
% this function takes an image and outputs and inverted binary images which
% has been dilated and eroded. (for use in c_elegans processing)

% TODO : add hole filling, smoothing and particle detection
% IM = imfill(IM,'holes'); 
% IM = imgaussfilt(IM,2);               
    IM(IM < thresh) = 0; % Threshold 
    IM = imbinarize(IM); % Make binary                    
    se = strel('disk',width);
    for i = 1:n
        IM = imerode(IM,se); % Erode N times
    end                    
    for i = 1:n    
        IM = imdilate(IM,se); % Dilate N times
    end            
    for i = 1:length(IM(:))% INVERT image
        if IM(i) == 0
            IM(i)=1;
        else
            IM(i) = 0;
        end
    end
    IM_out = IM;
end