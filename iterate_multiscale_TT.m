function res = iterate_multiscale_TT(A, levels, levels_to_use, maxiter, rank_list, round_bool)
% Alternating optimization to compute a multiscale representation

%lowest res to highest res
res = cell(levels,1);
d = A.d;

for k = 1:levels
    res{k} = 0*tt_ones(2^(k-1), d);
end


for iter = 1:maxiter
    if mod(iter, 1) == 0
        disp(iter)
    end
   res = one_iteration_TT(A, res, rank_list, round_bool, levels, levels_to_use);
end
end