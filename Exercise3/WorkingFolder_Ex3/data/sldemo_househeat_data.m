%   SLDEMO_HOUSEHEAT_DATA
%   This script runs in conjunction with the "sldemo_househeat"
%   house thermodynamics example. Note that time is given in units of hours

%   Copyright 1990-2012 The MathWorks, Inc.

% -------------------------------
% Problem constant
% -------------------------------
% converst radians to degrees
r2d = 180/pi;
% -------------------------------
% Define the house geometry
% -------------------------------
% House length = 30 m
lenHouse = 30;
% House width = 10 m
widHouse = 10;
% House height = 4 m
htHouse = 4;
% Roof pitch = 40 deg
pitRoof = 40/r2d;
% Number of windows = 6
numWindows = 6;
% Height of windows = 1 m
htWindows = 1;
% Width of windows = 1 m
widWindows = 1;
windowArea = numWindows*htWindows*widWindows;
wallArea = 2*lenHouse*htHouse + 2*widHouse*htHouse + ...
           2*(1/cos(pitRoof/2))*widHouse*lenHouse + ...
           tan(pitRoof)*widHouse - windowArea;
% -------------------------------
% Define the type of insulation used
% -------------------------------
% Glass wool in the walls, 0.2 m thick
% k is in units of J/sec/m/C
kWall = 0.038;
LWall = .2;
RWall = LWall/(kWall*wallArea);
% Glass windows, 0.01 m thick
kWindow = 0.78; 
LWindow = .01;
RWindow = LWindow/(kWindow*windowArea);
% -------------------------------
% Determine the equivalent thermal resistance for the whole building
% -------------------------------
Req = RWall*RWindow/(RWall + RWindow);
% c = cp of air (273 K) = 1005.4 J/kg-K
c = 1005.4;
% Air flow rate Mdot = 1 kg/sec
Mdot = 1;
% -------------------------------
% Determine total internal air mass = M
% -------------------------------
% Density of air at sea level = 1.2250 kg/m^3
densAir = 1.2250;
M = (lenHouse*widHouse*htHouse+tan(pitRoof)*widHouse*lenHouse)*densAir;
% -------------------------------
% Enter the cost of electricity and initial internal temperature
% -------------------------------
%   Simscape Demo "House Heating System"
max_temp = 23;    % Maximum temperature
min_temp = 18;     % Minimum temperature
% Walls
% House length = 30 m
lenHouse = 30;
% House width = 10 m
widHouse = 10;
% House height = 4 m
htHouse = 4;
wallArea = 2*lenHouse*htHouse + 2*widHouse*htHouse;
LWall = .2;
wallVolume = wallArea * LWall;
wallDensity = 1920;     % kg/m^3
wallMass = wallVolume * wallDensity;
c_wall = 835;           % J/kg/K
kWall = 0.038;  % Thermal conductivity [W/m/K]
% -------------------------------
% Windows
% Number of windows = 6
numWindows = 6;
% Height of windows = 1 m
htWindows = 1;
% Width of windows = 1 m
widWindows = 1;
windowArea = numWindows*htWindows*widWindows;
LWindow = .01;
windowVolume = windowArea * LWindow;
windowDensity = 2700;       % kg/m^3
windowMass = windowVolume * windowDensity;
c_window = 840;             % J/kg/K
kWindow = 0.78;             % Thermal conductivity [W/m/K]
% -------------------------------
% Roof
% Roof pitch = 40 deg
pitRoof = 40/180/pi;
roofArea =  2*(1/cos(pitRoof/2))*widHouse*lenHouse + tan(pitRoof)*widHouse;
LRoof = 0.2;
roofVolume = roofArea * LRoof;
roofDensity = 32;           % Glass fiber
roofMass = roofVolume * roofDensity;
kRoof = 0.038;              % Thermal conductivity [W/m/K]
c_roof = 835;               % J/kg/K
% -------------------------------
% Convective heat gransfer coefficients (W/M^2/K)
h_A_W = 24;         % Air-wall
h_W_Atm = 34;       % Wall-atmosphere
h_A_Wnd = 25;       % Air-window
h_Wnd_Atm = 32;     % Window-atmosphere
h_A_R = 12;         % Air-roof
h_R_Atm = 38;       % Roof-atmosphere
% -------------------------------
%Air
% Density of air at sea level = 1.2250 kg/m^3
densAir = 1.2250;
% Air mass inside the house
M_air = (lenHouse*widHouse*htHouse+tan(pitRoof)*widHouse*lenHouse)*densAir;
c_air = 1005.4;         % cp of air at 273 K [J/(kg*K]
% -------------------------------
% Heater
% The air exiting the heater has a constant temperature which is a heater
% property. THeater = 50 deg C
THeater = 50;
HeaterAirFlow = 1;  % Heater air flow rate [kg/s]
% -------------------------------
% Cost of electricity
% Assume the cost of electricity is $0.09 per kilowatt/hour
% Assume all electric energy is transformed to heat energy
% 1 kW-hr = 3.6e6 J
% cost = $0.09 per 3.6e6 J
cost = 0.09/3.6e6;
% -------------------------------
% Initial internal temperatures
TinIC = 20; % deg C