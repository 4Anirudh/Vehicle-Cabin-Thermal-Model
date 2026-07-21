function mdot = BlowerControl(t,Ta,Tamb,params)

%% ==============================================================
% BLOWER CONTROL STRATEGY
%
% Determines blower mass flow rate
%
% Version 1.5
%% ==============================================================


model = params.vent.ControlModel;


switch model


    %% ----------------------------------------------------------
    % Constant mdot
    %% ----------------------------------------------------------

    case "Constant"


        mdot = params.vent.mdot;



        %% ----------------------------------------------------------
        % Temperature based ON/OFF
        %% ----------------------------------------------------------

    case "Temperature"


        if Ta > Tamb + params.vent.DeltaT_on

            mdot = params.vent.mdot_on;

        else

            mdot = 0;

        end



        %% ----------------------------------------------------------
        % Temperature + intermittent operation
        %% ----------------------------------------------------------

    case "Pulse"


        if Ta <= Tamb + params.vent.DeltaT_on

            mdot = 0;

        else


            cycleTime = ...
                params.vent.OnTime + ...
                params.vent.OffTime;


            position = mod(t,cycleTime);


            if position <= params.vent.OnTime

                mdot = params.vent.mdot_on;

            else

                mdot = 0;

            end


        end



    otherwise

        error("Unknown blower control model")


end


end