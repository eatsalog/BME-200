clc,clear all, close all;

keep_looping = true;
while(keep_looping)
    %Asks the user for an action he/she wants to take in the above program
    CHOICE = menu('Select an action',...
                  'Connect to monitoring system',...
                  'Configure sensors',...
                  'Monitor patient',...
                  'Save Data',...
                  'Exit');
switch CHOICE
    %%
    case 1 %%Connect to monitoring system
        %%
        %com is the port number that our arduino is connected to.
        com = 'COM4';
        %br is the baud rate 
        br = 9600;
        %option is an inputdlg that asks the user the values they want to
        %put for port number and for the baud rate
        option = inputdlg({'COM PORT','Baud Rate'},...
            'Arduino connection parameters',1,...
            {com,num2str(br)});
        br = str2num(option{2});
        %s is the serial port that we want to establish in order for Matlab
        %to connect to Arduino
        s = serial(com,'BaudRate',br);
        %We open the serial port here
        fopen(s);
        % We check if the serial port is open or closed 
        %If it is open it displays a message and if it is closed it exits
        if s.status=='open'
        msgbox('The monitoring system is connected');
        else s.status == 'closed'
            msgbox('There is an error');
        end
    case 2 %%Configure sensors
        %%
        %tmp is the touch module pin number and it is an analog input
        %pbp is the push button module pin number and it is a digital input
        %tsp is the tracking sensor pin number and it is a digital input
        %bp is the active buzzer module pin number and it is a digital
        %output
        %led is the led pin number and it is a digital output
        %dci is the data collection interval that determines the interval
        %difference between the data points collected from the analog
        %input
        %lstpy is the label of the y-axis of our analog input sensor
        
        tmp = 0; pbp = 7; tsp = 4; bp = 6; led = 5; dci = 1; lstpy = 'Analog Input';
        %selection is an inpudlg that asks the user of the values he wants
        %to put for the sensors and the interval and label the y axis of
        %the graph of the analog input 
        selection = inputdlg({'Touch Module Pin #','Push button module Pin #','Tracking sensor Pin #','Active buzzer module Pin#','LED Pin#','Data Collection Interval sec','Analog Sensor Type (label for plot y - axis)'},...
                              'Configuration',1,...
                              {num2str(tmp),num2str(pbp),num2str(tsp),num2str(bp),num2str(led),num2str(dci),lstpy});
        tmp = str2num(selection{1}); pbp = str2num(selection{2}); tsp = str2num(selection{3}); bp = str2num(selection{4}); led = str2num(selection{5}); dci = str2num(selection{6});
        %let is an array with letters that associates the pin numbers of
        %the different sensors to letters,since in arduino numbers are
        %translated to letters and are used that way
        let = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n'];
        %tmpl is the letter that associates to the input value of the touch
        %module pin number and it is something the arduino can recognize 
        tmpl = let(tmp+1);
        %pbpl is the letter that associates to the input value of the push
        %button module pin number and it is something the arduino can recognize 
        pbpl = let(pbp+1);
        %tspl is the letter that associates to the input value of the
        %tracking sensor pin number and it is something the arduino can recognize 
        tspl = let(tsp+1);
        %bpl is the letter that associates to the input value of the active
        %buzzer module pin number and it is something the arduino can recognize 
        bpl = let(bp+1);
        %ledl is the letter that associates to the input value of the led
        %pin number and it is something the arduino can recognize 
        ledl = let(led+1);
        %The code below assigns the digital pin number that is associated with the
        %tracking sensor to be a digital input
        fprintf(s,['0',tspl,'0'])
        %The code below assigns the digital pin number that is associated with the
        %buzzer to be a digital output
        fprintf(s,['0',bpl,'1'])
        %The code below assigns the digital pin number that is associated with the
        %push button module to be a digital input
        fprintf(s,['0',pbpl,'0'])
        %The code below assigns the digital pin number that is associated with the
        %LED light to be a digital output
        fprintf(s,['0',ledl,'1'])
        %The code below sets the digital pin number that is associated with the
        %buzzer to be low, which means to be closed
        fprintf(s,['2',bpl,'0'])
        %The code below assigns the digital pin number that is associated with the
        %LED light to be low, which means to be closed
        fprintf(s,['2',ledl,'0'])
    case 3 %%Monitor patient
        %%
        %me makes our plot later to start from the point (0,0) in the graph
        me = plot(0,0);
        %the ylabel is the label for the y-axis of the analog input sensor
        %the we asked the user to put earlier in the program
        ylabel(lstpy);
        %xlabel is time, because our graph varies as time changes
        xlabel('time');
        %kl means keep looping and if it is equal to true, then it keeps
        %looping 
        %tic signals the stopwatch timer to start
        %tm is an array that stores our touch module values that we get
        %when we use the sensor inside the while loop
        %telapsed is an array that stores the different times that we get a
        %tic and a toc and each time in the time array is associated with a
        %data point from the touch sensor
        kl = true; tic; tm = []; telapsed = [];
        while(kl)
            %telapsed(end+1) adds the value that toc has inside the
            %telapsed array
            telapsed(end+1) = toc;
            %pause is the time difference between our data point intervals
            pause(dci);
            %Arduino reads the digital pin number that is associated with the
            %buzzer
            fprintf(s,['1',bpl])
            %Matlab reads whatever the serial port outputted when it read
            %the buzzer pin number. That value is converted to a number
            buzz = str2num(fscanf(s));
            %Arduino reads the digital pin number that is associated with
            %the tracking sensor
            fprintf(s,['1',tspl])
            %Matlab reads whatever the serial port outputted when it read
            %the tracking sensor pin number. That value is converted to a number
            track = str2num(fscanf(s));
            %Arduino reads the digital pin number that is associated with
            %the touch module sensor
            fprintf(s,['3',tmpl])
            %Matlab reads whatever the serial port outputted when it read
            %the touch module sensor pin number. That value is converted to a number
            touch = str2num(fscanf(s));
            %Arduino reads the digital pin number that is associated with
            %the push button module
            fprintf(s,['1',pbpl])
            %Matlab reads whatever the serial port outputted when it read
            %the push button module pin number. That value is converted to a number
            push = str2num(fscanf(s));
            %Arduino reads the digital pin number that is associated with
            %the led light
            fprintf(s,['1',ledl])
            %Matlab reads whatever the serial port outputted when it read
            %the led light pin number. That value is converted to a number
            light = str2num(fscanf(s));
            %telapsed(end+1) adds the value that touch has inside the touch
            %module array
            tm(end+1) = touch;
            %sets the graph properties, me being the start point of our
            %point, telapsed the time array that is associated with the
            %touch sensor module input values and tm is the touch module
            %array with the touch sensor input values
            set(me,'xdata',telapsed,'ydata',tm);
            %Here if the touch sensor input values are between 100 and 300
            %and the track value is zero, which the tracking sensor detects
            %something and the color of the tracking sensor is red, then
            %the led light turns off and the buzzer turns on
            if touch >  100 && touch < 300 && track == 0
                %The buzzer turns on
                fprintf(s,['2',bpl,'1'])
                %The led light turns off
                fprintf(s,['2',ledl,'0'])
            %Here if the touch sensor input values are greater than 300 and
            %the track value is 1, which the tracking sensor is not
            %detecting something, which that the tracking sensor light is
            %off, then the buzzer turns off and the led light turns on
            elseif touch > 300 && track == 1
                %The buzzer turns off
                fprintf(s,['2',bpl,'0'])
                %The led light turns on
                fprintf(s,['2',ledl,'1'])
            end
            %If the user holds (presses) the button for a second then the
            %while stops
            if push == 0
                %keep looping is false and the while stops 
                kl = false;
            end
        end
    case 4 %%Save Data
        %%
        %fn is name of the filename that we want to store our data
        fn = 'mydata';
        %select is an inputdlg that asks the user the name of the
        %filename that our data will be stored 
        select = inputdlg({'Filename'},...
                 'Name the excel file',1,...
                 {fn});
        %xls1 writes the the touch module array data and time elapsed array
        %data into an excel file named fn
             xls1 = xlswrite(fn,[tm;telapsed]);
        %msgbox outputs the data was written successfully to an excel file
        %with name fn
             msgbox(['Data was written to ',fn]);
    otherwise
        %closes the serial port connection
        fclose(s)
        %finds the communication interface objects with specified property values
        out = instrfind;
        %deletes these objects. Generally for our case it deletes the
        %serial port that Matlab was connected into 
        delete(out);
        %keep looping is equal to false and allows the program to exit the
        %while loop and generally exit the program
        keep_looping = false;
end
end