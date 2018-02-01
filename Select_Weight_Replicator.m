% main function of our method
% Input:    CNN:         3d local feature of an image
%           med_CNN:     median value of s in training dataset
%           mean_CNN:    512*1 vector, mean vector in training dataset
% Output:   Bpoints:     logical vector, background points are marked as 'true'
%           Fweights£º   weights vector for corresponding feature 
function [Bpoints, Fweights] = Select_Weight_Replicator(CNN, med_CNN, mean_CNN)
[W,H,K] = size(CNN);
S = sum(CNN,3);

% Affinity matrix
CNN = reshape(CNN,[],K)'; 
S0 = reshape(S,[],1);
CNN = yael_vecs_normalize(CNN-mean_CNN, 2, 0);
A = CNN'*CNN;
A (1:size(A,1)+1:size(A,1)^2) = 0;
ind = find(S0==0);
A( ind,ind) = 0;
A(A<0) = 0;

% ROI points(FN)
[~, FN] = ROIs(S, med_CNN);

% initiate background points
Bpoints = false(W*H,1);
B_index = find(S0 < med_CNN);
Bpoints(B_index) = true;   
Fweights = ones(1,W*H,'single');  

if size(FN,2)>0
    FN_ALL = max(FN,[],2);
    FN_ALL_index = find(FN_ALL);
    
    % undefined points
    UN = (1:W*H)';
    UN([FN_ALL_index;B_index]) = [];
    
    % compute background rewards use background points
    Brewards = compute_rewards_replicator(A,B_index);
    
    % compute foreground rewards for each ROI set
    Frewards1 = zeros(size(FN,1),size(FN,2));
    for j = 1:size(FN,2)
        cur_index = find(FN(:,j));
        Frewards1(:,j) = compute_rewards_replicator(A,cur_index);
    end
    Frewards2 = compute_rewards_replicator(A,FN_ALL_index); % compute foreground rewards use all ROI points
    Frewards = [Frewards1 Frewards2];
    Frewards = max(Frewards,[],2);
    
    B_index = Brewards(UN) > Frewards(UN); % select background points from undefined points
    Bpoints(UN) = B_index;
    Fweights = exp(-Frewards2)';

end
end