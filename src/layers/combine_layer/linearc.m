function top = linearc(bottom, param)
% {blob}{image,level}[x,y,channel]

% load
% data = structfun(@(x)(getfield(x, 'data')), bottom);
data = struct2cell(bottom);
weights = param.weight;

% init
bottom_num = length(data);
img_num  = size(data{1},1);
level_num = size(data{1},2);

% processing
% [1] combine channels
if any(ismember(param.axis, 'channel'))
    data = cellfun(@(cc)(cellfun(@(m)(sum(m,3)),cc,'Uni',0)),data,'Uni',0);
end

% [2] combine levels
if any(ismember(param.axis, 'level'))
    weight = weights{ismember(param.axis, 'level')};
    if isempty(weight)
        weight = ones(1,level_num)./level_num;
    end
    for i_bottom = 1:bottom_num   
        i_data = cellfun(@times,data{i_bottom},repmat(num2cell(weight),[img_num,1]),'Uni',0);
        i_cdata = cell(img_num,1);
        for i_img = 1:img_num
            i_cdata{i_img,1} = sum(cat(4,i_data{i_img,:}),4);
        end
        data{i_bottom} = i_cdata;
    end
end

% [3] combine bottom
if any(ismember(param.axis, 'bottom'))
    weight = weights{ismember(param.axis, 'bottom')};
    if isempty(weight)
        weight = ones(1,bottom_num)./bottom_num;
    end
    
    celltimes = @(c,w)(cellfun(@times,c,repmat({w},size(c)),'Uni',0));
    cmb_data = celltimes(data{1}, weight(1));
    for i_bottom = 2:bottom_num        
        cmb_data = cellfun(@plus,cmb_data,celltimes(data{i_bottom}, weight(i_bottom)),'Uni',0);
    end   
end

% result
top.data = cmb_data;


end