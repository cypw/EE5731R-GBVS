function varargout = forward(model, input)
%

% temp data
blob        = cell(model.net_size);
% net info
net_struct  = model.net_struct;
% layer info
layer_param = model.layer_param;
bottom_idx  = model.layer_bottom_idx;
layer_forward  = model.layer_func;

%% data layer
for i_layer = 1:net_struct(1)
    i_input.data = input{i_layer};
    i_param = layer_param{1, i_layer};    
    blob{1, i_layer}.top = layer_forward{1, i_layer}(i_input, i_param);
end

%% run the rest layers
get_top = @(blob)(cellfun(@(x)(getfield(x, 'top')), blob));
for i_floor = 2:length(net_struct)
    for i_layer = 1:net_struct(i_floor)
        
        % current layer input data
        i_bb_idx = bottom_idx{i_floor, i_layer};  
        i_input = get_top(blob(sub2ind(size(blob), i_bb_idx(:,1), i_bb_idx(:,2)))); 
        i_param = layer_param{i_floor, i_layer};
        
        % run forward on current layer
        blob{i_floor, i_layer}.top = ...
            layer_forward{i_floor, i_layer}(i_input, i_param);     
        
    end
end
model.blob = blob;

%% outputs
varargout = struct2cell(get_top(blob(end,~cellfun(@isempty,blob(end,:)))));
varargout{end+1} = model;

end