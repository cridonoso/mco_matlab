function printpercentile(percentiles, tag)
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
            fprintf('\n=== %s ===\n', tag(i)); % Example header
        end
        disp(T);
    end
end

