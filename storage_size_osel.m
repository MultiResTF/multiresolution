function res = storage_size_osel(T)
% Computes the storage size of a tensor in the TT-representation
rs = T.r;
ns = T.n;

res = sum(rs(1:end-1).*rs(2:end).*ns);
end