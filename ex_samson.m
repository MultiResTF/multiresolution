%% Computes multiscale representation of a hyperspectral image.
%% Requires the TT-toolbox to be installed

clc; clf; clear all; close all

levels = 8;
d = 3;
n = 2^(levels-1);


info = read_envihdr('samson/Samson/SAMSON.hdr'); 
A = multibandread('samson/Samson/SAMSON.bil', info.size, [info.format '=>double'], info.header_offset, info.interleave, info.machine);
A_orig = A;
%%

Ause = A(1:896, 1:896, 1:n);

disp('loaded data')
A = tt_tensor(Ause)
disp('converted TT')
%%
clf
rank_tol = 1e-6;
maxiter = 20;%100;%maximum number of iterations
conv_tol = 1e-6;

scale_ranks = 20:18:200;%20:10:100;%maximum TT-rank for each scale

%errors
error_multi = zeros(length(scale_ranks),1);
error_TT = zeros(length(scale_ranks),1);

%storage costs
storage_multi = zeros(length(scale_ranks),1);
storage_TT = zeros(length(scale_ranks),1);

%computation times
times_multi = zeros(length(scale_ranks),1);
times_TT = zeros(length(scale_ranks),1);

for sind = 1:length(scale_ranks)
    scale_rank = scale_ranks(sind)
    warning('off')

    m = levels;
    levels_to_use = (levels-m+1):levels;
    rank_list = [zeros(levels-m,1); scale_rank*ones(m,1)];


    %compute the multiscale representation
    tic
    res2 = iterate_multiscale_TT(A, levels, levels_to_use, maxiter, rank_list, conv_tol, 0);
    t1 = toc;
    times_multi(sind) = t1;


    %convert to full tensor to check accuracy
    A1 = res2{1};
    for k = 2:levels
        A1 = downscale_TT(A1) + res2{k};
    end
    toc



    %compare to tensor-train representation

    tic
    Adirect = (round(A,1e-16, ceil(0.95*sqrt(2)*scale_rank)));
    t1 = toc;
    times_TT(sind) = t1;

    %compute accuracies
    error_multi(sind) = norm(A-A1)/norm(A);
    error_TT(sind) = norm(A-Adirect)/norm(A);

    %compute storage-costs  
    st = 0;
    for k = 1:levels
        st = st + storage_size_osel(round(res2{k}, 1e-16));
    end
    
    %plot during loop
    storage_multi(sind) = st;
    storage_TT(sind) = storage_size_osel(Adirect);
    figure(1)
    hold on
    plot(error_multi, numel(Ause)./storage_multi, '*-b')
    plot(error_TT, numel(Ause)./storage_TT, '*-r')
end


%%
%plot results

clf
figure(1)
semilogy(error_multi, numel(Ause)./storage_multi, '*-b')
hold on
semilogy(error_TT, numel(Ause)./storage_TT, 's-r')


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

ylim([0.8, 100])
ylabel('Compression ratio',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')
    grid()

legend({'Multiscale', 'Tensor-train','$g:$ TR-format'},...
        'location', 'NorthWest',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
    pbaspect([2 1 1])

% print -dpdf samson_storageM200_larger.pdf


%%
clf
figure(2)
plot(error_multi, times_multi./(maxiter), '>:', 'Color', [0.6350    0.0780    0.1840])
hold on
plot(error_TT, times_TT, '<-.', 'Color',[0    0.4470    0.7410])


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
% print -dpdf samson_timeM200_larger.pdf

