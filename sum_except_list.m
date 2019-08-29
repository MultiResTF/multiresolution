function Atmp = sum_except_list(res, list);
%Sums matrices not in the list
Atmp = 0;

for l = 1:length(res)
    if ~ismember(l,list)
        Atmp = Atmp + res{l};
    end
end
end