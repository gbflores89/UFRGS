clc; clear; % limpar console
fun = @ObjFunc; % defini��o do problema
x0 = [485000,185000]; % valor inicial
fval0 = fun(x0); % fun��o objetivo avaliado no valor inicial 
opt = optimset('fminunc');
opt = optimset(opt,'Display','iter'); 
opt = optimset(opt,'GradObj','on'); % definindo trust-region Newton
[x,fval,exitflag,output,grad,hessian] = fminunc(fun,x0,opt)
eigHessian = eig(hessian)





