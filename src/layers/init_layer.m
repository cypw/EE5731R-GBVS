function layer = init_layer(info)
%

%
layer_category = info{1};
layer_type = info{2};

%
root = fileparts(mfilename('fullpath'));

% check if function exist
if ~exist(fullfile(root, info{1}, [info{2},'.m']), 'file')
    error('');
end

layer.func = str2func(info{2});

% set default value
switch layer_category
    
    case 'fea_layer' 
        if strcmp(layer_type,'orientation')
            layer.param.gamma = 0.5;
            layer.param.psi = [0, pi/2];
        end
        
    case 'act_layer'
        if strcmp(layer_type,'gbvs_act')
            layer.param.tol = 10.^-4;
            layer.param.dist = @(x,y)(abs(x-y));
        end
        
    case 'norm_layer'
        if strcmp(layer_type,'gbvs_norm')
            layer.param.tol = 10.^-4;
        end
        
end

end





