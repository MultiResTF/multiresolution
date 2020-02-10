function Aup = upscale_candecomp(A)
% Implementation of the operator ave_1 in the canonical format

u = A.u;
lambda = A.lambda;
d = length(u);


res = cell(d,1);

for kind = 1:d
    s = size(u{kind});
    n = s(1);
    r = s(2);
    tmp_u = u{kind};
    new_u = zeros(n/2,r);
    for i = 1:(n/2)
        new_u(i,:) = (tmp_u(2*i-1,:) + tmp_u(2*i,:))/2;
    end
    res{kind} = new_u;
end

Aup = ktensor(lambda, res);

end
