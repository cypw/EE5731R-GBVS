function config = config_GBVSParams()

%% Main Framework

%%% floor 1:
config.layer{1,1} = init_layer({'data_layer', 'images'});

%%% floor 2:
config.layer{2,1} = init_layer({'fea_layer', 'colors'});
config.layer{2,2} = init_layer({'fea_layer', 'intensity'});
config.layer{2,3} = init_layer({'fea_layer', 'orientation'});
config.layer{2,4} = init_layer({'fea_layer', 'orientation'});

%%% floor 3:
config.layer{3,1} = init_layer({'concat_layer', 'concat'});

%%% floor 4:
config.layer{4,1} = init_layer({'act_layer', 'gbvs_act'}); 

%%% floor 5:
config.layer{5,1} = init_layer({'norm_layer', 'gbvs_norm'}); 

%%% floor 6:
config.layer{6,1} = init_layer({'combine_layer', 'linearc'}); 


%% Detailed Setting

%%% floor 1:
% data_layer:
config.layer{1,1}.name   = 'data';
config.layer{1,1}.top    = 'data';
config.layer{1,1}.param.level  = [2, 3, 4];

%%% floor 2:
% fea_layer: #1 - color
config.layer{2,1}.name   = 'color';
config.layer{2,1}.bottom = 'data';
config.layer{2,1}.top    = 'color';
config.layer{2,1}.param.maxlen = 32;
config.layer{2,1}.param.typeidx = 1;
% fea_layer: #2 - intensity
config.layer{2,2}.name   = 'intens';
config.layer{2,2}.bottom = 'data';
config.layer{2,2}.top    = 'intens';
config.layer{2,2}.param.maxlen = 32;
% fea_layer: #3 - orentation
config.layer{2,3}.name   = 'orent1';
config.layer{2,3}.bottom = 'data';
config.layer{2,3}.top    = 'orent1';
config.layer{2,3}.param.maxlen = 32;
config.layer{2,3}.param.bw = 1;
config.layer{2,3}.param.lambda = 8;
config.layer{2,3}.param.angle  = [0, 45, 90, 135];
% fea_layer: #3 - orentation
config.layer{2,4}.name   = 'orent2';
config.layer{2,4}.bottom = 'data';
config.layer{2,4}.top    = 'orent2';
config.layer{2,4}.param.maxlen = 32;
config.layer{2,4}.param.bw = 1.2;
config.layer{2,4}.param.lambda = 8;
config.layer{2,4}.param.angle  = [0, 45, 90, 135];

%%% floor 3:
% concat_layer: #1
config.layer{3,1}.name   = 'concat';
config.layer{3,1}.bottom = {'color', 'intens', 'orent1', 'orent2'};
config.layer{3,1}.top    = 'features';
config.layer{3,1}.param.axis = 'channel';

%%% floor 4:
% act_layer: #1
config.layer{4,1}.name   = 'act';
config.layer{4,1}.bottom = 'features';
config.layer{4,1}.top    = 'act';
config.layer{4,1}.param.sigma = 2.5;

%%% floor 5:
% norm_layer: #1
config.layer{5,1}.name   = 'norm';
config.layer{5,1}.bottom = 'act';
config.layer{5,1}.top    = 'norm';
config.layer{5,1}.param.sigma = 2.5;

%%% floor 6:
% concat_layer: #1
config.layer{6,1}.name   = 'combine';
config.layer{6,1}.bottom = 'norm'; %{'color', 'intens', 'orent1', 'orent2'};
config.layer{6,1}.top    = 'result';
config.layer{6,1}.param.axis = {'bottom', 'level', 'channel'};
config.layer{6,1}.param.weight = {[],[],[]}; %{[0.2, 0.3, 0.4, 0.1], [], []};

end








