% setup
addpath ./utils 
datapath = ['./data/',datatype,'/'];
if add100k
    path100k = [datapath,'100k/'];
end

if strcmp(dataset_test,'holidays')
    agg_type = 'weight';
else
    agg_type = 'select_weight';
end

% load mean and med file
create_mean_med;
if exist([datapath,dataset_train,'_med_CNN.mat'],'file')
load ([datapath,dataset_train,'_med_CNN.mat']) 
load ([datapath,dataset_train,'_mean_CNN.mat']) 
else
    create_mean_med;
end

dout = 512;    % final dimension after PCA