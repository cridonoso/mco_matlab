function X = sample_normal(n_samples, mu, sigma)
    %  SAMPLE_NORMAL Generate random samples from a normal distribution,
    %  with specified mean (mu) and standard deviation (sigma).
    %
    %   INPUTS:
    %       n_samples - Number of random samples to generate (positive integer).
    %       mu        - Mean of the normal distribution (scalar).
    %       sigma     - Standard deviation of the normal distribution (scalar).
    %
    %   OUTPUT:
    %       X         - A column vector containing n_samples random values drawn  
    %
    X = sqrt(sigma)* randn(n_samples, 1) + mu;
end

