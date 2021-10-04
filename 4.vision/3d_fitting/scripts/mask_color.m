function [Pcol] = mask_color(color,mask)

Cr = color(:,:,1);
Cg = color(:,:,2);
Cb = color(:,:,3);
Pcol = double([Cr(mask), Cg(mask), Cb(mask)])/255;

end

