function tdown = downscale_TT(A)
% Implementation of the operator ext_1 in the TT-format

core = A.core;
n = A.n;
r = A.r;

d = length(n);

res_length = sum( r(1:d).*2.*n(1:d).*r(2:d+1));
res_core = zeros(res_length, 1);

res_n = 2*n;
res_r = r;

curr_pos = 1;
curr_pos_exp = 1;
for kind = 1:d

    tmp_core = reshape( core(curr_pos: (curr_pos + r(kind)*n(kind)*r(kind+1)-1)), ...
        [r(kind), n(kind), r(kind+1)]);
    tmp_res_core = zeros(r(kind), 2*n(kind), r(kind+1));
    for i = 1:n(kind)
        tmp_res_core(:,2*i-1,:) = tmp_core(:,i,:);
        tmp_res_core(:,2*i,:) = tmp_core(:,i,:);
    end
    res_core(curr_pos_exp:(curr_pos_exp + r(kind)*2*n(kind)*r(kind+1)-1)) = tmp_res_core(:);
    curr_pos_exp = curr_pos_exp+r(kind)*2*n(kind)*r(kind+1);
    curr_pos = curr_pos+r(kind)*n(kind)*r(kind+1);
end

res_pos = cumsum([1; r(1:d).*2.*n(1:d).*r(2:d+1)]);

tdown = tt_tensor;
tdown.d = d;
tdown.r = res_r;
tdown.n = res_n;
tdown.core=res_core;
tdown.ps = res_pos;


end
