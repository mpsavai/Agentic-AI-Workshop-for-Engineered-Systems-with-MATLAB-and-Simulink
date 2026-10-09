function result = inspectSensorFrame(frameIndex)
%inspectSensorFrame - Plot one sensor-log frame in a bird's-eye view
%   RESULT = inspectSensorFrame(FRAMEINDEX) loads the bundled sensor log,
%   plots radar, vision, and lane detections, and returns frame metadata.
%
%   RESULT = inspectSensorFrame() plots frame 99.


arguments
    frameIndex (1, 1) double {mustBeInteger, mustBePositive} = 99
end

% Load the local sensor log each time so no setup is required.
scenario = localLoadScenario();

% Select synchronized detections and clamp requests beyond the final frame.
frameIndex = min(frameIndex, scenario.FrameCount);
radarFrame = scenario.Radar(frameIndex);
visionFrame = scenario.Vision(frameIndex);
laneFrame = scenario.Lane(frameIndex);

% Return the context needed to interpret the plotted snapshot.
result = struct( ...
    FrameIndex=frameIndex, ...
    FrameCount=scenario.FrameCount, ...
    TimeSeconds=scenario.TimeSeconds(frameIndex), ...
    RadarCount=radarFrame.numObjects, ...
    VisionCount=visionFrame.numObjects);

% Build a plot in sensor-vehicle coordinates. The sensor
% vehicle is at (0, 0), positive x is distance ahead, and y is left/right.
forwardLimit = 60;

% Reuse colors in the scene and the key to keep them consistent.
radarColor = [0.00 0.45 0.85];
visionColor = [0.96 0.38 0.08];
vehicleColor = [0.10 0.14 0.20];

% Draw the road, vehicle, lane boundaries, and sensor detections.
ax = localCreateAxes();
localDrawRoad(ax);
localDrawVehicle(ax, vehicleColor);
localPlotLane(ax, laneFrame.left, forwardLimit);
localPlotLane(ax, laneFrame.right, forwardLimit);
localPlotObjects(ax, radarFrame.object, radarFrame.numObjects, radarColor, 52);
localPlotObjects(ax, visionFrame.object, visionFrame.numObjects, visionColor, 58);
hold(ax, "off");

% Add display context after the scene content is complete.
localFormatAxes(ax, scenario, result, forwardLimit, vehicleColor);
localDrawKey(ax, radarColor, visionColor, vehicleColor);
end

function scenario = localLoadScenario()
%localLoadScenario - Load and standardize the bundled sensor log
codeFolder = fileparts(mfilename("fullpath"));
projectFolder = fileparts(codeFolder);
dataPath = fullfile(projectFolder, "data", "citySensorLog.mat");
if ~isfile(dataPath)
    error("inspectSensorFrame:MissingData", ...
        "Could not find sensor log at %s.", dataPath);
end

raw = load(dataPath, "vision", "radar", "lane");
scenario = struct;
scenario.Vision = raw.vision;
scenario.Radar = raw.radar;
scenario.Lane = raw.lane;
scenario.FrameCount = numel(raw.vision);
scenario.TimeSeconds = localTimeSeconds(raw.vision);
end

function timeSeconds = localTimeSeconds(vision)
%localTimeSeconds - Convert timestamps to elapsed seconds
%The first vision timestamp is the zero-time reference.
timeStamps = double([vision.timeStamp]);
timeSeconds = (timeStamps - timeStamps(1))*1e-6;
end

function ax = localCreateAxes()
%localCreateAxes - Create the configured bird's-eye plotting area
fig = figure(Name="Sensor Frame Snapshot");
fig.Position(3:4) = [1600 600];
fig.Color = [0.98 0.99 1.00];

ax = axes;
ax.PositionConstraint = "innerposition";
ax.FontSize = 16;
ax.Color = [0.93 0.95 0.98];
ax.XColor = [0.18 0.22 0.28];
ax.YColor = [0.18 0.22 0.28];
ax.GridColor = [0.75 0.79 0.85];
ax.GridAlpha = 0.35;
hold(ax, "on");
end

function localDrawVehicle(ax, vehicleColor)
%localDrawVehicle - Draw the sensor vehicle and its forward direction
rectangle(ax, Position=[-1.2 -0.75 2.4 1.5], Curvature=[0.35 0.35], ...
    FaceColor=vehicleColor, EdgeColor="none");
patch(ax, [1.2 1.8 1.2], [-0.75 0 0.75], vehicleColor, EdgeColor="none");
quiver(ax, 0, 0, 2.8, 0, 0, Color=vehicleColor, LineWidth=1.8, ...
    MaxHeadSize=0.8);
end

function localPlotObjects(ax, objects, objectCount, colorValue, markerSize)
%localPlotObjects - Plot valid object positions in sensor coordinates
% Object positions are [x y z]; only x and y are needed for this view.
if objectCount < 1
    return
end
positions = reshape([objects(1:objectCount).position], 3, []);
scatter(ax, positions(1, :), positions(2, :), markerSize, colorValue, "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
end

function localPlotLane(ax, laneBoundary, forwardLimit)
%localPlotLane - Plot a valid lane boundary in sensor coordinates
% Lane boundaries use y = offset + x*tan(heading) + curvature*x^2.
if ~isfield(laneBoundary, "isValid") || ~laneBoundary.isValid
    return
end
xCoordinates = linspace(0, forwardLimit, 60);
yCoordinates = laneBoundary.offset + xCoordinates*tan(laneBoundary.headingAngle) + ...
    laneBoundary.curvature*xCoordinates.^2;
plot(ax, xCoordinates, yCoordinates, Color=[0.25 0.25 0.25], ...
    LineStyle="--", LineWidth=1.4);
end

function localDrawRoad(ax)
%localDrawRoad - Draw the road surface behind the scene content
patch(ax, [-5 60 60 -5], [-2.1 -2.1 2.1 2.1], [0.84 0.87 0.91], ...
    EdgeColor="none", FaceAlpha=0.55);
end

function localFormatAxes(ax, scenario, result, forwardLimit, vehicleColor)
%localFormatAxes - Add labels, frame context, and display limits
grid(ax, "on");
axis(ax, "equal");
xlim(ax, [-5 forwardLimit]);
ylim(ax, [-12 12]);
xlabel(ax, "Distance ahead (m)", FontSize=18, FontWeight="bold");
ylabel(ax, "Left/right position (m)", FontSize=18, FontWeight="bold");
title(ax, "Sensor Detections Around the Vehicle", FontSize=22, ...
    FontWeight="bold", Color=vehicleColor);
text(ax, 0.02, 0.96, sprintf("Frame %03d / %03d   |   t = %.2f s", ...
    result.FrameIndex, scenario.FrameCount, result.TimeSeconds), Units="normalized", ...
    FontSize=16, FontWeight="bold", Color=vehicleColor, ...
    VerticalAlignment="top", BackgroundColor=[0.98 0.99 1.00], Margin=6);
end

function localDrawKey(ax, radarColor, visionColor, vehicleColor)
%localDrawKey - Draw the custom detection key
hold(ax, "on");
keyX = 48.5;
keyY = 9.8;
keyWidth = 10.4;
keyHeight = 6.0;
patch(ax, [keyX keyX+keyWidth keyX+keyWidth keyX], ...
    [keyY-keyHeight keyY-keyHeight keyY keyY], [1 1 1], ...
    FaceAlpha=0.92, EdgeColor=[0.55 0.60 0.67], LineWidth=0.8);
scatter(ax, keyX+0.8, keyY-1.1, 52, radarColor, "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
text(ax, keyX+1.6, keyY-1.1, "Radar", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
scatter(ax, keyX+0.8, keyY-2.25, 58, visionColor, "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
text(ax, keyX+1.6, keyY-2.25, "Vision", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
plot(ax, [keyX+0.35 keyX+1.25], [keyY-3.45 keyY-3.45], "--", ...
    Color=[0.25 0.25 0.25], LineWidth=1.4);
text(ax, keyX+1.6, keyY-3.45, "Lane boundary", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
rectangle(ax, Position=[keyX+0.35 keyY-5.0 0.9 0.55], ...
    Curvature=[0.35 0.35], FaceColor=vehicleColor, EdgeColor="none");
text(ax, keyX+1.6, keyY-4.72, "Sensor vehicle", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
hold(ax, "off");
end
