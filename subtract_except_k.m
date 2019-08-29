function Atmp = subtract_except_k(A, res, k)
%Subtracts matrices except for the k:th one
Atmp = A;

for l = 1:length(res)
    if l ~= k
        Atmp = Atmp - res{l};
    end
end
end