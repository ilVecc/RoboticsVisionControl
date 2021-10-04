% PrimeSense Carmine cameras
fx = 525;
fy = 525;
u0 = 319.5;  % principal point
v0 = 239.5;
color = imread('0000001-000000000000.jpg');  % RGB
depth = imread('0000001-000000000000.png');  % [mm]

%imagesc(depth);
%colorbar;


[n, m] = size(depth);
[x, y] = meshgrid(1:m, 1:n);
% filter too far points
near = 0 < depth & depth < 1750;
% computer 3D points
Zc = double(depth(near));
Xc = (x(near)-u0).*Zc/fx;
Yc = (y(near)-v0).*Zc/fy;
clear x y;
P = [Xc, Yc, Zc];

% add color
Cr = double(color(:,:,1));
Cg = double(color(:,:,2));
Cb = double(color(:,:,3));
C = [Cr(near), Cg(near), Cb(near)]/255;

% naive plot
scatter3(Xc, Yc, Zc, 6, C, '.');

%% save point cloud as .ply
ptCloud = pointCloud(P, 'Color', C);
pcshow(ptCloud);
pcwrite(ptCloud, 'output_cloud.ply');


%% create mesh
% warning: this take EONS to compute
% a handy ply_data.mat file contains the results
V = P;
ind = reshape(1:n*m, n, m);
near_ind = ind(near);

count = 1;
F = zeros(2*n*m,3);
for i=1:m-1  % col
    for j=1:n-1  % row
        
        anti = false;
        if near(j+1,i) && near(j+1,i+1) && near(j,i+1)
            % (BL, BR, UR) triangle
            ind_bl = sub2ind([n m], j+1, i);
            ind_br = sub2ind([n m], j+1, i+1);
            ind_ur = sub2ind([n m], j, i+1);
            f = [find(near_ind == ind_bl) ...
                 find(near_ind == ind_br) ...
                 find(near_ind == ind_ur)];
            F(count,:) = f;
            count = count + 1;
            anti = true;
        end
        
        if near(j,i)
            if near(j+1,i)
                if near(j,i+1)
                    % (UL, BL, UR) triangle
                    ind_ul = sub2ind([n m], j, i);
                    ind_bl = sub2ind([n m], j+1, i);
                    ind_ur = sub2ind([n m], j, i+1);
                    f = [find(near_ind == ind_ul) ...
                         find(near_ind == ind_bl) ...
                         find(near_ind == ind_ur)];
                    F(count,:) = f;
                    count = count + 1;
                else
                    if ~anti && near(j+1,i+1)
                        % (UL, BL, BR) triangle
                        ind_ul = sub2ind([n m], j, i);
                        ind_bl = sub2ind([n m], j+1, i);
                        ind_br = sub2ind([n m], j+1, i+1);
                        f = [find(near_ind == ind_ul) ...
                             find(near_ind == ind_bl) ...
                             find(near_ind == ind_br)];
                        
                        F(count,:) = f;
                        count = count + 1;
                    end
                end
            else
                if ~anti && near(j,i+1) && near(j+1,i+1)
                    % (UL, BR, UR) triangle
                    ind_ul = sub2ind([n m], j, i);
                    ind_br = sub2ind([n m], j+1, i+1);
                    ind_ur = sub2ind([n m], j, i+1);
                    f = [find(near_ind == ind_ul) ...
                         find(near_ind == ind_br) ...
                         find(near_ind == ind_ur)];
                    F(count,:) = f;
                    count = count + 1;
                end
            end
        end
        
    end
end
F = F(1:(count-1), :);

clear ind_ul ind_bl ind_br ind_ur


%% export the mesh
exportMeshToPly(V, F, C, 'output_mesh');











