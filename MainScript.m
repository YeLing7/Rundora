
%Rundora

clc
clear all

[player1,Fs1]=audioread('1.wav');
[player2,Fs2]=audioread('2.wav');
[player3,Fs3]=audioread('3.wav');
[player4,Fs4]=audioread('4.wav');
prevState=0;
curState=0;

PACE_THRESH_HIGH = 12;
PACE_MED=10;
HEART_THRESH = 105;

%%
% Save the serial port name in comPort variable.
%gauss;

%comPort = '/dev/tty.usbmodem411';
comPort = 'com4'; 

if (~exist('h','var') || ~ishandle(h))
    h = figure(1);
    set(h,'UserData',1);
end

if (~exist('button','var'))
    button = uicontrol('Style','togglebutton','String','Stop',...
        'Position',[0 0 50 25], 'parent',h);
end

%%
% After creating a system of two axis, a line object through which the data
% will be plotted is also created

if(~exist('myAxes','var'))
    
    buf_len = 100;
    index = 1:buf_len; 
    zeroIndex = zeros(size(index)); 
    tcdata = zeroIndex;
    limits = [-200 200];
    
    myAxes = axes('Xlim',[0 buf_len],'Ylim',limits);
    grid on;
    
    l = line(index,[tcdata;zeroIndex]);
    
    drawnow;
end
%

mode = 'R';

count=0;

myFrequency=zeros(1,200);
average_heartR=0;

while (get(button,'Value') == 0)
%tic
    if(rem(count,10)==0&&count~=0)
        processingData=tcdata;
        %processingData = filter(gaussFilter,3, tcdata);
        processingData(1)=0;
        [val,I]=max(abs(fft(processingData)));
        %[val,I]=max(abs(fftshift(processingData,1)));
        myFrequncy(floor(count/10))=I;
        fprintf('get %d frequency is %d \n',floor(count/10),I);
        fprintf('the heartRate is %d \n',average_heartR*6);
        %average_heartR=0;
        
        %%%%%%%choose the music player state%%%%%%%%
        %0 is low, 1 is high
        heartState=(average_heartR*6)>=HEART_THRESH;
        paceState_high=I>=PACE_THRESH_HIGH;
        paceState_med=(I>=PACE_MED) && (I<PACE_THRESH_HIGH);
        paceState=I>=PACE_MED;
        average_heartR=0;
        if(I==1)
            curState=1;
        elseif(heartState ~= paceState)
            curState=2;
        elseif(paceState_med==1)
            curState=3;
        elseif(paceState_high==1)
            curState=4;
        end
        
        fprintf('curState is %d\n',curState);
        fprintf('paceState_Med is %d\n', paceState_med);
        fprintf('paceState_High is %d\n', paceState_high);
        fprintf('heartrate is %d\n', heartState);
        fprintf('paceState is %d\n', paceState);
        
        if(curState~=prevState)
            clear sound
            switch curState
                case 2
                    sound(player2,Fs2);
                    fprintf('2...\n')
                case 1
                    sound(player1,Fs1);
                    fprintf('1...\n')
                case 4
                    sound(player4,Fs4);
                    fprintf('4...\n')
                otherwise
                    sound(player3,Fs3);
                    fprintf('3...\n')
            end
            prevState=curState;
        end
        
 
    end
        
    
    [tc,tc_heart,flag] = readSerial(comPort);
    
    average_heartR=average_heartR+tc_heart;
    
    if(tc==0) 
        continue;
    end
    %tc=tc+1325;
    tc=tc+1525;
    tcdata = [tcdata(21:end),tc];
    
    set(l,'Ydata',tcdata);
    
    drawnow;
    
    pause(0.001);
    count=count+1;
%toc
end



% To remeber: when you are satisfied with you measurement click on the 
% "stop" button in the bottom left corner of the figure. Now you have to
% close the serial object "Arduino" using the command "fclose(arduino)",
% and close the h figure typing "close(h)". Now in "tcdata" variable you
% have your real time data. 
