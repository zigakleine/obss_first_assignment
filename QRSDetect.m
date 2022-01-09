

function idx = QRSDetect(fileName, m, normalizeConst)
    

    % 1. linear highpass filter, with the equation: 
    % -> y[n] =  x[n- (M+1)/2] - (1/M)* Σ{0->M-1}x[n-m]
    % M should be odd, 3, 5, 7 works best 
    
    % 2. nonlinear lowpass filter, consisting of a cascade of:
    %   2.1.-> a simple point-by-point squaring operation
    %   2.2.-> a moving window integration or summation system
    
    % 3. decision system
    
    

    file = load(fileName);
    signalsSize = size(file.val);
    
    %disp(signalsSize);
    %disp(length(file.val(1,:)));
    
    signalSum = zeros(1, signalsSize(2));
    
    numOfSignals = signalsSize(1);
    
    for sigNum=1:numOfSignals

        signal = file.val(sigNum,:);
        signalSum = signalSum + signal;
    end
    avgSig = signalSum/numOfSignals;
    signal = avgSig;
    
    %signal = file.val(1,:);
    
    
    % 1. HPF
    b_1 = 1/m*(ones(1, m));
    a_1 = 1;

    y_1 = filter(b_1, a_1, signal);


    b_2 = zeros(1,m); 
    b_2((m+1)/2 + 1) = 1;
    a_2 = 1;

    y_2 = filter(b_2, a_2, signal);

    y = y_2 - y_1;

    % 2. LPF    

    y = y .^ 2;
    y = movsum(y,normalizeConst);

    %3 decision making stage
        
    gamma = 0.15 ; 
    alpha = 0.05;
    
    peaks = [];
    peak = mean(findpeaks(y(1:5000)));
    threshold = 1; 
    threshold = alpha * gamma * peak + (1-alpha)*threshold;
   
    %plot(y); hold on;
   
    i=1;
    while i<=length(y)
      
        if y(i) > threshold
            %disp(i); disp(y(i)); disp(threshold);
            peak_value = -1;
            peak_index = 0;
            while(i <= length(y) && y(i) > threshold)
                current_peak = y(i);
                if(current_peak > peak_value)
                    peak_value = current_peak;
                    peak_index = i;
                    
                end
                i=i+1;   
            end
            i=i+30;
            peak = peak_value;
            peaks = [peaks, peak_index];
            %disp(i);
            %disp(peak);
            threshold = alpha * gamma * peak + (1-alpha)*threshold;
            %plot(peak_index, peak_value, 'ro ', 'MarkerSize', 10);  
        else 
            i=i+1;
        end
        
    end
   
    
    idx = peaks;
      
    
        
    
    
    
    
    