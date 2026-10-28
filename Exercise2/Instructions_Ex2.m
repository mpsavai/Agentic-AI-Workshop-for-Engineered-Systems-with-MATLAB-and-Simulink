%[text] # Agentic AI Workflows with MATLAB for Engineering Analysis
%[text] This hands-on exercise shows how an agent can connect with MATLAB to support an end-to-end engineering analysis workflow. We will use natural-language prompts to inspect data, create visualizations, develop analysis logic, validate results, and build an interactive MATLAB app.
%[text] We are provided with a city-driving sensor log containing radar detections, vision detections, and lane boundary estimates. Our goal is to understand the data, identify the closest relevant object ahead of the vehicle, compute Time-to-Collision (TTC), validate the logic with executable tests, and build an interactive Forward Collision Warning App.
%[text:tableOfContents]{"heading":"Workshop Contents"}
%[text] ## 
%%
%[text] ## 
%[text] ## Setup
%[text] We will use projects to manage our files for this exercise as well as the next. MATLAB Projects help you organize your work and collaborate. Use projects to find files required to run your code, manage and share files and settings, and interact with source control. For more information about projects, see [Create Projects](https://www.mathworks.com/help/matlab/matlab_prog/create-projects.html).
%[text] First we will open our project. At startup, we have configured the project to execute setupExercise2 which does the following: 
%[text] - Close MATLAB-managed terminals
%[text] - Make WorkingFolder\_Ex2 your working folder, This is where the agent will be working.
%[text] - Close any open figures, clear variables in workspace and clear command window \
% Open exercise project
scriptFile = matlab.desktop.editor.getActiveFilename;
scriptDir = fileparts(scriptFile);
myProj = openProject(fullfile(scriptDir, "WorkingFolder_Ex2"));
%[text] %[text:anchor:TMP_730c] **Open Your Agent in the Current Working Folder**
% Open a Terminal in MATLAB 
myTerminal = terminal(Theme="dark",StartupCommand="codex");
%[text] **Action**: Depending on the path your agent takes, you will be asked to approve particular actions based on your prompts. Use your own evaluation and approve the decisions as you see fit. 
%[text] 
%%
%[text] ## 
%[text] ## Exercise
%[text] ### Step 1: Inspect the Dataset 
%[text] We start by understanding the structure of the supplied sensor data. With the prompt below, the agent should describe the contents of citySensorLog.mat.
myTerminal.run("Give me a high-level summary of the sensor data citySensorLog.mat"); 
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 2: Visualize One Sensor Frame
%[text] We now use the helper function to inspect a representative frame with both radar and vision detections. The expected result is a bird's-eye scene plot that shows the sensor vehicle, forward direction, lane boundaries, radar detections, and vision detections.
myTerminal.run("Run plotSensorFrame using a frame and explain what is visible in the plot"); 
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 3: Turn Requirements into a Collision-Warning Signal
%[text] Next, we would like to convert the sensor-frame inspection into an engineering decision signal. We ask the agent to create  a MATLAB function that produces a table of closest-object distance, position, closing speed, time to collision, and warning state over time.
myTerminal.run("Create analyzeLeadVehicle.m to compute time to collision from citySensorLog.mat. For each frame:" + ... 
    "Select the nearest object ahead within the current lane boundaries and calculate TTC as forward distance divided by closing speed.." + ...
    "Return No Object if none is in lane; use Inf TTC for objects that are stationary or moving away." + ...
    "Compute and classify TTC: ≤2 seconds as Warning, ≤4 seconds as Caution, otherwise Normal." + ...
    "Plot TTC with normal, caution, and warning bands. Cap displayed TTC at 6 seconds and label the cap as 6+."); 
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 4: Add Executable Validation from Requirements
%[text] Agent-generated code should still be treated like engineering code: requirements need executable checks. In this step, we will turn the collision-warning rules into MATLAB tests so the workflow can catch mistakes, confirm expected behavior, and support later changes with confidence. The expected result is a focused MATLAB unit test file that checks the core decision logic and confirms the generated summary artifact.
myTerminal.run("Add MATLAB unit tests for analyzeLeadVehicle.m covering closest in lane object selection and threshold classification," + ...
    "Run the tests and fix any failures."); 
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 5: Build an Interactive App 
%[text] We will now turn the analysis into an interactive review tool that is easier to inspect, tune, and share. In this step, we will package the validated collision-warning workflow into an interactive MATLAB app so the sensor scene, selected object, TTC timeline, thresholds, and logic checks can be reviewed together. This makes the results easier to explain, debug, and trust.
myTerminal.run("Build a programmatic MATLAB app for the collision warning workflow that loads citySensorLog.mat, shows the sensor scene, TTC timeline," + ...
    "closest-object details, provides warning and caution threshold controls, and let me step through frames." + ...
    "Run the app and fix layout or runtime issues. Close apps between each run and make them singletons"); 
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 6: List the skills used by the Agent 
%[text] As a last step, we will ask the agent to list all the skills we used to perform the analysis.  
myTerminal.run("List all the skills we used for the analysis"); 
pause(1)
myTerminal.run("");
%%
%[text] ### 
%[text] ### Step 7: Clean Up
%[text] Note: Only run this section if you have completed the sections above **and** you do not intend to run the optional prompts below. 
%[text] %[text:anchor:TMP_860b] We finish the exercise by shutting down the MATLAB terminal used for the agent and closing the current project to ensure a proper cleanup.
% Shut down the MATLAB terminal session
delete(myTerminal)
% Close the active MATLAB project
close(myProj);
%[text] ###  
%%
%[text] ## 
%[text] ## Further Exploration (Optional) 
%[text] This exercise demonstrates how an agent can move from raw engineering data to inspected data, validated analysis, and a MATLAB app. The same workflow can be extended in several directions.
%[text:table]{"columnWidths":[134,690]}
%[text] |  | Example |
%[text] | --- | --- |
%[text] | Independent design review | <p>Have the agent review the TTC implementation and tests against the original requirements and assumptions.</p><p></p><p>Prompt:</p><p>`Act as an independent reviewer. Compare the TTC implementation and tests against the requirements, identify gaps or unsupported assumptions, and propose focused corrections.`</p><p></p> |
%[text] |  Evidence-based reporting  | <p>Generate a report linking requirements, assumptions, analysis results, plots, and test evidence.</p><p></p><p>Prompt:</p><p>`Create a HTML engineering review report with requirements-to-test traceability, assumptions, sensor findings, TTC results, test evidence, limitations, and recommended next steps.`</p><p></p> |
%[text] | Reusable agent skills | <p>Package the sensor-analysis workflow as a reusable skill for future engineering datasets.</p><p></p><p>Prompt:</p><p>`Create a reusable local skill for reviewing vehicle sensor logs. Include data inspection, assumption tracking, sensor synchronization, TTC validation, testing, and reporting guidance.`</p> |
%[text:table]
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
