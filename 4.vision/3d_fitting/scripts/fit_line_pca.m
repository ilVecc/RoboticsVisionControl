function [c,d] = fit_line_pca(P)

assert(size(P,2)>=3,'This fitting function works with at least 3 points')

% 3D line: C + d*L
c = mean(P,1)';  % centroid
[N, E] = eig(cov(P));  % just a simple PCA actually
[~, i] = max(diag(E)); % the biggest eigenvector is the direction
d = N(:,i);  % direction

end

