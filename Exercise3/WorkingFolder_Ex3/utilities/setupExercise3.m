%% Set up a clean environment for Exercise 3
% This script is intended to run as a project startup file.

% Close MATLAB-managed terminals when that functionality is available.
try
    terminal.closeAll();
catch exception
    warning("setupExercise:TerminalCleanupSkipped", ...
        "Could not close terminals: %s", exception.message);
end

close all;
clearvars;
clc;

% The project is already open when this script runs as a startup action.
myProj = matlab.project.rootProject;
if isempty(myProj)
    error("setupExercise:NoOpenProject", ...
        "Open the Exercise 3 project before running setupExercise.");
end

% Make WorkingFolder_Ex3 your working folder. 
workingDirectory = myProj.RootFolder;
cd(workingDirectory);
disp("Working directory for this exercise: " + workingDirectory);

modelName = "HouseHeating";
open_system(modelName);

edit ../Instructions_Ex3.mlx