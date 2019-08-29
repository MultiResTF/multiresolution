% Confirming local convergence by recovering a multiscale representation
% after perturbation on each scale.
clc; clf; clear all; close all

levels = 8;

maxiter = 1500; %maximum number of iterations
scale_rank = 10; %maximum rank on each scale
A = 0;

Us = cell(levels,1);    %contains perturbed matrix on each scale
As = cell(levels,1);    %contains matrix on each scale
m = levels;

rank_list = min(scale_rank, 2.^((1:levels)-1));
levels_to_use = [4,6,7,8];


%set up matrices
for k = 1:levels
    Us{k} = randn(2^(k-1),min(scale_rank, 2^(k-1)))*randn(min(scale_rank,2^(k-1)),2^(k-1));
    Us{k} = Us{k}/norm(Us{k}, 'fro');
    if ~ismember(k, levels_to_use)
        Us{k} = 0*Us{k};
    end
end

for k = 1:levels
        if ismember(k, levels_to_use)
            tmp = abs(randn(size(Us{k})));
            As{k} = Us{k} + 0.1*tmp/norm(tmp);
        else
            As{k} = Us{k};
        end
end


for k = 1:levels
    for l = 1:k-1
        Us{l} = downscale(Us{l});
        As{l} = downscale(As{l});
    end
end


for k = 1:levels
    A = A + Us{k};
end

%run algorithm
[res1, errors2] = iterate_multiscale_start_check_pair(A, levels, maxiter, rank_list, As, Us, levels_to_use);

%%
%visualize convergence
clf
semilogy(errors2(:,4), '-','LineWidth',2.5)
hold on
semilogy(errors2(:,6), '--','LineWidth',2.5)
semilogy(errors2(:,7), '-.','LineWidth',2.5)
semilogy(errors2(:,8), ':','LineWidth',2.5)

set(gca,...
'FontUnits','points',...
'FontSize',24,...
'TickLabelInterpreter','latex',...
'FontName','Times')

xlabel('$$n$$',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')

ylim([10^(-16), 1])
yticks([1e-15 1e-10 1e-5 1])

ylabel('$$\|T_k - T_k^{(n)}\|$$',...
    'FontUnits','points',...
    'interpreter','latex',...
    'FontSize',24,...
    'FontName','Times')
    grid()

legend({'$$k = 4$$', '$$k = 6$$','$$k = 7$$', '$$k = 8$$'},...
        'location', 'BestOutside',...
        'FontUnits','points',...
        'interpreter','latex',...
        'FontSize',24,...
        'FontName','Times')
pbaspect([2 1 1])

% print -dpdf loc_conv.pdf