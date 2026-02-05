function [min_dist_idx] = shortest_distance(x_walker, y_walker, x, y)
    % find the shortest distance
    min_dist_idx = 0;
    min_dist = inf;
    for i = 1 : length(x)
        dist = sqrt((x(i) - x_walker)^2 + (y(i) - y_walker)^2);
        if(dist < min_dist)
            min_dist = dist;
            min_dist_idx = i;
        end
    end
end