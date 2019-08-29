function Adown = downscale(A)
%Implements the operator ext_1 for a matrix

[n,~] = size(A);

if class(A) == 'sdpvar'
    Adown = zeros(2*n,2*n,'like',sdpvar);
else
    Adown = zeros(2*n, 2*n);
end

for i = 1:n
    for j = 1:n
        Adown(2*i-1,2*j-1) = A(i,j);
        Adown(2*i,2*j-1) = A(i,j);
        Adown(2*i-1,2*j) = A(i,j);
        Adown(2*i,2*j) = A(i,j);
    end
end