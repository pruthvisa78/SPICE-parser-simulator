function [S] = sin_wave (sin_param,tstep,end_time)
% sine wave generator from given parameters
    time = 0:tstep:end_time;
    a = sin_param(1);
    b = sin_param(2);
    c = sin_param(3);
    d = sin_param(4);
    e = sin_param(5);
    f = sin_param(6);
    for i=1:length(time)
        if(time(i)>=d)
            S(i) = a+b*sin(2*pi*(time(i)-d)*c + ((pi*f)/180))*(exp(-(time(i)-d)*e));
        else
            S(i) = a+b*sin(((pi*f)/180));
        end
    end
end