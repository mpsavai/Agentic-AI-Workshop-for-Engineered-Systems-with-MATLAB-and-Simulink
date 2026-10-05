function result = inspectSensorFrame(frameIndex)
% Show one frame from the bundled sensor log.

% inspectSensorFrame(frameIndex) loads the local sensor log, returns a short
% summary, and plots radar, vision, and lane detections in a bird's-eye view.
% Coordinates are in the sensor-vehicle frame: x is forward, y is lateral.

arguments
    frameIndex (1, 1) double {mustBeInteger, mustBePositive} = 99
end

% Load the local sensor log each time so the function has no setup dependencies.
scenario = localLoadScenario();

% Clamp the requested frame so values beyond the end still show the last
% available frame instead of throwing an indexing error.
frameIndex = min(frameIndex, scenario.FrameCount);
radarFrame = scenario.Radar(frameIndex);
visionFrame = scenario.Vision(frameIndex);
laneFrame = scenario.Lane(frameIndex);

% Return key context for interpreting the plotted snapshot.
result = struct;
result.FrameIndex = frameIndex;
result.FrameCount = scenario.FrameCount;
result.TimeSeconds = scenario.TimeSeconds(frameIndex);
result.RadarCount = radarFrame.numObjects;
result.VisionCount = visionFrame.numObjects;

% Build a plot in sensor-vehicle coordinates. The sensor
% vehicle is at (0, 0), positive x is distance ahead, and y is left/right.
forwardLimit = 60;
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
localDrawRoad(ax);
rectangle(ax, Position=[-1.2 -0.75 2.4 1.5], Curvature=[0.35 0.35], ...
    FaceColor=[0.10 0.14 0.20], EdgeColor="none");
patch(ax, [1.2 1.8 1.2], [-0.75 0 0.75], [0.10 0.14 0.20], EdgeColor="none");
quiver(ax, 0, 0, 2.8, 0, 0, Color=[0.10 0.14 0.20], LineWidth=1.8, ...
    MaxHeadSize=0.8);
localPlotLane(ax, laneFrame.left, forwardLimit);
localPlotLane(ax, laneFrame.right, forwardLimit);
localPlotObjects(ax, radarFrame.object, radarFrame.numObjects, [0.00 0.45 0.85], 52);
localPlotObjects(ax, visionFrame.object, visionFrame.numObjects, [0.96 0.38 0.08], 58);
hold(ax, "off");
grid(ax, "on");
axis(ax, "equal");
xlim(ax, [-5 forwardLimit]);
ylim(ax, [-12 12]);
xlabel(ax, "Distance ahead (m)", FontSize=18, FontWeight="bold");
ylabel(ax, "Left/right position (m)", FontSize=18, FontWeight="bold");
title(ax, "Sensor Detections Around the Vehicle", FontSize=22, ...
    FontWeight="bold", Color=[0.10 0.14 0.20]);
text(ax, 0.02, 0.96, sprintf("Frame %03d / %03d   |   t = %.2f s", ...
    frameIndex, scenario.FrameCount, result.TimeSeconds), Units="normalized", ...
    FontSize=16, FontWeight="bold", Color=[0.10 0.14 0.20], ...
    VerticalAlignment="top", BackgroundColor=[0.98 0.99 1.00], Margin=6);
localDrawKey(ax);
end

function scenario = localLoadScenario()
% Load the sensor log and standardize names used by this function.
fileName = "citySensorLog.mat";
dataPath = fullfile(fileparts(mfilename("fullpath")), fileName);
if ~isfile(dataPath)
    error("inspectSensorFrame:MissingData", ...
        "Could not find %s next to inspectSensorFrame.m.", fileName);
end

raw = load(dataPath);
scenario = struct;
scenario.Vision = raw.vision;
scenario.Radar = raw.radar;
scenario.Lane = raw.lane;
scenario.FrameCount = numel(raw.vision);
scenario.TimeSeconds = localTimeSeconds(raw.vision);
end

function timeSeconds = localTimeSeconds(vision)
% Convert microsecond timestamps to elapsed seconds from the first frame.
timeStamp = double([vision.timeStamp]);
timeSeconds = (timeStamp - timeStamp(1))*1e-6;
end

function localPlotObjects(ax, objects, objectCount, colorValue, markerSize)
% Object positions are [x y z]; only x and y are needed for this top-down view.
if objectCount < 1
    return
end
positions = reshape([objects(1:objectCount).position], 3, []);
scatter(ax, positions(1, :), positions(2, :), markerSize, colorValue, "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
end

function localPlotLane(ax, laneBoundary, forwardLimit)
% Lane boundaries are stored as y = offset + x*tan(heading) + curvature*x^2.
if ~isfield(laneBoundary, "isValid") || ~laneBoundary.isValid
    return
end
x = linspace(0, forwardLimit, 60);
y = laneBoundary.offset + x*tan(laneBoundary.headingAngle) + laneBoundary.curvature*x.^2;
plot(ax, x, y, Color=[0.25 0.25 0.25], LineStyle="--", LineWidth=1.4);
end

function localDrawRoad(ax)
patch(ax, [-5 60 60 -5], [-2.1 -2.1 2.1 2.1], [0.84 0.87 0.91], ...
    EdgeColor="none", FaceAlpha=0.55);
end

function localDrawKey(ax)
hold(ax, "on");
keyX = 48.5;
keyY = 9.8;
keyWidth = 10.4;
keyHeight = 6.0;
patch(ax, [keyX keyX+keyWidth keyX+keyWidth keyX], ...
    [keyY-keyHeight keyY-keyHeight keyY keyY], [1 1 1], ...
    FaceAlpha=0.92, EdgeColor=[0.55 0.60 0.67], LineWidth=0.8);
scatter(ax, keyX+0.8, keyY-1.1, 52, [0.00 0.45 0.85], "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
text(ax, keyX+1.6, keyY-1.1, "Radar", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
scatter(ax, keyX+0.8, keyY-2.25, 58, [0.96 0.38 0.08], "filled", ...
    MarkerEdgeColor="w", LineWidth=0.7);
text(ax, keyX+1.6, keyY-2.25, "Vision", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
plot(ax, [keyX+0.35 keyX+1.25], [keyY-3.45 keyY-3.45], "--", ...
    Color=[0.25 0.25 0.25], LineWidth=1.4);
text(ax, keyX+1.6, keyY-3.45, "Lane boundary", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
rectangle(ax, Position=[keyX+0.35 keyY-5.0 0.9 0.55], ...
    Curvature=[0.35 0.35], FaceColor=[0.10 0.14 0.20], EdgeColor="none");
text(ax, keyX+1.6, keyY-4.72, "Sensor vehicle", FontSize=14, ...
    VerticalAlignment="middle", Color=[0.10 0.14 0.20]);
hold(ax, "off");
end
