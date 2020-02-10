function res = one_iteration_TT(A, res, rank_list, round_bool, levels, levels_to_use)
% Computes the optimal representation on one scale in the multiscale representation

d = ndims(A);
res_tmp = cell(d,1);
Atmpdown = A;

for l = length(res):-1:2
    if ismember(l, levels_to_use)
        if round_bool == 1
            tic;
             Atmpdown = round(Atmpdown - res{l}, 1e-16);
             toc
        else
            Atmpdown = Atmpdown - res{l};
        end
    end
    Atmpdown = upscale_TT(Atmpdown);
    res_tmp{l} = Atmpdown;
end


smallest_n = min(size(A));
Atmpup = 0*tt_ones(size(A)/smallest_n, d);
for k = 1:levels-1
    if ismember(k, levels_to_use)

        Atmp = round(res_tmp{k+1} - Atmpup,1e-16,rank_list(k));
        Atmpup = downscale_TT(Atmpup + Atmp);
        res{k} = Atmp;
    else
        Atmpup = downscale_TT(Atmpup);
    end
end

res{levels} = round(A - Atmpup,1e-16,rank_list(levels));

end
