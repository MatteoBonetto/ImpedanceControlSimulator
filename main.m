%% Draw initial state
clc;
clear all;
close all;

x_walker = -1;
y_walker = -1;
theta_walker = pi + pi/4;

rng(2)                 % reproducible randomness
N = 250;

dx = randn(1, N);
dy = randn(1, N);

x = cumsum(dx);
y = cumsum(dy);

% smooth it a bit so it’s not jagged
window = 130;
x = smoothdata(x, 'gaussian', window);
y = smoothdata(y, 'gaussian', window);

% scale up
x = 3 * x / max(abs(x));
y = 3 * y / max(abs(y));

draw_path_walker(x, y, x_walker, y_walker, theta_walker);

%% Find the shortest path
% find the shortest distance
min_dist_idx = shortest_distance(x_walker, y_walker, x, y);
draw_path_walker_min_dist(x, y, x_walker, y_walker, theta_walker, min_dist_idx)

%% Reference Point
idx_ref = find_reference(x, y, min_dist_idx);
draw_path_walker_min_dist_ref(x, y, x_walker, y_walker, theta_walker, min_dist_idx, idx_ref)

%% Delta
figure;
draw_path_walker_min_dist_ref_delta(x, y, x_walker, y_walker, theta_walker, min_dist_idx, idx_ref)

%% Simulation Linear
simulation(x_walker, y_walker, theta_walker, x, y, true)

%% Plot force
x = - pi : 0.01 : pi;
k_linear = 0.1 * x;
figure;

plot(rad2deg(x), k_linear);
hold on;
k_atan = 0.1 * atan(x);
plot(rad2deg(x), k_atan);
xlabel("mismatch angle[°]")
ylabel("Force[N]")
legend("Force linear with angle", "attenuated force")

%% Sensor Fusion
% same center
draw_path_walker(x, y, x_walker, y_walker, theta_walker);

C_htc = eye(2) * 0.1;

C_enc = eye(2);
C_enc(1, 1) = 0.4;
C_enc(2, 2) = 0.05;
R = [ cos(theta_walker)  -sin(theta_walker)
      sin(theta_walker)   cos(theta_walker) ];

hold on;
demo_fuse_and_plot([x_walker, y_walker]', R*C_enc*R', [x_walker, y_walker]', C_htc)
hold off;

%% different center
draw_path_walker(x, y, x_walker, y_walker, theta_walker);

C_htc = eye(2) * 0.2;

C_enc = eye(2);
C_enc(1, 1) = 0.4;
C_enc(2, 2) = 0.05;
R = [ cos(theta_walker)  -sin(theta_walker)
      sin(theta_walker)   cos(theta_walker) ];

hold on;
demo_fuse_and_plot([x_walker + 2, y_walker + 2]', R*C_enc*R', [x_walker, y_walker]', C_htc)
hold off;

%% difference sensor with high uncertainty
draw_path_walker(x, y, x_walker, y_walker, theta_walker);

C_htc = eye(2) * 0.2;

C_enc = eye(2);
C_enc(1, 1) = 0.4;
C_enc(2, 2) = 0.05;
C_enc = C_enc .* 20; 
R = [ cos(theta_walker)  -sin(theta_walker)
      sin(theta_walker)   cos(theta_walker) ];

hold on;
demo_fuse_and_plot([x_walker + 2, y_walker + 2]', R*C_enc*R', [x_walker, y_walker]', C_htc)
hold off;