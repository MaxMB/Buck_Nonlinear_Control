close, clear, clc;
L = 100e-6;
Cp = 50e-6;
R = 100;
Vi = 30;
Ts = 1e-5;
DB = 1 - 2*L/(Ts*R);
DBm = DB * Ts / (2*L);

%%% LTI continuous-time model: x' = [vC, iL]
A = [ -1/(R*Cp), 1/Cp; -1/L, 0];
B = [0;  Vi/L];
C = [1, 0];

%%% Controller - Overdamped
p = 0.99; % steady state percentage
dr = 1.2; % damping ratio > 1  ->  damped
ts = 0.01; % settling time
sp2 = log(1-p) / ts;
wn = - sp2 / (dr - sqrt(dr^2 - 1));
sp1 = - (dr + sqrt(dr^2 - 1)) * wn;
K0 = sp1 * sp2;
K1 = - (sp1 + sp2);

%%% Full Prediction Estimator
sp_obs = 4 * sp1 * (cos(pi/3) + 1i*sin(pi/3));
P_obs = [sp_obs; sp_obs'];
L_fpe = place(A', C', P_obs)';

%%% Simulation
Tr = 0.02;
tf = 3 * Tr;
t_step = 1e-6;
sim('Bulk_FL_PP_SE_Sim.slx');

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