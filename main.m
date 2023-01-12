clc
clear 
close all
%% Reading Input Spice File 
z = input("Provide the file name : ",'s'); % taking input file name from the user
fid = fopen(z); % opening file
index = 1; % initializing the index
%% Parseing the spice netlist file
% Decomposing file into lines and then into words
while(~feof(fid))
    str = fgetl(fid);
    if(~strcmp(str,''))
        text{index}=split(str);
        index = index+1;
    end
end
fclose(fid);
%% Making DataStructure of Components
index = 1;
C = [];
R = [];
G = [];
V = [];
nodeSet = [];
while(~(strcmp(text{index}{1},'.option')) && ~(strcmp(text{index}{1},'.options')))
% Resistor
    if(strcmp(text{index}{1}(1),'r') || strcmp(text{index}{1}(1),'R') )
        node1 = str2double(text{index}{2});
        node2 = str2double(text{index}{3});
        nodeSet = [nodeSet,node1,node2];
        resistorValue = str2unitConv(text{index}{4});
        R = [R; node1,node2,resistorValue];
% Capacitor 
    elseif(strcmp(text{index}{1}(1),'c') || strcmp(text{index}{1}(1),'C') )
        node1 = str2double(text{index}{2});
        node2 = str2double(text{index}{3});
        nodeSet = [nodeSet,node1,node2];
        capValue = str2unitConv(text{index}{4});
        C= [C; node1,node2,capValue];
% VCCS 
     elseif(strcmp(text{index}{1}(1),'g') || strcmp(text{index}{1}(1),'G') )
        node1 = str2double(text{index}{2});
        node2 = str2double(text{index}{3});
        node3 = str2double(text{index}{4});
        node4 = str2double(text{index}{5});
        nodeSet = [nodeSet,node1,node2,node3,node4];
        gValue = str2unitConv(text{index}{6});
        G= [G; node1,node2,node3,node4,gValue];
% Voltage Source        
        elseif(strcmp(text{index}{1}(1),'v') || strcmp(text{index}{1}(1),'V') )
        node1 = str2double(text{index}{2});
        node2 = str2double(text{index}{3});
        nodeSet = [nodeSet,node1,node2];
        vsValue = str2unitConv(text{index}{4});
        V= [V; node1,node2,vsValue];
    end
   index = index+1;
end

%% Reading simulation commands
issin = 0; ispwl = 0; ispulse = 0;
while(~(strcmp(text{index}{1},'.end')) && ~(strcmp(text{index}{1},'.END')) && ~(strcmp(text{index}{1},'*.end')))
    % transient command
    if(strcmp(text{index}{1},'.tran') || strcmp(text{index}{1},'.TRAN'))
        tstep    = str2unitConv(text{index}{2});
        end_time = str2unitConv(text{index}{3});
    end
    % alter command
    if(strcmp(text{index}{1},'.alter') || strcmp(text{index}{1},'.ALTER'))
        index = index + 1;
        if(strcmp(text{index}{4}(1:3),'sin')||strcmp(text{index}{4}(1:3),'SIN'))
            sin_param  = [str2unitConv(text{index}{4}(5:end)) str2unitConv(text{index}{5}) str2unitConv(text{index}{6}) str2unitConv(text{index}{7}) str2unitConv(text{index}{8}) str2unitConv(text{index}{9})];
            issin = 1;
        elseif(strcmp(text{index}{4}(1:3),'pwl')||strcmp(text{index}{4}(1:3),'PWL'))
            ispwl = 1;
            pwl_time    = [];
            pwl_voltage = [];
            if(strcmp(text{index}{end},')') || (strcmp(text{index}{end},'') && ~strcmp(text{index}{end-1},')')))
                k = length(text{index})-1;
            elseif(strcmp(text{index}{end},'') && strcmp(text{index}{end-1},')'))
                k = length(text{index})-2;
            else
                k = length(text{index});
             end
            if(strcmp(text{index}{4},'pwl') || strcmp(text{index}{4},'PWL'))
                if(strcmp(text{index}{5}(1),'(') && length(text{index}{5})>1)
                    for h = 5:k
                        [a b] = string_split_comma(text{index}{h});
                        a = str2unitConv(a);
                        b = str2unitConv(b);
                        pwl_time = [pwl_time a];
                        pwl_voltage = [pwl_voltage b];
                    end 
                elseif(strcmp(text{index}{5}(1),'(') && length(text{index}{5})==1)
                    
                    for h = 6:k
                        [a b] = string_split_comma(text{index}{h});
                        a = str2unitConv(a);
                        b = str2unitConv(b);
                        pwl_time = [pwl_time a];
                        pwl_voltage = [pwl_voltage b];
                    end
                end
            elseif(length(text{index}{4})>3)
                if(strcmp(text{index}{4}(4:end),'('))
                    for h = 5:k
                        [a b] = string_split_comma(text{index}{h});
                        a = str2unitConv(a);
                        b = str2unitConv(b);
                        pwl_time = [pwl_time a];
                        pwl_voltage = [pwl_voltage b];
                    end
                else
                        [a b] = string_split_comma(text{index}{4}(5:end));
                        a = str2unitConv(a);
                        b = str2unitConv(b);
                        pwl_time = [pwl_time a];
                        pwl_voltage = [pwl_voltage b];
                    for h = 5:k
                        [a b] = string_split_comma(text{index}{h});
                        a = str2unitConv(a);
                        b = str2unitConv(b);
                        pwl_time = [pwl_time a];
                        pwl_voltage = [pwl_voltage b];
                    end
                end
            end
        elseif(strcmp(text{index}{4}(1:5),'PULSE')||strcmp(text{index}{4}(1:5),'pulse'))
            ispulse = 1;
            if(strcmp(text{index}{4},'PULSE')||strcmp(text{index}{4},'pulse'))
                pulse_param = [str2unitConv(text{index}{6})  str2unitConv(text{index}{7}) str2unitConv(text{index}{8}) str2unitConv(text{index}{9}) str2unitConv(text{index}{10}) str2unitConv(text{index}{11}) str2unitConv(text{index}{12})];
            elseif(strcmp(text{index}{4},'PULSE(') || strcmp(text{index}{4},'pulse('))
                pulse_param = [str2unitConv(text{index}{5})  str2unitConv(text{index}{6}) str2unitConv(text{index}{7}) str2unitConv(text{index}{8}) str2unitConv(text{index}{9}) str2unitConv(text{index}{10}) str2unitConv(text{index}{11})];
            elseif(length(text{index}{4})>6)
                pulse_param = [str2unitConv(text{index}{4}(6:end))  str2unitConv(text{index}{5}) str2unitConv(text{index}{6}) str2unitConv(text{index}{7}) str2unitConv(text{index}{8}) str2unitConv(text{index}{9}) str2unitConv(text{index}{10})];
            end
        end
    end
    index = index + 1;
end
%% Stamp generation and A and B
[A,B,C_1p] = stamp_dc(V,G,R,C,tstep,nodeSet);

% DC operating Point
Dc_op = linsolve(A,B);
writematrix(Dc_op,'dc_operating_dc.txt');
% Transient Simulation
trans_Sim(A,B,C,tstep,end_time,C_1p,nodeSet);

%% generating alternate waves
if(issin)
    sin_v = sin_wave(sin_param,tstep,end_time);
end
if(ispwl)
    pwl_v = pwl_wave(pwl_time,pwl_voltage,tstep,end_time);
end
if(ispulse)
    pulse_v = pulse_wave(pulse_param,tstep,end_time);
end
%% Dc operating point and Transient simulation for alternate sources

if(issin)
    % DC_op sin
    [A,B,C_1p] = stamp_dc(V,G,R,C,tstep,nodeSet);
    for i = 1:size(V,1)
        B(max(nodeSet)+i) = B(max(nodeSet)+i) - V(i,3) + sin_param(1);
    end
    Dc_op = linsolve(A,B);
    writematrix(Dc_op,'dc_operating_sin.txt');
    % Trans_sim sin
    trans_Sim2(A,B,C,tstep,end_time,C_1p,sin_v,nodeSet);
end

if(ispwl)
    % DC_op pwl
    [A,B,C_1p] = stamp_dc(V,G,R,C,tstep,nodeSet);
    for i = 1:size(V,1)
        B(max(nodeSet)+i) = B(max(nodeSet)+i) - V(i,3) + pwl_v(1);
    end
    Dc_op = linsolve(A,B);
    writematrix(Dc_op,'dc_operating_pwl.txt');

    % Trans_sim pwl
    trans_Sim2(A,B,C,tstep,end_time,C_1p,pwl_v,nodeSet);
end


if(ispulse)
    % DC_op pulse
    [A,B,C_1p] = stamp_dc(V,G,R,C,tstep,nodeSet);
    for i = 1:size(V,1)
        B(max(nodeSet)+i) = B(max(nodeSet)+i) - V(i,3) + pulse_v(1);
    end
    Dc_op = linsolve(A,B);
    writematrix(Dc_op,'dc_operating_pulse.txt');

    % Trans_sim pulse
    Result = trans_Sim2(A,B,C,tstep,end_time,C_1p,pulse_v,nodeSet);
end

