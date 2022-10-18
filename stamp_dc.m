function [A,B,C_1p] = stamp_dc(V,G,R,C,tstep,nodeSet)
 %% Matrix A and B
    matrixAo = max(nodeSet);
    if(size(V,1)~=0)
        order = size(V,1);
        A = zeros(matrixAo+order(1));
        B = zeros(matrixAo+order(1),1);
    else
        A = zeros(matrixAo);
        B = zeros(matrixAo,1);
    end

    % Resistor stamp (time independent)
    for i=1:size(R,1)
        if(R(i,1)==0 && R(i,2) ~=0)
            A(R(i,2),R(i,2)) = A(R(i,2),R(i,2)) + 1/R(i,3);
        elseif(R(i,2)==0 && R(i,1) ~=0)
            A(R(i,1),R(i,1)) = A(R(i,1),R(i,1)) + 1/R(i,3);
        else
            A(R(i,1),R(i,1)) = A(R(i,1),R(i,1)) + 1/R(i,3); 
            A(R(i,2),R(i,2)) = A(R(i,2),R(i,2)) + 1/R(i,3);
            A(R(i,1),R(i,2)) = A(R(i,1),R(i,2)) - 1/R(i,3);
            A(R(i,2),R(i,1)) = A(R(i,2),R(i,1)) - 1/R(i,3);
        end
    end

    % VCCS Stamp (time independent)
    for i=1:size(G,1)
        if(G(i,1) ~=0 && G(i,2) ~=0 && G(i,3) ~=0  && G(i,4) ~=0 )
            A(G(i,1),G(i,3)) =  A(G(i,1),G(i,3)) + G(i,5);
            A(G(i,1),G(i,4)) =  A(G(i,1),G(i,4)) - G(i,5);
            A(G(i,2),G(i,3)) =  A(G(i,2),G(i,3)) - G(i,5);
            A(G(i,2),G(i,4)) =  A(G(i,2),G(i,4)) + G(i,5);
        elseif(G(i,1) ==0 && G(i,2) ~=0 && G(i,3) ~=0  && G(i,4) ~=0)
            A(G(i,2),G(i,3)) =  A(G(i,2),G(i,3)) - G(i,5);
            A(G(i,2),G(i,4)) =  A(G(i,2),G(i,4)) + G(i,5);
        elseif(G(i,1) ~=0 && G(i,2) ==0 && G(i,3) ~=0  && G(i,4) ~=0)
            A(G(i,1),G(i,3)) =  A(G(i,1),G(i,3)) + G(i,5);
            A(G(i,1),G(i,4)) =  A(G(i,1),G(i,4)) - G(i,5);
        elseif(G(i,1) ~=0 && G(i,2) ~=0 && G(i,3) ==0  && G(i,4) ~=0)
            A(G(i,1),G(i,4)) =  A(G(i,1),G(i,4)) - G(i,5);
            A(G(i,2),G(i,4)) =  A(G(i,2),G(i,4)) + G(i,5);
        elseif(G(i,1) ~=0 && G(i,2) ~=0 && G(i,3) ~=0  && G(i,4) ==0)
            A(G(i,1),G(i,3)) =  A(G(i,1),G(i,3)) + G(i,5);
            A(G(i,2),G(i,3)) =  A(G(i,2),G(i,3)) - G(i,5);
        elseif(G(i,1) ==0 && G(i,2) ~=0 && G(i,3) ==0  && G(i,4) ~=0)
            A(G(i,2),G(i,4)) =  A(G(i,2),G(i,4)) + G(i,5);
        elseif(G(i,1) ==0 && G(i,2) ~=0 && G(i,3) ~=0  && G(i,4) ==0)
            A(G(i,2),G(i,3)) =  A(G(i,2),G(i,3)) - G(i,5);
        elseif(G(i,1) ~=0 && G(i,2) ==0 && G(i,3) ==0  && G(i,4) ~=0)
            A(G(i,1),G(i,4)) =  A(G(i,1),G(i,4)) - G(i,5);
        elseif(G(i,1) ~=0 && G(i,2) ==0 && G(i,3) ~=0  && G(i,4) ==0)
           A(G(i,1),G(i,3)) =  A(G(i,1),G(i,3)) + G(i,5);
        end
    end

    %Voltage Stamp
    for i=1:size(V,1)
        if(V(i,1)~=0 && V(i,2)~=0)
            A(V(i,1),max(nodeSet)+i) = A(V(i,1),max(nodeSet)+i)+1;
            A(V(i,2),max(nodeSet)+i) = A(V(i,2),max(nodeSet)+i)-1;
            A(max(nodeSet)+i,V(i,1)) = A(max(nodeSet)+i,V(i,1))+1;
            A(max(nodeSet)+i,V(i,2)) = A(max(nodeSet)+i,V(i,2))-1;
            B(max(nodeSet)+i) =  B(max(nodeSet)+i) + V(i,3);
        elseif(V(i,1)==0 && V(i,2)~=0)
            A(V(i,2),max(nodeSet)+i) = A(V(i,2),max(nodeSet)+i)-1;
            A(max(nodeSet)+i,V(i,2)) = A(max(nodeSet)+i,V(i,2))-1;
            B(max(nodeSet)+i) =  B(max(nodeSet)+i) + V(i,3);
        elseif(V(i,1)~=0 && V(i,2)==0)
            A(V(i,1),max(nodeSet)+i) = A(V(i,1),max(nodeSet)+i)+1;
            A(max(nodeSet)+i,V(i,1)) = A(max(nodeSet)+i,V(i,1))+1;
            B(max(nodeSet)+i) =  B(max(nodeSet)+i) + V(i,3); 
        end
    end

    % Capacitor Stamp for DC operating point 
    for i=1:size(C,1)
        C_1p(i) = 0;
    end
    
    for i=1:size(C,1)
        if(C(i,1)==0 && C(i,2) ~=0)
            A(C(i,2),C(i,2)) = A(C(i,2),C(i,2)) + 1e-10;
            B(C(i,2)) = B(C(i,2)) + C_1p(i);
        elseif(C(i,2)==0 && C(i,1) ~=0)
            A(C(i,1),C(i,1)) = A(C(i,1),C(i,1)) + 1e-10;
            B(C(i,1)) = B(C(i,1)) - C_1p(i);
        else
            A(C(i,1),C(i,1)) = A(C(i,1),C(i,1)) + 1e-10;
            A(C(i,2),C(i,2)) = A(C(i,2),C(i,2)) + 1e-10;
            A(C(i,1),C(i,2)) = A(C(i,1),C(i,2)) - 1e-10;
            A(C(i,2),C(i,1)) = A(C(i,2),C(i,1)) - 1e-10;
            B(C(i,1)) = B(C(i,1)) + C_1p(i);
            B(C(i,2)) = B(C(i,2)) - C_1p(i);
        end
    end

end