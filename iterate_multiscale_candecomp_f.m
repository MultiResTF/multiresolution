function res = iterate_multiscale_candecomp_f(A, levels, levels_to_use, maxiter, rank_list, conv_tol)
% Alternating optimization to compute a multiscale representation

%%%lowest res to highest res
res = cell(levels,1);
ns = size(A);
smallest_n = min(ns);
for k = 1:levels

    z1 = zeros(ns(1)/smallest_n*2^(k-1),1);
    z2 = zeros(ns(2)/smallest_n*2^(k-1),1);
    z3 = zeros(ns(3)/smallest_n*2^(k-1),1);
    res{k} = ktensor({z1,z2,z3});

end

conv_error = Inf;
for iter = 1:maxiter
    disp(iter)
    if conv_error <= conv_tol
        break
    else
      res_old = res;
      res = one_iteration_candecomp_f(A, res, rank_list, levels, levels_to_use,res_old,iter);
    end
end
end
