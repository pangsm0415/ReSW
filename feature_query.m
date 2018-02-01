% process query images
clear
cd ../matlab
vl_setupnn;
cd ../new
addpath ../utils

data_folder = 'D:/imagesearch/'; 
dataset_test 				= 'paris6k';     

% config files for Oxford and Paris datasets
gnd_test = load(['./data/gnd_', dataset_test, '.mat']);    

% image files are expected under each dataset's folder
im_folder_test = [data_folder, dataset_test, '/'];

% choose pre-trained CNN model
% modelfn = 'imagenet-caffe-alex.mat';   lid = 15;				% use AlexNet
modelfn = 'imagenet-matconvnet-vgg-verydeep-16.mat';  lid = 31;		% use VGG
net = load(['../' modelfn]);
net.layers = {net.layers{1:lid}}; % remove fully connected layers


fprintf('Process query images\n');
qimlist = {gnd_test.imlist{gnd_test.qidx}};
qim = arrayfun(@(x) crop_qim([im_folder_test, qimlist{x}, '.jpg'], gnd_test.gnd(x).bbx), 1:numel(gnd_test.qidx), 'un', 0);
for imnum = 1:length(qim)
    tic
    im = qim{imnum} ;
    for i=1:3
        im_(:,:,i) = single(im(:,:,i)) - single(mean(net.meta.normalization.averageImage(i)));
    end
	rnet = vl_simplenn(net, im_);  
    qim{imnum} = max(rnet(end).x, 0);
    clear im_
    toc
end
psave = ['./data/vgg16/query_' dataset_test];
save(psave,'qim')