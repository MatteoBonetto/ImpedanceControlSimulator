function [] = draw_path_walker(x, y, x_walker, y_walker, theta_walker)
    figure;
    plot(x, y, 'LineWidth', 2)
    hold on;
    axis equal
    grid on
    xlabel('x')
    ylabel('y')
    drawUnicycle(x_walker, y_walker, theta_walker);
    legend("path", "walker", 'Location','best')
    hold off;
end