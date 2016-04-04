clc; clear; % limpar console
fun = @ObjFunc; % definição do problema
x0 = [485000,185000]; % valor inicial 
% testar x0 = [485000,29411];
opt = optimset('fminunc');
opt = optimset(opt,'Display','iter'); 
opt = optimset(opt,'GradObj','on'); % definindo trust-region Newton
[x,fval,exitflag,output,grad,hessian] = fminunc(fun,x0,opt)
eigHessian = eig(hessian)





