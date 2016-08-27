function top = gbvs_act(bottom, param)
% {image,level}[x,y,channel]

% load
data = bottom.data;

% init
img_num   = size(data,1);
img_level_num = size(data,2);

act_data = cell(size(bottom));

% processing
for i_img = 1:img_num
    for i_level = 1:img_level_num     
        i_data = data{i_img, i_level};
        i_act = zeros(size(i_data));
        for i_channel = 1:size(data,2)
            i_act(:,:,i_channel) = gbvs_act_v(i_data(:,:,i_channel), param);
        end
        act_data{i_img, i_level} = i_act;
    end
end

% result
top.data = act_data;

end

%% processing
function map = gbvs_act_v(map, param)

tol = param.tol;
sigma = param.sigma;
dist_fun = param.dist;

%% d
map_v  = map(:);
dissim_int = pdist2(map_v, map_v, dist_fun);

%% F
[dim1, dim2] = meshgrid(1:size(map,2),1:size(map,1));
pos = [dim1(:),dim2(:)];
dissim_pos = exp(-pdist2(pos, pos, 'euclidean').^2 ./ (2*sigma^2));

%% w
w = dissim_int .* dissim_pos;
nw = w./repmat(sum(w,1),[size(w,1),1]);
v = principalEigenvectorRaw( nw , tol );
map = reshape(v, [size(map,1),size(map,2)]);

end

