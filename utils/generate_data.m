function X = generate_data(n_samples, mu_vector, sigma_vector)
    %GENERATE_DATA Summary of this function goes here
    %   Detailed explanation goes here
    n_features = length(mu_vector);
    X = ones([n_samples, n_features]);
    for i=1:n_features
        X(:, i+1) = sample_normal(n_samples, mu_vector(i), sigma_vector(i));
    end
end
