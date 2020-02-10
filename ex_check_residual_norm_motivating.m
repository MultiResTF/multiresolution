%% Computes multiscale representation of the motivating example.
%% Requires the tensor toolbox to be installed

clc; clf; clear all; close all
level_list = 4:10;


error_MS = zeros(length(level_list),1);
error = zeros(length(level_list),1);

maxiter = 1;
max_als_iter = 100;
conv_tol = 1e-6;
scale_rank = 1;
warning('off')



l = 1;
for levels = level_list
    disp(levels)
    m = 3;
    rank_list = [zeros(levels-m,1); scale_rank*ones(m,1)];


    levels_to_use = levels-m+1:levels;
    n = 2^(levels-1);
    x = linspace(0, pi, n);
    A1 = [sin(x)'];
    A2 = [sin(4*x)'];

    A = ktensor({A1,A1,A1});
    B = downscale_candecomp(upscale_candecomp(A));
    t2 = toc;


    error(l) = norm(A-B)/norm(A);
    l = l+1;
end

%%
clf

loglog(2.^(level_list-1), error, '<-.', 'Color',[0    0.4470    0.7410])
hold on
loglog(2.^(level_list-1), 4*1./(2.^(level_list-1)), 'k')

set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
set(gca, 'YMinorTick','on', 'YMinorGrid','on')

set(gca,...
'FontUnits','points',...
'FontSize',18,...
'TickLabelInterpreter','latex',...
'FontName','Times')

xlabel('$n$',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',18,...
    'FontName','Times')

ylabel('Rel. approx. error',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',18,...
    'FontName','Times')
    grid()

legend({'Multiscale', 'Canonical', '$O(n^{-1})$'},...
        'location', 'SouthWest',...
        'interpreter','latex',...
        'FontSize',18,...
        'FontName','Times')


    legend boxoff
    
    pbaspect([3.5 1 1])

% print -dpdf motivating_residual.pdf

