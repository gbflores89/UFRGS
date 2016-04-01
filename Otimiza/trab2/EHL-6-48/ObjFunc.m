function [f,g] = ObjFunc(x)
% Calculate objective f
f = 13.9+58.05555556/x(1)^.3017+11.26569680*x(1)^.4925/x(2)+(0.5294030451e-4*(8484.00000*x(1)^.7952+1268.40000*(2*x(1)+1.2*x(2))^.861))/x(2)+.6302396198/x(2)^1.1899+0.2913888889e-3*x(2)^.671;
if nargout > 1 % gradient required
    g = ObjFuncGrad(x);
end
