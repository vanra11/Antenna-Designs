% Helix Antenna Design and Analysis Script

% Clear workspace and command window
clear;
clc;

% Define parameters for the helix antenna
frequency = 1.8e9; % Frequency in Hz
wavelength = physconst('LightSpeed') / frequency; % Wavelength
turns = 5; % Number of turns
diameter = 0.1; % Diameter of the helix in meters
spacing = 0.05; % Spacing between turns in meters

% Create a helix antenna
helix = helix('NumTurns', turns, ...
              'Diameter', diameter, ...
              'Spacing', spacing, ...
              'Tilt', 0, ...
              'GroundPlaneLength', 0.5); % Ground plane length

% Analyze the antenna
% Impedance
impedance = impedance(helix, frequency);
disp(['Impedance at ', num2str(frequency/1e9), ' GHz: ', num2str(impedance), ' Ohms']);

% S-parameters
s_params = sparameters(helix, frequency);
disp('S-parameters:');
disp(s_params.Parameters);

% Radiation pattern
figure;
pattern(helix, frequency);
title('Radiation Pattern at 1.8 GHz');

% Current distribution
figure;
current(helix, frequency);
title('Current Distribution at 1.8 GHz');

% Export the design as a MATLAB script
exportScript = 'helix_antenna_design.m';
export(helix, exportScript);
disp(['Design exported to ', exportScript]);

% Save the current figure as an image
saveas(gcf, 'radiation_pattern.png');