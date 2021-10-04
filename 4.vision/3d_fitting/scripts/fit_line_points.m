function [c,d] = fit_line_points(P)

if ~all(size(P)==[2 3])
    warning('This fitting function only works with 2 points (taking the first two)')
end

c = mean(P(1:2,:),1)';
P1 = P(1,:);
P2 = P(2,:);
d = (P2-P1)'/norm(P2-P1);

end
