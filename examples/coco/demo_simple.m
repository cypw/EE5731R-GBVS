%% install
cd ../..
install();
cd examples/coco

%% run demo
clc; clear; close all;
addpath('./config');

% [0]: set inputs
% input{1}.img = {imread([root_, './img/1.jpg']), imread([root_, './img/2.jpg'])};
input{1}.impath = GetFileList('./img', 'jpg');

% [1]: configure net framework
config = config_GBVSParams();

% [2]: initialize network
model = net.init(config);

% [3]: run 
map = net.forward(model, input);

%% show results
figure('color', 'w');
subplot(2,5,1); imshow(imread('./img/1.jpg'));
subplot(2,5,6); imshow(imresize(map{1},12),[]);

subplot(2,5,2); imshow(imread('./img/2.jpg'));
subplot(2,5,7); imshow(imresize(map{2},12),[]);

subplot(2,5,3); imshow(imread('./img/3.jpg'));
subplot(2,5,8); imshow(imresize(map{3},12),[]);

subplot(2,5,4); imshow(imread('./img/4.jpg'));
subplot(2,5,9); imshow(imresize(map{4},12),[]);

subplot(2,5,5); imshow(imread('./img/5.jpg'));
subplot(2,5,10); imshow(imresize(map{5},12),[]);





