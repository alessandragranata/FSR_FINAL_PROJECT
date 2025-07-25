
close all

output_folder = 'plotpass_noest';

%%Estrazione dei dati


time = squeeze(out.pos.time)';
pos = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';
err_p = squeeze(out.err_p.data);
dot_err_p = squeeze(out.dot_err_p.data);
err_R = squeeze(out.e_eta.data);
err_W = squeeze(out.e_etadot.data);
u_T = squeeze(out.u_t.data);
tau_b = squeeze(out.tau_b.data)';

if iscolumn(u_T)
    u_T = u_T';
end

N_samples = length(time);

pos = pos(:, 1:N_samples);
position_des = position_des(:, 1:N_samples);
err_p = err_p(:, 1:N_samples);
dot_err_p = dot_err_p(:, 1:N_samples);
err_R = err_R(:, 1:N_samples);
err_W = err_W(:, 1:N_samples);
tau_b = tau_b(:, 1:N_samples);


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

%%  TOTAL THRUST u_T 
y = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, u_T, '-', 'Color', [0, 0.5, 0], 'LineWidth', 1.5);
title('Total Thrust $u_T$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('Time $t$ (s)', 'Interpreter', 'latex')
ylabel('$u_T$ (N)', 'Interpreter', 'latex')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(y, fullfile(output_folder, 'thrust.pdf'));

%%  TORQUE tau_b 
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