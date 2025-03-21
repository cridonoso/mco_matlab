clearvars
clc
%% Question 2
rng(42); % Set seed to reproduce the same charts 
addpath("utils") % Add utility functions

N_vector = [50, 100, 500]; % Sample sizes vector
beta = [1, 2, 1,-1]; % Beta coefficients
sigma_e = 2; % Variance of U

% Initialize estimation
n_iter = 500;
beta_estimates = zeros(length(N_vector), n_iter, length(beta));
for j=1:length(N_vector)
    for i=1:n_iter
        N = N_vector(j); % Select current sample size
        
        % Define input matrix
        X = generate_data(N, [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N, 0, sigma_e);
        
        % Calculate target variable
        Y = X*beta' + U;
        
        % Compute parameter estimates
        beta_hat = X \ Y;
        
        % Store estimators
        beta_estimates(j, i, :) = beta_hat;
    end
end

%% PERCENTILE COMPUTATION AND VISUALIZACION
[beta_estimates, ptiles] = sort_percentile(beta_estimates);
printpercentile(ptiles, ["N=50", "N=100", "N=500"], ...
    './figures/percentiles_2.pdf')
%% PLOT
% Create tiled layout
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'loose');

% Add subplots
for j = 1:length(beta)
    nexttile;
    hold on;
    for s = 1:length(N_vector)
        data = beta_estimates(s, :, j);
        [xi, f] = kde(data);
        plot(xi, f, 'LineWidth', 1, 'DisplayName', sprintf('N = %g', N_vector(s)));
    end
    xline(beta(j), '--r', 'LineWidth', 1, 'DisplayName', 'True value');
    ylabel('Densidad');
    xlabel(sprintf('Valor estimado para \\beta_{%g}', j-1));
    grid on;
    hold off;
end

% Add shared title
sgtitle("Distribuci\'{o}n de $\hat{\beta}$ variando $N$", 'Interpreter', 'latex', 'FontSize', 14);

% Add legend below the plots
hLegend = legend('show', 'NumColumns', 2);
hLegend.Layout.Tile = 'south';
axis padded

% Configure print settings
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6, 5]); % Set paper size larger than figure
set(gcf, 'PaperPosition', [0., 0., 6, 5]); % Add 
print(gcf, '-dpdf', './figures/output_2.pdf');

