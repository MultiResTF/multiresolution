%% Computes multiscale representation of a video.
%% Requires the tensor toolbox to be installed

clc; clf; clear all; close all

disp('ex_mall_several_larger')
levels = 9;
d = 3;
n = 2^(levels-1);
A = zeros(n*ones(1,d));

for imgn = 1000:2279
    name = sprintf('ShoppingMall/ShoppingMall%d.bmp', imgn);
    tmp = imread(name);
    tmp = im2double(rgb2gray(tmp));
    tmp = imresize(tmp,[2^(levels-1) 2^(levels-1)]);
    A(:, :, imgn-999) = tmp;
end

A_orig = A;
nA = norm(tensor(A));

disp('loaded data')


%%
rank_tol = 1e-6;
maxiter = 200;%200;%100;
conv_tol = 1e-6;

scale_ranks = 50:50:250;%256;%70:10:120;%10:10:30;%10:10:110;%60:20:200;
error_multi = zeros(length(scale_ranks),1);
error_candecomp = zeros(length(scale_ranks),1);

storage_multi = zeros(length(scale_ranks),1);
storage_TT = zeros(length(scale_ranks),1);

times_multi = zeros(length(scale_ranks),1);
times_TT = zeros(length(scale_ranks),1);

for sind = 1:length(scale_ranks)
    scale_rank = scale_ranks(sind)
    warning('off')
    
    tic
    Adirect = cp_als(tensor(A), 2*scale_rank, 'printitn',1,'maxiters',50);
 
    t1 = toc;
    times_TT(sind) = t1;

    m = levels;
    levels_to_use = (levels-m+1):levels;
    rank_list = [zeros(levels-m,1); scale_rank*ones(m,1)];
    tic
    res2 = iterate_multiscale_candecomp_f(A, levels, levels_to_use, maxiter, rank_list, conv_tol);
    t1 = toc;
    times_multi(sind) = t1;

    A1 = res2{1};
    for k = 2:levels
        A1 = downscale_candecomp(A1) + res2{k};
    end

    error_multi(sind) = sqrt(nA^2 + norm(A1)^2 - 2*innerprod(tensor(A),A1))/nA;
    error_candecomp(sind) = sqrt(nA^2 + norm(Adirect)^2 - 2*innerprod(tensor(A),Adirect))/nA;

    st = 0;
    for k = levels-m+1:levels
        st = st + numel(res2{k}.U{1})+numel(res2{k}.U{2})+numel(res2{k}.U{3});
    end
    storage_multi(sind) = st;
    storage_TT(sind) = numel(Adirect.U{1})+numel(Adirect.U{2})+numel(Adirect.U{3});
    sA = numel(A);
    figure(1)
    hold on
    plot(error_multi, sA./storage_multi, '*-b')
    plot(error_candecomp, sA./storage_TT, '*-r')
end

%%

clf
figure(1)
semilogy(error_multi, numel(A)./storage_multi, '*-b')
hold on
semilogy(error_candecomp, numel(A)./storage_TT, 's-r')


set(gca,...
'FontUnits','points',...
'FontSize',24,...
'TickLabelInterpreter','latex',...
'FontName','Times')

xlabel('Relative error',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')

ylim([6, 35])
ylabel('Compression ratio',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')
    grid()

legend({'Multiscale', 'Tensor-train'},...
        'location', 'NorthWest',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
    pbaspect([2 1 1])

% print -dpdf mall_storageM200_candecomp.pdf


%%

clf
figure(2)
plot(error_multi, times_multi./(maxiter), '>:', 'Color', [0.6350    0.0780    0.1840])
hold on
plot(error_candecomp, times_TT, '<-.', 'Color',[0    0.4470    0.7410])


set(gca,...
'FontUnits','points',...
'FontSize',24,...
'TickLabelInterpreter','latex',...
'FontName','Times')

xlabel('Relative error',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')


ylabel('Time (s)',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')
    grid()

legend({'Multiscale/iteration', 'Tensor-train'},...
        'location', 'NorthEast',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
    pbaspect([2 1 1])
% print -dpdf mall_timeM200_candecomp.pdf


