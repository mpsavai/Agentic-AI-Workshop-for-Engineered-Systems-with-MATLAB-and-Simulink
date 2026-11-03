%% Set up a clean environment for Exercise 3
% This script is intended to run as a project startup file.

close all force;
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

edit ../Instructions_Ex3.m