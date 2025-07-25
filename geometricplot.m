%% GEOMETRIC CONTROL WITH GROUND EFFECT
time = squeeze(out.pos.time)';
pos = squeeze(out.pos.data)';
position_des = squeeze(out.position_des.data)';

err_p = squeeze(out.err_p.data)';
dot_err_p = squeeze(out.dot_err_p.data)';
err_R = squeeze(out.err_R.data)';
err_W = squeeze(out.err_W.data)';
u_T = squeeze(out.u_t.data)';
tau_b = squeeze(out.tau_b.data)';
yaw = squeeze(out.yaw.data)';
GE_factor = squeeze(out.GE_factor.data)';


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
exportgraphics(g, 'plotgeom/position_error.pdf');

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
exportgraphics(h, 'plotgeom/linear_velocity_error.pdf');


%% TOTAL THRUST u_T
x = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, u_T, '-', 'Color', [1, 0, 1], 'LineWidth', 1.5);
title('Thrust $u_T$','FontSize',20, 'Interpreter', 'latex')
set(gca, 'FontSize',12);
xlabel('t (s)', 'Interpreter', 'latex')
ylabel('$u_T$ (N)', 'Interpreter', 'latex')
xlim([min(time) max(time)])
grid on; box on;
exportgraphics(x, 'plotgeom/thrust.pdf');

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
exportgraphics(t, 'plotgeom/torque_tau_b.pdf');


%% ALTITUDE  
z_altitude = pos(3,:);  
GE = GE_factor;         


f_alt = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, z_altitude, '-', 'Color', [0.1, 0.6, 0.1], 'LineWidth', 1.8);
ylabel('Altitude $z$ (m)', 'Interpreter', 'latex');
xlabel('t (s)', 'Interpreter', 'latex');
title('Drone Altitude','FontSize',20, 'Interpreter', 'latex');
xlim([min(time), max(time)]);
ylim([min(z_altitude)*0.9, max(z_altitude)*1.1]);
legend({'$z$ (altitude)'}, 'Interpreter', 'latex', 'Location','best');
set(gca, 'FontSize',12);
grid on; box on;
exportgraphics(f_alt, 'plotgeom/altitude.pdf');

%% GROUND EFFECT FACTOR 
GE = GE_factor;  

f_ge = figure('Renderer','painters','Position',[10 10 900 700]);
plot(time, GE, '--', 'Color', [0.85, 0.33, 0.1], 'LineWidth', 1.8);
ylabel('Ground Effect Factor', 'Interpreter', 'latex');
xlabel('t (s)', 'Interpreter', 'latex');
title('Ground Effect Factor','FontSize',20, 'Interpreter', 'latex');
xlim([min(time), max(time)]);
ylim([min(GE)*0.9, max(GE)*1.1]);
legend({'GE factor'}, 'Interpreter', 'latex', 'Location','best');
set(gca, 'FontSize',12);
grid on; box on;
exportgraphics(f_ge, 'plotgeom/ground_effect.pdf');
