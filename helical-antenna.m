%Helical Antenna Design

%% 1. Create Helix Antenna Structure
hx = helix(...
    'Radius', 0.028, ...       % 28 mm radius (λ/4 at 1.8 GHz)
    'Width', 1.2e-3, ...       % 1.2 mm strip width
    'Turns', 4, ...            % Number of turns
    'Spacing', 0.035, ...      % 35 mm turn spacing
    'GroundPlaneRadius', 0.075,... % 75 mm ground plane
    'Substrate', dielectric('Air'),...
    'Conductor', metal('Copper'));

%% 2. Fundamental Analysis Parameters
fc = 1.8e9; % Center frequency (1.8 GHz)
freqRange = linspace(1.7e9, 2.2e9, 51); % 1.7-2.2 GHz sweep
wavelength = physconst('lightspeed')/fc;

%% 3. Impedance and S-Parameter Analysis
% Impedance vs Frequency
figure('Name','Impedance Characteristics');
impedance(hx, freqRange); 
grid on;
title('Input Impedance vs Frequency');

% S11 Parameters
figure('Name','Return Loss');
s = sparameters(hx, freqRange);
rfplot(s);
hold on;
plot(fc/1e9, -10, 'ro', 'MarkerSize', 8); % -10dB marker
legend('S_{11}','-10 dB Reference');
title('S-Parameter (Return Loss)');

%% 4. Radiation Pattern Analysis
% 3D Radiation Pattern
figure('Name','3D Radiation Pattern');
pattern(hx, fc);
title('3D Radiation Pattern at 1.8 GHz');

% Azimuth Cut (φ=0°)
figure('Name','Azimuth Pattern');
patternAzimuth(hx, fc, 'Elevation', 0);
title('Azimuth Cut (Elevation = 0°)');

% Elevation Cut (θ=90°)
figure('Name','Elevation Pattern');
patternElevation(hx, fc, 'Azimuth', 0);
title('Elevation Cut (Azimuth = 0°)');

%% 5. Current Distribution Analysis
figure('Name','Surface Currents');
current(hx, fc);
title('Current Distribution at 1.8 GHz');

%% 6. Advanced Visualization
% Mesh Representation
figure('Name','Antenna Mesh');
mesh(hx, 'MaxEdgeLength', wavelength/20);
title('Mesh Visualization');

% Polarization Characteristics
figure('Name','Axial Ratio');
axialRatio(hx, fc, 0:5:360, 0);
title('Axial Ratio vs Phi (θ=0°)');

%% 7. AI-Based Optimization (Requires Global Optimization Toolbox)
% Optimize for 50 Ω impedance at 1.8 GHz
optimized_hx = design(hx, fc, ...
    'Height', 0.15, ... % Initial height estimate
    'GroundPlaneRadius', 0.075, ...
    'ObjectiveFunction', 'S11', ...
    'SystemObjective', -30, ... % Target S11 (-30 dB)
    'UseGeneticAlgorithm', true);

%% 8. Export Antenna Parameters
antenna_data = struct(...
    'Geometry', hx.Geometry,...
    'Material', hx.Material,...
    'Performance', analyze(hx, fc));
save('helix_antenna_design.mat', 'antenna_data');

%% Support Functions
function performance = analyze(antenna, freq)
    % Calculate key performance metrics
    perf.Impedance = impedance(antenna, freq);
    perf.Gain = pattern(antenna, freq);
    perf.Efficiency = efficiency(antenna, freq);
    perf.AxialRatio = axialRatio(antenna, freq);
    performance = perf;
end
