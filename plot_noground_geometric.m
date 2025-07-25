%% UAV DASHBOARD 


clear h_*;

try
    
    out = evalin('base', 'out');
    disp('Variabile "out" caricata con successo dal workspace.');
catch ME
    if strcmp(ME.identifier, 'MATLAB:evalin:UndefinedFunctionOrVariable')
        error(['La variabile "out" non è stata trovata nel workspace di MATLAB. ' ...
               'Assicurarsi di aver eseguito la simulazione Simulink prima di lanciare questo script.']);
    else
        rethrow(ME);
    end
end

rho = 0.05;

try
    t            = out.pos1.Time;
    xyz          = out.pos1.Data;          
    position_des = out.position_des1.Data;
    uT           = out.u_t1.Data;          
catch ME
    error(['Errore durante l''estrazione dei dati: ', ME.message, ...
           '. Verificare che la variabile "out" contenga i campi "pos1", "position_des1" e "u_t1".']);
end

z_ge = 2 * rho;


len_min = min([length(t), size(xyz,1), size(position_des,1), length(uT)]);
t = t(1:len_min);
xyz = xyz(1:len_min,:);
position_des = position_des(1:len_min,:);
uT = uT(1:len_min);

err_p = xyz - position_des;
err_norm = vecnorm(err_p, 2, 2);

figHandle = figure(404); clf; 
set(figHandle, 'Name', 'UAV Dynamic Dashboard (Control Analysis)', 'NumberTitle', 'off', 'WindowState', 'maximized');
tlo = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tlo, 'UAV Dynamic Dashboard (Control Analysis)', 'FontSize', 14, 'FontWeight', 'bold');

%% 3D Graph
ax1 = nexttile;
hold(ax1, 'on');

plot3(ax1, xyz(:,2), xyz(:,1), xyz(:,3), 'k--', 'LineWidth', 1.2, 'DisplayName', 'Real Trajectory');
plot3(ax1, position_des(:,2), position_des(:,1), position_des(:,3), 'g-', 'LineWidth', 1.5, 'DisplayName', 'Desired Trajectory');
h_drone = plot3(ax1, NaN, NaN, NaN, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Drone');

xlabel(ax1, 'West'); ylabel(ax1, 'North'); zlabel(ax1, 'Up');
set(ax1, 'XDir', 'reverse', 'ZDir', 'reverse');
view(ax1, 94, 15);
axis(ax1, 'equal'); grid(ax1, 'on'); box(ax1, 'on');
title(ax1, '3D Trajectory');
legend(ax1, 'Location', 'northwest');

%% Z 
ax2 = nexttile;
hold(ax2, 'on');
h_z_line = plot(ax2, NaN, NaN, 'b', 'LineWidth', 1.5, 'DisplayName', 'z-component');
xlabel(ax2, 'Time [s]'); ylabel(ax2, 'z-component of the Drone [m]');
title(ax2, 'z-component of the Drone');
grid(ax2, 'on'); legend(ax2, 'Location', 'best');

%% position error
ax3 = nexttile;
hold(ax3, 'on');
h_err_line = plot(ax3, NaN, NaN, 'm', 'LineWidth', 1.5, 'DisplayName', '||e_p||');
xlabel(ax3, 'Time [s]'); ylabel(ax3, 'Position Error [m]');
title(ax3, 'Position Error Norm');
grid(ax3, 'on'); legend(ax3, 'Location', 'best');

%% Thrust 
ax4 = nexttile;
hold(ax4, 'on');
h_uT_line = plot(ax4, NaN, NaN, 'r', 'LineWidth', 1.5, 'DisplayName', 'Thrust u_T');
xlabel(ax4, 'Time [s]'); ylabel(ax4, 'Thrust u_T [N]');
title(ax4, 'Total Thrust');
grid(ax4, 'on'); legend(ax4, 'Location', 'best');

=
linkaxes([ax2, ax3, ax4], 'x');
xlim(ax2, [t(1), t(end)]);
ylim(ax2, [min(min(xyz(:,3)), 0)*1.1 - 0.01, max(xyz(:,3))*1.1 + 0.01]);
ylim(ax3, [0, max(err_norm)*1.1 + 0.01]);
ylim(ax4, [min(uT)*0.95 - 0.01, max(uT)*1.05 + 0.01]);

disp('Inizializzazione registrazione video...');
videoFilename = 'UAV_nogroundeffect.mp4';
videoPlayer = VideoWriter(videoFilename, 'MPEG-4');
videoPlayer.FrameRate = 30;
open(videoPlayer);



animation_step = max(1, floor(length(t) / 500));

for k = 1:animation_step:length(t)
    idx = 1:k;
    
    set(h_drone, 'XData', xyz(k,2), 'YData', xyz(k,1), 'ZData', xyz(k,3));
    
    set(h_z_line,  'XData', t(idx), 'YData', xyz(idx,3));
    set(h_err_line,'XData', t(idx), 'YData', err_norm(idx));
    set(h_uT_line, 'XData', t(idx), 'YData', uT(idx));
    
    subtitle(ax1, sprintf('Time: %.2f s / %.2f s', t(k), t(end)));
    drawnow limitrate;
    
    
    frame = getframe(figHandle);
    writeVideo(videoPlayer, frame);
    
end

subtitle(ax1, sprintf('Animazione Completata (Tempo: %.2f s)', t(end)));

close(videoPlayer);
disp(['Dashboard animato completato. Video salvato come: ', videoFilename]);
