%% install
cd ../..
install();
cd examples/coco

%% run demo
clc; clear; close all;
addpath('./config');

% [0]: set inputs
source_root = '../../dataset/coco/test';
result_root = './result'; 
makedir(result_root);


[imPathList, imNameList] = GetFileList(source_root, 'jpg');
for i_img = 1:length(imPathList)
    % [1]: configure net framework
    config = config_GBVSParams();
    
    % [2]: initialize network
    model = net.init(config);
    
    % [3]: run
    im = imread(imPathList{i_img});
    input{1}.img = {im};
    map = net.forward(model, input);
    
    % normalize
    map = (map{1} - min(map{1}(:))) ./ (max(map{1}(:)) - min(map{1}(:)));
    map = imresize(map, [size(im,1), size(im,2)]);
    
    % save result
    imwrite(map, fullfile(result_root, [imNameList{i_img}, '.png']));
end




