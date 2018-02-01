% create mean_CNN and med_CNN file

% dataset_train = 'paris6k';
% datatype = 'vgg16';

load([datapath,dataset_train,'_cnn.mat'])
images_vgg_cnn = cell2mat(cellfun(@(x) reshape(x,[],512)',images_vgg_cnn,'un',0));
mean_CNN = mean(images_vgg_cnn,2);
ss = sum(images_vgg_cnn);
med_CNN = median(sort(ss));
clear images_vgg_cnn ss
save([datapath,dataset_train,'_mean_CNN'],'mean_CNN','-v7.3')
save([datapath,dataset_train,'_med_CNN'],'med_CNN','-v7.3')
