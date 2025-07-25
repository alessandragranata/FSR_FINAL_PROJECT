
close all

output_folder = 'plotpass_ext';
if ~exist(output_folder, 'dir')
   mkdir(output_folder);
end


time = squeeze(out.pos.time)'; 
pos = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';
err_p = squeeze(out.err_p.data);
dot_err_p = squeeze(out.dot_err_p.data);
err_R = squeeze(out.e_eta.data);
err_W = squeeze(out.e_eta_dot.data);
u_T = squeeze(out.u_t.data);
tau_b = squeeze(out.tau_b.data)';
f_hat = squeeze(out.f_hat.data)';
tau_hat = squeeze(out.tau_hat.data)';
f_e = squeeze(out.f_e.data)';
tau_e = squeeze(out.tau_e.data)';


if iscolumn(u_T)
    u_T = u_T';
end

N_samples = length(time);

f_hat = f_hat(:, 1:N_samples);
tau_hat = tau_hat(:, 1:N_samples);

pos = pos(:, 1:N_samples);
position_des = position_des(:, 1:N_samples);
err_p = err_p(:, 1:N_samples);
dot_err_p = dot_err_p(:, 1:N_samples);
err_R = err_R(:, 1:N_samples);
err_W = err_W(:, 1:N_samples);
tau_b = tau_b(:, 1:N_samples);
f_e = f_e(:, 1:N_samples);
tau_e = tau_e(:, 1:N_samples);



fprintf('--- Controllo Dimensioni (dopo correzione) ---\n');
whos time pos position_des err_p dot_err_p err_R err_W u_T tau_b f_hat tau_hat f_e tau_e
fprintf('-----------------------------------------------\n');


%% POSITION ERROR 
f = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, err_p(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, err_p(2,:), '--', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, err_p(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Position Error','FontSize',20, 'Interpreter','latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Error (m)', 'Interpreter', 'latex')
legend('$e_{p,x}$', '$e_{p,y}$', '$e_{p,z}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(f, fullfile(output_folder, 'position_error.pdf'));

%% LINEAR VELOCITY ERROR 
h = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, dot_err_p(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, dot_err_p(2,:), '--', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, dot_err_p(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Linear Velocity Error','FontSize',20, 'Interpreter','latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Velocity Error (m/s)', 'Interpreter', 'latex')
legend('$\dot{e}_{p,x}$', '$\dot{e}_{p,y}$', '$\dot{e}_{p,z}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(h, fullfile(output_folder, 'linear_velocity_error.pdf'));

%% ORIENTATION ERROR
g = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, err_R(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, err_R(2,:), '-', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, err_R(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Orientation Error','FontSize',20, 'Interpreter','latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Error', 'Interpreter', 'latex')
legend('$e_{R,roll}$', '$e_{R,pitch}$', '$e_{R,yaw}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(g, fullfile(output_folder, 'orientation_error.pdf'));

%% ANGULAR VELOCITY ERROR 
m = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, err_W(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, err_W(2,:), '-', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, err_W(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Angular Velocity Error','FontSize',20, 'Interpreter','latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Velocity Error (rad/s)', 'Interpreter', 'latex')
legend('$\dot{e}_{R,roll}$', '$\dot{e}_{R,pitch}$', '$\dot{e}_{R,yaw}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(m, fullfile(output_folder, 'angular_velocity_error.pdf'));

%% TOTAL THRUST u_T 
y = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, u_T, '-', 'Color', [0, 0.5, 0], 'LineWidth', 1.5);
title('Total Thrust $u_T$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('$u_T$ (N)', 'Interpreter', 'latex')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(y, fullfile(output_folder, 'thrust.pdf'));

%% TORQUE tau_b 
k = figure('Renderer','painters','Position',[10 10 900 700]);
hold on;
plot(time, tau_b(1,:), '-',  'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, tau_b(2,:), '-',  'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, tau_b(3,:), '-',  'Color', [1, 0, 0], 'LineWidth', 1.5);
hold off
title('Control Torque $\tau_b$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('$\tau_b$ (Nm)', 'Interpreter', 'latex')
legend('$\tau_{b,x}$', '$\tau_{b,y}$', '$\tau_{b,z}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(k, fullfile(output_folder, 'torque_tau_b.pdf'));

%%  POSITION vs TIME 
z = figure('Renderer','painters','Position',[10 10 900 700]);
hold on;
plot(time, pos(1,:), '-',  'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, pos(2,:), '--', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, pos(3,:), '-',  'Color', [1, 0, 0], 'LineWidth', 1.5);
hold off
title('Position Components','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Position (m)', 'Interpreter', 'latex')
legend('$x(t)$', '$y(t)$', '$z(t)$', 'Interpreter', 'latex', 'Location','best')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(z, fullfile(output_folder, 'position.pdf'));

%%  DISTURBANCE FORCES: Estimated vs Real 
df = figure('Renderer','painters','Position',[10 10 900 700]);
colors = [1 0 1; 0 0 1; 1 0 0]; 
hold on;

plot(time, f_hat(1,:), '-', 'Color', colors(1,:), 'LineWidth', 1.5);
plot(time, f_hat(2,:), '-', 'Color', colors(2,:), 'LineWidth', 1.5);
plot(time, f_hat(3,:), '-', 'Color', colors(3,:), 'LineWidth', 1.5);

plot(time, f_e(1,:), '--', 'Color', colors(1,:), 'LineWidth', 1.5);
plot(time, f_e(2,:), '--', 'Color', colors(2,:), 'LineWidth', 1.5);
plot(time, f_e(3,:), '--', 'Color', colors(3,:), 'LineWidth', 1.5);
hold off;
title('Disturbance Force Estimation $\hat{f}$ vs $f_e$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Force (N)', 'Interpreter', 'latex')
legend('$\hat{f}_x$', '$\hat{f}_y$', '$\hat{f}_z$', '$f_{e,x}$', '$f_{e,y}$', '$f_{e,z}$', 'Interpreter', 'latex', 'Location','best', 'NumColumns', 2)
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(df, fullfile(output_folder, 'disturbance_forces.pdf'));

%% DISTURBANCE TORQUES: Estimated vs Real 
dt = figure('Renderer','painters','Position',[10 10 900 700]);
colors = [1 0 1; 0 0 1; 1 0 0]; 
hold on;

plot(time, tau_hat(1,:), '-', 'Color', colors(1,:), 'LineWidth', 1.5);
plot(time, tau_hat(2,:), '-', 'Color', colors(2,:), 'LineWidth', 1.5);
plot(time, tau_hat(3,:), '-', 'Color', colors(3,:), 'LineWidth', 1.5);

plot(time, tau_e(1,:), '--', 'Color', colors(1,:), 'LineWidth', 1.5);
plot(time, tau_e(2,:), '--', 'Color', colors(2,:), 'LineWidth', 1.5);
plot(time, tau_e(3,:), '--', 'Color', colors(3,:), 'LineWidth', 1.5);
hold off;
title('Disturbance Torque Estimation $\hat{\tau}$ vs $\tau_e$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('Torque (Nm)', 'Interpreter', 'latex')
legend('$\hat{\tau}_x$', '$\hat{\tau}_y$', '$\hat{\tau}_z$', '$\tau_{e,x}$', '$\tau_{e,y}$', '$\tau_{e,z}$', 'Interpreter', 'latex', 'Location','best', 'NumColumns', 2)
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(dt, fullfile(output_folder, 'disturbance_torques.pdf'));



