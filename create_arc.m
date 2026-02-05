function [delta] = create_arc(x_walker, y_walker, theta_walker, x, y, idx_ref, heading, plot_flag)
    % --- arc between walker heading and the walker->reference line ---
    % vector from walker to reference
    vx = x(idx_ref) - x_walker;
    vy = y(idx_ref) - y_walker;
    dist_ref = hypot(vx, vy);

    if dist_ref > 1e-6
        % angle of the line to reference
        ang_line = atan2(vy, vx);
        % normalize angles to [0,2pi)
        ang_walk = wrapTo2Pi(theta_walker);
        ang_line = wrapTo2Pi(ang_line);

        % compute shortest (signed) delta in [-pi, pi]
        delta = ang_line - ang_walk;
        if delta > pi
            delta = delta - 2*pi;
        elseif delta < -pi
            delta = delta + 2*pi;
        end

        if(plot_flag)
            % sample along the short arc from walker heading to the line
            t = linspace(ang_walk, ang_walk + delta, 64);
            arc_x = x_walker + heading * cos(t);
            arc_y = y_walker + heading * sin(t);
    
            % draw arc (use purple, thicker)
            plot(arc_x, arc_y, '-', 'Color', [0.6 0 0.8], 'LineWidth', 4);
        end
    end
end