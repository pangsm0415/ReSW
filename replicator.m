function [x, Cvalue] = replicator(A, Nbs)
    A_cur = A(Nbs,Nbs);
    x = ones(length(Nbs),1)/length(Nbs);
    y = A_cur*x;
    Pvalue = x'*y;
    if Pvalue == 0
        x = zeros(length(Nbs),1)/length(Nbs);
        Cvalue = 0;
    else
        while true
            x = x.*y/Pvalue;
            y = A_cur*x;
            Cvalue = x'*y;
            Ratio = (Cvalue - Pvalue)/Pvalue;
            if Ratio < 1e-5
                break
            end
            Pvalue = Cvalue;
        end
    end
end