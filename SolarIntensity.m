function Isolar = SolarIntensity(t,params)

%% ==============================================================
% SOLAR INTENSITY MODEL
%
% Calculates solar radiation intensity at the current time
%
% Version : 1.5
%% ==============================================================


model = params.solar.Model;


switch model


    %% ----------------------------------------------------------
    % CONSTANT SOLAR INTENSITY
    %% ----------------------------------------------------------

    case "Constant"


        Isolar = params.env.I_solar;



        %% ----------------------------------------------------------
        % WEATHER DATA BASED SOLAR INTENSITY
        %% ----------------------------------------------------------

    case "Weather"


        % Convert simulation time (seconds)
        % into actual clock hour

        time_hr = params.solar.StartHour + t/3600;


        % Interpolate weather data

        Isolar = interp1( ...
            params.weather.time,...
            params.weather.GHI,...
            time_hr,...
            'pchip');


        % Outside available data range

        if isnan(Isolar)

            Isolar = 0;

        end



        %% ----------------------------------------------------------
        % UNKNOWN MODEL
        %% ----------------------------------------------------------

    otherwise


        error("Unknown solar intensity model selected")


end


end