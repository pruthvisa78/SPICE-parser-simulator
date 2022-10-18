function [numeric] = str2unitConv(string)
    if(strcmp(string(end),'k') || strcmp(string(end),'K'))
         numeric = str2double(string(1:end-1)).*1000;
    elseif(strcmp(string(end),'meg') || strcmp(string(end),'MEG'))
        numeric = str2double(string(1:end-1)).*1e+6;
    elseif(strcmp(string(end),'m'))
        numeric = str2double(string(1:end-1)).*1e-3;
    elseif(strcmp(string(end),'s') || strcmp(string(end),'S'))
        if(strcmp(string(end-1:end),'ns') || strcmp(string(end-1:end),'NS'))
            numeric = str2double(string(1:end-2)).*1e-9;
        end
        if(strcmp(string(end-1:end),'ms') || strcmp(string(end-1:end),'MS'))
            numeric = str2double(string(1:end-2)).*1e-3;
        end
    elseif(strcmp(string(end),'u'))
        numeric = str2double(string(1:end-1)).*1e-6;
    elseif(strcmp(string(end),'V') || strcmp(string(end),'v'))
        numeric = str2double(string(1:end-1));
    elseif(strcmp(string(end),'n')) 
        numeric = str2double(string(1:end-1)).*1e-9;
    elseif(strcmp(string(end),'z'))
        if(contains(string,"k") || contains(string,"K"))
            numeric = str2double(string(1:end-3)).*1e+3; 
        else
            numeric = str2double(string(1:end-2));
        end
    elseif(strcmp(string(1),'(')) 
        numeric = str2double(string(2:end));
    elseif(strcmp(string(end),')'))
        numeric = str2unitConv(string(1:end-1));
    else
        numeric = str2double(string);
    end
end