%% UAV DASHBOARD NED 

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
    t         = out.pos.Time;
    xyz       = out.pos.Data;
    uT        = out.u_t.Data;
    GE_factor = out.GE_factor.Data;
catch ME
    error(['Errore durante l''estrazione dei dati dalla variabile "out": ', ME.message, ...
           '. Verificare che i campi "pos", "u_t" e "GE_factor" esistano.']);
end

z_ge = 2 * rho;


figHandle = figure(404); clf; 
set(figHandle, 'Name', 'UAV Dynamic Dashboard', 'NumberTitle', 'off', 'WindowState', 'maximized');
tlo = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');
title(tlo, 'UAV Dynamic Dashboard', 'FontSize', 14, 'FontWeight', 'bold');

%% 3D graph
ax1 = nexttile;
hold(ax1, 'on');

plot3(ax1, xyz(:,2), xyz(:,1), xyz(:,3), 'k--', 'LineWidth', 1.2, 'DisplayName', 'Traiettoria');

[xp, yp] = meshgrid(floor(min(xyz(:,2)))-1:0.5:ceil(max(xyz(:,2)))+1, ...
                    floor(min(xyz(:,1)))-1:0.5:ceil(max(xyz(:,1)))+1);

surf(ax1, xp, yp, zeros(size(xp)), 'FaceColor', [0.4 0.6 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', 'Ground');
surf(ax1, xp, yp, z_ge * ones(size(xp)), 'FaceColor', [1 0.6 0.2], 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'DisplayName', 'z = 2ρ');

h_drone = plot3(ax1, NaN, NaN, NaN, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Drone');

xlabel(ax1, 'West');
ylabel(ax1, 'North');
zlabel(ax1, 'Up');

set(ax1, 'XDir', 'reverse');
set(ax1, 'ZDir', 'reverse');
view(ax1, 94, 15);
axis(ax1, 'equal'); grid(ax1, 'on'); box(ax1, 'on');
title(ax1, '3D TRAJECTORY');
legend(ax1, 'Location', 'northwest');

%% z
ax2 = nexttile;
hold(ax2, 'on');

plot(ax2, t, z_ge * ones(size(t)), 'r--', 'DisplayName', 'z = 2ρ');
h_z_line = plot(ax2, NaN, NaN, 'b', 'LineWidth', 1.5, 'DisplayName', 'z');

xlabel(ax2, 'Time [s]'); ylabel(ax2, 'z-component of the Drone [m]');
title(ax2, 'z-component of the Drone [m]');
grid(ax2, 'on');
legend(ax2, 'Location', 'best');

%% GE factor 
ax3 = nexttile;
hold(ax3, 'on');
h_ge_line = plot(ax3, NaN, NaN, 'k', 'LineWidth', 1.5);
xlabel(ax3, 'Time [s]'); ylabel(ax3, 'GE Factor');
title(ax3, 'Ground Effect Factor');
grid(ax3, 'on');

%% Thrust 
ax4 = nexttile;
hold(ax4, 'on');
h_uT_line = plot(ax4, NaN, NaN, 'r', 'LineWidth', 1.5);
xlabel(ax4, 'Time [s]'); ylabel(ax4, 'Thrust u_T [N]');
title(ax4, 'Total Thrust');
grid(ax4, 'on');

linkaxes([ax2, ax3, ax4], 'x');

xlim(ax2, [t(1), t(end)]);
ylim(ax2, [min(min(xyz(:,3)), 0)*1.1 - 0.01, max(xyz(:,3))*1.1 + 0.01]);
ylim(ax3, [min(GE_factor)*0.95 - 0.01, max(GE_factor)*1.05 + 0.01]);
ylim(ax4, [min(uT)*0.95 - 0.01, max(uT)*1.05 + 0.01]);

%% recording
disp('Inizializzazione registrazione video...');
videoFilename = 'UAV_groundeffect.mp4';
videoPlayer = VideoWriter(videoFilename, 'MPEG-4');
videoPlayer.FrameRate = 30; 
open(videoPlayer);


animation_step = max(1, floor(length(t) / 500));

for k = 1:animation_step:length(t)
    idx = 1:k;
    
    set(h_drone, 'XData', xyz(k,2), 'YData', xyz(k,1), 'ZData', xyz(k,3));
    
    set(h_z_line,  'XData', t(idx), 'YData', xyz(idx,3));
    set(h_ge_line, 'XData', t(idx), 'YData', GE_factor(idx));
    set(h_uT_line, 'XData', t(idx), 'YData', uT(idx));

    subtitle(ax1, sprintf('Time: %.2f s / %.2f s', t(k), t(end)));
    drawnow limitrate;

    frame = getframe(figHandle);
    writeVideo(videoPlayer, frame);

end

subtitle(ax1, sprintf('Completed (Time: %.2f s)', t(end)));

close(videoPlayer);
disp(['Dashboard animato completato. Video salvato come: ', videoFilename]);
