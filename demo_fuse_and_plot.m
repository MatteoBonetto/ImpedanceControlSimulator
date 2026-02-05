function demo_fuse_and_plot(mu1, P1, mu2, P2)
    % Example inputs: two estimates (means) and covariance matrices

    % Fuse (information form)
    % guard for singular covariances by regularizing if needed
    eps_reg = 1e-9;
    P1i = inv(P1 + eps_reg*eye(2));
    P2i = inv(P2 + eps_reg*eye(2));
    P_f = inv(P1i + P2i);
    mu_f = P_f * (P1i*mu1 + P2i*mu2);

    % confidence level for ellipse (e.g. 95%)
    conf = 0.35;
    % chi2inv requires Statistics Toolbox; explicit value for 2D:
    k2 = chi2inv(conf, 2);   % ~ 5.991 for conf=0.95
    % If chi2inv not available, uncomment the line below:
    % k2 = 5.991;  % 95% confidence contour for 2 DOF

    %figure('Color','w'); hold on; axis equal; grid on;
    % draw ellipses (filled with transparency)
    plot_cov_ellipse(mu1, P1, k2, [0.2 0.6 1], 0.25, 'Sensor1');
    plot_cov_ellipse(mu2, P2, k2, [0.2 1 0.2], 0.25, 'Sensor2');
    plot_cov_ellipse(mu_f, P_f, k2, [1 0.2 0.2], 0.35, 'Fused');

    hold off
end

function plot_cov_ellipse(mu, P, k2, color, alpha_val, labelText)
    % Plots/confidence ellipse as a filled patch for 2D Gaussian
    % mu: 2x1 center
    % P: 2x2 covariance
    % k2: chi-square threshold (e.g. chi2inv(0.95,2) ~ 5.991)
    % color: RGB triple
    % alpha_val: transparency [0..1]
    % labelText: string (optional)
    if nargin < 6, labelText = ''; end

    % Eigen-decomposition (principal axes)
    [V, D] = eig((P + P')/2);           % ensure symmetric
    ev = abs(diag(D));
    % numerical safety
    ev(ev < 0) = 0;
    % semiaxes lengths
    a = sqrt(k2 * ev(1));
    b = sqrt(k2 * ev(2));
    % angle of rotation (eigenvector for ev(1))
    theta = atan2(V(2,1), V(1,1));

    % parametric ellipse
    t = linspace(0, 2*pi, 200);
    xe = a*cos(t);
    ye = b*sin(t);
    % rotation
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    pts = R * [xe; ye];
    X = mu(1) + pts(1, :);
    Y = mu(2) + pts(2, :);

    % filled patch
    p = patch(X, Y, color, 'FaceAlpha', alpha_val, 'EdgeColor', color*0.8, 'LineWidth', 1);
    if ~isempty(labelText)
        % put a "fake" handle in annotation for legend using invisible line
        h = plot(NaN, NaN, '-', 'Color', color, 'LineWidth', 1.5);
        set(get(get(p,'Annotation'),'LegendInformation'), 'IconDisplayStyle','off'); % hide patch
        set(h, 'DisplayName', labelText);
    end
end
