function model = init(config)
%

%% set paramters
layer_info  = config.layer; 
net_size    = size(layer_info);
net_struct  = zeros(net_size(1),1);
layer_name  = cell(net_size);
layer_func  = cell(net_size);
layer_param = cell(net_size);
layer_top   = cell(net_size);
layer_bottom = cell(net_size);
layer_bottom_idx = cell(net_size);

%% init whole network structure
% - get connection table
for i_floor = 1:net_size(1)
    for i_layer = 1:net_size(2)
        % check if used
        i_layer_info = layer_info{i_floor,i_layer};
        if isempty(layer_info{i_floor,i_layer})
            break;
        end
        % if pos is used then assign value
        net_struct(i_floor) = net_struct(i_floor) + 1;
        layer_name{i_floor, i_layer}  = i_layer_info.name;
        layer_func{i_floor, i_layer}  = i_layer_info.func;
        layer_top{i_floor, i_layer}   = i_layer_info.top;
        if isfield(i_layer_info, 'bottom')
            layer_bottom{i_floor, i_layer}= i_layer_info.bottom;
        end
        if isfield(i_layer_info, 'param')
            layer_param{i_floor, i_layer} = i_layer_info.param;
        end
    end
end
layer_top(cellfun(@isempty, layer_top)) = {''};

% - construct network
for i_floor = 2:length(net_struct)
    for i_layer = 1:net_struct(i_floor)
        % connect layer's input (bottom)
        i_bottom = layer_bottom{i_floor, i_layer};
        if iscell(i_bottom)
            i_bottom_idx = zeros(length(i_bottom),2);
            for ii_b = 1:length(i_bottom)
                [idx1, idx2] = find(ismember(layer_top, i_bottom{ii_b}));
                i_bottom_idx(ii_b, :) = [idx1, idx2];
            end
        else
            [idx1, idx2] = find(ismember(layer_top, i_bottom));
            i_bottom_idx = [idx1, idx2];
        end
        layer_bottom_idx{i_floor, i_layer} = i_bottom_idx;        
    end
end

% model
model.net_size   = net_size;
model.net_struct = net_struct;
model.layer_info = layer_info;
model.layer_name = layer_name;
model.layer_func = layer_func;
model.layer_top  = layer_top;
model.layer_param = layer_param;
model.layer_bottom = layer_bottom;
model.layer_bottom_idx = layer_bottom_idx;

end









