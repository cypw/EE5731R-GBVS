function install()

% get current path
root = fileparts(mfilename('fullpath'));

% add net layers
addpath(genpath(fullfile(root,'src/layers')));

% add net util
addpath(genpath(fullfile(root,'src/util')));

% add toolbox
addpath(fullfile(root,'src/tools/file_toolbox'));
addpath(fullfile(root,'src/tools/visualization_toolbox'));

% add main path
addpath(root);


end