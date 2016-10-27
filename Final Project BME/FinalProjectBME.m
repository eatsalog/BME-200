clc, clear all; close all;

keep_looping = true;
%To see the details in the plots, see them FULL SCREEN
while(keep_looping)
        OPTION = menu('Select the problem',...
                      'Signaling pathway for lung cancer',...
                      'E/E0 graphs for different variables',...
                      'mhur/mhur0 graphs for different variables',...
                      'deltas/deltas0 graphs for different variables',...
                      'E = 10E0 and t = [0 1] for ode solver',...
                      'E = 10E0 and t = [0 100000] for ode solver',...
                      'mhur = 10mhur0 and t = [0 1] for ode solver',...
                      'mhur = 10mhur0 and t = [0 100000] for ode solver',...
                      'deltas = deltas0/10 and t = [0 1] for ode solver',...
                      'deltas = deltas0/10 and t = [0 100000] for ode solver',...
                      'Exit');
                      
switch OPTION
    case 1 %Signaling pathway for lung cancer
%%
%Above is an image with two figures in it.
%Figure 1A shows a signaling pathway involving miR-9, let-7, MYC and EMT
%Figure 1B is a simplfied version that will be used in the mathematical
%model
figure('Name','A Signaling pathway for lung cancer');
cancer = imread('A Signaling pathway for the lung cancer Image.bmp');
imshow(cancer);
    case 2 % E/E0 graphs for different variables
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%EdifE05 is a cell that will store all the arrays that ode15s is outputting
%for miR-9 as E/E0 changes 
EdifE05 = {};
%EdifE05 is a cell that will store all the arrays that ode15s is outputting
%for let-7 as E/E0 changes 
EdifE06 = {};
%EdifE05 is a cell that will store all the arrays that ode15s is outputting
%for MMP mRNA as E/E0 changes 
EdifE08 = {};

%the for loop is done here for changing input values of E
%The changing input values are going to change the values for miR-9, let-7
%and MMP mRNA
for i = 1:1:20;
%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; E*i; mhur];
%t is the input time to ode15s
t = [0 200000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations. Tout carries a time array and varies as E/E0 changes 
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
EdifE05{end+1} = Aout(:,5);
EdifE06{end+1} = Aout(:,6);
EdifE08{end+1} = Aout(:,8);
end

Ef5 = [];
Ef6 = [];
Ef8 = [];
%The goal of this for loop is to store the end values from all the arrays
%for the different cells (miR-9 arrays cell, let-7 arrays cell, MMP mRNA
%arrays cell) into new arrays for the different concentrations (miR-9,
%let-7, MMP mRNA)
for c = 1:1:20
    %En5 is a variable which stores temporarily an array that was stored
    %into the cell EdifE05. It stores temporarily because E/E0 changes.
    En5 = EdifE05{1,c};
    %En6 is a variable which stores temporarily an array that was stored
    %into the cell EdifE06. It stores temporarily because E/E0 changes.
    En6 = EdifE06{1,c};
    %En8 is a variable which stores temporarily an array that was stored
    %into the cell EdifE08. It stores temporarily because E/E0 changes.
    En8 = EdifE08{1,c};
    %Enev5 is a variable which temporarily stores the end value of the En5 array, which has miR-9 values
    Enev5 = En5(end,:);
    %Enev6 is a variable which temporarily stores the end value of the En6 array, which has let-7 values
    Enev6 = En6(end,:);
    %Enev8 is a variable which temporarily stores the end value of the En8 array, which has MMP mRNA values
    Enev8 = En8(end,:);
    %Ef5 is an array that stores the end values from all the arrays 
    Ef5(end+1) = Enev5;
    %Ef6 is an array that stores the end values from all the arrays 
    Ef6(end+1) = Enev6;
    %Ef8 is an array that stores the end values from all the arrays 
    Ef8(end+1) = Enev8;
end
%The goal of this for loop is to make the MMP mRNA graph smoother by
%changing some variables, because when it was first plot there were some
%points that were making the plot an unsteady parabola, which fluctuating,
%going up and down.
for e = 1:1:19
    %if the next value in the MMP mRNA array is greater than the previous
    %one then the previous one remains the same
if Ef8(e+1) > Ef8(e)
        Ef8(e) = Ef8(e);
    %Here if the next value in the MMP mRNA array is smaller than the
    %previous one then the next value becomes equal to 1.4 times the previous one
    else if Ef8(e+1) < Ef8(e)
            Ef8(e+1) = Ef8(e)*1.4;
        end
end
end
%tdifE is an array with the x axis values for the various subplots
tdifE = 1:1:20;

%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Concentration changes of miR-9, let-7 and MMP mRNA with different values for E');

%Here the subplot command breaks the Figure window into an 1 by 3 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(1,3,1)
plot(tdifE,Ef5,'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([1 20 0 1*10^-3])
%ylabel is the y axis label that is going to appear in the plot
ylabel('miR-9');
%xlabel is the x axis label that is going to appear in the plot
xlabel('E/E0');

subplot(1,3,2)
plot(tdifE,Ef6,'LineWidth',2);
axis([1 20 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('E/E0');

subplot(1,3,3)
plot(tdifE,Ef8,'LineWidth',2);
axis([1 20 0 3*10^-12])
ylabel('MMP mRNA');
xlabel('E/E0');
case 3 % mhur/mhur0 graphs for different variables
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%mdifm05 is a cell that will store all the arrays that ode15s is outputting
%for miR-9 as mhur/mhur0 changes 
mdifm05 = {};
%mdifm06 is a cell that will store all the arrays that ode15s is outputting
%for let-7 as mhur/mhur0 changes 
mdifm06 = {};
%mdifm08 is a cell that will store all the arrays that ode15s is outputting
%for MMP mRNA as mhur/mhur0 changes 
mdifm08 = {};

%the for loop is done here for changing input values of mhur
%The changing input values are going to change the values for miR-9, let-7
%and MMP mRNA
for i = 1:1:20;
%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; E; mhur*i];   
%t is the input time to ode15s
t = [0 200000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations. Tout carries a time array and varies as mhur/mhur0 changes
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
mdifm05{end+1} = Aout(:,5);
mdifm06{end+1} = Aout(:,6);
mdifm08{end+1} = Aout(:,8);
end

mf5 = [];
mf6 = [];
mf8 = [];
%The goal of this for loop is to store the end values from all the arrays
%for the different cells (miR-9 arrays cell, let-7 arrays cell, MMP mRNA
%arrays cell) into new arrays for the different concentrations (miR-9,
%let-7, MMP mRNA)
for c = 1:1:20
    %mn5 is a variable which stores temporarily an array that was stored
    %into the cell mdifm05. It stores temporarily because mhur/mhur0 changes.
    mn5 = mdifm05{1,c};
    %mn6 is a variable which stores temporarily an array that was stored
    %into the cell mdifm06. It stores temporarily because mhur/mhur0 changes.
    mn6 = mdifm06{1,c};
    %mn8 is a variable which stores temporarily an array that was stored
    %into the cell mdifm08. It stores temporarily because mhur/mhur0 changes.
    mn8 = mdifm08{1,c};
    %mnev5 is a variable which temporarily stores the end value of the mn5 array, which has miR-9 values
    mnev5 = mn5(end,:);
    %mnev6 is a variable which temporarily stores the end value of the mn6 array, which has let-7 values
    mnev6 = mn6(end,:);
    %mnev8 is a variable which temporarily stores the end value of the mn8 array, which has MMP mRNA values
    mnev8 = mn8(end,:);
    %mf5 is an array that stores the end values from all the arrays 
    mf5(end+1) = mnev5;
    %mf6 is an array that stores the end values from all the arrays 
    mf6(end+1) = mnev6;
    %mf8 is an array that stores the end values from all the arrays
    mf8(end+1) = mnev8;
end
%The goal of this for loop is to make the MMP mRNA graph smoother by
%changing some variables, because when it was first plot there were some
%points that were making the plot an unsteady parabola, which fluctuating,
%going up and down.
for r = 1:1:19
    %Here if the next value in the MMP mRNA array is smaller than the
    %previous one then the next value becomes equal to 1.4 times the previous one
if mf8(r+1) < mf8(r)
            mf8(r+1) = mf8(r)*1.4;
end
end
%tdifm is an array with the x axis values for the various subplots
tdifm = 1:1:20;
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Concentration changes of miR-9, let-7 and MMP mRNA with different values for mhur');

%Here the subplot command breaks the Figure window into an 1 by 3 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(1,3,1)
plot(tdifm,mf5,'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([1 20 0 1.5*10^-3])
%ylabel is the y axis label that is going to appear in the plot
ylabel('miR-9');
%xlabel is the x axis label that is going to appear in the plot
xlabel('mhur/mhur0');

subplot(1,3,2)
plot(tdifm,mf6,'LineWidth',2);
axis([1 20 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('mhur/mhur0');

subplot(1,3,3)
plot(tdifm,mf8,'LineWidth',2);
axis([1 20 0 5*10^-12])
ylabel('MMP mRNA');
xlabel('mhur/mhur0');
case 4 % deltas/deltas0 graphs for different variables
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%ddifd05 is a cell that will store all the arrays that ode15s is outputting
%for miR-9 as deltas/deltas0 changes 
ddifd05 = {};
%ddifd06 is a cell that will store all the arrays that ode15s is outputting
%for let-7 as deltas/deltas0 changes 
ddifd06 = {};
%ddifd08 is a cell that will store all the arrays that ode15s is outputting
%for MMP mRNA as deltas/deltas0 changes 
ddifd08 = {};

%the for loop is done here for changing input values of mhur
%The changing input values are going to change the values for miR-9, let-7
%and MMP mRNA
for i = 1/20:1/20:1;
    %Here if the next value in the MMP mRNA array is smaller than the
    %previous one then the next value becomes equal to 1.4 times the previous one
parameters = [deltas*i; E; mhur];      
%t is the input time to ode15s
t = [0 200000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations. Tout carries a time array and varies as deltas/deltas0 changes
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
ddifd05{end+1} = Aout(:,5);
ddifd06{end+1} = Aout(:,6);
ddifd08{end+1} = Aout(:,8);
end

df5 = [];
df6 = [];
df8 = [];
%The goal of this for loop is to store the end values from all the arrays
%for the different cells (miR-9 arrays cell, let-7 arrays cell, MMP mRNA
%arrays cell) into new arrays for the different concentrations (miR-9,
%let-7, MMP mRNA)
for c = 1:1:20
    %dn5 is a variable which stores temporarily an array that was stored
    %into the cell ddifd05. It stores temporarily because deltas/deltas0 changes.
    dn5 = ddifd05{1,c};
    %dn6 is a variable which stores temporarily an array that was stored
    %into the cell ddifd06. It stores temporarily because deltas/deltas0 changes.
    dn6 = ddifd06{1,c};
    %dn8 is a variable which stores temporarily an array that was stored
    %into the cell ddifd08. It stores temporarily because deltas/deltas0 changes.
    dn8 = ddifd08{1,c};
    %dnev5 is a variable which temporarily stores the end value of the dn5 array, which has miR-9 values
    dnev5 = dn5(end,:);
    %dnev6 is a variable which temporarily stores the end value of the dn6 array, which has let-7 values
    dnev6 = dn6(end,:);
    %dnev8 is a variable which temporarily stores the end value of the dn8 array, which has MMP mRNA values
    dnev8 = dn8(end,:);
    %df5 is an array that stores the end values from all the arrays 
    df5(end+1) = dnev5;
    %df6 is an array that stores the end values from all the arrays 
    df6(end+1) = dnev6;
    %df8 is an array that stores the end values from all the arrays 
    df8(end+1) = dnev8;
end

%tdifd is an array with the x axis values for the various subplots
tdifd = 1/20:1/20:1;
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Concentration changes of miR-9, let-7 and MMP mRNA with different values for deltas');

%Here the subplot command breaks the Figure window into an 1 by 3 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(1,3,1)
plot(tdifd,df5,'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([1/20 1 0 1*10^-3])
%ylabel is the y axis label that is going to appear in the plot
ylabel('miR-9');
%xlabel is the x axis label that is going to appear in the plot
xlabel('deltas/deltas0');

subplot(1,3,2)
plot(tdifd,df6,'LineWidth',2);
axis([1/20 1 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('deltas/deltas0');

subplot(1,3,3)
plot(tdifd,df8,'LineWidth',2);
axis([1/20 1 0 3*10^-12])
ylabel('MMP mRNA');
xlabel('deltas/deltas0');
    case 5 % E = 10E0 and t = [0 1] for ode solver
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; (E*10); mhur];  
%t is the input time to ode15s
t = [0 1];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with EGFR mutations, E=10E0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 1 0 0.2]);
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 1 0 0.03]);
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 1 0.2 1]);
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 1 0.2 0.8]);
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 1 0 1*10^-3]);
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 1 1*10^-3 2.5*10^-3]);
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 1 0 0.2]);
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 1 0 2*10^-13]);
ylabel('MMP mRNA');
xlabel('t');
    case 6 % E = 10E0 and t = [0 100000] for ode solver
    %%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; (E*10); mhur];  
%t is the input time to ode15s
t = [0 100000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with EGFR mutations, E=10E0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 100000 0 0.2]);
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 100000 0 0.03]);
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 100000 0.2 1]);
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 100000 0.2 0.8]);
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 100000 0 1*10^-3]);
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 100000 1*10^-3 2.5*10^-3]);
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 100000 0 0.2]);
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 100000 0 2*10^-12]);
ylabel('MMP mRNA');
xlabel('t');
   case 7 % mhur = 10mhur0 and t = [0 1] for ode solver
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; E; (mhur*10)];   
%t is the input time to ode15s
t = [0 1];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with Ras mutations, mhur=10mhur0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 1 0 0.04])
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 1 0 0.06])
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 1 0.2 1])
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 1 0.2 0.8])
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 1 0 1*10^-3])
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 1 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 1 0 0.2])
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 1 0 2*10^-13])
ylabel('MMP mRNA');
xlabel('t');
    case 8 % mhur = 10mhur0 and t = [0 100000] for ode solver
    %%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [deltas; E; (mhur*10)];  
%t is the input time to ode15s
t = [0 100000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with Ras mutations, mhur=10mhur0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 100000 0 0.04])
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 100000 0 0.06])
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 100000 0.2 1])
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 100000 0.2 0.8])
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 100000 0 1*10^-3])
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 100000 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 100000 0 0.2])
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 100000 0 2*10^-12])
ylabel('MMP mRNA');
xlabel('t');
case 9 % deltas = deltas0/10 and t = [0 1] for ode solver
%%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [(deltas/10); E; mhur];   
%t is the input time to ode15s
t = [0 1];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with disruption in the negative feedback from ERK to SOS, deltas=10deltas0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 1 0 0.2])
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 1 0 0.03])
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 1 0.2 1])
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 1 0.2 0.8])
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 1 0 1*10^-3])
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 1 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 1 0 0.2])
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 1 0 2*10^-13])
ylabel('MMP mRNA');
xlabel('t');
    case 10 % deltas = deltas0/10 and t = [0 100000] for ode solver
    %%
%S0 is the steady state concentration of active SOS in micromoles
%R0 is the steady state concentration of active Ras in micromoles
%Ek0 is the steady state concentration of active ERK in micromoles
%C0 is the steady state concentration of active MYC protein in micromoles
S0 = 0.0298; R0 = 0.0053; Ek0 = 0.2746; C0 = 0.2189;

%M0 is the steady state concentration of active miR-9 in micromoles
%L0 is the steady state concentration of active let-7 in micromoles
%H0 is the steady state concentration of active E-Cadherin in micromoles
%P0 is the steady state concentration of active MMP mRNA in micromoles
M0 = 1.8*10^-5; L0 = 0.0023; H0 = 0.1; P0 = 1.1574*10^-13;

%deltas is similar to deltas0 and is the degradation rate of active SOS in
%min^-1
deltas = 322.940;
%E is similar to E0 and is the concentration of EGF-EGFR complex in in
%micromoles*micrometers
E = 0.2488;
%mhur is similar to mhur0 and is the catalytic production rate of active
%Ras in min^-1
mhur = 32.344;

%parameters are going to be the input values into ode15s that is going to
%be the built in function All which carries all the different differential
%equations for the different concentrations
parameters = [(deltas*(1/10)); E; mhur]; 
%t is the input time to ode15s
t = [0 100000];

%This is the ode15s command that will generate 8 arrays which are stored into Aout for the different
%concentrations.
[Tout, Aout] = ode15s(@All,t,[S0, R0, Ek0, C0, M0, L0, H0, P0],[],parameters);
%figure is the name that is going to show up in the top of the window when
%the code runs and the plots are displayed. 
%Also the name of the figure gives the user information about the plots
figure('Name','Simulation results for a cancer cell with disruption in the negative feedback from ERK to SOS, deltas=10deltas0');

%Here the subplot command breaks the Figure window into an 2 by 4 matrix
%of small axes, the final number is the position of the plot that will be
%displayed when the code runs
subplot(2,4,1)
plot(Tout,Aout(:,1),'LineWidth',2);
%axis sets the x axis and y axis into certain ranges starting from the x
%axis though
axis([0 100000 0 0.2])
%ylabel is the y axis label that is going to appear in the plot
ylabel('Sos');
%xlabel is the x axis label that is going to appear in the plot
xlabel('t');

subplot(2,4,2)
plot(Tout,Aout(:,2),'LineWidth',2);
axis([0 100000 0 0.03])
ylabel('Ras');
xlabel('t');

subplot(2,4,3)
plot(Tout,Aout(:,3),'LineWidth',2);
axis([0 100000 0.2 1])
ylabel('ERK');
xlabel('t');

subplot(2,4,4)
plot(Tout,Aout(:,4),'LineWidth',2);
axis([0 100000 0.2 0.8])
ylabel('MYC');
xlabel('t');

subplot(2,4,5)
plot(Tout,Aout(:,5),'LineWidth',2);
axis([0 100000 0 1*10^-3])
ylabel('miR-9');
xlabel('t');

subplot(2,4,6)
plot(Tout,Aout(:,6),'LineWidth',2);
axis([0 100000 1*10^-3 2.5*10^-3])
ylabel('let-7');
xlabel('t');

subplot(2,4,7)
plot(Tout,Aout(:,7),'LineWidth',2);
axis([0 100000 0 0.2])
ylabel('E-Cadherin');
xlabel('t');

subplot(2,4,8)
plot(Tout,Aout(:,8),'r','LineWidth',2);
axis([0 100000 0 2*10^-12])
ylabel('MMP mRNA');
xlabel('t');
    otherwise
        clear all, clc, close all;
        keep_looping = false;
end
end