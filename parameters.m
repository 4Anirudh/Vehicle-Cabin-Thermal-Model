function params = parameters()
%% ==============================================================
% VEHICLE CABIN THERMAL MODEL
% Parameter File
%
% All quantities are in SI Units
%
% Version : 1.5
%% ==============================================================

%% ==============================================================
%% NODE IDs
%% ==============================================================

params.ID.Windshield  = 1;

params.ID.RoofOuter   = 2;
params.ID.RoofInner   = 3;

params.ID.Dashboard   = 4;

params.ID.SeatSurface = 5;
params.ID.SeatFoam    = 6;

params.ID.CabinAir    = 7;

params.ID.Cover       = 8;

params.ID.SideGlass = 9;

params.ID.DoorOuter = 10;

params.ID.DoorInner = 11;

params.ID.PCM = 12;


N = 12;

%% ==============================================================
%% ENVIRONMENTAL PARAMETERS
%% ==============================================================

params.env.T_amb   = 318;          % Ambient Temperature (K)

params.env.I_solar =900;          % Solar Irradiance (W/m^2)

params.env.h_in    = 4;          % Internal Convection Coefficient (W/m^2-K)

%% External convection coefficient

params.env.h_out = 11.95;
% W/m2K
% convection only


%% Sky radiation

params.env.Tsky_offset = 10;
% K
% Tsky = Tamb - 10K

params.env.sigma   = 5.670374419e-8;      % Stefan-Boltzmann Constant (W/m^2-K^4)

%% ==============================================================
%% SURFACE SOLAR ORIENTATION FACTORS
%% ==============================================================

% Accounts for surface inclination relative to solar direction


params.solar.factor_roof = 1.0;
% Roof is approximately horizontal


params.solar.factor_windshield = 0.9;
% Inclined windshield


params.solar.factor_sideglass = 0.75;
% Side/rear glass average


params.solar.factor_dashboard = 1.0;
% Uses transmitted radiation after glazing


params.solar.factor_seat = 1.0;
% Uses transmitted radiation after glazing

params.solar.factor_door = 0.5;

%% ==============================================================
%% SOLAR INTENSITY MODEL
%% ==============================================================

% Options:
% "Constant" : Uses params.env.I_solar
% "Weather"  : Uses downloaded weather data

params.solar.Model = "Weather";


% --------------------------------------------------------------
% Simulation Start Time
% --------------------------------------------------------------
% t = 0 corresponds to this clock time

params.solar.StartHour = 6;     % Hour (24-hour format)


%% ==============================================================
%% AMBIENT TEMPERATURE MODEL
%% ==============================================================

% Options:
% "Constant" : Uses params.env.T_amb
% "Weather"  : Uses downloaded weather data

params.ambient.Model = "Weather";


%% ==============================================================
%% WEATHER DATA
%% ==============================================================

% Options:
% "Manual"    : Uses manually entered weather data
% "Internet"  : Downloads data from Open-Meteo

params.weather.Source = "Internet";


% --------------------------------------------------------------
% Location
% --------------------------------------------------------------
% Gurgaon
% params.weather.latitude  = 28.497472;      
% params.weather.longitude = 77.071417;

params.weather.latitude  = 28.497472;

params.weather.longitude = 77.071417;


% --------------------------------------------------------------
% Date
% --------------------------------------------------------------

params.weather.date = "2026-07-16"; % "yyyy-mm-dd"


% --------------------------------------------------------------
% Download Weather Data
% --------------------------------------------------------------

params = LoadWeatherData(params);


%% ==============================================================
%% VENTILATION PARAMETERS
%% ==============================================================

% --------------------------------------------------------------
% Mass Flow Rate
% --------------------------------------------------------------
% Set mdot = 0 for a closed cabin (no ventilation).
% Increase mdot to simulate natural or forced ventilation.
% Unit : kg/s
% --------------------------------------------------------------

%% ==============================================================
%% BLOWER CONTROL MODEL
%% ==============================================================

% Options:
% "Constant"
% "Temperature"
% "Pulse"

params.vent.ControlModel = "Constant";

%params.vent.mdot_max = 0.12025;
%params.vent.mdot_min = 0.0370;

% Blower flow rates
params.vent.mdot = 0;

params.vent.mdot_off = 0;

params.vent.mdot_on = 0.0370;


% Temperature difference required to activate

params.vent.DeltaT_on = 0;


% Pulse mode settings

params.vent.OnTime = 5*60;      % seconds (5 min)

params.vent.OffTime = 5*60;     % seconds (5 min)

% --------------------------------------------------------------
% Vent Opening Area
% --------------------------------------------------------------
% Effective flow area through which air enters the cabin.
% Used to calculate the average cabin air velocity.
% Unit : m^2
% --------------------------------------------------------------

params.vent.Avent = 0.020;

% --------------------------------------------------------------
% Characteristic Length
% --------------------------------------------------------------
% Representative length of the interior surfaces used for the
% Reynolds and Nusselt number calculations.
% Unit : m
% --------------------------------------------------------------

params.vent.Lchar = 0.50;

% --------------------------------------------------------------
% Air Properties
% --------------------------------------------------------------

params.vent.mu    = 1.90e-5;      % Dynamic Viscosity (Pa.s)

params.vent.kair  = 0.0265;       % Thermal Conductivity (W/m-K)

params.vent.Pr    = 0.71;         % Prandtl Number

%% ==============================================================
%% INTERIOR CONVECTION MODEL
%% ==============================================================

params.vent.ConvModel = "FlatPlate";

%% ==============================================================
%% WINDSHIELD
%% ==============================================================

params.node(params.ID.Windshield).A       = 1.2;     % Area (m^2)

params.node(params.ID.Windshield).m       = 18;     % Mass (kg)

params.node(params.ID.Windshield).Cp      = 840;     % Specific Heat (J/kg-K)

params.node(params.ID.Windshield).alpha   = 0.15;     % Solar Absorptivity

params.node(params.ID.Windshield).epsilon = 0.90;     % Emissivity

params.node(params.ID.Windshield).tau     = 0.75;     % Solar Transmissivity

%% ==============================================================
%% SIDE AND REAR GLAZING
%% ==============================================================

% Represents:
% side windows + rear windshield


params.node(params.ID.SideGlass).A = 2.5;
% m2


params.node(params.ID.SideGlass).m = 25;
% kg


params.node(params.ID.SideGlass).Cp = 840;
% J/kg-K


% --------------------------------------------------------------
% Optical Properties
% --------------------------------------------------------------

params.node(params.ID.SideGlass).alpha = 0.15;
% absorptivity


params.node(params.ID.SideGlass).epsilon = 0.90;
% emissivity


params.node(params.ID.SideGlass).tau = 0.65;
% transmissivity

%% ==============================================================
%% DOOR OUTER PANEL
%% ==============================================================

params.node(params.ID.DoorOuter).A = 4.0;
% m2
% four doors combined


params.node(params.ID.DoorOuter).m = 25;
% kg


params.node(params.ID.DoorOuter).Cp = 900;
% J/kg-K


params.node(params.ID.DoorOuter).alpha = 0.65;
% normal door 
% alpha=65
% epsilon=0.9

% PDRC door 
% alpha=0.05
% epsilon=0.95

params.node(params.ID.DoorOuter).epsilon = 0.9;


params.node(params.ID.DoorOuter).k = 50;
% W/mK


params.node(params.ID.DoorOuter).L = 0.001;
% metal sheet thickness



%% ==============================================================
%% DOOR INNER PANEL
%% ==============================================================

params.node(params.ID.DoorInner).A = 4.0;


params.node(params.ID.DoorInner).m = 20;


params.node(params.ID.DoorInner).Cp = 1200;
% plastics + trim


params.node(params.ID.DoorInner).epsilon = 0.9;


params.node(params.ID.DoorInner).k = 0.05;
% trim


params.node(params.ID.DoorInner).L = 0.015;

%% ==============================================================
%% ROOF OUTER
%% ==============================================================
% normal roof 
% alpha=85
% epsilon=0.9

% PDRC roof 
% alpha=0.05
% epsilon=0.95

params.node(params.ID.RoofOuter).A = 1.60;          % m^2
params.node(params.ID.RoofOuter).m = 8.5;          % kg
params.node(params.ID.RoofOuter).Cp = 500;         % J/kg-K

params.node(params.ID.RoofOuter).k = 50;          % W/m-K
params.node(params.ID.RoofOuter).L = 0.0007;          % m

params.node(params.ID.RoofOuter).alpha = 0.85;      % -
params.node(params.ID.RoofOuter).epsilon = 0.9;    % -


%% ==============================================================
%% ROOF INNER
%% ==============================================================

params.node(params.ID.RoofInner).A = 1.55;          % m^2
params.node(params.ID.RoofInner).m = 2.5;          % kg
params.node(params.ID.RoofInner).Cp = 1400;         % J/kg-K

params.node(params.ID.RoofInner).k = 0.05;          % W/m-K
params.node(params.ID.RoofInner).L = 0.015;          % m

params.node(params.ID.RoofInner).alpha = 0.60;      % -
params.node(params.ID.RoofInner).epsilon = 0.95;    % -

%% ==============================================================
%% DASHBOARD
%% ==============================================================

params.node(params.ID.Dashboard).A        = 1.00;

params.node(params.ID.Dashboard).m        = 8;

params.node(params.ID.Dashboard).Cp       = 1600;

params.node(params.ID.Dashboard).alpha    = 0.90;

params.node(params.ID.Dashboard).epsilon  = 0.95;

params.node(params.ID.Dashboard).phi      = 0.50;
% Fraction of transmitted solar absorbed by dashboard

%% ==============================================================
%% SEAT SURFACE
%% ==============================================================

params.node(params.ID.SeatSurface).A = 1.10;        % m^2
params.node(params.ID.SeatSurface).m = 1.5;        % kg
params.node(params.ID.SeatSurface).Cp = 1500;       % J/kg-K

params.node(params.ID.SeatSurface).k = 0.20;        % W/m-K
params.node(params.ID.SeatSurface).L = 0.002;        % m

params.node(params.ID.SeatSurface).alpha = 0.90;    % -
params.node(params.ID.SeatSurface).epsilon = 0.95;  % -

params.node(params.ID.SeatSurface).phi = 0.25;      % -
% Fraction of transmitted solar absorbed by seats

%% ==============================================================
%% SEAT FOAM
%% ==============================================================

params.node(params.ID.SeatFoam).A = 1.1;           % m^2
params.node(params.ID.SeatFoam).m = 4.5;           % kg
params.node(params.ID.SeatFoam).Cp = 1400;          % J/kg-K

params.node(params.ID.SeatFoam).k = 0.035;           % W/m-K
params.node(params.ID.SeatFoam).L = 0.100;           % m

params.node(params.ID.SeatFoam).alpha = 0.20;       % -
params.node(params.ID.SeatFoam).epsilon = 0.95;     % -

%% ==============================================================
%% SOLAR REFLECTIVE COVER
%% ==============================================================

% Options:
% "On"
% "Off"

%% Cover Controls

params.cover.Roof = "Off";
% Covers roof

params.cover.Windshield = "Off";
% Covers windshield

params.cover.SideGlass = "Off";
% Covers side + rear glazing

params.cover.Door = "Off";
% Covers:Door outer panels.  

% --------------------------------------------------------------
% Geometry
% --------------------------------------------------------------

% Covers roof + windshield


% --------------------------------------------------------------
% Thermal Properties
% --------------------------------------------------------------

params.node(params.ID.Cover).m = 0.25;   % Cover areal density (kg/m²)

params.node(params.ID.Cover).Cp = 1200;
% J/kg-K


% --------------------------------------------------------------
% Optical Properties
% --------------------------------------------------------------

params.node(params.ID.Cover).alpha = 0.15;
% solar absorptivity
% 90% reflection assumption


params.node(params.ID.Cover).epsilon = 0.30;
% long wave emissivity 
% Aluminized
% alpha_c = 0.15;
% epsilon_c = 0.30;

% normal fabric
% alpha_c = 0.5;
% epsilon_c = 0.9;

% --------------------------------------------------------------
% Cover to vehicle heat transfer
% --------------------------------------------------------------

params.cover.h_gap = 7;
% W/m2-K
% for normal car cover use h_gap=2
% for umbrella ca cover use h_gap=7
% Effective heat transfer coefficient
% through air gap between cover and vehicle

%% ==============================================================
%% CABIN AIR
%% ==============================================================

params.node(params.ID.CabinAir).Volume    = 2.5;     % m^3

params.node(params.ID.CabinAir).Density   = 1.11;     % kg/m^3

params.node(params.ID.CabinAir).Cp        = 1005;     % J/kg-K

%% ==============================================================
%% PCM NODE
%% ==============================================================



params.pcm.Model = "Off";


params.node(params.ID.PCM).m = 30;    
% kg


params.node(params.ID.PCM).Tm = 22 + 273.15;
% K


params.node(params.ID.PCM).L = 199000;
% J/kg


params.node(params.ID.PCM).dT = 1;


params.node(params.ID.PCM).Cp_solid = 2710;


params.node(params.ID.PCM).Cp_liquid = 2780;


params.node(params.ID.PCM).epsilon = 0.9;


params.node(params.ID.PCM).h = 5;


%% PCM exposed area calculation

params.pcm.thickness = 0.01;
% m

params.node(params.ID.PCM).rho = 903;


params.node(params.ID.PCM).A = ...
    2 * ...
    (params.node(params.ID.PCM).m / ...
    params.node(params.ID.PCM).rho) ...
    / params.pcm.thickness;

%% ==============================================================
%%PDRC paint Mode
%% ==============================================================
params.PDRCpaint.Model="Off";

if params.PDRCpaint.Model=="On"
    params.node(params.ID.DoorOuter).alpha = 0.05;
    params.node(params.ID.DoorOuter).epsilon = 0.95;
    params.node(params.ID.RoofOuter).alpha = 0.05;      
    params.node(params.ID.RoofOuter).epsilon = 0.95;
end

%% ==============================================================
%%PDRC Cover Mode
%% ==============================================================
params.PDRCcover.Model="Off";

if params.PDRCcover.Model=="On"
    params.node(params.ID.Cover).alpha = 0.18;
    params.node(params.ID.Cover).epsilon = 0.95;
end

%% ==============================================================
%% IR REFLECTIVE GLAZING FILM
%% ==============================================================

% Options:
% "Off" - Standard glazing properties remain unchanged
% "On"  - IR reflective film properties overwrite glazing properties

params.IRFilm.Model = "On";


if params.IRFilm.Model == "On"

    %% ----------------------------------------------------------
    % Windshield with IR Reflective Film
    %% ----------------------------------------------------------

    params.node(params.ID.Windshield).alpha = 0.10;

    params.node(params.ID.Windshield).tau = 0.35;

    params.node(params.ID.Windshield).epsilon = 0.85;


    %% ----------------------------------------------------------
    % Side and Rear Glazing with IR Reflective Film
    %% ----------------------------------------------------------

    params.node(params.ID.SideGlass).alpha = 0.10;

    params.node(params.ID.SideGlass).tau = 0.35;

    params.node(params.ID.SideGlass).epsilon = 0.85;

end
%% ==============================================================
%% RADIATION VIEW FACTOR MATRIX
%% ==============================================================

params.F = zeros(N,N);
ID = params.ID;
% Windshield
params.F(ID.Windshield,ID.RoofInner)   = 0.20;
params.F(ID.Windshield,ID.Dashboard)   = 0.50;
params.F(ID.Windshield,ID.SeatSurface) = 0.30;

% Roof Inner
params.F(ID.RoofInner,ID.Windshield)   = 0.20;
params.F(ID.RoofInner,ID.Dashboard)    = 0.30;
params.F(ID.RoofInner,ID.SeatSurface)  = 0.50;

% Dashboard
params.F(ID.Dashboard,ID.Windshield)   = 0.45;
params.F(ID.Dashboard,ID.RoofInner)    = 0.25;
params.F(ID.Dashboard,ID.SeatSurface)  = 0.30;

% Seat Surface
params.F(ID.SeatSurface,ID.Windshield) = 0.25;
params.F(ID.SeatSurface,ID.RoofInner)  = 0.45;
params.F(ID.SeatSurface,ID.Dashboard)  = 0.30;

% SIDE GLASS VIEW FACTORS

params.F(params.ID.SideGlass,params.ID.Dashboard) = 0.20;

params.F(params.ID.SideGlass,params.ID.SeatSurface) = 0.25;

params.F(params.ID.SideGlass,params.ID.RoofInner) = 0.15;

params.F(params.ID.SideGlass,params.ID.Windshield) = 0.10;

params.F(params.ID.SideGlass,params.ID.DoorInner) = 0.30;

%% ==============================================================
%% DOOR INNER VIEW FACTORS
%% ==============================================================

params.F(params.ID.DoorInner,params.ID.Dashboard) = 0.20;


params.F(params.ID.DoorInner,params.ID.SeatSurface) = 0.30;


params.F(params.ID.DoorInner,params.ID.RoofInner) = 0.20;


params.F(params.ID.DoorInner,params.ID.SideGlass) = 0.20;


params.F(params.ID.DoorInner,params.ID.Windshield) = 0.10;

%% ==============================================================
%% PCM VIEW FACTORS
%% ==============================================================

params.F(params.ID.PCM,params.ID.Dashboard) = 0.25;

params.F(params.ID.PCM,params.ID.SeatSurface) = 0.15;

params.F(params.ID.PCM,params.ID.RoofInner) = 0.25;

params.F(params.ID.PCM,params.ID.DoorInner) = 0.15;

params.F(params.ID.PCM,params.ID.Windshield) = 0.10;

params.F(params.ID.PCM,params.ID.SideGlass) = 0.10;

%Reciprocal
params.F(params.ID.Dashboard,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.Dashboard);


params.F(params.ID.SeatSurface,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.SeatSurface);


params.F(params.ID.RoofInner,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.RoofInner);


params.F(params.ID.DoorInner,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.DoorInner);


params.F(params.ID.Windshield,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.Windshield);


params.F(params.ID.SideGlass,params.ID.PCM) = ...
    params.F(params.ID.PCM,params.ID.SideGlass);
% ---------------------------------------------------------------
% View Factor Matrix- example for a five node system
%
%                 W      D      R      S      A
%
% W               -     Fwd    Fwr    Fws     0
%
% D              Fdw     -     Fdr    Fds     0
%
% R              Frw    Frd     -     Frs     0
%
% S              Fsw    Fsd    Fsr     -      0
%
% A               0      0      0      0      -
%
% Example:
%
% params.F(params.ID.Windshield,params.ID.Dashboard) = NaN;
%
% Fill the values once the cabin geometry is finalized.
%
% ---------------------------------------------------------------

end