function [idx_ref] = find_reference(x, y, min_dist_idx)
    delta_s = 1;
    tot_dist = 0;
    idx_ref = 0;
    for i = min_dist_idx : length(x)
        dist = sqrt((x(i) - x(i - 1))^2 + (y(i) - y(i - 1))^2);
        tot_dist = tot_dist + dist; 
        if(tot_dist >= delta_s)
            idx_ref = i;
            break;
        end
    end
    if(idx_ref == 0)
        idx_ref = length(x);
    end
end