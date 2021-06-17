%% Genetic Algorithm of True Function, Max. 50000 Function Evaluations
clear  
close all 
clc
%% Call Fitness Function

FF = @DragCostUTOPIAE;

%% Set Optimistaion Bounds

lb = zeros(1,6);
ub = [10 10 100 1000 2000 10000];

%% Start Genetic Algorithm 
opt = xlsread('Results.xlsx', 3, 'B2:C71'); 
i = 1;
X = [];
F = [];
FK = [];
XK = [];
feval = [];
fevalmax = 50000;
npop = 70;
n1 = fevalmax / (3 * npop);
n = floor(n1);

for i = 1:20
options = optimoptions(@gamultiobj, 'MaxGenerations', n );
[x, fval, exitflag, output] = gamultiobj(FF,6,[],[],[],[],lb,ub,options);
feval = [feval ; output.funccount];
X = [X  x];
F = [F  fval];
%% Kriging

[Xk, Fk] = krige(lb, ub);
XK = [XK; Xk];
FK = [FK; Fk];
sz1 = size(FK, 1);
sz2 = size(Fk ,1);
delta = sz1-sz2;

   
  
    scatter(FK((1 + delta):end ,1), FK((1 + delta):end ,2));
    hold on 
    scatter(opt(:,1),opt(:,2),'*','r')
    title('Surrogate Model')
    

end
%% Plotting
q = 0
     
    figure
for q=0:19
    hold on
    scatter(F(:,1+(2*q)),F(:,2+(2*q)))
    hold on
    scatter(opt(:,1),opt(:,2),'*','r')
    hold on
    title('Genetic Algorithm')
    

    q=q+1;
end
%     
    
%     subplot(3,1,3)
%     scatter(Fk(:,1), Fk(:,2))
%     hold on
%      scatter(Fcomp(:,1), Fcomp(:,2))
%     title('Kriging Comparison')
    
% saveas(gcf, 'theta.tif')
% saveas(gcf, 'theta.fig')
% 
% xlswrite('Kriging.xlsx', FK)
% xlswrite('Genetic Alogrithm.xlsx', F)
