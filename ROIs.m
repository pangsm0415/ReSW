% This function create ROIs (foreground points)
% Input:    S:          sum value matrix of a 3d-local feature
%           med_CNN:    median value of s in training dataset
% Output:   F_central:  2*n mat, n central points of ROIs, each colume 
%                       denote the location of one ROI central point
%           FN:         X*n logical mat, X=W*H is the total number of points, 
%                       each colume is a logical vector which denote foreground
%                       points in one ROI.
function [F_central, FN] = ROIs(S, med_CNN)
radii = 2;
eta = 0.5;
[W,H] = size(S);
mf = 0;
F_central = zeros(2,100);   % foreground  seed  points, each colume correspond to 
FN = false(W*H,100);    % the neighbors of foreground seed points should be considered as foreground   
sS_F = sort(reshape(S,[],1),'descend');
% foreground
for i = 1:W*H
    if sS_F(i) < med_CNN
        break
    end
    ind = find(S==sS_F(i),1);  
    c = ceil(ind/W);
    r = mod(ind, W);
    if r == 0
        r = W;
    end
    % non_intersection detection
    if mf > 0
        dist = [r;c] - F_central(:,1:mf);
        dist1 = abs(dist(1,:));
        dist2 = abs(dist(2,:));
    else
        dist1 = 10*radii;
        dist2 = 10*radii;
    end
    id1 = dist1 < 2*radii+1; id2 = dist2 < 2*radii+1;
    if max(id1 & id2)
        continue
    end
    % test neighbor points 
    Temp = S(max(r-radii,1):min(r+radii,W),max(c-radii,1):min(c+radii,H)) > med_CNN;  
    if sum(sum(Temp)) > eta*size(Temp,1)*size(Temp,2)
        mf = mf + 1;
        F_central(:,mf) = [r;c];
        indicator = false(W,H); 
        indicator(max(r-radii,1):min(r+radii,W),max(c-radii,1):min(c+radii,H)) = Temp;
        FN(:,mf) = indicator(:);
    end 
end
F_central = F_central(:,1:mf);
FN = FN(:,1:mf);
end