%[text] # Agentic AI Workflows with Simulink for Model-Based Design
%[text] This hands-on exercise shows how an agent can connect with Simulink to support model-based design workflows. 
%[text:tableOfContents]{"heading":"Workshop Contents"}
%%
%[text] ## 
%[text] ## Setup
%[text] We will use projects to manage our files for this exercise as well as the next. MATLAB Projects help you organize your work and collaborate. Use projects to find files required to run your code, manage and share files and settings, and interact with source control. For more information about projects, see [Create Projects](https://www.mathworks.com/help/matlab/matlab_prog/create-projects.html).
%[text] First we will open our project. At startup, we have configured the project to execute setupExercise3 which does the following: 
%[text] - Close MATLAB-managed terminals
%[text] - Make WorkingFolder\_Ex3 your working folder, This is where the agent will be working.
%[text] - Close any open figures, clear variables in workspace and clear command window \
% Open exercise project
scriptFile = matlab.desktop.editor.getActiveFilename;
scriptDir = fileparts(scriptFile);
myProj = openProject(fullfile(scriptDir, "WorkingFolder_Ex3"));
%[text] %[text:anchor:TMP_730c] **Open Your Agent in the Current Working Folder**
% Open a Terminal in the house heating Simulink model
modelName = "HouseHeating";
open_system(modelName);
myTerminal = terminal(Place="simulink",Theme="dark",StartupCommand="codex"); 
%[text] **Action**: Depending on the path your agent takes, you will be asked to approve particular actions based on your prompts. Use your own evaluation and approve the decisions as you see fit. 
%[text] 
%%
%[text] ## 
%[text] ## Exercise
%[text] ### Step 1: Analyze House Heating Model
%[text] Before working with a Simulink model, we should understand its contents and structure at a high level, and the same applies when working with agents. One advantage of working with agents is that they can not just *explain* the contents of a model, but *reason* about them as well. 
%[text] Ask the agent to examine the model and give some analysis regarding heat flow through the model.
myTerminal.run("Analyze the Simulink model HouseHeating.slx and " + ...
    "provide an overview of its major components and subsystems. " + ...
    "Also provide equations for the heat transfer mechanism.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### **Step 2:** Run Simulation an**d Analyze Results**
%[text] Run a 24-hour simulation of the house heating system and analyze the results.
sim(modelName);
%[text] Notice that the temperature inside the house far exceeds the bounds of 18-22 degrees we defined in our thermostat logic. In the next step, we will ask our agent to help us debug this.
%[text] 
%%
%[text] ### 
%[text] ### **Step 3: Debug Thermostat Logic**
%[text] The house heating model contains a thermostat whose logic is implemented using a state chart in Stateflow. The thermostat is designed to keep the house temperature between 18-22 degrees Celsius, but simulation results show that these limits are being violated. 
%[text] Ask the agent to investigate the issue.
myTerminal.run("During simulation, the house temperature " + ...
    "far exceeds the temperature bounds used by the thermostat. " + ...
    "The thermostat should promptly switch on/off when the " + ...
    "temperature bounds are violated. Investigate the issue " + ...
    "and create a simple test to capture the faulty logic.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 4: Correct Controller Logic and Verify
%[text] After assessing the agent's findings on the thermostat bug, we can implement the fix ourselves or simply ask the agent to do it for us (using the already-created test harness as a verification gate).
myTerminal.run("Change the thermostat sample time to 5 " + ...
    "seconds and verify it using the same test we just " + ...
    "created. Then run a full simulation to check the " + ...
    "house stays within the desired 18-22 degree range.");
pause(1)
myTerminal.run("");
%[text] 
%%
%[text] ### 
%[text] ### Step 5: Add Heater Cost Calculation
%[text] Agents can also be useful tools for extending existing models to add new functionality. For instance, we may want to calculate the operating cost of our heater, so we can ask our agent to add some logic to the model to do exactly that.
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
%[text] In Model-Based Design, we typically want to move some part of our design (such as a controller) to production through automatic code generation. Agents can leverage code generation capabilities in MATLAB and Simulink to deterministically create traceable code from a design. You can even ask the agent to target specific hardware platforms, implement certain optimizations, etc.
%[text] Ask the agent to create C code for the thermostat controller targeting a generic 32-bit embedded platform and optimizing for memory footprint. 
myTerminal.run("Generate embedded C code for the thermostat controller subsystem. " + ...
    "Target a generic 32-bit embedded processor and optimize for memory footprint. " + ...
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
%[text] This exercise showed how far natural-language prompts and a couple of built-in skills can complete a real debugging and modeling task. The same pattern extends well beyond this one example. A few ways to keep building on it:
%[text:table]{"columnWidths":[139,683]}
%[text] |  | Example |
%[text] | --- | --- |
%[text] | Execute trade study | <p>Trade studies are a great way to use simulations to answer an investigative question about our system, and agents are great at orchestrating these kinds of studies. </p><p>Ask the agent to analyze how changing the thermostat setpoint affects power consumption and operating cost, and to document its findings via a MATLAB live script (which we can later reuse).</p><p></p><p>Prompt:</p><p>`Using simulations, run a trade study analyzing how changing the allowed temperature range by +/- 1 degree affects power consumption and operating cost. Create a MATLAB live script to execute and document the trade study. Visualize the results using report-quality MATLAB figures. Open the live script once you've finished.`</p> |
%[text] | Run SIL test | <p>Software-in-the-loop (SIL) testing is an important part of Model-Based Design. SIL testing helps us verify that a piece of logic behaves the same after being converted into embedded code as it does in normal simulation. Agents can easily leverage built-in SIL testing functionality in Simulink.</p><p></p><p>Prompt:</p><p>`Run a SIL equivalency test to verify the generated C code.`</p> |
%[text] | Model-Based Design best practices | <p>MathWorks has established many best practices for Model-Based Design, such as where and how model data is stored. Agents can be very useful for implementing this kind of refactoring and organization work.</p><p></p><p>Prompt:</p><p>`Currently, the simulation data is initialized from sldemo_househeat_data.m. Create a data dictionary named "HouseHeatingData.sldd" to store the data instead.`</p> |
%[text] | Synthetic data generation | <p>Not only can agents use MATLAB and Simulink to generate synthetic data, but the can also use the data they were trained on as well as external sources to create realistic synthetic data. For instance, we could ask our agent to create a reasonable outdoor temperature profile for an Autumn day at the primary MathWorks office.</p><p></p><p>Prompt:</p><p>`Generate a synthetic outdoor temperature data profile (in Celsius) representing average conditions in November in Natick, Massachusetts, USA. The profile should be 48 hours long. Modify the model so the user has the option to manually switch between the nominal temperature profile and synthetic temperature data.`</p> |
%[text:table]
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
