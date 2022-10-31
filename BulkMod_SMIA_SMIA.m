close, clear, clc;
L = 100e-6;
Cp = 50e-6;
R = 100;
Vi = 30;
Ts = 1e-5;
DB = 1 - 2*L/(Ts*R);
DBm = DB * Ts / (2*L);

%%% Bulk modified parameters
mm = 1; % mm = {0, 1, 2}
if mm == 0 % identical
    Lm = L;
    Cpm = Cp;
    Rm = R;
    Vim = Vi;
elseif mm == 1 % -10% RLC // -2% Vi
    Lm = L * 0.9;
    Cpm = Cp * 0.9;
    Rm = R * 0.9;
    Vim = Vi * 0.98;
else % +10% RLC // +2% Vi
    Lm = L * 1.1;
    Cpm = Cp * 1.1;
    Rm = R * 1.1;
    Vim = Vi * 1.02;
end

%%% Controller - Overdamped
ts = 0.01;
lambda = 700;
phi = 0.001 * lambda^2;
Ks = 200 * Vi * lambda / ts;

%%% Simulation
Tr = 0.02;
tf = 3 * Tr;
t_step = 1e-6;
sim('BulkMod_SMIA_SMIA_Sim.slx');

%%% Output
figure(1), set(gcf,'color','w');
subplot(411), plot(t,vcm,'k'), grid on, xlabel('Time [s]');
    ylabel('Capacitor Voltage [V]'), xlim([0,t(end)]);
subplot(412), plot(t,ilm,'k'), grid on, xlabel('Time [s]');
    ylabel('Inductor Current [A]'), xlim([0,t(end)]);
subplot(413), plot(t,d,'k'), grid on, xlabel('Time [s]');
    ylabel('Duty Cycle'), xlim([0,t(end)]);
subplot(414), stairs(t,mp,'k','LineWidth',2), hold on, stairs(t,mc,'r');
    hold off, grid on, xlabel('Time [s]'), ylabel('Conduction Mode');
    legend('Plant','Controller'), xlim([0,t(end)]), ylim([0,1]);
figure(2), set(gcf,'color','w');
plot([0,Vi],[DBm*Vi,0],'r','LineWidth',2), hold on, plot(vcm,ilm,'k'), hold off;
    grid on, xlabel('Capacitor Voltage [V]'), ylabel('Inductor Current [A]');
    title('State Space'), legend('Conduction Mode Boundary','Trajectory');