function Cp_eff = PCMEffectiveCp(T,Tm,dT,Cps,Cpl,L)

%% ==============================================================
% Effective heat capacity method for PCM
% ==============================================================

T_low  = Tm - dT/2;
T_high = Tm + dT/2;


if T < T_low

    % Solid PCM
    Cp_eff = Cps;


elseif T > T_high

    % Liquid PCM
    Cp_eff = Cpl;


else

    % Phase change region
    Cp_eff = (Cps+Cpl)/2 + L/dT;


end


end