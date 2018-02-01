% This matlab file is for presenting the whole process of our method ReSW
% all local features should be saved in 'data' folder before run this code
% data           All the local features used in this file are stored in 'data' folder
%                All local features are extracted using 'feature_*.m'
% parameters     the two parameters in our paper are in 'seed_point.m'
%                note that omega = 2 * radii+1 = 5 , eta = 0.5 in this program
clear
datatype = 'vgg16';             %'vgg16','siaMac','netvlad'
dataset_test = 'oxford5k';
dataset_train = 'paris6k';      % for PCA training, mean_CNN and med_CNN                       
add100k = 0;                    % add100k = 1 for adding ox100k images
qe = 1; qnd = 5;
setup;


%------------------------PCA training------------------------
fprintf('Learning PCA parameters...\n');
data_train = load([datapath,dataset_train,'_cnn.mat']);
% ReSW process for training dataset
vecs_train = cellfun(@(x) ReSW(x,med_CNN,mean_CNN,agg_type),data_train.images_vgg_cnn,'un',0);
vecs_train = preprocess(cell2mat(vecs_train),datatype);
[~, eigvec, eigval, Xm] = yael_pca (single(vecs_train), dout);
fprintf('end...\n');
clearvars vecs_train data_train

%---------------------Process test dataset------------------------
fprintf('Processing test dataset...\n');
load([datapath,dataset_test,'_cnn.mat']);
vecs = cellfun(@(x) ReSW(x,med_CNN,mean_CNN,agg_type),images_vgg_cnn,'un',0);
X = preprocess(cell2mat(vecs),datatype);
clear vecs
X = apply_whiten (X, Xm, eigvec, eigval, dout);
X = yael_vecs_normalize(X,2,0);
fprintf('end...\n');

%-------------------------100k---------------------------
%%
if add100k
fprintf('Adding ox100k images...\n');
addpath(path100k);
D = dir(strcat(path100k,'*'));
D = D(3:end);
num_D = size(D,1);
for i=1:num_D
    tic
    load(strcat(path100k,D(i).name));
    cur_X = cellfun(@(x) ReSW(x,med_CNN,mean_CNN,agg_type),images_vgg_cnn,'un',0);
    cur_X = preprocess(cell2mat(cur_X),datatype);
    clear images_vgg_cnn
    cur_X = apply_whiten (cur_X, Xm, eigvec, eigval, dout);
    cur_X = yael_vecs_normalize(cur_X,2,0);
    X = [X cur_X];
    clear cur_X
    fprintf('The %ith component has been added.\n',i);
    toc    
end
fprintf('100k end...\n');
end

%----------------------query process---------------------
fprintf('Processing query images...\n');
switch dataset_test
    case {'oxford5k','paris6k'}
    load([datapath,'query_',dataset_test,'.mat']);
    qvecs = cellfun(@(x) ReSW(x,med_CNN,mean_CNN,agg_type),qim,'un',0);
    Q = preprocess(cell2mat(qvecs),datatype);
    clear qim qvecs
    Q = apply_whiten (Q, Xm, eigvec, eigval, dout);
    Q = yael_vecs_normalize(Q,2,0);
    load (['./data/gnd_',dataset_test])
    
    case 'holidays'
    load (['./data/gnd_',dataset_test])
    Q = X(:,qidx);
end
fprintf('end...\n');

%-------------------image search--------------------
[ranks,sim] = yael_nn(X, Q, size(X,2), 'L2');
[map,aps] = compute_map (ranks, gnd);
fprintf('%s   map, without qe = %.4f\n',dataset_test,map);
if qe
   q_qe = Q;
   for i=1:size(Q,2)
       q_qe(:,i) = mean([Q(:,i) X(:,ranks(1:qnd,i))],2);  
   end
   q_qe = yael_vecs_normalize(q_qe,2,0);
   [ranks_qe,~] = yael_nn(X, q_qe, size(X,2), 'L2');
   [map_qe,~] = compute_map (ranks_qe, gnd);
   fprintf('map, after qe =%.4f\n',map_qe);
end
