%% Examples of Smooth Functions
close all
clear
clc

addpath("..\labelLines");

if isMATLABReleaseOlderThan("R2025a")
    tempFig = figure();
else
    tempFig = figure(Theme="light");
end
tempAx = axes;

figOpts = {"Units", "inches", ...
    "defaultTiledLayoutTileSpacing", "compact", ...
    "defaultTiledLayoutPadding", "compact", ...
    "defaultAxesFontSize", 14, ...
    "defaultTextFontSize", 14, ...
    "defaultTextboxshapeFontSize", 14, ...
    "defaultAxesLineWidth", 1.0, ...
    "defaultLineLineWidth", 1.5, ...
    "defaultAxesXColor", "k", ...
    "defaultAxesYColor", "k", ...
    "defaultAxesLineStyleCyclingMethod", "withColor" ...
 };
if ~isMATLABReleaseOlderThan("R2025a")
    figOpts = [figOpts, {"Theme", tempFig.Theme.BaseColorStyle}];
end

close(tempFig);

%% Smooth functions of one variable
s = Smooth(tol=1);
x = linspace(-10, 10, 401);

hf = figure("Name", "Smooth_Functions", ...
    figOpts{:}, ...
    "Position", [1,1,6.5,4], ...
    "defaultAxesLineStyleOrder", [":", "-"]);
tiledlayout(2, 2);

ha = nexttile();hold on;grid off;box on;
ylabel("step");
h1 = plot(x, zeros(size(x))+(x>0), ":", ...
    DisplayName="Step");
h2 = plot(x, s.step(x), "-", ...
    DisplayName="SmoothStep");
ha.YLim = [-0.1, 1.1];
ha.YTick = 0:0.5:1;
hlabel1 = label_line(h1, 0.65, String="Original", Pin=200, PinOffset=4);
hlabel2 = label_line(h2, 0.65, String="Smooth", Pin=-45, PinOffset=0);

ha = nexttile;hold on;grid off;box on;
ylabel("sign");
plot(x, sign(x), ...
    DisplayName="Sign");
plot(x, s.sign(x), ...
    DisplayName="SmoothSign");
ha.YLim = [-1.1, 1.1];
ha.YTick = -1:1:1;

ha = nexttile;hold on;grid off;box on;
ylabel("abs");
xlabel("x/tol");
plot(x, abs(x), ...
    DisplayName="abs");
plot(x, s.abs(x), ...
    DisplayName="SmoothAbs");
ha.YLim = [-1, 11];
ha.YTick = 0:5:10;

ha = nexttile;hold on;grid off;box on;
ylabel("sign(x)•√|x|");
xlabel("x/tol");
plot(x, sign(x).*sqrt(abs(x)), ...
    DisplayName="sign_sqrt");
plot(x, s.sign_sqrt(x), ...
    DisplayName="SmoothSqrt");
ha.YLim = [-4, 4];
ha.YTick = -3:3:3;
print("images\\" + hf.Name, "-dsvg");

% title(layout, "Non-smooth vs Smooth Approximations", ...
%     FontWeight="normal", FontSize=ha.FontSize, FontName=ha.FontName);

%% Different Sigmoid functions
s(1) = Smooth("irrational", tol=1);
s(2) = Smooth("hyperbolic", tol=1);
s(3) = Smooth("inv-trig", tol=1);
x = linspace(-10, 10, 401);

hf = figure("Name", "Sigmoid_Options", figOpts{:}, ...
    Position=[1,1,6.5,4]);
ha = axes("LineStyleOrder", ["-", "--", ":"]);
hold on;box on;
ylabel("Smooth Sign Function");
xlabel("x/tol");
ha.XLim = x([1,end]);
ha.YLim = [-1, 1]*1.1;
ha.YTick = -1:1:1;
for i = 1:length(s)
    plot(x, s(i).sign(x), DisplayName=s(i).type);
end
label_line(ha.Children(1), 0.8, Pin=-45,       PinOffset=2);
label_line(ha.Children(3), 0.7, Pin=[-45, 50], PinOffset=2);
label_line(ha.Children(2), 0.7, Pin=170,       PinOffset=2);
print("images\\" + hf.Name, "-dsvg");

%% Convergence
x = linspace(-10, 10, 401);
s = Smooth();
hf = figure("Name", "Convergence", figOpts{:}, ...
    Position=[1,1,6.5,4]);
ha = axes;hold on;box on;
ylabel("Smooth Sign Function");
xlabel("x");
ha.XLim = x([1,end]);
ha.YLim = [-1, 1]*1.1;
ha.YTick = -1:1:1;
tol = [10, 7, 5, 3, 2, 1, 0.7, 0.5, 0.3, 0.2, 0.1, 0.01];
for i = 1:length(tol)
    plot(x, s.sign(x, tol(i)), ...
        DisplayName=sprintf("tol=%g", tol(i)));
end
label_line(ha.Children(12), 0.85, Pin=[300, 20], PinOffset=2)
label_line(ha.Children(10), 0.75, Pin=[300, 55], PinOffset=2)
label_line(ha.Children( 7), 0.65, Pin=[300, 90], PinOffset=2)
label_line(ha.Children( 1), 0.69, Pin=[200, 20], PinOffset=6)
label_line(ha.Children( 2), 0.68, Pin=[220, 40], PinOffset=3)
print("images\\" + hf.Name, "-dsvg");

%% Convergence Animation
figure("Name", "ConvergenceAnimation", figOpts{:}, ...
    Position=[1,1,12,4]);
ha = gobjects(1, 2);
layout = tiledlayout(1, 2);
ha(1) = nexttile;hold on;grid off;box on;
ylabel("Smooth Sign Function");
xlabel("x");
ha(1).XLim = x([1,end]);
ha(1).YLim = [-1, 1]*1.1;
ha(1).YTick = -1:1:1;

ha(2) = nexttile;hold on;grid off;box on;
ylabel("Smooth Abs Function");
xlabel("x");
ha(2).XLim = x([1,end]);
ha(2).YLim = [-1, 11];
ha(2).YTick = 0:5:10;

tol = logspace(1, -2, 13);
h = gobjects(numel(tol), 2);
for i = 1:numel(tol)
    if i > 1
        h(i-1, 1).Color = 0.3*ha(1).XColor + 0.7*ha(1).Color;
        h(i-1, 2).Color = h(i-1, 1).Color;
    end
    h(i, 1) = plot(ha(1), x, s.sign(x, tol(i)), Color=ha(1).XColor);
    h(i, 2) = plot(ha(2), x, s.abs(x, tol(i)), Color=ha(1).XColor);
    title(layout, sprintf("tol = %5.3f", tol(i)), FontWeight="normal");
    print(sprintf("images\\conv_animation_%02d", i), "-dsvg");
end