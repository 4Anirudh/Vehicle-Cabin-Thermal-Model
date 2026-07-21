function Q = RadiationHeat(A1, epsilon1, A2, epsilon2, F12, T1, T2)
%% ==============================================================
% RADIATIONHEAT
%
% Calculates the net radiative heat transfer between two diffuse-gray
% surfaces using the radiation resistance network.
%
% Governing Equation:
%
%                  sigma*(T1^4 - T2^4)
% Q = ----------------------------------------------------------
%      (1-e1)/(A1*e1) + 1/(A1*F12) + (1-e2)/(A2*e2)
%
% Sign Convention:
%   Q > 0 : Heat leaves Surface 1
%   Q < 0 : Heat enters Surface 1
%
% Inputs:
%   A1          Surface 1 Area (m^2)
%   epsilon1    Surface 1 Emissivity (-)
%   A2          Surface 2 Area (m^2)
%   epsilon2    Surface 2 Emissivity (-)
%   F12         View Factor from Surface 1 to Surface 2 (-)
%   T1          Surface 1 Temperature (K)
%   T2          Surface 2 Temperature (K)
%
% Output:
%   Q           Net radiative heat transfer (W)
%
% Version: 1.5
%% ==============================================================

% Stefan-Boltzmann Constant (W/m^2-K^4)
sigma = 5.670374419e-8;

% Radiation resistances
R1 = (1 - epsilon1) / (A1 * epsilon1);
Rspace = 1 / (A1 * F12);
R2 = (1 - epsilon2) / (A2 * epsilon2);

% Total resistance
Rtotal = R1 + Rspace + R2;

% Net radiative heat transfer
Q = sigma * (T1^4 - T2^4) / Rtotal;

end