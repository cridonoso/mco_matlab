clearvars
clc
%% Question 1
rng(42); % Set seed to reproduce the same charts    
addpath("utils") % Add utility functions

N = 100; % Sample size
beta = [1, 2, 1,-1]; % Beta coefficients
sigma_u = [1, 2, 10]; % Variance values for U

% Initialize estimation
n_iter = 500; % Number of trials
beta_estimates = zeros(length(sigma_u), n_iter, length(beta));
for j=1:length(sigma_u)
    for i=1:n_iter
        % Define input matrix 
        X = generate_data(N, [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N, 0, sigma_u(j));
        
        % Calculate target variable
        Y = X*beta' + U;
        
        % Compute parameter estimates
        beta_hat = X \ Y;
    
        beta_estimates(j, i, :) = beta_hat;
    end
end

%% CALCULATING PERCENTILE AND VISUALIZE THEM
[beta_estimates, ptiles] = sort_percentile(beta_estimates);
printpercentile(ptiles, ["\sigma_U^2=1", "\sigma_U^2=2", "\sigma_U^2=10"], ...
    './figures/percentiles_1.pdf')
%% PLOT
% Create tiled layout
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'loose');

for j = 1:4  % iterates over β0, β1, β2, and β3.
    nexttile;
    hold on;
    % Calculate density estimates for each σ² value using KDE
    for s = 1:length(sigma_u)
        data = beta_estimates(s, :, j);
        [xi, f] = kde(data);
        plot(xi, f, 'LineWidth', 1, 'DisplayName', sprintf('\\sigma^2 = %g', sigma_u(s)));
    end
    % Add vertical line for true parameter value
    xline(beta(j), '--r', 'LineWidth', 1, 'DisplayName', 'True value');
    ylabel(sprintf('Densidad'));
    xlabel(sprintf('Valor estimado para \\beta_{%g}', j-1));
    grid on;
    hold off;
end
% Add shared title
sgtitle("Distribuci\'{o}n de $\hat{\beta}$ variando $\sigma^2_U$", 'Interpreter', 'latex', 'FontSize', 14);

% Add legend below the plots
hLegend = legend('show', 'NumColumns', 2);
hLegend.Layout.Tile = 'south';
axis padded

% Configure print settings
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6, 5]); % Set paper size larger than figure
set(gcf, 'PaperPosition', [0., 0., 6, 5]); % Add 
print(gcf, '-dpdf', './figures/output_1.pdf');
