function [] = draw_path_walker_min_dist_ref(x, y, x_walker, y_walker, theta_walker, min_dist_idx, idx_ref)

    figure; hold on

    % full path
    plot(x, y, 'LineWidth', 2)

    % highlighted path segment
    plot(x(min_dist_idx:idx_ref), y(min_dist_idx:idx_ref), ...
         'r-', 'LineWidth', 4)

    % reference point
    scatter(x(idx_ref), y(idx_ref), 80, 'r', 'filled')

    % closest point (transparent)
    scatter(x(min_dist_idx), y(min_dist_idx), 80, ...
            'MarkerFaceColor', [1 0 0], ...
            'MarkerFaceAlpha', 0.35, ...
            'MarkerEdgeColor', 'none')

    % walker position (transparent)
    scatter(x_walker, y_walker, 80, ...
            'MarkerFaceColor', [1 0 0], ...
            'MarkerFaceAlpha', 0.35, ...
            'MarkerEdgeColor', 'none')

    % shortest-distance dashed line (transparent)
    plot([x_walker x(min_dist_idx)], ...
         [y_walker y(min_dist_idx)], ...
         '--', 'Color', [0.6 0 0.8 0.35], 'LineWidth', 1.5)

    % walker pose
    drawUnicycle(x_walker, y_walker, theta_walker)

    axis equal
    grid on
    xlabel('x')
    ylabel('y')
    legend('path', "highlighted path segment", "reference point", 'closest point', 'walker position', ...
           'shortest distance', 'walker', 'Location','best')
end
