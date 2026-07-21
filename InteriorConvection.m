function hin = InteriorConvection(params)
%% ==============================================================
% INTERIOR CONVECTION COEFFICIENT
%
% Calculates the average interior convective heat transfer
% coefficient based on the selected convection model.
%
% Version : 1.5
%% ==============================================================

%% ==============================================================
%% INPUT PARAMETERS
%% ==============================================================

ConvModel = params.vent.ConvModel;

mdot  = params.vent.mdot;      % kg/s
Avent = params.vent.Avent;     % m^2
Lchar = params.vent.Lchar;     % m

mu    = params.vent.mu;        % Pa.s
kair  = params.vent.kair;      % W/m-K
Pr    = params.vent.Pr;        % -

rho = params.node(params.ID.CabinAir).Density;

hNatural = params.env.h_in;

%% ==============================================================
%% SELECT CONVECTION MODEL
%% ==============================================================

switch ConvModel

    %% ----------------------------------------------------------
    % Constant Convection
    %% ----------------------------------------------------------

    case "Constant"

        hin = hNatural;

    %% ----------------------------------------------------------
    % Flat Plate Forced Convection
    %% ----------------------------------------------------------

    case "FlatPlate"

        % No ventilation
        if mdot == 0

            hin = hNatural;
            return

        end

        % Average cabin air velocity
        Vair = mdot/(rho*Avent);

        % Reynolds Number
        Re = rho*Vair*Lchar/mu;

        % Nusselt Number
        if Re < 5e5

            % Laminar Flow
            Nu = 0.664*Re^0.5*Pr^(1/3);

        else

            % Turbulent Flow
            Nu = 0.037*Re^0.8*Pr^(1/3);

        end

        % Forced Convection Coefficient
        hForced = Nu*kair/Lchar;

        % Total Interior Convection
        hin = hNatural + hForced;

    %% ----------------------------------------------------------
    % Mixed Convection (Future)
    %% ----------------------------------------------------------

    case "Mixed"

        error("Mixed convection model not yet implemented.");

    %% ----------------------------------------------------------
    % Automotive Correlation (Future)
    %% ----------------------------------------------------------

    case "Automotive"

        error("Automotive convection correlation not yet implemented.");

    %% ----------------------------------------------------------
    % Invalid Selection
    %% ----------------------------------------------------------

    otherwise

        error("Unknown interior convection model selected.");

end

end