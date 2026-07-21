function Q = ConductionHeat(R, T1, T2)
%% ==============================================================
% CONDUCTIONHEAT
%
% Calculates conductive heat transfer between two nodes using the
% thermal resistance method.
%
% Governing Equation:
%
%               (T1 - T2)
% Q = -----------------------------
%            R_cond
%
% Sign Convention:
%   Q > 0 : Heat leaves Node 1
%   Q < 0 : Heat enters Node 1
%
% Inputs:
%   R   - Thermal Resistance (K/W)
%   T1  - Temperature of Node 1 (K)
%   T2  - Temperature of Node 2 (K)
%
% Output:
%   Q   - Conductive heat transfer (W)
%
% % Version: 1.5
%% ==============================================================

Q = (T1 - T2) / R;

end