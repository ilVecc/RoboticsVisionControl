function [] = plot_line(c,d,L)

P = (c+d*L)';

hold on
scatter3(P(:,1),P(:,2),P(:,3),5,'filled');
hold off

end

