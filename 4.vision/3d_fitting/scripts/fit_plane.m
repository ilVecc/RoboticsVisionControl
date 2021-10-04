function [c,n] = fit_plane(P)

% 3D plane: ax + by + cz + d = 0
c = mean(P,1)';  % centroid [d = -n*c]
[U, E] = eig(cov(P));  % just a simple PCA actually
[~, i] = min(diag(E)); % the smallest eigenvector is the normal
n = U(:,i);  % normal [a b c]

end

