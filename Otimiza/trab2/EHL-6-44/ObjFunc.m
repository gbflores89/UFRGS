function [f,g] = ObjFunc(x)
% Calculate objective f
f = [93750.0000 - 46875.00000*sqrt(2)*sqrt(pi)*(2000*erf((1/4000)*x*sqrt(2)) + sqrt(4000000))] + (3750.000000*((1/2)*x + (1/2)*pi))*sqrt(2)*sqrt(pi)*(2000*erf((1/4000)*x*sqrt(2)) + sqrt(4000000))*((1/2)*x + (1/4)*sqrt(2)*sqrt(pi));
if nargout > 1 % gradient required
    g = ObjFuncGrad(x);
end
