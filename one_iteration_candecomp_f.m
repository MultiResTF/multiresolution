function res = one_iteration_candecomp_f(A, res, rank_list, levels, levels_to_use,res_old,niter)
% Computes the optimal representation on one scale in the multiscale representation

d = ndims(A);
res_tmp = cell(d,1);
Atmpdown = A;

for l = length(res):-1:2
    if ismember(l, levels_to_use)
            Atmpdown = double(Atmpdown - full_slow(res{l}));
    end
    Atmpdown = tensor(upscale_tensor(double(Atmpdown)), size(A)*2^(l-length(res)-1));
    res_tmp{l} = Atmpdown;
end


ns = size(A);
smallest_n = min(ns);

z1 = zeros(ns(1)/smallest_n,rank_list(1));
z2 = zeros(ns(2)/smallest_n,rank_list(1));
z3 = zeros(ns(3)/smallest_n,rank_list(1));
Atmpup = ktensor({z1,z2,z3});
for k = 1:levels-1
    if ismember(k, levels_to_use)
        s1 = size(res_tmp{k+1});
        if ( numel(res_tmp{k+1}) == 1) && (numel(Atmpup) == 1)
            Atmp = ktensor(double(res_tmp{k+1}), {1,1,1});
        elseif  s1(1) == 1 && s1(2) == 1
            Atmp = ktensor( {1,1,squeeze(double(res_tmp{k+1}))});
        else
            if niter > 1
                    Atmp = cp_als_mixed(tensor(res_tmp{k+1}),Atmpup, rank_list(k), 'printitn', 0,'maxiters',50,'init',res_old{k}.u);
            else
                    Atmp = cp_als_mixed(tensor(res_tmp{k+1}),Atmpup, rank_list(k), 'printitn', 0,'maxiters',50);
            end
        end
        Atmpup = downscale_candecomp(Atmpup + Atmp);
        res{k} = Atmp;
    else
        Atmpup = downscale_candecomp(Atmpup);
    end
end

if niter > 1
    res{levels} = cp_als_mixed(tensor(A), Atmpup, rank_list(levels), 'printitn', 0,'maxiters',50,'init',res_old{levels}.u);
else
    res{levels} = cp_als_mixed(tensor(A), Atmpup, rank_list(levels), 'printitn', 0,'maxiters',50);
end

end
