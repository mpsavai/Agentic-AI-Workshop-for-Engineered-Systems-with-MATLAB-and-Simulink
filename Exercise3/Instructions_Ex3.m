%[text] # Agentic AI Workflows with Simulink for Model-Based Design
%[text] This exercise demonstrates how to use an agent with Simulink to support Model-Based Design workflows.
%[text] The sample application for this exercise is a house heating system. You will inspect the model structure, run and analyze simulations, debug thermostat logic, extend the model with heater cost calculations, and generate embedded C code for the controller. Along the way, the exercise shows how natural-language prompts can help analyze, modify, verify, and automate Simulink-based designs.
%[text:tableOfContents]{"heading":"Workshop Contents"}
%%
%[text] ## 
%[text] ## Setup
%[text] We will use projects to manage our files for this exercise as well as the next. MATLAB Projects help you organize your work and collaborate. Use projects to find files required to run your code, manage and share files and settings, and interact with source control. For more information about projects, see [Create Projects](https://www.mathworks.com/help/matlab/matlab_prog/create-projects.html).
%[text] First we will open our project. At startup, we have configured the project to execute `setupExercise3` which does the following: 
%[text] - Close MATLAB-managed terminals
%[text] - Make WorkingFolder\_Ex3 your working folder. This is where the agent will be working.
%[text] - Close any open figures, clear variables in workspace and clear command window \
% Open exercise project
scriptFile = matlab.desktop.editor.getActiveFilename;
scriptDir = fileparts(scriptFile);
myProj = openProject(fullfile(scriptDir, "WorkingFolder_Ex3"));
%[text] %[text:anchor:TMP_730c] **Open Your Agent in the Current Working Folder**
% Open a Terminal in the house heating Simulink model
modelName = "HouseHeating";
open_system(modelName);

myTerminal = terminal(Place="matlab",Theme="dark",StartupCommand="codex"); 
%[text] **Action**: Depending on the path your agent takes, you will be asked to approve particular actions based on your prompts. Use your own evaluation and approve the decisions as you see fit. 
%[text] 
%%
%[text] ## 
%[text] ## Exercise
%[text] ### Step 1: Analyze House Heating Model
%[text] Before working with a Simulink model, we often want to understand its contents and structure at a high level, and the same applies when working with agents. One advantage of working with agents is that they can not just explain the various pieces of a model, but also explain how those pieces fit together. 
%[text] Ask the agent to examine the model and give some analysis regarding heat flow through the model.
myTerminal.run("Analyze the Simulink model HouseHeating.slx and " + ...
    "provide an overview of its major components and subsystems. " + ...
    "Provide equations for the major heat transfer paths.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### **Step 2:** Run Simulation an**d Analyze Results**
%[text] Static analysis is only part of understanding a system. We typically also want to use simulations to analyze the dynamic behavior of the system. We could run a simulation ourselves, but having the agent to run the simulation allows it to add the results to its context for future tasks.
%[text] Ask the agent to run a 24-hour simulation of the house heating system and analyze the results.
myTerminal.run("Run a 24-hour simulation of the house heating " + ...
    "system and summarize its behavior.");
pause(1)
myTerminal.run("");
%[text] Notice that the temperature inside the house far exceeds the upper limit of 22 degrees defined in our thermostat logic. In the next step, we will ask our agent to help us debug this.
%[text] 
%%
%[text] ### 
%[text] ### **Step 3: Debug Thermostat Logic**
%[text] The house heating model contains a thermostat whose logic is implemented using a state chart in Stateflow. The thermostat is designed to keep the house temperature between 18-22 degrees Celsius, but simulation results show that these limits are being violated. 
%[text] Ask the agent to investigate the issue and create a test to capture the failure.
myTerminal.run("During simulation, the thermostat is slow to " + ...
    "respond when the house temperature exceeds the bounds " + ...
    "used by the thermostat. The thermostat should promptly " + ...
    "respond within 30 seconds when either temperature bound " + ...
    "is violated. Investigate the issue and create a simple " + ...
    "test to capture the faulty logic. Open the test after " + ...
    "it's been created.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 4: Correct Controller Logic and Verify
%[text] After assessing the agent's findings on the thermostat bug, we can implement the fix ourselves or simply ask the agent to do it for us. When asking an agent to fix an issue for us, we want to ensure that we have some verification gates to check its work.
%[text] Ask the agent to correct the thermostat issue and verify the change using the previously-created test as a verification gate.
myTerminal.run("Change the thermostat sample time to 10 " + ...
    "seconds and verify it using the same test we just " + ...
    "created. Then run a full simulation to check the " + ...
    "house stays closer to the desired 18-22 degree range.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 5: Add Heater Cost Calculation
%[text] Agents can also be useful tools for extending existing models to add new functionality. For instance, we may want to calculate the operating cost of our heater to assess the efficiency of our design.
%[text] Ask the agent to add a heater use cost calculation to the model, as well as a scope to track cumulative cost during simulations.
myTerminal.run("Add a feature to the Heater subsystem " + ...
    "to compute the cost of electricity consumed by the heater. " + ...
    "Include a separate Scope block with two displays to show " + ...
    "both the instantaneous heater power and cumulative cost " + ...
    "of electricity consumed throughout the simulation. " + ...
    "The unit price of electricity is stored in the simulation data. " + ...
    "Run a simulation once you're finished and show the new scope.");
open_system(modelName+"/Heater");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 6: Generate Controller Code
%[text] In Model-Based Design, we typically want to deploy some part of our design (such as a controller) using automatic code generation. Agents can leverage code generation capabilities in MATLAB and Simulink to deterministically create traceable code from our design. You can even ask the agent to target specific hardware platforms, implement certain optimizations, etc.
%[text] Ask the agent to create C code for the thermostat controller targeting a generic 32-bit embedded platform and optimizing for memory footprint. 
myTerminal.run("Generate embedded C code for the `Thermostat` subsystem. " + ...
    "Use a generic 32-bit embedded processor as the target hardware " + ...
    "and optimize the generated code for memory footprint. " + ...
    "Open the code generation report when finished.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] 
%[text] ### Step 7: Clean Up
%[text] Note: Only run this section if you have completed the sections above **and** you do not intend to run the optional prompts below. 
%[text] %[text:anchor:TMP_860b] We finish the exercise by shutting down the MATLAB terminal used for the agent and closing the current project to ensure a proper cleanup.
% Shut down the MATLAB terminal session
delete(myTerminal)
% Close the active MATLAB project
close(myProj);
%[text] 
%%
%[text] ## 
%[text] ## Further Exploration 
%[text] This exercise showed how agents, with the help of Simulink Agentic Toolkit, can complete real debugging and modeling tasks. The same pattern extends well beyond this simple example. A few ways to keep building on it:
%[text:table]{"columnWidths":[139,683]}
%[text] |  | Example |
%[text] | --- | --- |
%[text] | Execute trade study | <p>Trade studies are a great way to use simulations to answer an investigative question about our system, and agents are great at orchestrating these kinds of studies. </p><p>Ask the agent to analyze how changing the thermostat setpoint affects power consumption and operating cost, and to document its findings via a MATLAB live script (which we can later reuse).</p><p></p><p>Prompt:</p><p>`Using simulations, run a trade study analyzing how changing the allowed temperature range by +/- 1 degree affects power consumption and operating cost. Create a MATLAB live script to execute and document the trade study. Visualize the results using report-quality MATLAB figures. Open the live script once you've finished.`</p><p></p> |
%[text] | Run SIL test | <p>Software-in-the-loop (SIL) testing is an important part of Model-Based Design. SIL testing helps us verify that a piece of logic behaves the same after being converted into embedded code as it does in normal simulation. Agents can easily leverage built-in SIL testing functionality in Simulink.</p><p></p><p>Prompt:</p><p>`Run a SIL equivalency test to verify the generated C code.`</p><p></p> |
%[text] | Model-Based Design best practices | <p>MathWorks has established many best practices for Model-Based Design, such as where and how model data is stored. Agents can be very useful for implementing this kind of refactoring and organization work.</p><p></p><p>Prompt:</p><p>`Currently, the simulation data is initialized from sldemo_househeat_data.m. Create a data dictionary named "HouseHeatingData.sldd" to store the data instead.`</p><p></p> |
%[text] | Synthetic data generation | <p>Not only can agents use MATLAB and Simulink to generate synthetic data, but the can also use the data they were trained on as well as external sources to create realistic synthetic data. For instance, we could ask our agent to create a reasonable outdoor temperature profile for an Autumn day at the primary MathWorks office.</p><p></p><p>Prompt:</p><p>`Generate a synthetic outdoor temperature data profile (in Celsius) representing average conditions in November in Natick, Massachusetts, USA. The profile should be 24 hours long. Modify the model so the user has the option to manually switch between the nominal temperature profile and synthetic temperature data.`</p><p></p> |
%[text:table]
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
