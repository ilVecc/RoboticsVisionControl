function [best_C, best_D, best_inliers, best_score] = ransac(P,k,th,s,fitFun,distFun)

inlier_score = zeros([k,1]);
inlier_C = zeros([3,k]);
inlier_D = zeros([3,k]);
for i=1:k
    idxs = randsample(size(P,1),s);
    [C,D] = fitFun(P(idxs,:));
    d = distFun(P,C,D);
    inlier_score(i) = sum(d<th);
    inlier_C(:,i) = C;
    inlier_D(:,i) = D;
end
[best_score,i] = max(inlier_score);
best_C = inlier_C(:,i);
best_D = inlier_D(:,i);
best_inliers = distFun(P,best_C,best_D)<th;

end

