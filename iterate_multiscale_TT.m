function res = iterate_multiscale_TT(A, levels, levels_to_use, maxiter, rank_list, conv_tol, round_bool)
% Alternating optimization to compute a multiscale representation

%lowest res to highest res
res = cell(levels,1);
d = A.d;

smallest_n = min(size(A));

for k = 1:levels
        res{k} = 0*tt_ones(size(A)/smallest_n*2^(k-1), d);
end


conv_error = Inf;
for iter = 1:maxiter
    if mod(iter, 1) == 0
        disp(iter)
    end
    if conv_error <= conv_tol
        break
    else
      res = one_iteration_TT(A, res, rank_list, round_bool, levels, levels_to_use);
    end
end
end

