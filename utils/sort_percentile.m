function [tensor, percentile] = sort_percentile(tensor)
    %Sort tensor matrix by specific parameter. 
    % INPUT: tensor of (trials, n_iter, n_params)
    % OUTPUT: same tensor sorted by param-axis and percentile 5-95 for each
    %         trial param
    
    n_trials   = size(tensor, 1);
    n_features = size(tensor, 3);
    percentile = zeros([n_trials, n_features, 2]);
    for i=1:n_trials
        % Sort by parameter 
        current = squeeze(tensor(i, :, :));
        current = sortrows(current, 2, 'ascend');
        P = prctile(current, [25 75], 1);
        percentile(i, :, :) = P';
        tensor(i, :, :) = current;
    end
end

