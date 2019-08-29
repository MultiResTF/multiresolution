function [res, errors] = iterate_multiscale_start_check(A, levels, maxiter, rank_list, res, Us, levels_to_use)
%Runs the alternating decomposition algorithm with given starting matrix

errors = zeros(maxiter,levels);
for iter = 1:maxiter
    if mod(iter, 100) == 0
        disp(iter)
    end
    for k = 1:levels
        if ismember(k, levels_to_use)

            Atmp = subtract_except_k(A, res, k);

            Utmp = Us{k};

            for lind = 1:(levels-k)
                Atmp = upscale(Atmp);
            end

            B = approx_r(Atmp, rank_list(k));

            for lind = 1:(levels-k)
                B = downscale(B);
            end

            res{k} = B;

            errors(iter, k) = 2^(k-levels)*norm(B - Utmp, 'fro');
        end
    end
end
end
