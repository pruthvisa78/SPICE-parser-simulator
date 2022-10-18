function [A,B] = trans_Sim(A,B,C,tstep,end_time,C_1p,nodeSet)
    time = 0:tstep:end_time;
    h  = tstep;
    for i=1:size(C,1)
        if(C(i,1)==0 && C(i,2) ~=0)
            A(C(i,2),C(i,2)) = A(C(i,2),C(i,2)) + C(i,3)/h;
        elseif(C(i,2)==0 && C(i,1) ~=0)
            A(C(i,1),C(i,1)) = A(C(i,1),C(i,1)) + C(i,3)/h;
        else
            A(C(i,1),C(i,1)) = A(C(i,1),C(i,1)) + C(i,3)/h;
            A(C(i,2),C(i,2)) = A(C(i,2),C(i,2)) + C(i,3)/h;
            A(C(i,1),C(i,2)) = A(C(i,1),C(i,2)) - C(i,3)/h;
            A(C(i,2),C(i,1)) = A(C(i,2),C(i,1)) - C(i,3)/h;
        end
    end
    IC = linsolve(A,B);
    Result = IC;
for j = 2:length(time)
% Calculating Cv minus
    for i=1:size(C,1)
        if(C(i,1)==0 && C(i,2) ~=0)
            C_1(i) = (-1)*Result(C(i,2),j-1)*(C(i,3)/tstep); 
        elseif(C(i,2)==0 && C(i,1) ~=0)
            C_1(i) = Result(C(i,1),j-1)*(C(i,3)/tstep); 
        else
            C_1(i) = (Result(C(i,1),j-1)-Result(C(i,2),j-1))*(C(i,3)/tstep); 
       end
    end
% Updating RHS
    for i=1:size(C,1)
        if(C(i,1)==0 && C(i,2) ~=0)
            B(C(i,2)) = B(C(i,2)) - C_1(i) + C_1p(i);
        elseif(C(i,2)==0 && C(i,1) ~=0)
            B(C(i,1)) = B(C(i,1)) + C_1(i) - C_1p(i);
        else
            B(C(i,1)) = B(C(i,1)) + C_1(i) - C_1p(i);
            B(C(i,2)) = B(C(i,2)) - C_1(i) + C_1p(i);
        end
        C_1p(i) = C_1(i);
    end
    temp   = linsolve(A,B);
    Result = [Result ,temp ];
end

for k=1:size(B,1)
    figure()
    plot(time,Result(k,:))
    xlabel('Time (Seconds)')
    if(k>max(nodeSet))
        ylabel('Branch Current (Amperes)')
        str = "Transient Response of Branch Current Ib" + num2str(size(B,1)-k+1);
    else
        ylabel('Voltage (Volts)')
        str = "Transient Response of Node Voltage V" + k;
    end
    title(str)
end
end