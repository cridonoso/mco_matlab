%% Limpieza del entorno
clear all; close all; clc;

%% Parámetros
rng(42);
beta_true = [1; 2; 1; -1];  % [β0, β1, β2, β3]
replications = 500;
N = 100;
sigma2_values = [1, 2, 10];

% Almacenamos los resultados de los estimadores para cada valor de sigma²
betas_sigma = cell(length(sigma2_values),1);

for s = 1:length(sigma2_values)
    sigma2 = sigma2_values(s);
    betas = zeros(replications, 4);
    
    for r = 1:replications
        % Generar variables independientes
        X1 = randn(N, 1);             % N(0,1)
        X2 = sqrt(2)*randn(N, 1);       % N(0,2)
        X3 = randn(N, 1);             % N(0,1)
        % Generar error
        U = sqrt(sigma2)*randn(N, 1);   % N(0, σ²_ε)
        % Generación de Y
        Y = beta_true(1) + beta_true(2)*X1 + beta_true(3)*X2 + beta_true(4)*X3 + U;
        % Matriz de regresores (incluye intercepto)
        X = [ones(N,1) X1 X2 X3];
        % Estimación mediante la fórmula matricial
        beta_hat = (X' * X) \ (X' * Y);
        betas(r, :) = beta_hat';
    end
    
    betas_sigma{s} = betas;
    
    % Reporte de percentiles 5 y 95
    p5 = prctile(betas, 5);
    p95 = prctile(betas, 95);
    fprintf('Para σ²_ε = %g:\n', sigma2);
    fprintf('Percentil 5: [%.3f, %.3f, %.3f, %.3f]\n', p5(1), p5(2), p5(3), p5(4));
    fprintf('Percentil 95: [%.3f, %.3f, %.3f, %.3f]\n\n', p95(1), p95(2), p95(3), p95(4));
end

%% Gráficos de línea: Comparación de la distribución de cada estimador para distintos σ²_ε
figure;
for j = 1:4  % j=1 corresponde a β0, j=2 a β1, etc.
    subplot(2,2,j);
    hold on;
    % Se calcula la densidad de los estimadores para cada valor de sigma² usando myKSDensity
    for s = 1:length(sigma2_values)
        data = betas_sigma{s}(:, j);
        [xi, f] = kde(data);
        plot(xi, f, 'LineWidth', 2, 'DisplayName', sprintf('\\sigma^2 = %g', sigma2_values(s)));
    end
    % Línea vertical que indica el valor verdadero del parámetro
    xline(beta_true(j), '--r', 'LineWidth', 2, 'DisplayName', 'Valor verdadero');
    title(sprintf('Densidad de \\beta_{%d}', j-1));
    xlabel('Valor estimado');
    ylabel('Densidad');
    legend('show');
    hold off;
end
subtitle(sprintf('Distribución de estimadores (N = %d) para distintos \\sigma^2_{\\epsilon}', N));



%% Parte 2: Variación del tamaño muestral para σ²_ε = 2
sigma2 = 2;
N_values = [50, 100, 500];
replications = 500; % Número de repeticiones
betas_N = cell(length(N_values),1);
beta_true = [1; 2; 1; -1];  % Parámetros verdaderos

for s = 1:length(N_values)
    N = N_values(s);
    betas = zeros(replications, 4);
    
    for r = 1:replications
        % Generar variables independientes
        X1 = randn(N, 1);
        X2 = sqrt(2)*randn(N, 1);
        X3 = randn(N, 1);
        % Error
        U = sqrt(sigma2)*randn(N, 1);
        % Generación de Y
        Y = beta_true(1) + beta_true(2)*X1 + beta_true(3)*X2 + beta_true(4)*X3 + U;
        % Matriz de regresores (incluye intercepto)
        X = [ones(N,1) X1 X2 X3];
        % Estimación mediante la fórmula matricial
        beta_hat = (X' * X) \ (X' * Y);
        betas(r, :) = beta_hat';
    end
    
    betas_N{s} = betas;
    
    % Reporte de percentiles 5 y 95
    p5 = prctile(betas, 5);
    p95 = prctile(betas, 95);
    fprintf('Para N = %d y σ²_ε = %g:\n', N, sigma2);
    fprintf('Percentil 5: [%.3f, %.3f, %.3f, %.3f]\n', p5(1), p5(2), p5(3), p5(4));
    fprintf('Percentil 95: [%.3f, %.3f, %.3f, %.3f]\n\n', p95(1), p95(2), p95(3), p95(4));
end

%% Gráficos de línea: Comparación de la distribución de cada estimador para distintos tamaños muestrales
figure;
for j = 1:4  % j = 1 corresponde a β0, j = 2 a β1, etc.
    subplot(2,2,j);
    hold on;
    for s = 1:length(N_values)
        data = betas_N{s}(:, j);
        [xi, f] = myKSDensity(data);
        plot(xi, f, 'LineWidth', 2, 'DisplayName', sprintf('N = %d', N_values(s)));
    end
    % Línea vertical que indica el valor verdadero
    xline(beta_true(j), '--r', 'LineWidth', 2, 'DisplayName', 'Valor verdadero');
    title(sprintf('Densidad de \\beta_{%d}', j-1));
    xlabel('Valor estimado');
    ylabel('Densidad');
    legend('show');
    hold off;
end
subtitle(sprintf('Distribución de estimadores (σ²_ε = %g) para distintos tamaños muestrales', sigma2));


%% Parte 3: Endogeneidad en X3 con X3 = Z + λ·U (σ²_ε = 2, N = 100)
sigma2 = 2;
N = 100;
lambda_values = [0.1, 0.5, 5];
replications = 500;
betas_lambda = cell(length(lambda_values),1);
beta_true = [1; 2; 1; -1];  % Parámetros verdaderos

for s = 1:length(lambda_values)
    lambda = lambda_values(s);
    betas = zeros(replications, 4);
    
    for r = 1:replications
        % Generar variables independientes
        X1 = randn(N, 1);
        X2 = sqrt(2)*randn(N, 1);
        U = sqrt(sigma2)*randn(N, 1);
        Z = randn(N, 1);
        % X3 con endogeneidad
        X3 = Z + lambda*U;
        % Generación de Y
        Y = beta_true(1) + beta_true(2)*X1 + beta_true(3)*X2 + beta_true(4)*X3 + U;
        % Matriz de regresores (incluye intercepto)
        X = [ones(N,1) X1 X2 X3];
        % Estimación mediante la fórmula matricial
        beta_hat = (X' * X) \ (X' * Y);
        betas(r, :) = beta_hat';
    end
    
    betas_lambda{s} = betas;
    
    % Reporte de percentiles 5 y 95
    p5 = prctile(betas, 5);
    p95 = prctile(betas, 95);
    fprintf('Para λ = %g:\n', lambda);
    fprintf('Percentil 5: [%.3f, %.3f, %.3f, %.3f]\n', p5(1), p5(2), p5(3), p5(4));
    fprintf('Percentil 95: [%.3f, %.3f, %.3f, %.3f]\n\n', p95(1), p95(2), p95(3), p95(4));
end

%% Gráficos de línea: Comparación de la distribución de cada estimador para distintos λ (endogeneidad)
figure;
for j = 1:4  % j = 1 corresponde a β0, j = 2 a β1, etc.
    subplot(2,2,j);
    hold on;
    for s = 1:length(lambda_values)
        data = betas_lambda{s}(:, j);
        [xi, f] = myKSDensity(data);
        plot(xi, f, 'LineWidth', 2, 'DisplayName', sprintf('\\lambda = %g', lambda_values(s)));
    end
    % Línea vertical que indica el valor verdadero
    xline(beta_true(j), '--r', 'LineWidth', 2, 'DisplayName', 'Valor verdadero');
    title(sprintf('Densidad de \\beta_{%d}', j-1));
    xlabel('Valor estimado');
    ylabel('Densidad');
    legend('show');
    hold off;
end
subtitle(sprintf('Distribución de estimadores con endogeneidad (N = %d, σ²_ε = %g)', N, sigma2));