function [] = draw_path_walker_min_dist(x, y, x_walker, y_walker, theta_walker, min_dist_idx)
    figure; hold on
    plot(x, y, 'LineWidth', 2)                      % path
    
    scatter(x(min_dist_idx), y(min_dist_idx), 80, ...
            'r', 'filled')                               % closest point
    
    scatter(x_walker, y_walker, 80, ...
            'r', 'filled')                               % walker red dot
    
    plot([x_walker x(min_dist_idx)], ...
         [y_walker y(min_dist_idx)], ...
         '--', 'Color', [0.6 0 0.8], 'LineWidth', 1.5)   % purple dashed line
    
    drawUnicycle(x_walker, y_walker, theta_walker)       % walker pose
    
    axis equal
    grid on
    xlabel('x')
    ylabel('y')
    legend('path', 'closest point', 'walker position', ...
           'shortest distance', 'walker', 'Location','best')
end