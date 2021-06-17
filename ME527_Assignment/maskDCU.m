function [F1,F2]=maskDCU(x)

FF=DragCostUTOPIAE(x);
F1=FF(1);
F2=FF(2);
end