function res = approx_r(A, r)
%Returns truncated svd with r terms

[U,S,V] = svds(A,r);

res = zeros(size(A));
[l,~] = size(S);

for k = 1:l
    res = res + S(k,k)*U(:,k)*V(:,k)';
end
