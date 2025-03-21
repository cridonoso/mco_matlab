clearvars
clc
%% Question 1
rng(42); % seed to recall same charts 
addpath("utils") % add util functions

N = 100; % sample size
beta = [1, 2, 1,-1]; % beta coefs.
sigma_u = [1, 2, 10]; % variance for U

% Initialize estimation
n_iter = 500;
beta_estimates = zeros(length(sigma_u), n_iter, length(beta));
for j=1:length(sigma_u)
    for i=1:n_iter
    
        % Defining input matrix 
        X = generate_data(N, [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N, 0, sigma_u(j));
        
        % Target
        Y = X*beta' + U;
        
        % Beta parameter
        %beta_hat = inv(X'*X)*X'Y % inneficient
        %beta_hat = (X'*X) \ (X'*Y); % better but not enough
        beta_hat = X \ Y; % best
    
        beta_estimates(j, i, :) = beta_hat;
    end
end

[beta_estimates, ptiles] = sort_percentile(beta_estimates);
printpercentile(ptiles, ["sigma=1";"sigma=2";"sigma=10"])
%% PLOT
% Create tiled layout
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'loose');

for j = 1:4  % j=1 corresponde a β0, j=2 a β1, etc.
    nexttile;
    hold on;
    % Se calcula la densidad de los estimadores para cada valor de sigma² usando myKSDensity
    for s = 1:length(sigma_u)
        data = beta_estimates(s, :, j);
        [xi, f] = kde(data);
        plot(xi, f, 'LineWidth', 1, 'DisplayName', sprintf('\\sigma^2 = %g', sigma_u(s)));
    end
    % Línea vertical que indica el valor verdadero del parámetro
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

set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6, 5]); % Set paper size larger than figure
set(gcf, 'PaperPosition', [0., 0., 6, 5]); % Add 
print(gcf, '-dpdf', './figures/output_1.pdf');
