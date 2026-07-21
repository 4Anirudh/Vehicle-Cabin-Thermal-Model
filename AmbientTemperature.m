function Tamb = AmbientTemperature(t,params)

%% ==============================================================
% AMBIENT TEMPERATURE MODEL
%
% Calculates ambient temperature at current simulation time
%
% Version : 1.5
%% ==============================================================


model = params.ambient.Model;


switch model


    %% ----------------------------------------------------------
    % CONSTANT AMBIENT TEMPERATURE
    %% ----------------------------------------------------------

    case "Constant"


        Tamb = params.env.T_amb;



        %% ----------------------------------------------------------
        % WEATHER BASED AMBIENT TEMPERATURE
        %% ----------------------------------------------------------

    case "Weather"


        % Convert simulation time to clock time

        time_hr = params.solar.StartHour + t/3600;


        % Interpolate temperature data

        Tamb = interp1( ...
            params.weather.time,...
            params.weather.Tamb,...
            time_hr,...
            'pchip');


        if isnan(Tamb)

            Tamb = params.env.T_amb;

        end



        %% ----------------------------------------------------------
        % UNKNOWN MODEL
        %% ----------------------------------------------------------

    otherwise


        error("Unknown ambient temperature model selected")


end


end