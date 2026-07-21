function dTdt = CabinODE(t,T,params)
%% ==============================================================
% CABINODE
%
% Governing equations for the lumped parameter vehicle cabin model.
%
% Inputs:
%   t       - Simulation time (s)
%   T       - Node temperature vector (K)
%   params  - Structure containing model parameters
%
% Output:
%   dTdt    - Temperature rate of change (K/s)
%
% % Version: 1.5
%% ==============================================================
%% ==============================================================
%% NODE TEMPERATURES
%% ==============================================================

Tw  = T(params.ID.Windshield);

Tsg = T(params.ID.SideGlass);

Tro = T(params.ID.RoofOuter);

Tri = T(params.ID.RoofInner);

Td  = T(params.ID.Dashboard);

Tss = T(params.ID.SeatSurface);

Tsf = T(params.ID.SeatFoam);

Ta  = T(params.ID.CabinAir);

Tc = T(params.ID.Cover);

Tdo = T(params.ID.DoorOuter);

Tdi = T(params.ID.DoorInner);

Tpcm = T(params.ID.PCM);

%% ==============================================================
%% ENVIRONMENTAL PARAMETERS
%% ==============================================================

Tamb = AmbientTemperature(t,params);

Tsky = Tamb - params.env.Tsky_offset;

mdot = BlowerControl(t,Ta,Tamb,params);

params.vent.mdot = mdot;

Isolar = SolarIntensity(t,params);

hout = params.env.h_out;


%% ==============================================================
%% INTERIOR CONVECTION
%% ==============================================================

hin = InteriorConvection(params);

%% ==============================================================
%% VENTILATION
%% ==============================================================

Qvent = VentilationHeat(Tamb, Ta, params);

%% ==============================================================
%% WINDSHIELD PARAMETERS
%% ==============================================================
Aw = params.node(params.ID.Windshield).A;

mw = params.node(params.ID.Windshield).m;

Cpw = params.node(params.ID.Windshield).Cp;

alphaw = params.node(params.ID.Windshield).alpha;

epsilonw = params.node(params.ID.Windshield).epsilon;

tau = params.node(params.ID.Windshield).tau;

%% ==============================================================
%% SIDE GLASS PROPERTIES
%% ==============================================================

Asg = params.node(params.ID.SideGlass).A;

msg = params.node(params.ID.SideGlass).m;

Cpsg = params.node(params.ID.SideGlass).Cp;


alphasg = params.node(params.ID.SideGlass).alpha;

epsilonsg = params.node(params.ID.SideGlass).epsilon;

tausg = params.node(params.ID.SideGlass).tau;

%% ==============================================================
%% Door Outer
%% ==============================================================

Ado = params.node(params.ID.DoorOuter).A;

mdo = params.node(params.ID.DoorOuter).m;

Cpdo = params.node(params.ID.DoorOuter).Cp;

alphado = params.node(params.ID.DoorOuter).alpha;

epsilondo = params.node(params.ID.DoorOuter).epsilon;

kdo = params.node(params.ID.DoorOuter).k;

Ldo = params.node(params.ID.DoorOuter).L;

%% ==============================================================
%% Door Inner
%% ==============================================================

Adi = params.node(params.ID.DoorInner).A;

mdi = params.node(params.ID.DoorInner).m;

Cpdi = params.node(params.ID.DoorInner).Cp;

epsilondi = params.node(params.ID.DoorInner).epsilon;

kdi = params.node(params.ID.DoorInner).k;

Ldi = params.node(params.ID.DoorInner).L;

%% ==============================================================
%% ROOF OUTER
%% ==============================================================

Aro = params.node(params.ID.RoofOuter).A;

mro = params.node(params.ID.RoofOuter).m;

Cpro = params.node(params.ID.RoofOuter).Cp;

kro = params.node(params.ID.RoofOuter).k;

Lro = params.node(params.ID.RoofOuter).L;

alpharo = params.node(params.ID.RoofOuter).alpha;

epsilonro = params.node(params.ID.RoofOuter).epsilon;

%% ==============================================================
%% ROOF INNER
%% ==============================================================

Ari = params.node(params.ID.RoofInner).A;

mri = params.node(params.ID.RoofInner).m;

Cpri = params.node(params.ID.RoofInner).Cp;

kri = params.node(params.ID.RoofInner).k;

Lri = params.node(params.ID.RoofInner).L;

alphari = params.node(params.ID.RoofInner).alpha;

epsilonri = params.node(params.ID.RoofInner).epsilon;

%% ==============================================================
%% DASHBOARD PARAMETERS
%% ==============================================================

Ad = params.node(params.ID.Dashboard).A;

md = params.node(params.ID.Dashboard).m;

Cpd = params.node(params.ID.Dashboard).Cp;

alphad = params.node(params.ID.Dashboard).alpha;

epsilond = params.node(params.ID.Dashboard).epsilon;

phid = params.node(params.ID.Dashboard).phi;

%% ==============================================================
%% SEAT SURFACE
%% ==============================================================

Ass = params.node(params.ID.SeatSurface).A;

mss = params.node(params.ID.SeatSurface).m;

Cpss = params.node(params.ID.SeatSurface).Cp;

kss = params.node(params.ID.SeatSurface).k;

Lss = params.node(params.ID.SeatSurface).L;

alphass = params.node(params.ID.SeatSurface).alpha;

epsilonss = params.node(params.ID.SeatSurface).epsilon;

phiss = params.node(params.ID.SeatSurface).phi;

%% ==============================================================
%% SEAT FOAM
%% ==============================================================

Asf = params.node(params.ID.SeatFoam).A;

msf = params.node(params.ID.SeatFoam).m;

Cpsf = params.node(params.ID.SeatFoam).Cp;

ksf = params.node(params.ID.SeatFoam).k;

Lsf = params.node(params.ID.SeatFoam).L;

alphasf = params.node(params.ID.SeatFoam).alpha;

epsilonsf = params.node(params.ID.SeatFoam).epsilon;

%% ==============================================================
%% CABIN AIR PARAMETERS
%% ==============================================================

Vair = params.node(params.ID.CabinAir).Volume;

rhoair = params.node(params.ID.CabinAir).Density;

Cpair = params.node(params.ID.CabinAir).Cp;

mair = Vair * rhoair;

%% ==============================================================
%% COVER PROPERTIES
%% ==============================================================

%% ==============================================================
%% ACTIVE COVER AREA
%% ==============================================================

Ac = 0;

if params.cover.Roof=="On"

    Ac = Ac + Aro;

end


if params.cover.Windshield=="On"

    Ac = Ac + Aw;

end


if params.cover.SideGlass=="On"

    Ac = Ac + Asg;

end


if params.cover.Door=="On"

    Ac = Ac + Ado;

end

m_areal = params.node(params.ID.Cover).m;

mc = m_areal * Ac;

Cpc = params.node(params.ID.Cover).Cp;


alphac = params.node(params.ID.Cover).alpha;

epsilonc = params.node(params.ID.Cover).epsilon;

%% ==============================================================
%% PCM PROPERTIES
%% ==============================================================

mpcm = params.node(params.ID.PCM).m;

Apcm = params.node(params.ID.PCM).A;

epsilonpcm = params.node(params.ID.PCM).epsilon;


hpcm = params.node(params.ID.PCM).h;


Tm_pcm = params.node(params.ID.PCM).Tm;

dT_pcm = params.node(params.ID.PCM).dT;


Lpcm = params.node(params.ID.PCM).L;


Cppcm_s = params.node(params.ID.PCM).Cp_solid;

Cppcm_l = params.node(params.ID.PCM).Cp_liquid;

Cppcm = PCMEffectiveCp( ...
    Tpcm, ...
    Tm_pcm, ...
    dT_pcm, ...
    Cppcm_s, ...
    Cppcm_l, ...
    Lpcm);

%% ==============================================================
%% VIEW FACTORS
%% ==============================================================

Fwri = params.F(params.ID.Windshield,...
    params.ID.RoofInner);

Fwss = params.F(params.ID.Windshield,...
    params.ID.SeatSurface);

Fwd = params.F(params.ID.Windshield,...
    params.ID.Dashboard);

Frid = params.F(params.ID.RoofInner,...
    params.ID.Dashboard);

Friss = params.F(params.ID.RoofInner,...
    params.ID.SeatSurface);

Fdss = params.F(params.ID.Dashboard,...
    params.ID.SeatSurface);

Fsgd = params.F( ...
    params.ID.SideGlass,...
    params.ID.Dashboard);


Fsgss = params.F( ...
    params.ID.SideGlass,...
    params.ID.SeatSurface);


Fsgri = params.F( ...
    params.ID.SideGlass,...
    params.ID.RoofInner);


Fsgw = params.F( ...
    params.ID.SideGlass,...
    params.ID.Windshield);

%% Door Inner View Factors

Fdid = params.F( ...
    params.ID.DoorInner,...
    params.ID.Dashboard);


Fdiss = params.F( ...
    params.ID.DoorInner,...
    params.ID.SeatSurface);


Fdiri = params.F( ...
    params.ID.DoorInner,...
    params.ID.RoofInner);


Fdisg = params.F( ...
    params.ID.DoorInner,...
    params.ID.SideGlass);

Fdiw = params.F( ...
    params.ID.DoorInner,...
    params.ID.Windshield);

%% ==============================================================
%% SOLAR HEAT
%% ==============================================================


% --------------------------------------------------------------
% Surface projected solar intensity
% --------------------------------------------------------------

Iroof = ...
    params.solar.factor_roof * Isolar;


Iwindshield = ...
    params.solar.factor_windshield * Isolar;


Isideglass = ...
    params.solar.factor_sideglass * Isolar;

Idoor = ...
    params.solar.factor_door * Isolar;

%% --------------------------------------------------------------
% ROOF  SOLAR
%% --------------------------------------------------------------


if params.cover.Roof == "Off"


    % Roof exposed

    Q_solar_ro = SolarHeat( ...
        Aro, alpharo, Iroof);


else


    % Roof covered

    Q_solar_ro = 0;


end
%% --------------------------------------------------------------
% WINDSHIELD SOLAR
%% --------------------------------------------------------------

if params.cover.Windshield == "Off"



    % Windshield exposed

    Q_solar_w = SolarHeat( ...
        Aw, alphaw, Iwindshield);


    % Transmission through windshield

    Ithrough_windshield = ...
        tau * Iwindshield;



else


    % windshield covered

    Q_solar_w = 0;


    Ithrough_windshield = 0;


end

%% --------------------------------------------------------------
% SIDE GLASS SOLAR
%% --------------------------------------------------------------


if params.cover.SideGlass == "Off"


    % Side glass exposed

    Q_solar_sg = SolarHeat( ...
        Asg, alphasg, Isideglass);



    % Transmission through side glass

    Ithrough_sideglass = ...
        tausg * Isideglass;



else


    % Side glass covered

    Q_solar_sg = 0;


    Ithrough_sideglass = 0;


end

%% --------------------------------------------------------------
% DOOR SOLAR
%% --------------------------------------------------------------

if params.cover.Door == "Off"


    Q_solar_do = SolarHeat( ...
        Ado, alphado, Idoor);


else


    Q_solar_do = 0;


end

%% --------------------------------------------------------------
% TOTAL CABIN SOLAR
%% --------------------------------------------------------------


Icabin = ...
    Ithrough_windshield ...
    + Ithrough_sideglass;



%% Dashboard

Idash = ...
    phid * Icabin;


Q_solar_d = SolarHeat( ...
    Ad, alphad, Idash);



%% Seat Surface

Iseat = ...
    phiss * Icabin;


Q_solar_ss = SolarHeat( ...
    Ass, alphass, Iseat);

%% ==============================================================
%% COVER HEAT TRANSFER
%% ==============================================================

Q_solar_c = 0;

Q_cover_roof = 0;
Q_cover_windshield = 0;
Q_cover_sideglass = 0;

Q_rad_cover_roof = 0;
Q_rad_cover_windshield = 0;
Q_rad_cover_sideglass = 0;

Q_cover_amb = 0;

Q_cover_door = 0;

Q_rad_cover_door = 0;


if params.cover.Roof == "On"


    % Solar absorbed by cover

    Q_solar_c = Q_solar_c + ...
        SolarHeat(Aro, alphac, Iroof);


    % Cover to Roof convection

    Q_cover_roof = ConvectionHeat( ...
        Aro,...
        params.cover.h_gap,...
        Tc,Tro);


    % Cover-Roof Radiation

    Q_rad_cover_roof = RadiationHeat( ...
        Aro,epsilonc,...
        Aro,epsilonro,...
        1,...
        Tc,Tro);


end

if params.cover.Windshield == "On"


    % Solar absorbed by cover

    Q_solar_c = Q_solar_c + ...
        SolarHeat(Aw, alphac, Iwindshield);


    % Cover to Windshield convection

    Q_cover_windshield = ConvectionHeat( ...
        Aw,...
        params.cover.h_gap,...
        Tc,Tw);

    % Cover-Windshield Radiation

    Q_rad_cover_windshield = RadiationHeat( ...
        Aw,epsilonc,...
        Aw,epsilonw,...
        1,...
        Tc,Tw);

end

if params.cover.SideGlass == "On"


    Q_solar_c = Q_solar_c + ...
        SolarHeat(Asg,alphac,Isideglass);



    Q_cover_sideglass = ConvectionHeat( ...
        Asg,...
        params.cover.h_gap,...
        Tc,Tsg);



    Q_rad_cover_sideglass = RadiationHeat( ...
        Asg,epsilonc,...
        Asg,epsilonsg,...
        1,...
        Tc,Tsg);

end

%% --------------------------------------------------------------
% DOOR COVER
%% --------------------------------------------------------------

if params.cover.Door == "On"


    % Solar absorbed by cover over doors

    Q_solar_c = Q_solar_c + ...
        SolarHeat(Ado, alphac, Idoor);



    % Cover to Door convection

    Q_cover_door = ConvectionHeat( ...
        Ado,...
        params.cover.h_gap,...
        Tc,Tdo);



    % Cover to Door radiation

    Q_rad_cover_door = RadiationHeat( ...
        Ado, epsilonc,...
        Ado, epsilondo,...
        1,...
        Tc,Tdo);

end

if params.cover.Roof=="On" || ...
   params.cover.Windshield=="On" || ...
   params.cover.SideGlass=="On" || ...
   params.cover.Door=="On"


    Q_cover_amb = ConvectionHeat( ...
        Ac,...
        hout,...
        Tc,Tamb);
else

    Q_cover_amb = 0;

end

%% ==============================================================
%% EXTERNAL CONVECTION
%% ==============================================================


if params.cover.Roof=="Off"

    Q_conv_ro_amb = ConvectionHeat( ...
        Aro,hout,Tro,Tamb);


else


    Q_conv_ro_amb = 0;


end

if params.cover.Windshield=="Off"


    Q_conv_w_amb = ConvectionHeat( ...
        Aw,hout,Tw,Tamb);


else

    Q_conv_w_amb = 0;


end


if params.cover.SideGlass=="Off"


    Q_conv_sg_amb = ConvectionHeat( ...
        Asg,hout,Tsg,Tamb);


else


    Q_conv_sg_amb = 0;


end



if params.cover.Door=="Off"


    Q_conv_do_amb = ConvectionHeat( ...
        Ado,hout,Tdo,Tamb);


else


    Q_conv_do_amb = 0;


end

%% ==============================================================
%% SKY RADIATION
%% ==============================================================


if params.cover.Roof=="Off"


    % Roof outer to sky

    Q_rad_ro_sky = ...
        epsilonro * params.env.sigma * Aro * ...
        (Tro^4 - Tsky^4);


else


    Q_rad_ro_sky = 0;


end


if params.cover.Windshield=="Off"


    % Windshield to sky

    Q_rad_w_sky = ...
        epsilonw * params.env.sigma * Aw * ...
        (Tw^4 - Tsky^4);



else

    Q_rad_w_sky = 0;


end



if params.cover.SideGlass=="Off"


    % Side glazing to sky

    Q_rad_sg_sky = ...
        epsilonsg * params.env.sigma * Asg * ...
        (Tsg^4 - Tsky^4);


else


    Q_rad_sg_sky = 0;


end



if params.cover.Door=="Off"


    % Door outer to sky

    Q_rad_do_sky = ...
        epsilondo * params.env.sigma * Ado * ...
        (Tdo^4 - Tsky^4);


else


    Q_rad_do_sky = 0;


end
%% ==============================================================
%% COVER SKY RADIATION
%% ==============================================================


if params.cover.Roof=="On" || ...
        params.cover.Windshield=="On" || ...
        params.cover.SideGlass=="On" || ...
        params.cover.Door=="On"


    Q_rad_cover_sky = ...
        epsilonc * params.env.sigma * Ac * ...
        (Tc^4 - Tsky^4);


else


    Q_rad_cover_sky = 0;


end
%% ==============================================================
%% INTERNAL CONVECTION
%% ==============================================================

Q_conv_ri_a = ConvectionHeat(Ari, hin, Tri, Ta);

Q_conv_d_a = ConvectionHeat(Ad, hin, Td, Ta);

Q_conv_ss_a = ConvectionHeat(Ass, hin, Tss, Ta);

Q_conv_w_a = ConvectionHeat(Aw, hin, Tw, Ta);

Q_conv_sg_a = ConvectionHeat(Asg,hin,Tsg,Ta);

Q_conv_di_a = ConvectionHeat( ...
    Adi,hin,Tdi,Ta);
%% PCM convection with cabin air

Q_conv_pcm_a = ConvectionHeat( ...
    Apcm, ...
    hpcm, ...
    Tpcm, ...
    Ta);

%% ==============================================================
%% THERMAL RESISTANCES
%% ==============================================================

% Roof
A_roof = min(Aro, Ari);

R_roof = Lro/(2*kro*A_roof) + ...
    Lri/(2*kri*A_roof);

% Seat
A_seat = min(Ass, Asf);

R_seat = Lss/(2*kss*A_seat) + ...
    Lsf/(2*ksf*A_seat);

% Door

A_door = min(Ado,Adi);


R_door = ...
    Ldo/(2*kdo*A_door) + ...
    Ldi/(2*kdi*A_door);

%% ==============================================================
%% CONDUCTION
%% ==============================================================

Q_cond_r = ConductionHeat(R_roof, Tro, Tri);

Q_cond_s = ConductionHeat(R_seat, Tss, Tsf);

Q_cond_door = ConductionHeat( ...
    R_door,...
    Tdo,...
    Tdi);

%% ==============================================================
%% RADIATION
%% ==============================================================

% Roof Inner <-> Dashboard
Q_rad_ri_d = RadiationHeat( ...
    Ari, epsilonri, ...
    Ad, epsilond, ...
    Frid, ...
    Tri, Td);

% Roof Inner <-> Seat Surface
Q_rad_ri_ss = RadiationHeat( ...
    Ari, epsilonri, ...
    Ass, epsilonss, ...
    Friss, ...
    Tri, Tss);

% Roof Inner <-> Windshield
Q_rad_ri_w = RadiationHeat( ...
    Ari, epsilonri, ...
    Aw, epsilonw, ...
    Fwri, ...
    Tri, Tw);

% Dashboard <-> Seat Surface
Q_rad_d_ss = RadiationHeat( ...
    Ad, epsilond, ...
    Ass, epsilonss, ...
    Fdss, ...
    Td, Tss);

% Dashboard <-> Windshield
Q_rad_d_w = RadiationHeat( ...
    Ad, epsilond, ...
    Aw, epsilonw, ...
    Fwd, ...
    Td, Tw);

% Seat Surface <-> Windshield
Q_rad_ss_w = RadiationHeat( ...
    Ass, epsilonss, ...
    Aw, epsilonw, ...
    Fwss, ...
    Tss, Tw);

% Door Inner <-> Windshield

Q_rad_di_w = RadiationHeat( ...
    Adi,epsilondi,...
    Aw,epsilonw,...
    Fdiw,...
    Tdi,Tw);

%% ==============================================================
%% SIDE GLASS RADIATION
%% ==============================================================


% Side Glass <-> Dashboard

Q_rad_sg_d = RadiationHeat( ...
    Asg, epsilonsg,...
    Ad, epsilond,...
    Fsgd,...
    Tsg,Td);



% Side Glass <-> Seat Surface

Q_rad_sg_ss = RadiationHeat( ...
    Asg, epsilonsg,...
    Ass, epsilonss,...
    Fsgss,...
    Tsg,Tss);



% Side Glass <-> Roof Inner

Q_rad_sg_ri = RadiationHeat( ...
    Asg, epsilonsg,...
    Ari, epsilonri,...
    Fsgri,...
    Tsg,Tri);



% Side Glass <-> Windshield

Q_rad_sg_w = RadiationHeat( ...
    Asg, epsilonsg,...
    Aw, epsilonw,...
    Fsgw,...
    Tsg,Tw);

%% ==============================================================
%% DOOR INNER RADIATION
%% ==============================================================


Q_rad_di_d = RadiationHeat( ...
    Adi,epsilondi,...
    Ad,epsilond,...
    Fdid,...
    Tdi,Td);


Q_rad_di_ss = RadiationHeat( ...
    Adi,epsilondi,...
    Ass,epsilonss,...
    Fdiss,...
    Tdi,Tss);


Q_rad_di_ri = RadiationHeat( ...
    Adi,epsilondi,...
    Ari,epsilonri,...
    Fdiri,...
    Tdi,Tri);


Q_rad_di_sg = RadiationHeat( ...
    Adi,epsilondi,...
    Asg,epsilonsg,...
    Fdisg,...
    Tdi,Tsg);

%% ==============================================================
%% PCM RADIATION
%% ==============================================================


Q_rad_pcm_d = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Ad, epsilond, ...
    params.F(params.ID.PCM,params.ID.Dashboard), ...
    Tpcm, Td);



Q_rad_pcm_ss = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Ass, epsilonss, ...
    params.F(params.ID.PCM,params.ID.SeatSurface), ...
    Tpcm, Tss);



Q_rad_pcm_ri = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Ari, epsilonri, ...
    params.F(params.ID.PCM,params.ID.RoofInner), ...
    Tpcm, Tri);



Q_rad_pcm_di = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Adi, epsilondi, ...
    params.F(params.ID.PCM,params.ID.DoorInner), ...
    Tpcm, Tdi);



Q_rad_pcm_w = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Aw, epsilonw, ...
    params.F(params.ID.PCM,params.ID.Windshield), ...
    Tpcm, Tw);



Q_rad_pcm_sg = RadiationHeat( ...
    Apcm, epsilonpcm, ...
    Asg, epsilonsg, ...
    params.F(params.ID.PCM,params.ID.SideGlass), ...
    Tpcm, Tsg);

%% ==============================================================
%% PCM HEAT TRANSFER CONTROL
%% ==============================================================

switch params.pcm.Model


    case "On"


        % keep calculated values


    case "Off"


        Q_conv_pcm_a = 0;


        Q_rad_pcm_d = 0;

        Q_rad_pcm_ss = 0;

        Q_rad_pcm_ri = 0;

        Q_rad_pcm_di = 0;

        Q_rad_pcm_w = 0;

        Q_rad_pcm_sg = 0;


    otherwise

        error("Invalid PCM model selected")

end
%% ==============================================================
%% ENERGY BALANCES
%% ==============================================================


%--------------------------------------------------------------
% Roof Outer
%--------------------------------------------------------------

if params.cover.Roof == "On"


    dTrodt = ( ...
        Q_cover_roof ...
        + Q_rad_cover_roof ...
        - Q_cond_r ) ...
        /(mro*Cpro);


else


    dTrodt = ( ...
        Q_solar_ro ...
        - Q_conv_ro_amb ...
        - Q_rad_ro_sky...
        - Q_cond_r ) ...
        /(mro*Cpro);


end

%--------------------------------------------------------------
% Roof Inner
%--------------------------------------------------------------

dTridt = ( ...
    Q_cond_r ...
    - Q_conv_ri_a ...
    - Q_rad_ri_d ...
    - Q_rad_ri_ss ...
    - Q_rad_ri_w ...
    + Q_rad_sg_ri ...
    + Q_rad_di_ri ...
    + Q_rad_pcm_ri) ...
    /(mri*Cpri);

%--------------------------------------------------------------
% Windshield External Heat
%--------------------------------------------------------------

if params.cover.Windshield == "On"


    Q_w_external = ...
        Q_cover_windshield ...
        + Q_rad_cover_windshield;


else


    Q_w_external = ...
        Q_solar_w   ...
        - Q_rad_w_sky ...
        - Q_conv_w_amb;


end


dTwdt = ( ...
    Q_w_external ...
    - Q_conv_w_a ...
    + Q_rad_ri_w ...
    + Q_rad_d_w ...
    + Q_rad_ss_w ...
    + Q_rad_sg_w ...
    + Q_rad_di_w ...
    + Q_rad_pcm_w) ...
    /(mw*Cpw);

%--------------------------------------------------------------
% Side Glass
%--------------------------------------------------------------
dTsgdt = ( ...
    Q_solar_sg ...
    + Q_cover_sideglass ...
    + Q_rad_cover_sideglass ...
    - Q_conv_sg_amb ...
    - Q_rad_sg_sky...
    - Q_conv_sg_a ...
    - Q_rad_sg_d ...
    - Q_rad_sg_ss ...
    - Q_rad_sg_ri ...
    - Q_rad_sg_w ...
    + Q_rad_di_sg ...
    +Q_rad_pcm_sg) ...
    /(msg*Cpsg);

%--------------------------------------------------------------
% Dashboard
%--------------------------------------------------------------

dTddt = ( ...
    Q_solar_d ...
    - Q_conv_d_a ...
    + Q_rad_ri_d ...
    - Q_rad_d_ss ...
    - Q_rad_d_w ...
    + Q_rad_sg_d ...
    + Q_rad_di_d ...
    + Q_rad_pcm_d) ...
    /(md*Cpd);

%--------------------------------------------------------------
% Seat Surface
%--------------------------------------------------------------

dTssdt = ( ...
    Q_solar_ss ...
    - Q_conv_ss_a ...
    + Q_rad_ri_ss ...
    + Q_rad_d_ss ...
    - Q_rad_ss_w ...
    - Q_cond_s ...
    + Q_rad_sg_ss ...
    + Q_rad_di_ss ...
    + Q_rad_pcm_ss) ...
    /(mss*Cpss);

%--------------------------------------------------------------
% Seat Foam
%--------------------------------------------------------------

dTsfdt = ( ...
    Q_cond_s ) ...
    /(msf*Cpsf);

%--------------------------------------------------------------
% Door Outer
%--------------------------------------------------------------

if params.cover.Door=="On"


    Q_door_external = ...
        Q_cover_door ...
        + Q_rad_cover_door;


else


    Q_door_external = (...
        Q_solar_do ...
        - Q_rad_do_sky ...
        - Q_conv_do_amb);


end


dTdodt = ( ...
    Q_door_external ...
    - Q_cond_door ) ...
    /(mdo*Cpdo);



%--------------------------------------------------------------
% Door Inner
%--------------------------------------------------------------

dTdidt = ( ...
    Q_cond_door ...
    - Q_conv_di_a ...
    - Q_rad_di_d ...
    - Q_rad_di_ss ...
    - Q_rad_di_ri ...
    - Q_rad_di_sg ...
    - Q_rad_di_w ...
    + Q_rad_pcm_di) ...
    /(mdi*Cpdi);

%--------------------------------------------------------------
% Cabin Air
%--------------------------------------------------------------

dTadt = ( ...
    Q_conv_w_a ...
    + Q_conv_ri_a ...
    + Q_conv_d_a ...
    + Q_conv_ss_a ...
    + Q_conv_sg_a ...
    + Q_conv_di_a ...
    + Qvent ...
    + Q_conv_pcm_a) ...
    /(mair*Cpair);

%% ==============================================================
%% COVER ENERGY BALANCE
%% ==============================================================


if params.cover.Roof=="On" || ...
   params.cover.Windshield=="On" || ...
   params.cover.SideGlass=="On" || ...
   params.cover.Door=="On"


   dTcdt = ( ...
    Q_solar_c ...
    - Q_cover_roof ...
    - Q_cover_windshield ...
    - Q_cover_sideglass ...
    - Q_cover_door ...
    - Q_rad_cover_roof ...
    - Q_rad_cover_windshield ...
    - Q_rad_cover_sideglass ...
    - Q_rad_cover_door ...
    - Q_cover_amb ...
    - Q_rad_cover_sky) ...
    /(mc*Cpc);


else


    dTcdt = 0;


end

%% ==============================================================
%% PCM ENERGY BALANCE
%% ==============================================================

switch params.pcm.Model


    case "On"


        dTpcmdt = ( ...
            - Q_conv_pcm_a ...
            - Q_rad_pcm_d ...
            - Q_rad_pcm_ss ...
            - Q_rad_pcm_ri ...
            - Q_rad_pcm_di ...
            - Q_rad_pcm_w ...
            - Q_rad_pcm_sg ) ...
            /(mpcm*Cppcm);



    case "Off"


        dTpcmdt = 0;


end
%% ==============================================================
%% RETURN TEMPERATURE DERIVATIVES
%% ==============================================================

dTdt = [ ...
    dTwdt;
    dTrodt;
    dTridt;
    dTddt;
    dTssdt;
    dTsfdt;
    dTadt;
    dTcdt;
    dTsgdt;
    dTdodt;
    dTdidt
    dTpcmdt];
end