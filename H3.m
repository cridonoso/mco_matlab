clearvars
clc

%% Question 3
rng(42); % seed to reproduce same charts 
addpath("utils") % add util functions

N = 100; % sample sizes vector
beta = [1, 2, 1,-1]; % beta coefs.
sigma_u = 2; % variance for U
sigma_z = 1; % variance for Z
lambda_v = [0.1, 0.5, 5]; % lambda values 

% Initialize estimation
n_iter = 500;
beta_estimates = zeros(length(lambda_v), n_iter, length(beta));
for j=1:length(lambda_v)
    for i=1:n_iter
        
        % Defining input matrix 
        Z   = sample_normal(N, 0, sigma_z);
        U   = sample_normal(N, 0, sigma_u);
        X12 = generate_data(N, [0, 0], [1, 2]);
        X3  = Z + lambda_v(j).*U;
        X   = [X12 X3];

        % Target
        Y = X*beta' + U;
        
        % Beta parameter
        beta_hat = X \ Y; % best
    
        beta_estimates(j, i, :) = beta_hat;
    end
end
%% PERCENTILE COMPUTATION AND VISUALIZACION
[beta_estimates, ptiles] = sort_percentile(beta_estimates);
printpercentile(ptiles, ["\lambda=0.1", "\lambda=0.5", "\lambda=5"], ...
    './figures/percentiles_3.pdf')

%% PLOTTING ESTIMATIONS
% Create tiled layout
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'loose');

for j = 1:length(beta)  % iterate over beta indices
    nexttile;
    hold on;
    for s = 1:length(lambda_v) % Iterate over N sizes
        data = beta_estimates(s, :, j);
        [xi, f] = kde(data);
        plot(xi, f, 'LineWidth', 1, 'DisplayName', sprintf('\\lambda = %g', lambda_v(s)));
    end
    xline(beta(j), '--r', 'LineWidth', 1, 'DisplayName', 'True value');
    ylabel('Densidad');
    xlabel(sprintf('Valor estimado para \\beta_{%g}', j-1));
    grid on;
    hold off;
end

% Add shared title
sgtitle("Distribuci\'{o}n de $\hat{\beta}$ variando $\lambda$", 'Interpreter', 'latex', 'FontSize', 14);

% Add legend below the plots
hLegend = legend('show', 'NumColumns', 2);
hLegend.Layout.Tile = 'south';
axis padded

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6, 5]); % Set paper size larger than figure
set(gcf, 'PaperPosition', [0., 0., 6, 5]); % Add 
print(gcf, '-dpdf', './figures/output_3.pdf');
