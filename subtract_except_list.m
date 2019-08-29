function Atmp = subtract_except_list(A, res, list)
%Subtracts matrices not in the list
Atmp = A;

for l = 1:length(res)
    if ~ismember(l,list)
        Atmp = Atmp - res{l};
    end
end
end