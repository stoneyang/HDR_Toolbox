%
%     HDR Toolbox Installer
%
%     Copyright (C) 2011-2013  Francesco Banterle
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%

disp('Installing the HDR Toolbox...');

folder = cellstr('Alignment');
folder = [folder, cellstr('BatchFunctions')];
folder = [folder, cellstr('ColorCorrection')];
folder = [folder, cellstr('ColorSpace')];
folder = [folder, cellstr('Compression')];
folder = [folder, cellstr('Compression_video')];
folder = [folder, cellstr('Compression_video/util')];
folder = [folder, cellstr('Deghosting')];
folder = [folder, cellstr('Deghosting/util')];
folder = [folder, cellstr('EnvironmentMaps')];
folder = [folder, cellstr('EO')];
folder = [folder, cellstr('EO/util')];
folder = [folder, cellstr('Formats')];
folder = [folder, cellstr('Generation')];
folder = [folder, cellstr('IBL')];
folder = [folder, cellstr('IBL/util')];
folder = [folder, cellstr('IO')];
folder = [folder, cellstr('IO_video')];
folder = [folder, cellstr('LaplacianPyramids')];
folder = [folder, cellstr('Metrics')];
folder = [folder, cellstr('Metrics/util')];
folder = [folder, cellstr('NativeVisualization')];
folder = [folder, cellstr('Tmo')];
folder = [folder, cellstr('Tmo/util')];
folder = [folder, cellstr('Tmo_video')];
folder = [folder, cellstr('Tools')];
folder = [folder, cellstr('util')];

for i=1:length(folder)
    addpath([pwd(), '/source_code/', char(folder(i))], '-begin');
end

addpath([pwd(), '/demos/'], '-begin');

savepath

clear('folder');

disp('done!');

disp(' ');
disp('Check demos in the folder ''demos'' for learning how to use the HDR Toolbox!');
disp(' ');
disp('If you use the toolbox in your research, please reference the book in your papers:');
disp('@book{Banterle:2011,');
disp('      author = {Banterle, Francesco and Artusi, Alessandro and Debattista, Kurt and Chalmers, Alan},');
disp('      title = {Advanced High Dynamic Range Imaging: Theory and Practice},');
disp('      year = {2011},');
disp('      isbn = {9781568817194},');
disp('      publisher = {AK Peters (CRC Press)},');
disp('      address = {Natick, MA, USA},');
disp('      }');