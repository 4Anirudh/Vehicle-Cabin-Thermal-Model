clear
clc
close all

%% ==============================================================
%% LOAD MODEL PARAMETERS
%% ==============================================================

params = parameters();

%% ==============================================================
%% INITIAL CONDITIONS
%% ==============================================================

T0 = zeros(12,1);

T0(params.ID.Windshield)  = 291;    % K
T0(params.ID.RoofOuter)   = 291;    % K
T0(params.ID.RoofInner)   = 291;    % K
T0(params.ID.Dashboard)   = 291;    % K
T0(params.ID.SeatSurface) = 291;    % K
T0(params.ID.SeatFoam)    = 291;    % K
T0(params.ID.CabinAir)    = 291;    % K
T0(params.ID.Cover)       = 291;    % K
T0(params.ID.SideGlass)   = 291;    % K
T0(params.ID.DoorOuter)   = 291;    % K
T0(params.ID.DoorInner)   = 291;    % K
T0(params.ID.PCM)         = 291;    % K

%% ==============================================================
%% INITIAL TEMPERATURE - AFTER SOLAR SOAK
%% ==============================================================

% T0(params.ID.Windshield)  = 326;    % 60°C
% T0(params.ID.RoofOuter)   = 349;    % 57°C
% T0(params.ID.RoofInner)   = 339;    % 74°C
% T0(params.ID.Dashboard)   = 349;    % 83°C
% T0(params.ID.SeatSurface) = 341;    % 79°C
% T0(params.ID.SeatFoam)    = 322;    % 73°C
% T0(params.ID.CabinAir)    = 333;    % 60°C
% T0(params.ID.Cover)       = 306;    % 30°C (cover off)
% T0(params.ID.SideGlass)   = 323;    % 57°C
% T0(params.ID.DoorOuter)   = 327;    % 70°C
% T0(params.ID.DoorInner)   = 349;    % 72°C
% T0(params.ID.PCM)         = 333;
%% ==============================================================
%% SIMULATION TIME
%% ==============================================================

tspan = [0:60:12*60*60];      % Simulate for _______ seconds

%% ==============================================================
%% SOLVE ODE SYSTEM
%% ==============================================================

options = odeset( ...
    'MaxStep',10, ...
    'RelTol',1e-6, ...
    'AbsTol',1e-8);

[t,T] = ode45(@(t,T) CabinODE(t,T,params), ...
    tspan, ...
    T0, ...
    options);

%% ==============================================================
%% PLOT RESULTS
%% ==============================================================


% Convert simulation time to clock time

time_day = params.solar.StartHour + t/3600;


% Convert Kelvin to Celsius

T_C = T - 273.15;

%% ==============================================================
%% PLOT COLORS
%% ==============================================================

colors = lines(12);


c_Windshield  = colors(params.ID.Windshield,:);
c_RoofOuter   = colors(params.ID.RoofOuter,:);
c_RoofInner   = colors(params.ID.RoofInner,:);
c_Dashboard   = colors(params.ID.Dashboard,:);
c_SeatSurface = colors(params.ID.SeatSurface,:);
c_SeatFoam    = colors(params.ID.SeatFoam,:);
c_CabinAir    = colors(params.ID.CabinAir,:);
c_Cover       = colors(params.ID.Cover,:);
c_SideGlass   = colors(params.ID.SideGlass,:);
c_DoorOuter   = colors(params.ID.DoorOuter,:);
c_DoorInner   = colors(params.ID.DoorInner,:);
c_PCM         = colors(params.ID.PCM,:);


%% ==============================================================
%% COMPLETE MODEL TEMPERATURE PLOT
%% ==============================================================

figure


plot(time_day,T_C,'LineWidth',2)


grid on
box on


xlabel('Time of Day (hr)')

ylabel('Temperature (°C)')


title('Vehicle Cabin Thermal Simulation - Complete Model')


legend( ...
    'Windshield', ...
    'Roof Outer', ...
    'Roof Inner', ...
    'Dashboard', ...
    'Seat Surface', ...
    'Seat Foam', ...
    'Cabin Air', ...
    'Cover', ...
    'Side Glass', ...
    'Door Outer', ...
    'Door Inner', ...
    'PCM', ...
    'Location','best');



%% ==============================================================
%% IMPORTANT CABIN TEMPERATURES PLOT
%% ==============================================================

figure


plot(time_day, T_C(:,params.ID.Dashboard), ...
    'LineWidth',2,...
    'Color',c_Dashboard)

hold on


plot(time_day, T_C(:,params.ID.CabinAir), ...
    'LineWidth',2,...
    'Color',c_CabinAir)


plot(time_day, T_C(:,params.ID.SeatSurface), ...
    'LineWidth',2,...
    'Color',c_SeatSurface)


plot(time_day, T_C(:,params.ID.RoofInner), ...
    'LineWidth',2,...
    'Color',c_RoofInner)


plot(time_day, T_C(:,params.ID.DoorInner), ...
    'LineWidth',2,...
    'Color',c_DoorInner)


plot(time_day, T_C(:,params.ID.PCM), ...
    'LineWidth',2,...
    'Color',c_PCM)



grid on
box on


xlabel('Time of Day (hr)')

ylabel('Temperature (°C)')


title('Major Cabin Component Temperatures')


legend( ...
    'Dashboard', ...
    'Cabin Air', ...
    'Seat Surface', ...
    'Roof Inner', ...
    'Door Inner', ...
    'PCM', ...
    'Location','best')

%% ==============================================================
%% ENVIRONMENT HISTORY
%% ==============================================================

Tamb_history = zeros(length(t),1);

Isolar_history = zeros(length(t),1);


for i = 1:length(t)


    Isolar_history(i) = SolarIntensity(t(i),params);


    Tamb_history(i) = AmbientTemperature(t(i),params);


end

%% ==============================================================
%% IMPORTANT TEMPERATURES WITH ENVIRONMENT CONDITIONS
%% ==============================================================

figure


%% --------------------------------------------------------------
% Component Temperatures
%% --------------------------------------------------------------

yyaxis left


plot(time_day, T_C(:,params.ID.Dashboard), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_Dashboard)

hold on


plot(time_day, T_C(:,params.ID.CabinAir), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_CabinAir)


plot(time_day, T_C(:,params.ID.SeatSurface), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_SeatSurface)


plot(time_day, T_C(:,params.ID.RoofInner), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_RoofInner)


plot(time_day, T_C(:,params.ID.DoorInner), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_DoorInner)


plot(time_day, T_C(:,params.ID.PCM), ...
    'LineWidth',2,...
    'LineStyle','-',...
    'Marker','none',...
    'Color',c_PCM)


%% Ambient temperature (dashed)

plot(time_day, Tamb_history - 273.15, ...
    'LineWidth',2,...
    'LineStyle','--',...
    'Marker','none')


ylabel('Temperature (°C)')


%% --------------------------------------------------------------
% Solar Irradiance
%% --------------------------------------------------------------

yyaxis right


plot(time_day, Isolar_history, ...
    'LineWidth',2,...
    'LineStyle','--',...
    'Marker','none')


ylabel('Solar Irradiance (W/m^2)')


grid on
box on


xlabel('Time of Day (hr)')


title('Cabin Temperatures with Solar and Ambient Conditions')


legend( ...
    'Dashboard', ...
    'Cabin Air', ...
    'Seat Surface', ...
    'Roof Inner', ...
    'Door Inner', ...
    'PCM', ...
    'Ambient Temperature', ...
    'Solar Irradiance', ...
    'Location','best')

%% ==============================================================
%% CABIN AIR TEMPERATURE TABLE
%% ==============================================================

CabinTemperatureTable = table( ...
    T_C(:,params.ID.CabinAir), ...
    'VariableNames', { ...
    'CabinAirTemperature_C'});

disp(CabinTemperatureTable);