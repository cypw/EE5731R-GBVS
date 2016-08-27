function top = concat(bottom, param)
% {image,level}[x,y,channel]

% load
% data = structfun(@(x)(getfield(x, 'data')), bottom);
data = struct2cell(bottom);

% init

img_num   = size(data{1},1);
img_level_num = size(data{1},2);
input_num = length(bottom);

if strcmp(param.axis, 'channel')
    concat_data  = cell(img_num, img_level_num);
end

% processing
for i_img = 1:img_num
    if strcmp(param.axis, 'channel')
        for i_level = 1:img_level_num
            i_data = data{1}{i_img, i_level};
            for i_input = 2:input_num
                i_data = cat(3, i_data, data{i_input}{i_img, i_level});
            end
            concat_data{i_img,i_level} = i_data;        
        end
    end    
end

% result
top.data = concat_data;

end