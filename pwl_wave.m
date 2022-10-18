function [pwl] = pwl_wave(pwl_time,pwl_voltage,tstep,end_time)
% pwl wave generator
pwl = zeros(1,ceil(end_time/tstep)+1);
pwl(1:ceil(pwl_time(1)/tstep))=pwl_voltage(1);
    for i=1:length(pwl_time)-1
        for j = ceil(pwl_time(i)/tstep)+1:ceil(pwl_time(i+1)/tstep)
            pwl(j) = (((pwl_voltage(i+1)-pwl_voltage(i))/(pwl_time(i+1)-pwl_time(i)))*(j*tstep-pwl_time(i))) + pwl_voltage(i);
        end
    end
    pwl(ceil(pwl_time(i+1)/tstep):end)=pwl_voltage(i+1);
end