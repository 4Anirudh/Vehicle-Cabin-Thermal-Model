function Q = ConvectionHeat(A, h, Ts, Tf)
%% ==============================================================
% CONVECTIONHEAT
%
% Calculates convective heat transfer between a surface and a fluid
% using Newton's Law of Cooling.
%
% Governing Equation:
%       Q = h * A * (Ts - Tf)
%
% Sign Convention:
%   Q > 0 : Heat leaves the surface
%   Q < 0 : Heat enters the surface
%
% Inputs:
%   A   - Surface area (m^2)
%   h   - Convective heat transfer coefficient (W/m^2-K)
%   Ts  - Surface temperature (K)
%   Tf  - Fluid temperature (K)
%
% Output:
%   Q   - Convective heat transfer rate (W)
%
% 
% Version: 1.5
%% ==============================================================

Q = h * A * (Ts - Tf);

end