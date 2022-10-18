function [time,voltage] = string_split_comma(string)
    k = 0;
    for i=1:length(string)
        if(strcmp(string(i),','))
            k = i;
        end
    end
    time = string(1:k-1);
    voltage = string(k+1:end);
end