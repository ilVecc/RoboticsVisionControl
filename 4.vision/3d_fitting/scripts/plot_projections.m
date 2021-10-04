function [] = plot_projections(M,H)

hold on;
scatter3(M(:,1),M(:,2),M(:,3),'filled','r');
scatter3(H(:,1),H(:,2),H(:,3),'filled','g');
for i=1:size(M,1)
    line([M(i,1) H(i,1)],[M(i,2) H(i,2)],[M(i,3) H(i,3)],'Color','black');
end
hold off;

end

