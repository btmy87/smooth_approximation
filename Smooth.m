classdef Smooth
    % SMOOTH Produce smooth approximations based on a sigmoid function
    %
    % Implementing this as a class makes it easy to swap out the
    % sigmoid function and change the default tolerance.

    properties(GetAccess=public, SetAccess=private)
        f (1, 1) function_handle = @(x, a) nan(size(x));
        tol (1, 1) double = nan
        type (1, 1) string = ""
    end

    methods
        function obj = Smooth(type, opts)
            %SMOOTH Construct an instance of this class
            %   Detailed explanation goes here
            arguments
                type (1, 1) string = "irrational"
                opts.tol (1, 1) double {mustBePositive} = 1e-4;
                opts.fun (1, 1) function_handle = @(x, a) nan(size(x));
            end
            obj.tol = opts.tol;
            obj.type = type;

            % pick a sigmoid function
            type1 = lower(type);
            if type1 == "irrational"
                obj.f = @(x, a) 0.5*(1 + x./sqrt(x.^2+a.^2));
            elseif type1 == "rational"
                obj.f = @(x, a) 0.5*(1 + x./(abs(x) + abs(a)));
            elseif type == "exponential"
                obj.f = @(x, a) 0.5 + 0.5.*sign(x).*(1-exp(-a.*abs(x)));
            elseif type == "logarithmic"
                obj.f = @(x, a) log((1+exp(a.*x).*exp(0.5))./(1+exp(a.*x).*exp(-0.5)));
            elseif type == "inv-trig"
                obj.f = @(x, a) 0.5 + 1./pi.*atan(a.*x);
            elseif type == "hyperbolic"
                obj.f = @(x, a) 0.5 + 0.5*tanh(a.*x); 
            elseif type == "erf"
                obj.f = @(x, a) 0.5 + 0.5.*erf(a.*x./sqrt(2));
            elseif type1 == "custom"
                obj.f = opts.fun;


            else
                error("Unrecognized sigmoid function type")
            end

            % run some checks
            if abs(obj.f(-inf, obj.tol) - 0.0) > 100*eps(0)
                warning("Expected f(-inf, tol) = 0");
            end
            if abs(obj.f(inf, obj.tol) - 1.0) > 100*eps(1)
                warning("Expected f(inf, tol) = 1");
            end
            if abs(obj.f(0, obj.tol) - 0.5) > 100*eps(0.5)
                warning("Expected f(0, tol) = 0.5");
            end

        end

        function y = step(obj, x, tol)
            % step smooth approximation of step function
            arguments
                obj
                x
                tol = obj.tol
            end
            y = obj.f(x, tol);
        end

        function y = sign(obj, x, tol)
            % SIGN smooth approximation of sign function
            arguments
                obj
                x
                tol = obj.tol
            end
            y = 2.0*obj.f(x, tol) - 1.0;
        end

        function y = abs(obj, x, tol)
            % ABS smooth approximation of abs function
            arguments
                obj
                x
                tol = obj.tol
            end
            y = (2.0*obj.f(x, tol) - 1.0).*x;
        end

        function y = sign_sqrt(obj, x, tol)
            % SIGN_SQRT smooth approximation of the sign(x)*sqrt(abs(x))
            arguments
                obj
                x
                tol = obj.tol
            end
            y = (2.0*obj.f(x, tol) - 1.0).*(x.^2 + tol.^2).^0.25;
        end

        function y = switch_s(obj, x, y1, y2, tol)
            % SWITCH_S switch smoothly from y1 if x > 0 to y2 if x < 0
            arguments
                obj
                x
                y1
                y2
                tol = obj.tol
            end
            y = obj.step(x, tol).*y1 + obj.step(-x, tol).*y2;
        end

        function y = min(obj, x1, x2, tol)
            % MIN smooth minimum value
            % note that during transition, a value lower than the minimum
            % of the two can be returned.
            arguments
                obj
                x1
                x2
                tol = obj.tol
            end
            y = obj.switch_s(x1-x2, x2, x1, tol);
        end

        function y = max(obj, x1, x2, tol)
            % MAX smooth maximum value
            % note that during transition, a value higher than the
            % maximum of the two can be returned.
            arguments
                obj
                x1
                x2
                tol = obj.tol
            end
            y = obj.switch_s(x1-x2, x1, x2, tol);
        end
    end
end