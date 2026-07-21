function params = LoadWeatherData(params)

%% ==============================================================
% LOAD WEATHER DATA
%
% Automatically selects:
%
%   Past date          -> Open-Meteo Archive API
%   Today/Future date  -> Open-Meteo Forecast API
%
% Outputs:
% params.weather.time  - hour of day
% params.weather.GHI   - solar radiation (W/m2)
% params.weather.Tamb  - ambient temperature (K)
%
% Version : 1.5
%% ==============================================================


%% ==============================================================
%% READ LOCATION AND DATE
%% ==============================================================

lat = params.weather.latitude;

lon = params.weather.longitude;

date = params.weather.date;


%% ==============================================================
%% CONVERT REQUESTED DATE
%% ==============================================================

requestedDate = datetime( ...
    char(date), ...
    'InputFormat','yyyy-MM-dd');

todayDate = dateshift( ...
    datetime('now','TimeZone','Asia/Kolkata'), ...
    'start','day');

% Remove timezone for direct date comparison
todayDate.TimeZone = '';


%% ==============================================================
%% SELECT WEATHER API
%% ==============================================================

if requestedDate < todayDate

    %% ----------------------------------------------------------
    % HISTORICAL DATE
    %% ----------------------------------------------------------

    baseURL = ...
        'https://archive-api.open-meteo.com/v1/archive?';

    fprintf( ...
        'Loading historical weather data for %s\n', ...
        char(date));

else

    %% ----------------------------------------------------------
    % TODAY OR FUTURE DATE
    %% ----------------------------------------------------------

    baseURL = ...
        'https://api.open-meteo.com/v1/forecast?';

    fprintf( ...
        'Loading forecast weather data for %s\n', ...
        char(date));

end


%% ==============================================================
%% CREATE API URL
%% ==============================================================

url = [ ...
    baseURL ...
    'latitude=' num2str(lat) ...
    '&longitude=' num2str(lon) ...
    '&start_date=' char(date) ...
    '&end_date=' char(date) ...
    '&hourly=shortwave_radiation,temperature_2m' ...
    '&timezone=Asia%2FKolkata'];


%% ==============================================================
%% DOWNLOAD DATA
%% ==============================================================

try

    data = webread(url);

catch ME

    error( ...
        'Weather data could not be downloaded.\n%s', ...
        ME.message);

end


%% ==============================================================
%% EXTRACT TIME
%% ==============================================================

timeData = datetime( ...
    data.hourly.time, ...
    'InputFormat','yyyy-MM-dd''T''HH:mm');


params.weather.time = ...
    hour(timeData);


%% ==============================================================
%% SOLAR DATA
%% ==============================================================

% Global Horizontal Irradiance (W/m2)

params.weather.GHI = ...
    data.hourly.shortwave_radiation;


%% ==============================================================
%% AMBIENT TEMPERATURE DATA
%% ==============================================================

% Open-Meteo provides temperature in Celsius.
% Convert to Kelvin.

params.weather.Tamb = ...
    data.hourly.temperature_2m ...
    + 273.15;


%% ==============================================================
%% DISPLAY DATA SOURCE
%% ==============================================================

if requestedDate < todayDate

    params.weather.DataSource = "Historical";

else

    params.weather.DataSource = "Forecast";

end


fprintf( ...
    'Weather data loaded successfully using %s data.\n', ...
    params.weather.DataSource);


end