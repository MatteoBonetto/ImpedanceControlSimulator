function [h] = uncertainty_region(u, Cx)
    %     [V,D] = eig(A) produces a diagonal matrix D of eigenvalues and 
    %     a full matrix V whose columns are the corresponding eigenvectors  
    %     so that A*V = V*D.
    [V, D] = eig(Cx);
    a = diag(sqrt(abs(D))); 
    %circle with unit radius
    dtheta = 0.01;
    theta = 0 : dtheta : 2*pi;
    x = cos(theta);
    y = sin(theta);
    %elipse in origin and without orientation
    x = a(1) * x;
    y = a(2) * y;
    %elipse with the correct orientation in the origin
    points = V * [x; y];
    x = points(1,:);
    y = points(2,:);
    %elipse with the correct orientation in the origin
    x = x + u(1);
    y = y + u(2);
    
    h = plot(x, y);
    xlabel('x[Nm]')
    ylabel('y[Nm]')
    axis equal;
end