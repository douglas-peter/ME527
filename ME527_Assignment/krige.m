function [Xk, Fk]= krige(lb, ub)
ndim=6;
TRUE_F=@(x) DragCostUTOPIAE(x);



%% DOE
nn=64; %improve
xKept = xinit(lb,ub);
% xKept=lhsdesign(nn,ndim,'criterion','maximin','iterations',10000);
% options = optimoptions(@gamultiobj, 'MaxGenerations', nn );
% [xKept, fval, exitflag, output] = gamultiobj(TRUE_F,6,[],[],[],[],lb,ub,options);

%% Evaluation of the two objectives
yKept1=[];
yKept2=[];
for i=1:nn
    [f]=TRUE_F(xKept(i,:));
    yKept1=[yKept1; f(1)];
    yKept2=[yKept2; f(2)];
end



% addpath('.\dace')
theta = [10 10 50 200 400 2000]; lob = [1e-1 1e-1 1e-1 1e-1 1e-1 1e-1]; upb =  [25 25 100 100 500 5000];
[dmodel1, perf1] = dacefit(xKept,yKept1, @regpoly0, @corrgauss, theta, lob, upb);
[dmodel2, perf2] = dacefit(xKept,yKept2, @regpoly0, @corrgauss, theta, lob, upb);
dmodel10=dmodel1;
dmodel20=dmodel2;

%% Definition of the surrogate model that should be passed to optimiser
fg_1=@(x) predictor(x,dmodel1);
fg_2=@(x) predictor(x,dmodel2);
FITNESSFCN=@(x) [fg_1(x);fg_2(x)];



ng=0;
ngmax=0;

while size(yKept1,1)<600 && ng<200
    %% Setting of the GA options
    PopSize=5000;
    X0=lhsdesign(PopSize,ndim,'criterion','maximin','iterations',10000);
    optionsGA = optimoptions('gamultiobj','PopulationSize',PopSize,'PlotFcn',@gaplotpareto,'InitialPopulationMatrix',X0);
    naddMax=100; %change
    naddZ=0;
    ngmax=ngmax+5;
    %% Surrogate based Optimisation loop
    while naddZ<=2 && size(yKept1,1)<600
        ng=ng+1;
        optionsGA = optimoptions('gamultiobj','PopulationSize',PopSize,'MaxGenerations',ngmax,'InitialPopulationMatrix',xKept,'Display','none');
        [X,FVAL,EXITFLAG,OUTPUT,POPULATION,SCORE] = gamultiobj(FITNESSFCN,ndim,[],[],[],[],lb,ub,[],optionsGA);
        X0=POPULATION;
        update_database
        
        if nadd>0
            [dmodel1, perf1] = dacefit(xKept,yKept1, @regpoly0, @corrgauss, theta, lob, upb);
            [dmodel2, perf2] = dacefit(xKept,yKept2, @regpoly0, @corrgauss, theta, lob, upb);
            
            
            fg_1=@(x) predictor(x,dmodel1);
            fg_2=@(x) predictor(x,dmodel2);
            FITNESSFCN=@(x) [fg_1(x);fg_2(x)];
        end
        if nadd==0
            naddZ=naddZ+1;
        else
            naddZ=0;
        end
%         disp([size(yKept1) nadd naddZ])
    end    
    disp('**************************************************************************************************************************************************')
    disp('Result obtained using Kriing to create surrogate model')
    disp('**************************************************************************************************************************************************')
    Xk = X;
    Fk = FVAL;
end
end
