function Q = SolarHeat(A, alpha, I)
%% ==============================================================
% SOLARHEAT
%
% Calculates the absorbed solar heat by an exposed surface.
%
% Governing Equation:
%       Q = alpha * A * I
%
% Inputs:
%   A       - Surface area (m^2)
%   alpha   - Solar absorptivity (-)
%   I       - Solar irradiance (W/m^2)
%
% Output:
%   Q       - Absorbed solar heat (W)
%
% Author: Anirudh MS
% Version: 1.5
%% ==============================================================

Q = alpha * A * I;

end