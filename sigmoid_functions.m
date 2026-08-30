%% sigmoid_functions
% plot different sigmoid functions

close all
clear
clc

%%
x = linspace(-10, 10, 501);

c = log(sqrt(2) - 1);
%         "exponential", @(x, a) 1.0./(1+exp(-a.*x)); ...
funs = {"rational", @(x, a) 0.5*(1 + x./(abs(x) + abs(a))); ...
        "irrational", @(x, a) 0.5*(1 + x./sqrt(x.^2+a.^2)); ...
        "exponential", @(x, a) 0.5 + 0.5.*sign(x).*(1-exp(-a.*abs(x))); ...
        "logarithmic", @(x, a) log((1+exp(a.*x).*exp(0.5))./(1+exp(a.*x).*exp(-0.5))); ...
        "trigonometric", @(x, a) sin(pi./(2+2.*exp(-a.*x))); ...
        "inv-trig", @(x, a) 0.5 + 1./pi.*atan(a.*x); ...
        "hyperbolic", @(x, a) 0.5 + 0.5*tanh(a.*x); ...
        "inv-hyper", @(x, a) 2.0./pi.*asin(1.0./(1+exp(-a.*x+a.*c))); ...
        "special", @(x, a) 0.5 + 0.5.*erf(a.*x./sqrt(2));
};

%% Individual plots
figure;
for i = 1:size(funs, 1)
    f = funs{i, 2};
    nexttile;hold on;box on;
    title(funs{i, 1}, FontWeight="normal");
    plot(x, f(x, 1));
end

%% combined plot
figure;
ha = axes;hold on;box on;
ha.LineStyleOrder = ["-", "--", ":"];
for i = 1:size(funs, 1)
    f = funs{i, 2};
    plot(x, f(x, 1), DisplayName=funs{i, 1});
end
legend(Location="NorthWest");