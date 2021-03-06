%% Computes multiscale representation of a 2d image.
%% Requires the TT-toolbox to be installed

clc; clf; clear all; close all

levels = 11;        %Number of levels in the representation
d = 2;              %Tensor dimension
n = 2^(levels-1);

J = imread('2d/NYC.jpg');

Ause = imresize(J,[2^(levels-1) 2^(levels-1)]);
Ause = im2double(rgb2gray(Ause));

%%
clf
imagesc((Ause))
colormap('gray'); brighten(0.5);
axis off
% print -dpdf NYC.pdf
%%
disp('loaded data')
A = tt_tensor(Ause)
disp('converted TT')

%%
maxiter = 100;  %maximum number of iterations

scale_ranks = [20];%20:30:290;  %maximum TT-rank for each scale

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
    t = toc;
    times_multi(sind) = t;

    %convert to full tensor to check accuracy
    A1 = res2{1};
    for k = 2:levels
        A1 = downscale_TT(A1) + res2{k};
    end


    %compare to tensor-train representation
    tic
    Adirect = (round(A,1e-16, ceil(sqrt(3)*scale_rank)));
    t = toc
    times_TT(sind) = t;
    
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
%plot results
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

legend({'Multiscale', 'Low-rank matrix'},...
        'location', 'NorthWest',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
    pbaspect([2 1 1])

% print -dpdf NYC_storageM200.pdf


figure(2)
plot(error_multi, times_multi./(maxiter), '*-b')
hold on
plot(error_TT, times_TT, 's-r')


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

legend({'Multiscale/iteration', 'Tensor-train'},...
        'location', 'NorthEast',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
    pbaspect([2 1 1])

% print -dpdf NYC_timeM200.pdf