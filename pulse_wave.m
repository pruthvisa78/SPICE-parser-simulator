function [P] = pulse_wave (pulse_param,tstep,end_time)
% pulse wave generator from given parameters
    a = pulse_param(1); % V1
    b = pulse_param(2); % V2
    c = pulse_param(3); % Tdelay
    d = pulse_param(4); % Trise
    e = pulse_param(5); % Tfall
    f = pulse_param(6); % Ton
    g = pulse_param(7); % Tperiod

    P = zeros(1,ceil(end_time/tstep)+1);
    nc = ceil((end_time)/g);
    del = floor(c/tstep);

    if(del == 0)
        del = del+1;
    end
    P(1,1:del) = a;
    
  for i=1:nc
        for t = (c/tstep):1:((c+d)/tstep)
            P(del) = a + ((b-a)/d)*(t*tstep-c);
            del = del+1;
        end
        for t = ((c+d)/tstep):1:((c+d+f)/tstep)
            P(del) = b;
            del = del+1;
        end

        for t=((c+d+f)/tstep):1:((c+d+f+e)/tstep)
            P(del) = b + ((a-b)/e)*(t*tstep-(c+f+d));
            del = del+1;
        end
        for t = ((c+d+e+f)/tstep):1:((c+g)/tstep)
            P(del) = a;
            del = del+1;
        end
   end
   P = P(1:ceil(end_time/tstep)+1);
end
