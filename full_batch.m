function t = full_batch(t)
%FULL Convert a ktensor to a (dense) tensor.
%
%   T = FULL(C) converts a ktensor to a (dense) tensor.
%
%   Examples
%   X = ktensor([3; 2], rand(4,2), rand(5,2), rand(3,2));
%   Y = full(A) %<-- equivalent dense tensor
%
%   See also KTENSOR, TENSOR.
%
%MATLAB Tensor Toolbox.
%Copyright 2012, Sandia Corporation.

% This is the MATLAB Tensor Toolbox by T. Kolda, B. Bader, and others.
% http://www.sandia.gov/~tgkolda/TensorToolbox.
% Copyright (2012) Sandia Corporation. Under the terms of Contract
% DE-AC04-94AL85000, there is a non-exclusive license for use of this
% work by or on behalf of the U.S. Government. Export of this data may
% require a license from the United States Government.
% The full license terms can be found in the file LICENSE.txt

%Downloaded from http://www.sandia.gov/~tgkolda/TensorToolbox Jan 10, 2020, and modified.

batch = 50;%batch_size
sz = size(t);
[~,r] = size(t.u{1});
data = 0;
for pos = 1:batch:r
    nind = min((pos+batch-1),r);
    lam = t.lambda(pos:nind);
    u = {t.u{1}(:,pos:nind), t.u{2}(:,pos:nind), t.u{3}(:,pos:nind)};
    data = data + lam' * khatrirao(u,'r')';
end
t = tensor(data,sz);
