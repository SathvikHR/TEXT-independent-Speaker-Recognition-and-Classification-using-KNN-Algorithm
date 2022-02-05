function dataDir = HelperAN4Download
%HelperAN4Download Download and extract the AN4 dataset. 
% The dataset is downloaded from:
%  http://www.speech.cs.cmu.edu/databases/an4
%
% The output of the  function is the path to the 'an4' parent directory in the dataset.



url = 'http://www.speech.cs.cmu.edu/databases/an4/an4_raw.littleendian.tar.gz';
d = tempdir;
fs = 16e3;

% Download and extract if it hasn't already been done.
unpackedData = fullfile(d, 'an4');
d1 = fullfile(unpackedData, 'wav','flacData');
if ~exist(unpackedData, 'dir')
    fprintf('Downloading AN4 dataset... ');
    untar(url, d);
    fprintf('done.\n');
    mkdir(d1);
end

validDirs = {'fejs', 'fmjd', 'fsrb', 'ftmj', 'fwxs', ...
             'mcen', 'mrcb', 'msjm', 'msjr', 'msmn','.', '..'};
d3 = fullfile(unpackedData, 'wav', 'an4_clstk');
listing = dir(d3);
l = {listing(:).name};

if length(l) > length(validDirs)
    fprintf('Reducing dataset to 5 females and 5 males... ');
    for idx = 3:length(l)
        if ~ismember(l{idx}, validDirs)
            rmdir(fullfile(d3,l{idx}),'s');
        else
           mkdir(fullfile(d1,l{idx}));
           list = dir(fullfile(d3,l{idx}));
           for i = 3:length(list)
               filename = list(i).name;
               fname = fullfile(d3,l{idx},filename);
               
               fullfilename = fullfile(d1,l{idx},filename);
               
               % % Read binary data (stored as int16)
               
               fid = fopen(fname,'r');
               xint = int16(fread(fid,[1,inf],'int16')).';
               fclose(fid);
               
               % Scale int16 to double
               x = double(xint)*2^-15;
               % % Convert to flac and write it
               newname = strrep(fullfilename,'.raw','.flac');
               audiowrite(newname,x,fs);
           end
        end
    end
    rmdir(fullfile(unpackedData, 'wav', 'an4test_clstk'),'s');
    fprintf('done.\n');
end

dataDir = d1;

end