function Adown = downscale_tensor(A)
% Implementation of the operator ext_1 for a 3-dimensional tensor.

s = size(A);

if length(s) == 2
    s = [s(1) s(2) 1];
elseif length(s) == 1
    s = [s(1) 1 1];
end


Adown = zeros(2*s);

for i = 1:s(1)
    for j = 1:s(2)
        for k = 1:s(3)
            Adown(2*i-1,2*j-1,2*k) = A(i,j,k);
            Adown(2*i,2*j-1,2*k) = A(i,j,k);
            Adown(2*i-1,2*j,2*k) = A(i,j,k);
            Adown(2*i,2*j,2*k) = A(i,j,k);
            Adown(2*i-1,2*j-1,2*k-1) = A(i,j,k);
            Adown(2*i,2*j-1,2*k-1) = A(i,j,k);
            Adown(2*i-1,2*j,2*k-1) = A(i,j,k);
            Adown(2*i,2*j,2*k-1) = A(i,j,k);
        end
    end
end
