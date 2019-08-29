function [res, errors] = iterate_multiscale_start_check_pair(A, levels, maxiter, rank_list, res, Us, levels_to_use)
%Runs the alternating decomposition algorithm for local convergence


errors = zeros(maxiter,levels);
Atmp = A;
for k = 1:levels-1
    if ismember(k, levels_to_use)

        start = cell(levels,1);
        for l = 1:k-1
            start{l} = 0;
        end
        start{k} = res{k};
        for l = k+1:levels-1
            start{l} = 0;
        end
        
        Atmp = subtract_except_list(A, res, k:levels);
        res_sum = sum_except_list(res, 1:k);
        start{levels} = res_sum;

        tmp_mat = 0;
        for l = (k+1):levels
           if ismember(l, levels_to_use)
                tmp_mat = tmp_mat + Us{l};
           end
        end
        last_rank = rank(tmp_mat);
        [resk, errorsk] = iterate_multiscale_start_check(Atmp, levels,...
            maxiter, [zeros(k-1, 1); rank_list(k);...
            zeros(levels-k-1,1) ; last_rank],...
            start, Us, [k, levels]);
        
        res{k} = resk{k};

        errors(:, k) = errorsk(:,k);
        errors(:, levels) = errorsk(:,levels);
    end
end
    res{levels} = resk{levels};

end
