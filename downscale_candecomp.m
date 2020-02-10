function Adown = downscale_candecomp(A)
% Implementation of the operator ext_1 in the canonical format

u = A.u;
lambda = A.lambda;
d = length(u);


res = cell(d,1);

for kind = 1:d
    s = size(u{kind});
    n = s(1);
    r = s(2);
    tmp_u = u{kind};
    new_u = zeros(2*n,r);
    for i = 1:n
        new_u(2*i-1,:) = tmp_u(i,:);
        new_u(2*i,:) = tmp_u(i,:);
    end
    res{kind} = new_u;
end


Adown = ktensor(lambda, res);

end
