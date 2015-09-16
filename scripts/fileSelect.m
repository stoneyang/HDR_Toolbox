function [filename, fNames] = fileSelect(fileDir, fileIdx)
%FILESELECT selects a filename among files under a specified directory
%
% Input parameters:
%  dir:     directory where the file resides
%  fileIdx: file index
%
% Output parameters:
%  filename: name of the file selected
%  fNames:   names stack under the specified directory

% Fan Yang 06/25/2015

fileList = dir(fileDir);
nFiles = length(fileList);
for ii = 1:nFiles
    fNames{ii} = fileList(ii).name; 
end

filename = fNames{fileIdx};
[~,filename,~] = fileparts(filename);

end