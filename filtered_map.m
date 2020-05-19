function output = filtered_map(input, kernel, se, threshold)
% Filters out using a Gaussian kernel
% and removes small objects using grayscale morphology

% notice there's no error or input checks: no warranty 

output = filter2(kernel,input);
mask = abs(output);
mask = imclearborder(mask);
mask(mask < threshold*max(mask(:))) = 0;
mask = imopen(mask,se);
output(~mask) = 0;

