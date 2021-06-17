function [X0]=xinit( lb, ub)
[r,n] = size(lb);
bin = dec2bin(2^n-1:-1:0)-'0';
X0=[];
for i=1:(2^n)
    for j=1:n
        if bin(i,j)==0
        X0(i,j) = lb(j);
        else
            X0(i,j) = ub(j);
        end
    end
    
end