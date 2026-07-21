clear
clc
close all

params = parameters();


figure

plot(params.weather.time,...
    params.weather.GHI,...
    'LineWidth',2)

grid on

xlabel("Hour")
ylabel("Solar Irradiance (W/m^2)")
title("Downloaded Solar Data")


figure

plot(params.weather.time,...
    params.weather.Tamb-273.15,...
    'LineWidth',2)

grid on

xlabel("Hour")
ylabel("Ambient Temperature (C)")
title("Downloaded Ambient Temperature")