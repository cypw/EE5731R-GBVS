function top = images(bottom, param)
% {image,level}[x,y,channel]

% laod
img_info = bottom.data;

% init
if isfield(img_info, 'impath')
    img_num   = length(img_info.impath);
end
if isfield(img_info, 'img')
    img_num   = length(img_info.img);
end
img_level = param.level;
img_level_num = length(img_level);
img_data  = cell(img_num, img_level_num);

% processing
for i_img = 1:img_num
    for i_level = 1:img_level_num
        % - for image list
        if isfield(img_info, 'impath')
            im = im2double(imread(img_info.impath{i_img}));
        end
        % - for raw image
        if isfield(img_info, 'img')
            im = im2double(img_info.img{i_img});
        end
        % pyramid
        % im = imresize(im, 1./img_level(i_level), 'bicubic');
        im = downblur(im, img_level(i_level)-1);
        img_data{i_img, i_level} = im;
    end
end

% result
top.data = img_data;

end

function map = downblur(map, times)

% todo
h = fspecial('gaussian', [5 5], 1.5);
for i_times = 1:times
    map = imfilter(map, h);
end

end


