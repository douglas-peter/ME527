% function [f,x,fval] = GA_DragCostU
clear  
close all 
clc
%% Call Fitness Function

FF = @DragCostUTOPIAE

%% Set Optimistaion Bounds

lb = zeros(1,6);
ub = [10 10 100 1000 2000 10000];

%% Start Genetic Algorithm 
i = 1;
X = [];
F = [];
feval = [];
fevalmax = 50000;

% n1 = fevalmax / (3 * npop);
% n = floor(n1);
% for i = 1:20
options = optimoptions(@gamultiobj , 'FunctionTolerance', 1e-6, 'MaxGenerations', 100000);
[x, fval, exitflag, output] = gamultiobj(FF,6,[],[],[],[],lb,ub,options);
feval = [feval ; output.funccount];
X = [X  x];
F = [F  fval];
scatter(F(:,1),F(:,2))
xlswrite('TEST_Pareto_Front.xlsx', F)
i = i + 1;
% end