function top = intensity(bottom, param)
% {image,level}[x,y,channel]

% laod
img_data = bottom.data;


% init
img_num   = size(img_data,1);
img_level_num = size(img_data,2);
map_data  = cell(img_num, img_level_num);

% processing
for i_img = 1:img_num
    im_size = size(img_data{i_img,1});
    map_size = fix(im_size(1:2)./ max(im_size(1:2)) .* param.maxlen);    
    for i_level = 1:img_level_num      
        
        % read input data
        im = img_data{i_img, i_level};
        
        % process
        if size(im, 3) == 1
            im_gray = im;
        else
            im_gray = rgb2gray(im);
        end

        map_data{i_img,i_level} = imresize(im_gray, map_size, 'bicubic');
        
    end
end

% result
top.data = map_data;


end


