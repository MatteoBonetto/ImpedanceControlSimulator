function [] = simulation(x0, y0, theta0, x_path, y_path, video_flag)
    % Define the range of force values
    N = 1000;
    Fx = ones(1,N) * 70;
    T = zeros(1,N);
    
    % System parameters
    M = 5;
    C = 10;
    K = 0;
    M_w = 5;
    C_w = 20;
    K_w = 500;
    
    R = 10e-2;
    b = 1;
    m = 20;
    mw = 0.5;
    Iwheel = mw * R^2;
    
    % Initialize state variables
    s = zeros(1, N);
    sd = zeros(1, N);
    sdd = zeros(1, N);
    
    delta = zeros(1, N);
    deltad = zeros(1, N);
    deltadd = zeros(1, N);

    x = zeros(1, N);
    y = zeros(1, N);
    
    % Time step and simulation time
    dt = 1/200;
    N_dt = 20;
    v = VideoWriter('my_plot_video.mp4', 'MPEG-4');
    if(video_flag)
        v.FrameRate = 1 / (dt * N_dt);        % frames per second
        open(v);
    end

    % Set up the figure for real-time plotting
    figure(1);
    grid on;
    axis equal;
    %axis([-10 -10 3 3]);
    
    for ii = 1:N
        if ii ~= 1 
            % Update positions and velocities
            x(ii) = x(ii - 1) + sd(ii) * dt * cos(delta(ii));
            y(ii) = y(ii - 1) + sd(ii) * dt * sin(delta(ii));
            delta(ii) = delta(ii - 1) + deltad(ii) * dt;
        else
            % Initial step: compute initial positions and accelerations
            x(ii) = x0;
            y(ii) = y0;
            delta(ii) = theta0;
        end

        % Update
        sdd(ii) = (Fx(ii) - C * sd(ii) - K * s(ii)) / M;
        sd(ii + 1) = sd(ii) + sdd(ii) * dt;
        s(ii + 1) = s(ii) + sd(ii) * dt;

        min_dist_idx = shortest_distance(x(ii), y(ii), x_path, y_path);
        idx_ref = find_reference(x_path, y_path, min_dist_idx);
        variation_angle = create_arc(x(ii), y(ii), delta(ii), x_path, y_path, idx_ref, 1.5, false);
        angle_force = atan(variation_angle) / pi/2;

        deltadd(ii) = (T(ii) - C_w * deltad(ii) + K_w * angle_force) / M_w;
        deltad(ii + 1) = deltad(ii) + deltadd(ii) * dt;
        delta(ii + 1) = delta(ii) + deltad(ii) * dt;
        
        % Visualization update
        if ii > N_dt
            cla; % Clear
            draw_path_walker_min_dist_ref_delta(x_path, y_path, x(ii), y(ii), delta(ii), min_dist_idx, idx_ref)
            drawnow;
            if(video_flag)
                frame = getframe(gcf);
                writeVideo(v, frame);
                if(idx_ref == length(x_path))
                    if(video_flag)
                        close(v)
                    end
                    break;
                end
            end
        end
    end 

end