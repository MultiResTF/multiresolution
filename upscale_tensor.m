function res=upscale_tensor(A)
% downloaded from https://www.mathworks.com/matlabcentral/answers/134167-how-can-i-create-another-matrix-with-the-sum-of-every-30-rows-in-a-14-400-by-11-matrix

%DOWNSAMPN - simple tool for downsampling n-dimensional nonsparse arrays
%
%  M=downsampn(M,bindims)
%
%in:
%
% M: an array
% bindims: a vector of integer binning dimensions
%
%out:
%
% M: the downsized array
nn=ndims(A);
bindims = 2*ones(1,nn);

[sz{1:nn}]=size(A); %M is the original array
sz=[sz{:}];
newdims=sz./bindims;
args=num2cell([bindims;newdims]);
A=reshape(A,args{:});
for ii=1:nn
   A=mean(A,2*ii-1);
end
res=reshape(A,newdims);
end
