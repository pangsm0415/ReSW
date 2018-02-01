% feature_extract
cd ../matlab
vl_setupnn;
cd ../new

data_folder = 'D:/imagesearch/'; % oxford5k,paris6k, holidays should be in here

dataset			= 'holidays';    

% config files for dataset
load(['./data/gnd_', dataset, '.mat']);    

% image files are expected under each dataset's folder
im_folder = [data_folder, dataset, '/'];

% choose pre-trained CNN model
% modelfn = 'imagenet-caffe-alex.mat';   lid = 15;				% use AlexNet
modelfn = 'imagenet-matconvnet-vgg-verydeep-16.mat';  lid = 31;		% use VGG
net = load(['../' modelfn]);
% net.layers = {net.layers{1:lid}}; % remove fully connected layers

num_images = size(imlist,1);
images_vgg_cnn = cell(1,num_images);
for imnum = 1:num_images
    tic
    im = imread(strcat(im_folder,imlist{imnum},'.jpg')) ;
    for i=1:3
        im_(:,:,i) = single(im(:,:,i)) - single(mean(net.meta.normalization.averageImage(i)));
    end
	rnet = vl_simplenn(net, im_);  
    images_vgg_cnn{imnum} = max(rnet(31).x, 0);
    clear im_
    toc
end

Path_save = strcat('./data/vgg16/',dataset,'_cnn');
save(Path_save,'images_vgg_cnn','-v7.3')
