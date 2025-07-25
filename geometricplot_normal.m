%% GEOMETRIC CONTROL WITHOUT GROUND EFFECT
time = squeeze(out.pos.time)';
pos = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';

err_p = squeeze(out.err_p1.data)';
dot_err_p = squeeze(out.dot_err_p1.data)';
err_R = squeeze(out.err_R1.data)';
err_W = squeeze(out.err_W1.data)';
u_T = squeeze(out.u_t1.data)';
tau_b = squeeze(out.tau_b1.data)';
yaw = squeeze(out.yaw1.data)';

%% POSITION ERROR
g = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, err_p(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, err_p(2,:), '--', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, err_p(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Position Error','FontSize',20)
set(gca, 'FontSize',12);
xlabel('t (s)', 'Interpreter', 'latex')
ylabel('Error (m)', 'Interpreter', 'latex')
legend('$e_{p,x}$', '$e_{p,y}$', '$e_{p,z}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(g, 'plotgeom/position_error_noge.pdf');

%% LINEAR VELOCITY ERROR
h = figure('Renderer','painters','Position',[10 10 900 700]);
hold on
plot(time, dot_err_p(1,:), '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, dot_err_p(2,:), '--', 'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, dot_err_p(3,:), '-', 'Color', [1,0,0], 'LineWidth', 1.5);
hold off
title('Linear Velocity Error','FontSize',20)
set(gca, 'FontSize',12);
xlabel('t (s)', 'Interpreter', 'latex')
ylabel('Velocity Error (m/s)', 'Interpreter', 'latex')
legend('$\dot{e}_{p,x}$', '$\dot{e}_{p,y}$', '$\dot{e}_{p,z}$', 'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(h, 'plotgeom/linear_velocity_error_noge.pdf');

%% TOTAL THRUST u_T 
x = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, u_T, '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
title('Thrust $u_T$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('t (s)', 'Interpreter', 'latex')
ylabel('$u_T$ (N)', 'Interpreter', 'latex')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(x, 'plotgeom/thrust_noge.pdf');

%% TORQUE tau_b 
t = figure('Renderer','painters','Position',[10 10 900 700]);
hold on;
plot(time, tau_b(1,:), '-',  'Color', [1, 0, 1], 'LineWidth', 1.5);
plot(time, tau_b(2,:), '-',  'Color', [0, 0, 1], 'LineWidth', 1.5);
plot(time, tau_b(3,:), '-',  'Color', [1, 0, 0], 'LineWidth', 1.5);
hold off
title('Torque $\tau_b$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('t (s)', 'Interpreter', 'latex')
ylabel('$\tau_b$ (Nm)', 'Interpreter', 'latex')
legend('$\tau_{b,x}$', '$\tau_{b,y}$', '$\tau_{b,z}$', ...
    'Interpreter', 'latex', 'Location','northeast')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(t, 'plotgeom/torque_tau_b_noge.pdf');

