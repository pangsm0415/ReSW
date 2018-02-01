function Rewards = compute_rewards_replicator(A, index)
    [x, ~] = replicator(A, index);
    X = zeros(size(A,1),1,'single');
    X(index) = x;    
    Rewards = A*X;
end