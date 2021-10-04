function [a] = angle_between_lines(D1,D2)

% just calculate angle between the two directions
a = acosd((D1'*D2)/(norm(D1)*norm(D2)));

end

