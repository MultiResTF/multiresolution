function [res10, res20, res30, res50, res100, res150, res] = iterate_multiscale_TT_several(A, levels, levels_to_use, maxiter, rank_list, conv_tol, round_bool)
% Alternating optimization to compute a multiscale representation

%lowest res to highest res
res = cell(levels,1);
d = A.d;
smallest_n = min(size(A));

for k = 1:levels
    res{k} = 0*tt_ones(size(A)/smallest_n*2^(k-1), d);
end

for iter = 1:maxiter

      res = one_iteration_TT(A, res, rank_list, round_bool, levels, levels_to_use);

    if iter == 10
        res10 = res;
    elseif iter == 20
        res20 = res;
    elseif iter == 30
        res30 = res;
    elseif iter == 50
        res50 = res;
    elseif iter == 100
        res100 = res;
    elseif iter == 150
        res150 = res;
    end
end
end

