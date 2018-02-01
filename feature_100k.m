% feature_extract of 100k
cd ../matlab
vl_setupnn;
cd ../new

modelfn = 'imagenet-matconvnet-vgg-verydeep-16.mat';  lid = 31;		% use VGG
net = load(['../' modelfn]);
net.layers = {net.layers{1:lid}}; % remove fully connected layers

imagepath = 'D:/imagesearch/oxford_images_100K/';
addpath(imagepath);
D = dir(strcat(imagepath,'*'));
D = D(3:end);
num_folder = size(D,1);

for j = 29:35
    curpath = [imagepath D(j).name '/'];
    addpath(curpath);
    Dim = dir(strcat(curpath,'*.jpg'));
    num_images = size(Dim,1);
    images_vgg_cnn = cell(1,num_images);
    
    for imnum = 1:num_images
        tic
        im = imread(strcat(curpath,Dim(imnum).name)) ;
%       if size(im,3) == 1
%           im = repmat(im, [1 1 3]);
%       end
%         im = single(im) - mean(net.meta.normalization.averageImage(:));
    for i=1:3
        im_(:,:,i) = single(im(:,:,i)) - single(mean(net.meta.normalization.averageImage(i)));
    end
        rnet = vl_simplenn(net, im_);  
%         rnet = vl_simplenn(net, im);  
        images_vgg_cnn{imnum} = max(rnet(end).x, 0);
        clear im_
        toc
    end
    
    Path_save = strcat('./data/vgg16/100k/',D(j).name);
    save(Path_save,'images_vgg_cnn','-v7.3');
    rmpath(curpath);
    clear images_vgg_cnn
end