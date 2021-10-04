function [] = plot_multipoint(tk,qk)

h = gcf().Children(end);
hold(h,'on');
scatter(h,tk,qk,144,"r.");
hold(h,'off');

end

