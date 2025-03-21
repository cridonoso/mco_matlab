function printpercentile(percentiles, tag, target)
    % PRINTPERCENTILE Display percentile information
    % labels are assumed to be correlated with the first axis
    % second and thrid axes are betas and percentile respectively
    columns = ["beta";"5th Percentile";"95th Percentile"];
    beta_labels = ["b0", "b1", "b2", "b3"];
    for i=1:size(percentiles, 1)
        p5 = percentiles(i, :, 1)';
        p95 = percentiles(i, :, 2)';
        T = table(beta_labels', p5, p95, 'VariableNames', columns);
        % Add header
        if exist('tag', 'var')
            display(tag(i)); % Example header
        end
        disp(T);
    end

    param_labels = {'$\\\beta_0$', '$\\\beta_1$', '$\\\beta_2$', '$\\\beta_3$'};
    % Create figure
    figure('Units','inches', 'Position', [0 0 10 2]);
    % Plot for each parameter
    for param_idx = 1:length(beta_labels)
        subplot(1, 4, param_idx);
        hold on;
        
        % Extract data for current parameter
        param_data = squeeze(percentiles(:, param_idx, :)); % 3x2 matrix
        
        % Plot percentile ranges
        for hp = 1:3
            x = hp + [-0.2, 0.2];
            y5 = [param_data(hp,1), param_data(hp,1)];
            y95 = [param_data(hp,2), param_data(hp,2)];
            plot(x, y5, 'b', 'LineWidth', 2);
            plot(x, y95, 'r', 'LineWidth', 2);
            plot([hp, hp], [y5(1), y95(1)], 'k-', 'LineWidth', 1);
        end
        
        % Formatting
        title(param_labels{param_idx});
        xticks(1:3);
        xticklabels(tag);
        ylabel('Valor');
        grid on;
        ylim([min(param_data(:)) - 0.1, max(param_data(:)) + 0.1]);
    end
    % Add legend below the plots
    lgd=legend('P5', 'P95', 'NumColumns', 2);
    lgd.Position = [0.78, 0.9, 0.05, 0.05]; % [left, bottom, width, height]

    sgtitle('Percentiles 5-95', 'Interpreter', 'latex');
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', [9, 3]); % Set paper size larger than figure
    set(gcf, 'PaperPosition', [0., 0., 9, 3]); % Add 
    print(gcf, '-dpdf', target);
end

