
time         = squeeze(out.pos.time)';
pos          = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';
err_p        = squeeze(out.err_p.data)';
dot_err_p    = squeeze(out.dot_err_p.data)';
err_R        = squeeze(out.e_eta.data)';
err_W        = squeeze(out.e_etadot.data)';
u_T          = squeeze(out.u_t.data)';
tau_b        = squeeze(out.tau_b.data)';

close all

f = figure('Renderer','opengl','Position',[10 10 1200 600]);  


plot3(position_des(1,:), position_des(2,:), position_des(3,:), ...
    'Color', [0 0 1], 'LineStyle', '-', 'LineWidth', 1.8, ...
    'DisplayName', 'Desired');
hold on;


plot3(pos(1,:), pos(2,:), pos(3,:), ...
    'Color', [1 0 0], 'LineStyle', '--', 'LineWidth', 1.8, ...
    'DisplayName', 'Actual');


plot3(position_des(1,1), position_des(2,1), position_des(3,1), ...
    'bo', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Start Desired');
plot3(pos(1,1), pos(2,1), pos(3,1), ...
    'ro', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'Start Actual');

xlabel('$x$ (m)', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$y$ (m)', 'Interpreter', 'latex', 'FontSize', 14);
zlabel('$z$ (m)', 'Interpreter', 'latex', 'FontSize', 14);
title('3D Trajectory','FontSize', 20, 'Interpreter', 'latex');

legend('Interpreter', 'latex', 'Location', 'best');

grid on;
axis equal;  
view(3);      
set(gca, 'FontSize', 12);
box on;

exportgraphics(f, 'plothier/trajectory3D.pdf');



