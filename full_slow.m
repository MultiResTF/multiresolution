function res = full_slow(A)
%%% converts a tensor from the tensor toolbox to full form.

lambda = A.lambda;
u = A.u;
u1 = u{1};
u2 = u{2};
u3 = u{3};
[n1,r] = size(u1);
[n2,~] = size(u2);
[n3,~] = size(u3);
res = zeros(n1,n2,n3);
for k = 1:r
    res = res + double(ktensor(lambda(k), u1(:,k), u2(:,k), u3(:,k)));
end

    
