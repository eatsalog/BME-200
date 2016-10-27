function [Aout] = All(t,vars,params)
%All Summary of this function goes here
%   The function uses variables of different concentrations and solves
%   ordinary differential equations
%The variables and the parameters are defined in the script
S0 = vars(1); 
mhus = 394.5868; %catalytic production rate of active SOS in micrometers^-1*min*-1
Stot = 0.2120; %total concentration of SOS in micromoles
Ks1 = 10.7515; %saturation of inactive SOS on active SOS in micromoles
Ks2 = 1.5844; %saturation of active SOS on inactive SOS in micromoles
deltas = params(1); 
E = params(2);

R0 = vars(2); 
mhur = params(3);
Rtot = 0.2120; %total concentration of Ras in micromoles
Kr1 = 0.0635; %saturation of inactive Ras on active Ras in micromoles
Kr2 = 0.0230; %control of let-7 on Ras in micromoles
Kr3 = 2.5305; %saturation of active Ras on inactive Ras in micromoles
deltar = 319.9672; %degradation rate of active Ras in micromoles*min^-1

Ek0 = vars(3);
mhuek = 49.2683; %catalytic production rate of active ERK in min^-1
Ektot = 1.0599; %total concentration of ERK in micromoles
Kek1 = 1.7795; %saturation of inactive ERK on active ERK in micromoles
Kek2 = 6.1768; %saturation of active ERK on inactive ERK in micromoles
deltaek = 1.8848; %degradation rate of active ERK in micromoles*min^-1

C0 = vars(4);
mhuc = 0.0184; %catalytic production rate of MYC in min^-1
deltac = 0.0231; %degradation rate of MYC protein in min^-1

M0 = vars(5);
mhum = 0.0026; %catalytic production rate of miR-9 in micromoles*min^-1
Km = 22.9606; %saturation of MYC on miR-9 in micromoles^4
deltam = 0.0144; %degradation rate of miR-9 in min^-1

L0 = vars(6);
mhul = 1.3340*10^-5; %catalytic production rate of let-7 in micromoles*min^-1
Kl = 0.2189; %control of MYC on let-7 in micromoles 
deltal = 0.0029; %degradation rate of let-7 in min^-1

H0 = vars(7);
mhuh = 0.2087; %catalytic production rate of E-Cadherin in min^-1
Kh = 1.8*10^-5; %control of MYC on E-Cadherin in micromoles
deltah = 0.0024; %degradation rate of E-Cadherin in min^-1

P0 = vars(8);
mhup = 9.8379*10^-17; %catalytic production rate of MMP in micromoles*min^-1
Kp = 0.1; %control of E-Cadherin on MMP mRNA in micromoles
deltap = 0.0017; %degradation rate of MMP mRNA in min^-1

S = mhus*E*((Stot-S0)/(Stot-S0+Ks1))-deltas*Ek0*(S0/(S0+Ks2));
R = mhur*S0*((Rtot-R0)/(Rtot-R0+Kr1))*(Kr2/(L0+Kr2))-deltar*(R0/(R0+Kr3));
Ek = mhuek*R0*((Ektot-Ek0)/(Ektot-Ek0+Kek1))-deltaek*(Ek0/(Ek0+Kek2));
C = mhuc*Ek0-deltac*C0;
M = mhum*(C0^4/(C0^4+Km))-deltam*M0;
L = mhul*(Kl/(C0+Kl))-deltal*L0;
H = mhuh*L0*(Kh./(Kh+M0))-deltah*H0;
P = mhup-deltap*P0*(H0/(H0+Kp));

Aout = [S; R; Ek; C; M; L; H; P];

end

