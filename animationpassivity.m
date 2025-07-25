

close all;

fprintf('Starting animation preparation...\n');

%% DATA CONFIGURATION AND EXTRACTION

time = squeeze(out.pos.time)';
pos = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';

if isfield(out, 'euler_angles')
    angles = squeeze(out.euler_angles.data)';
else
    warning('Orientation data not found. The drone will not rotate. Please check your Simulink output.');
    angles = zeros(3, length(time));
end


N_samples = length(time);
pos = pos(:, 1:N_samples);
position_des = position_des(:, 1:N_samples);
angles = angles(:, 1:N_samples);


video_filename = 'animationpassivity.mp4';
frame_rate = 30;
total_duration_s = time(end);
target_frames = total_duration_s * frame_rate;
frame_skip = round(length(time) / target_frames);
if frame_skip < 1, frame_skip = 1; end


%% DRONE GEOMETRY DEFINITION
fig = figure('Name', '3D Drone Animation (NED)', 'Position', [100 100 1200 900]);
ax = axes('Parent', fig);
hold(ax, 'on');

drone_transform = hgtransform('Parent', ax);


drone_color = '#C00000'; motor_radius = 0.05; motor_thickness = 0.02; arm_length = 0.20;
arm_width = 0.02; arm_thickness = 0.015; hub_radius = 0.06; hub_thickness = 0.03; axis_length = 0.15;


[X,Y,Z] = cylinder(hub_radius); Z = Z * hub_thickness - (hub_thickness/2);
surf(X, Y, Z, 'FaceColor', drone_color, 'EdgeColor', 'none', 'Parent', drone_transform);
arm_positions = [arm_length, 0; -arm_length, 0; 0, arm_length; 0, -arm_length];
for i = 1:4
    p = [-arm_length/2 -arm_width/2 -arm_thickness/2; arm_length/2 -arm_width/2 -arm_thickness/2; arm_length/2  arm_width/2 -arm_thickness/2; -arm_length/2  arm_width/2 -arm_thickness/2; -arm_length/2 -arm_width/2  arm_thickness/2; arm_length/2 -arm_width/2  arm_thickness/2; arm_length/2  arm_width/2  arm_thickness/2; -arm_length/2  arm_width/2  arm_thickness/2];
    faces = [1 2 3 4; 2 6 7 3; 6 5 8 7; 5 1 4 8; 1 5 6 2; 4 3 7 8];
    angle = atan2(arm_positions(i,2), arm_positions(i,1));
    R_z = [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1];
    p_rotated = (R_z * p')';
    patch('Vertices', p_rotated, 'Faces', faces, 'FaceColor', drone_color, 'EdgeColor', 'none', 'Parent', drone_transform);
    [X,Y,Z] = cylinder(motor_radius); Z = Z * motor_thickness - (motor_thickness/2);
    X = X + arm_positions(i,1); Y = Y + arm_positions(i,2);
    surf(X, Y, Z, 'FaceColor', drone_color, 'EdgeColor', 'none', 'Parent', drone_transform);
end

quiver3(0,0,0, axis_length, 0, 0, 'r', 'LineWidth', 2.5, 'Parent', drone_transform, 'AutoScale', 'off');
quiver3(0,0,0, 0, axis_length, 0, 'g', 'LineWidth', 2.5, 'Parent', drone_transform, 'AutoScale', 'off');
quiver3(0,0,0, 0, 0, axis_length, 'b', 'LineWidth', 2.5, 'Parent', drone_transform, 'AutoScale', 'off');


%% SCENE AND VIDEO WRITER SETUP


plot3(ax, position_des(1,:), position_des(2,:), position_des(3,:), ...
    'Color', [0 0.8 0.2], 'LineStyle', '-', 'LineWidth', 1.5);


actual_trajectory_plot = plot3(NaN, NaN, NaN, 'r-', 'LineWidth', 1.5);

legend(ax, {'Desired Trajectory', 'Actual Trajectory'}, 'Location', 'northwest');


margin = 1.0;
lim_x = [min([pos(1,:), position_des(1,:)])-margin, max([pos(1,:), position_des(1,:)])+margin];
lim_y = [min([pos(2,:), position_des(2,:)])-margin, max([pos(2,:), position_des(2,:)])+margin];
lim_z = [min([pos(3,:), position_des(3,:)])-margin, max([pos(3,:), position_des(3,:)])+margin];
xlim(lim_x); ylim(lim_y); zlim(lim_z);

set(ax, 'ZDir', 'reverse');
xlabel(ax, 'North (m)');
ylabel(ax, 'East (m)');
zlabel(ax, 'Down (m)');
view(ax, 135, 25);
axis(ax, 'equal');
grid(ax, 'on');
title(ax, 'Drone Animation');


writerObj = VideoWriter(video_filename, 'MPEG-4');
writerObj.FrameRate = frame_rate;
open(writerObj);
fprintf('Setup complete. Starting video rendering...\n');

%% ANIMATION AND SAVING LOOP 
try
    for k = 1:frame_skip:length(time)
        
        current_pos = pos(:, k);
        phi = angles(1, k);
        theta = angles(2, k);
        psi = angles(3, k);

        
        R_z = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
        R_y = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
        R_x = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
        R = R_z * R_y * R_x;

       
        T = [R, current_pos; 0, 0, 0, 1];
        
        set(drone_transform, 'Matrix', T);
        
        
        set(actual_trajectory_plot, 'XData', pos(1, 1:k), ...
                                    'YData', pos(2, 1:k), ...
                                    'ZData', pos(3, 1:k));
        
        
        title(ax, sprintf('Drone Animation (t = %.2f s)', time(k)));
        drawnow;

        
        frame = getframe(fig);
        writeVideo(writerObj, frame);
        
        
        if mod(k, round(frame_rate * frame_skip * 2)) == 1
            fprintf('Rendering... Simulation Time: %.2f s / %.2f s\n', time(k), time(end));
        end
    end
    fprintf('Rendering complete.\n');

catch ME
    
    close(writerObj);
    fprintf('ERROR during video creation: %s\n', ME.message);
    rethrow(ME);
end

%% FINALIZATION

close(writerObj);
fprintf('Video successfully saved as: %s\n', video_filename);