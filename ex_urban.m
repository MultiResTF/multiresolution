%% Computes multiscale representation of a hyperspectral image.
%% Requires the TT-toolbox to be installed

clc; clf; clear all; close all

levels = 8;
d = 3;
n = 2^(levels-1);

load('urban/Urban_R162.mat');
Al = (reshape(Y', [307, 307, 162]));

Ause = zeros(n,n,n);
for k = 1:n
    tmp = Al(1:256,1:256,k);
    Ause(:,:,k) = (upscale(tmp));
end

%%
clf
imagesc(mat2gray(Al(:,:,1)))
colormap('gray'); brighten(0.5);
axis off
% print -dpdf urban.pdf

%%

disp('loaded data')
A = tt_tensor(Ause)
disp('converted TT')

%%
clf
maxiter = 20;%100;  %maximum number of iterations

scale_ranks = [10];%10:10:100; %maximum TT-rank for each scale

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
    res2 = iterate_multiscale_TT(A, levels, levels_to_use, maxiter, rank_list, 0);
    t1 = toc;
    times_multi(sind) = t1;

    %convert to full tensor to check accuracy
    A1 = res2{1};
    for k = 2:levels
        A1 = downscale_TT(A1) + res2{k};
    end

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
    storage_multi(sind) = st;
    storage_TT(sind) = storage_size_osel(Adirect);
    
    %plot during loop
    figure(1)
    hold on
    plot(error_multi, prod(size(Ause))./storage_multi, '*-b')
    plot(error_TT, prod(size(Ause))./storage_TT, '*-r')
end



%%
clf
figure(1)
semilogy(error_multi, prod(size(Ause))./storage_multi, '*-b')
hold on
semilogy(error_TT, prod(size(Ause))./storage_TT, 's-r')


set(gca,...
'FontUnits','points',...
'FontSize',24,...
'TickLabelInterpreter','latex',...
'FontName','Times')

% xlim([5, 30]);
xlabel('Relative error',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')

% yticks(0:0.2:1)
ylim([0.8, 100])
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

% print -dpdf urban_storageM200.pdf


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

% xlim([5, 30]);
xlabel('Relative error',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')

% yticks(0:0.2:1)
% ylim([0.8, 100])
ylabel('Time (s)',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')
    grid()

% legend({'Multiscale/iteration', 'Tensor-train'},...
%         'location', 'NorthEast',...
%         'interpreter','latex',...
%         'FontSize',24,...
%         'FontName','Times')
    pbaspect([2 1 1])
% print -dpdf urban_timeM200.pdf

%%
%Visualize the multiscale-representation versus the TT-representation

v = [];
figure(1)

for imgn = 1:n
    imgn
    B = full(A1);
    B = reshape(B, n*ones(1,d));
    C = B(:,:,imgn);

    
    D = full(Adirect);
    D = reshape(D, n*ones(1,d));
    E = D(:,:,imgn);

    F = full(A);
    G = reshape(F, n*ones(1,d));
    G = G(:,:,imgn);
    subplot(3,1,1)
    imagesc((G))
    title('Actual tensor')
    subplot(3,1,2)
    imagesc((C))
    title('Multiscale')
    subplot(3,1,3)
    imagesc((E))
    title('Tensor-train')

    pause(0.05)
end
