
% Rundora

function[out_pace,out_heart,flag] = readSerial(comPort)
% It accept as the entry value, the index of the serial port
% Arduino is connected to, and as output values it returns the serial 
% element obj and a flag value used to check if when the script is compiled
% the serial element exists yet.
flag = 1;
% Initialize Serial object
obj = serial(comPort);
% set(obj,'DataBits',8);
% set(obj,'StopBits',1);
% set(obj,'BaudRate',9600);
% set(obj,'Parity','none');
fopen(obj);
%mbox = msgbox('Serial Communication setup'); uiwait(mbox);
output_temp=fscanf(obj,'%f')';
out_pace=output_temp(1:20);
out_heart=output_temp(21);
fclose(obj);
end
