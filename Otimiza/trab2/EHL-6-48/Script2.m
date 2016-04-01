clc; clear; % limpar console
fun = @ObjFunc; % definição do problema
x0 = [485000,185000]; % valor inicial
opt = optimset('fminunc');
opt = optimset(opt,'Display','iter'); 
opt = optimset(opt,'GradObj','off'); % definindo Quasi-Newton line search
[x,fval,exitflag,output,grad,hessian] = fminunc(fun,x0,opt)
eigHessian = eig(hessian)






