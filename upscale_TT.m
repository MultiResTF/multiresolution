function tup = upscale_TT(A)
% Implementation of the operator ave_1 in the TT-format

core = A.core;
n = A.n;
r = A.r;

d = length(n);

res_length = sum( r(1:d).*n(1:d)/2.*r(2:d+1));
res_core = zeros(res_length, 1);

res_n = n/2;
res_r = r;

curr_pos = 1;
curr_pos_exp = 1;
for kind = 1:d

    tmp_core = reshape( core(curr_pos: (curr_pos + r(kind)*n(kind)*r(kind+1)-1)), ...
        [r(kind), n(kind), r(kind+1)]);
    tmp_res_core = zeros(r(kind), n(kind)/2, r(kind+1));
    for i = 1:n(kind)/2
        tmp_res_core(:,i,:) = (tmp_core(:,2*i-1,:) + tmp_core(:,2*i,:))/2;
    end
    res_core(curr_pos_exp:(curr_pos_exp + r(kind)*n(kind)/2*r(kind+1)-1)) = tmp_res_core(:);
    curr_pos_exp = curr_pos_exp+r(kind)*n(kind)/2*r(kind+1);
    curr_pos = curr_pos+r(kind)*n(kind)*r(kind+1);
end

res_pos = cumsum([1; r(1:d).*n(1:d)/2.*r(2:d+1)]);

tup = tt_tensor;
tup.d = d;
tup.r = res_r;
tup.n = res_n;
tup.core=res_core;
tup.ps = res_pos;


end
