%% Función para estimar la densidad con un kernel gaussiano
function [xi, f] = kde(data)
    % myKSDensity: estima la densidad de un conjunto de datos usando un kernel gaussiano.
    % data: vector de datos.
    % xi: puntos de la grilla.
    % f: densidad estimada en los puntos de la grilla.
    
    n = numel(data);
    % Definir la grilla de evaluación, ampliando un poco el rango de data
    xi = linspace(min(data)-std(data), max(data)+std(data), 100);
    % Ancho de banda según la regla de Silverman
    bw = 1.06 * std(data) * n^(-1/5);
    f = zeros(size(xi));
    % Calcular la densidad para cada punto de la grilla
    for i = 1:length(xi)
        % Kernel gaussiano
        f(i) = sum(exp(-0.5 * ((xi(i)-data)/bw).^2)) / (n * bw * sqrt(2*pi));
    end
end
