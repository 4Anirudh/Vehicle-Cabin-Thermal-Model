function Qvent = VentilationHeat(Tamb, Ta, params)
%% ==============================================================
% VENTILATION HEAT TRANSFER
%
% Calculates the heat transfer due to ventilation using the
% steady-flow energy equation.
%
% Positive Qvent  : Cabin gains heat
% Negative Qvent  : Cabin loses heat
%
% Version : 1.5
%% ==============================================================

%% ==============================================================
%% INPUT PARAMETERS
%% ==============================================================

mdot = params.vent.mdot;                     % kg/s

Cp = params.node(params.ID.CabinAir).Cp;    % J/kg-K

%% ==============================================================
%% VENTILATION HEAT TRANSFER
%% ==============================================================

Qvent = mdot*Cp*(Tamb - Ta);

end