% Aggregate one conv3d_feature into single vector by using our method
function final_vector = ReSW (conv3d_feature, med_CNN, mean_CNN, agg_type)
    if nargin < 4
        agg_type = 'select_weight';
    end
    
    [Bpoints, Fweights] = Select_Weight_Replicator(conv3d_feature, med_CNN, mean_CNN);
    [~,~,K] = size(conv3d_feature);
    CNN_org = reshape(conv3d_feature,[],K)';
    S = sum(CNN_org);
    z = sum(sum(S.^2)).^0.5;
    S = (S/z).^0.5;
    if strcmp(agg_type,'weight')
        Fweights = Fweights.*S;
        CNN = bsxfun(@times,CNN_org,Fweights);
    else
        Fweights = Fweights(~Bpoints).*S(~Bpoints);
        CNN = bsxfun(@times,CNN_org(:,~Bpoints), Fweights);
    end
    final_vector = sum(CNN,2);
end