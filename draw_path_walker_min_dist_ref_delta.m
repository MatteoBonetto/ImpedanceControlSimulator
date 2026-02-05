function [] = draw_path_walker_min_dist_ref_delta(x, y, x_walker, y_walker, theta_walker, min_dist_idx, idx_ref)

    hold on

    % full path
    plot(x, y, 'LineWidth', 2)

    % ensure correct ordering for the highlighted segment
    idx1 = min(min_dist_idx, idx_ref);
    idx2 = max(min_dist_idx, idx_ref);

    % highlighted path segment
    plot(x(idx1:idx2), y(idx1:idx2), ...
        'Color', [1 0 0 0.35], 'LineWidth', 4)

    % reference point
    scatter(x(idx_ref), y(idx_ref), 80, ...
            'MarkerFaceColor', [1 0 0], ...
            'MarkerFaceAlpha', 0.35, ...
            'MarkerEdgeColor', 'none')

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

    % shortest-distance dashed line to closest point (transparent purple)
    plot([x_walker x(min_dist_idx)], ...
         [y_walker y(min_dist_idx)], ...
         '--', 'Color', [0.6 0 0.8 0.35], 'LineWidth', 1.5)

    % dashed line between walker and reference 
    plot([x_walker x(idx_ref)], ...
         [y_walker y(idx_ref)], ...
         '--', 'Color', [1 0 0], 'LineWidth', 1.5)

    % dashed line between walker and reference 
    v_walker = [cos(theta_walker); sin(theta_walker)];
    heading = 0.5;
    walker_point = [x_walker; y_walker] + v_walker * heading;
    plot([x_walker walker_point(1)], ...
         [y_walker walker_point(2)], ...
         '--', 'Color', [1 0 0], 'LineWidth', 1.5)

    create_arc(x_walker, y_walker, theta_walker, x, y, idx_ref, heading, true);

    % walker pose (draw after the arc so it sits on top)
    drawUnicycle(x_walker, y_walker, theta_walker)

    axis equal
    grid on
    xlabel('x')
    ylabel('y')
    legend('path', "highlighted path segment", "reference point", 'closest point', ...
           'walker position', 'shortest distance to closest', 'line to ref', "heading", 'arc angle', 'walker', 'Location','best')
    hold off;

end
