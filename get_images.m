function Ori = get_images(nfiles,dnsample)
    type = 'jpeg';
    filein =  'C:\Users\labmember\Desktop\data';    
    time = cputime;

    % get the names of all files of the specified type in the input folder 'filepath'
    filepath = sprintf('%s/*.%s',filein,type);
    names = dir(filepath);
    names = {names.name};
    names = names(1:dnsample:end);
    
    if nfiles > 100000
        nfiles = length(names);
    end

    Ori = cell(nfiles,1);
    
    for ii = 1:nfiles 
        Ori{ii} = im2double(imread(sprintf('%s/%s',filein,names{ii})));
        if mod(ii,100) == 0
            fprintf('processing frame %i\n',ii)
        end
    end
    
    fprintf('%6.2f milliseconds per frame\n',cputime-time/(ii))
end