clearvars
clc

addpath("utils") % add util functions

N = 5; % sample size
beta = [1, 2, 1,-1]; % beta coefs.
sigma_e = [1, 2, 10]; % variance for U

% Initialize estimation
n_iter = 500;
beta_estimates = zeros(length(sigma_e), n_iter, length(beta));
for j=1:length(sigma_e)
    for i=1:n_iter
    
        % Defining input matrix 
        X = generate_data(N, [0, 0, 0], [1, 2, 1]);
        U = sample_normal(N, 0, sigma_e(j));
        
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



%% Plot histograms for each sigma_e
figure;
for j = 1:length(sigma_e)
    for k = 1:length(beta)
        subplot(length(sigma_e), length(beta), (j-1)*length(beta) + k);
        histogram(squeeze(beta_estimates(j, :, k)), 'Normalization', 'pdf');
        hold on;
        xline(beta(k), 'r', 'LineWidth', 1); % Mark the true beta value
        title(['\sigma_\epsilon = ', num2str(sigma_e(j)), ', \beta_', ...
            num2str(k-1), '=', num2str(beta(k))]);
        xlabel('Estimated value');
        ylabel('Density');
        
    end
end
% shared legend
hLegend = legend('\beta\_Hat', 'beta\_True', 'NumColumns',  2);
set(hLegend, 'Position', [0.74, .87, 0.03, 0.03]); % Ajusta la posición del legend

% Adjust image size
set(gcf, 'Units', 'inches');
pos = get(gcf, 'Position');
set(gcf, 'PaperPositionMode', 'Auto', ...
    'PaperUnits', 'Inches', 'PaperSize', [pos(3), pos(4)]);

sgtitle('\beta distribution among different \sigma_\epsilon values');
% Save fig as pdf 
exportgraphics(gcf, 'output_1.pdf', 'ContentType', 'vector');