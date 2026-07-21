function results = TechnologyComparison()

%% ==============================================================
% TECHNOLOGY COMPARISON
%
% Automatically runs all combinations of:
%
%   1. Solar Reflective Cover
%   2. PDRC Paint
%   3. PCM
%   4. Blower - Temperature Model
%
% Cabin air temperature for every case is plotted on one graph.
%
% Version : 1.5
%% ==============================================================


%% ==============================================================
%% LOAD MODEL PARAMETERS
%% ==============================================================

baseParams = parameters();


%% ==============================================================
%% INITIAL CONDITIONS
%% ==============================================================

T0 = zeros(12,1);

T0(baseParams.ID.Windshield)  = 308;
T0(baseParams.ID.RoofOuter)   = 308;
T0(baseParams.ID.RoofInner)   = 308;
T0(baseParams.ID.Dashboard)   = 308;
T0(baseParams.ID.SeatSurface) = 308;
T0(baseParams.ID.SeatFoam)    = 308;
T0(baseParams.ID.CabinAir)    = 308;
T0(baseParams.ID.Cover)       = 308;
T0(baseParams.ID.SideGlass)   = 308;
T0(baseParams.ID.DoorOuter)   = 308;
T0(baseParams.ID.DoorInner)   = 308;
T0(baseParams.ID.PCM)         = 308;


%% ==============================================================
%% SIMULATION TIME
%% ==============================================================

tspan = 0:5:12*60*60;


%% ==============================================================
%% ODE SOLVER OPTIONS
%% ==============================================================

options = odeset( ...
    'MaxStep',10, ...
    'RelTol',1e-6, ...
    'AbsTol',1e-8);


%% ==============================================================
%% DEFINE TEST CASES
%
% Columns:
%
% 1 - Case Name
% 2 - Reflective Cover
% 3 - PDRC Paint
% 4 - PCM
% 5 - Blower
%
%% ==============================================================

cases = {

%   Name                                               Cover Paint PCM Blower

    'Baseline'                                           0    0    0    0

    % Individual Technologies
    'Reflective Cover'                                   1    0    0    0
    'PDRC Paint'                                         0    1    0    0
    'PCM'                                                0    0    1    0
    'Blower'                                             0    0    0    1

    % Two-Technology Combinations
    'Reflective Cover + PDRC Paint'                      1    1    0    0
    'Reflective Cover + PCM'                             1    0    1    0
    'Reflective Cover + Blower'                          1    0    0    1
    'PDRC Paint + PCM'                                   0    1    1    0
    'PDRC Paint + Blower'                                0    1    0    1
    'PCM + Blower'                                       0    0    1    1

    % Three-Technology Combinations
    'Reflective Cover + PDRC Paint + PCM'                1    1    1    0
    'Reflective Cover + PDRC Paint + Blower'             1    1    0    1
    'Reflective Cover + PCM + Blower'                    1    0    1    1
    'PDRC Paint + PCM + Blower'                          0    1    1    1

    % All Technologies
    'Reflective Cover + PDRC Paint + PCM + Blower'       1    1    1    1

    };


%% ==============================================================
%% NUMBER OF CASES AND PLOT COLORS
%% ==============================================================

numCases = size(cases,1);

% Generate one distinct color for every simulation case
plotColors = turbo(numCases);


%% ==============================================================
%% CREATE FIGURE
%% ==============================================================

figure;

hold on;
grid on;
box on;


%% ==============================================================
%% RUN ALL TEST CASES
%% ==============================================================

for i = 1:numCases


    %% ----------------------------------------------------------
    % Case Information
    %% ----------------------------------------------------------

    caseName = cases{i,1};

    reflectiveCover = cases{i,2};

    pdrcPaint = cases{i,3};

    pcm = cases{i,4};

    blower = cases{i,5};


    fprintf( ...
        'Running case %d of %d: %s\n', ...
        i, ...
        numCases, ...
        caseName);


    %% ==========================================================
    %% CREATE LOCAL PARAMETER COPY
    %% ==========================================================

    params = baseParams;


    %% ==========================================================
    %% RESET MODEL TO BASELINE
    %% ==========================================================


    %% ----------------------------------------------------------
    % Reflective Cover OFF
    %% ----------------------------------------------------------

    params.cover.Roof = "Off";

    params.cover.Windshield = "Off";

    params.cover.SideGlass = "Off";

    params.cover.Door = "Off";


    %% ----------------------------------------------------------
    % PCM OFF
    %% ----------------------------------------------------------

    params.pcm.Model = "Off";


    %% ----------------------------------------------------------
    % Blower OFF
    %
    % Constant control with zero mass flow represents
    % the blower-off baseline condition.
    %% ----------------------------------------------------------

    params.vent.ControlModel = "Constant";

    params.vent.mdot = 0;


    %% ----------------------------------------------------------
    % Normal Roof Properties
    %% ----------------------------------------------------------

    params.node(params.ID.RoofOuter).alpha = 0.85;

    params.node(params.ID.RoofOuter).epsilon = 0.90;


    %% ----------------------------------------------------------
    % Normal Door Properties
    %% ----------------------------------------------------------

    params.node(params.ID.DoorOuter).alpha = 0.65;

    params.node(params.ID.DoorOuter).epsilon = 0.90;


    %% ----------------------------------------------------------
    % Standard Reflective Cover Properties
    %% ----------------------------------------------------------

    params.node(params.ID.Cover).alpha = 0.15;

    params.node(params.ID.Cover).epsilon = 0.30;


    %% ==========================================================
    %% APPLY REFLECTIVE COVER
    %% ==========================================================

    if reflectiveCover == 1

        params.cover.Roof = "On";

        params.cover.Windshield = "On";

        params.cover.SideGlass = "On";

        % Door cover excluded due to current model limitation
        params.cover.Door = "Off";


        % Reflective cover optical properties
        params.node(params.ID.Cover).alpha = 0.15;

        params.node(params.ID.Cover).epsilon = 0.30;

    end


    %% ==========================================================
    %% APPLY PDRC PAINT
    %% ==========================================================

    if pdrcPaint == 1

        % Roof
        params.node(params.ID.RoofOuter).alpha = 0.05;

        params.node(params.ID.RoofOuter).epsilon = 0.95;


        % Door Outer
        params.node(params.ID.DoorOuter).alpha = 0.05;

        params.node(params.ID.DoorOuter).epsilon = 0.95;

    end


    %% ==========================================================
    %% APPLY PCM
    %% ==========================================================

    if pcm == 1

        params.pcm.Model = "On";

    end


    %% ==========================================================
    %% APPLY BLOWER
    %
    % Temperature-controlled blower:
    %
    % Blower activates when:
    %
    % Cabin Air Temperature >
    % Ambient Temperature + DeltaT_on
    %
    % Active mass flow rate is defined by:
    %
    % params.vent.mdot_on
    %% ==========================================================

    if blower == 1

        params.vent.ControlModel = "Temperature";

    end


    %% ==========================================================
    %% RUN SIMULATION
    %% ==========================================================

    [t,T] = ode45( ...
        @(t,T) CabinODE(t,T,params), ...
        tspan, ...
        T0, ...
        options);


    %% ==========================================================
    %% CONVERT RESULTS
    %% ==============================================================

    time_day = ...
        params.solar.StartHour ...
        + t/3600;


    T_cabin = ...
        T(:,params.ID.CabinAir) ...
        - 273.15;


    %% ==========================================================
    %% PLOT CABIN AIR TEMPERATURE
    %% ==============================================================

    plot( ...
        time_day, ...
        T_cabin, ...
        'LineWidth',2, ...
        'Color',plotColors(i,:), ...
        'DisplayName',caseName);


    %% ==========================================================
    %% STORE RESULTS
    %% ==============================================================

    results(i).Name = caseName;

    results(i).Time = time_day;

    results(i).CabinTemperature = T_cabin;

    results(i).FinalTemperature = T_cabin(end);

    results(i).PeakTemperature = max(T_cabin);


end


%% ==============================================================
%% FORMAT COMPARISON GRAPH
%% ==============================================================

xlabel('Time of Day (hr)');

ylabel('Cabin Air Temperature (°C)');


title( ...
    'Comparison of Cabin Thermal Management Technologies');


legend( ...
    'Location','eastoutside');


xlim([ ...
    baseParams.solar.StartHour, ...
    baseParams.solar.StartHour ...
    + tspan(end)/3600]);


hold off;


%% ==============================================================
%% CALCULATE TEMPERATURE REDUCTION FROM BASELINE
%% ==============================================================

baselinePeak = results(1).PeakTemperature;

baselineFinal = results(1).FinalTemperature;


for i = 1:length(results)

    results(i).PeakReduction = ...
        baselinePeak ...
        - results(i).PeakTemperature;


    results(i).FinalReduction = ...
        baselineFinal ...
        - results(i).FinalTemperature;

end


%% ==============================================================
%% DISPLAY RESULTS
%% ==============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('TECHNOLOGY COMPARISON RESULTS\n');

fprintf('============================================================\n\n');


fprintf( ...
    '%-55s %12s %12s %15s\n', ...
    'Technology', ...
    'Peak Temp', ...
    'Final Temp', ...
    'Peak Reduction');


fprintf( ...
    '--------------------------------------------------------------------------------------------------\n');


for i = 1:length(results)

    fprintf( ...
        '%-55s %10.2f C %10.2f C %12.2f C\n', ...
        results(i).Name, ...
        results(i).PeakTemperature, ...
        results(i).FinalTemperature, ...
        results(i).PeakReduction);

end


fprintf( ...
    '==================================================================================================\n');


%% ==============================================================
%% CHECK FOR IDENTICAL OR NEAR-IDENTICAL CURVES
%% ==============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('CHECK FOR OVERLAPPING TEMPERATURE CURVES\n');

fprintf('============================================================\n');


tolerance = 0.05;       % °C

overlapFound = false;


for i = 1:length(results)

    for j = i+1:length(results)


        maxDifference = max(abs( ...
            results(i).CabinTemperature ...
            - results(j).CabinTemperature));


        if maxDifference < tolerance

            overlapFound = true;


            fprintf( ...
                '%s\n', ...
                results(i).Name);


            fprintf( ...
                '    overlaps with: %s\n', ...
                results(j).Name);


            fprintf( ...
                '    Maximum difference: %.4f °C\n\n', ...
                maxDifference);

        end

    end

end


if overlapFound == false

    fprintf( ...
        'No curves overlap within the %.2f °C tolerance.\n', ...
        tolerance);

end


fprintf( ...
    '============================================================\n');


end