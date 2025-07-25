%% Analisi Ground Effect da dati Simulink (formato timeseries)

% --- Estrazione segnali dal workspace ---
position      = out.pos.Data;
position_des  = out.position_des.Data;
uT            = out.u_t.Data;
GE_factor     = out.GE_factor.Data;
tout          = out.pos.Time;

% --- Calcolo errore di posizione normato ---
err_p = position - position_des;
err_norm = vecnorm(err_p, 2, 2);

% --- Ricostruzione thrust ipotetico senza effetto suolo ---
uT_no_GE = uT .* GE_factor;

% --- Parametro geometrico (rho) ---
rho = 0.05;
z_threshold = 2 * rho;

% --- Creazione figura ---
figure(300); clf;
set(gcf, 'Name', 'Analisi controllo con Ground Effect');

%% 1. Quota Z
subplot(2,2,1);
plot(tout, position(:,3), 'b', 'LineWidth', 1.5); hold on;

% Linea orizzontale per z = 2*rho (se z_threshold > 0)
if z_threshold > 0
    plot(tout, z_threshold * ones(size(tout)), 'r--', 'LineWidth', 1.2);
    % Etichetta posizionata vicino alla fine
    text(tout(end)*0.8, z_threshold*1.05, 'z = 2\rho', 'Color', 'r', 'FontSize', 10);
end

xlabel('Tempo [s]'); ylabel('Quota Z [m]');
title('Quota del drone');
grid on;

%% 2. Errore di posizione
subplot(2,2,2);
plot(tout, err_norm, 'm', 'LineWidth', 1.5);
xlabel('Tempo [s]'); ylabel('e_p [m]');
title('Errore di posizione');
grid on;

%% 3. Ground Effect Factor
subplot(2,2,3);
plot(tout, GE_factor, 'k', 'LineWidth', 1.5);
xlabel('Tempo [s]'); ylabel('GE factor');
title('Ground Effect Factor nel tempo');
grid on;

%% 4. Thrust con vs senza GE
subplot(2,2,4);
plot(tout, uT, 'r', 'LineWidth', 1.5); hold on;
plot(tout, uT_no_GE, 'b--', 'LineWidth', 1.5);
xlabel('Tempo [s]'); ylabel('Thrust u_T');
title('Confronto thrust con / senza GE');
legend('u_T con GE', 'u_T equivalente senza GE');
grid on;