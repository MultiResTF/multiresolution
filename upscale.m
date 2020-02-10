function Aup = upscale(A)
% Implementation of the operator ave_1 for a matrix.

[n,~] = size(A);
Aup = zeros(n/2, n/2);

for i = 1:n/2
    for j = 1:n/2
        Aup(i,j) = (A(2*i-1,2*j) + A(2*i,2*j) + A(2*i-1,2*j-1) + A(2*i,2*j-1))/4;
    end
end