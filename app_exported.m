classdef app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        Label_4                     matlab.ui.control.Label
        BrowseCustomSignalButton    matlab.ui.control.Button
        sLabel                      matlab.ui.control.Label
        ProcessingTimeLabel         matlab.ui.control.Label
        SampleSignalLoadedLabel     matlab.ui.control.Label
        SystemStatusLabel           matlab.ui.control.Label
        Label_3                     matlab.ui.control.Label
        Label_2                     matlab.ui.control.Label
        dBLabel                     matlab.ui.control.Label
        CompressionRatioLabel       matlab.ui.control.Label
        MSELabel                    matlab.ui.control.Label
        SNRLabel                    matlab.ui.control.Label
        PerformanceMetricsLabel     matlab.ui.control.Label
        WaveletFamilyDropDown       matlab.ui.control.DropDown
        WaveletFamilyDropDownLabel  matlab.ui.control.Label
        SignalTypeDropDown          matlab.ui.control.DropDown
        SignalTypeDropDownLabel     matlab.ui.control.Label
        CompareResultsButton        matlab.ui.control.Button
        CompressSignalButton        matlab.ui.control.Button
        DenoiseSignalButton         matlab.ui.control.Button
        PerformIDWTButton           matlab.ui.control.Button
        PerformDWTButton            matlab.ui.control.Button
        LoadSelectedSignalButton    matlab.ui.control.Button
        Waveletbasedsignalprocessingstimulation  matlab.ui.control.Label
        TimeFrequencyAxes           matlab.ui.control.UIAxes
        CoefficientAxes             matlab.ui.control.UIAxes
        ProcessedAxes               matlab.ui.control.UIAxes
        OriginalAxes                matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
            OriginalSignal
            ProcessedSignal
            WaveletCoefficients
            SignalName
            DetailCoefficients
            CleanReferenceSignal
            LastOperation
            CompressionRatio
         

        end
    
    
    methods (Access = private)
        
        function results = func(app)
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadSelectedSignalButton
        function LoadSelectedSignalButtonPushed(app, event)

                % Read selected signal
                selection = app.SignalTypeDropDown.Value;

               

                % Generate Sample Noisy Sine Wave
                if strcmp(selection,"Sample Noisy Sine Wave")

                    % Create time vector
                    t = 0:0.001:1;

                    % Generate clean sine wave
                    signal = sin(2*pi*5*t);

                    % Add Gaussian noise
                    rng(1);
                    noise = 0.4*randn(size(signal));

                    % Create noisy signal
                    noisySignal = signal + noise;

                  

                    % Plot on Original Signal axes
                    plot(app.OriginalAxes,t,noisySignal,'b','LineWidth',1.5)

                    grid(app.OriginalAxes,'on')

                    title(app.OriginalAxes,'Input Signal')
                    xlabel(app.OriginalAxes,'Time (s)')
                    ylabel(app.OriginalAxes,'Amplitude')
                    app.SampleSignalLoadedLabel.Text = 'Sample Signal Loaded';
                    app.OriginalSignal = noisySignal;
                    app.CleanReferenceSignal = signal;

                    cla(app.TimeFrequencyAxes);

                    signal = app.OriginalSignal(:);

                    % Sampling frequency
                    Fs = 1000;
                    t = (0:length(signal)-1)/Fs;

                    % Continuous Wavelet Transform
                    [cfs,f] = cwt(signal,Fs);

                    % Time-frequency plot
                    surf(app.TimeFrequencyAxes,...
                        t,f,abs(cfs),...
                        'EdgeColor','none');

                    view(app.TimeFrequencyAxes,2);
                    axis(app.TimeFrequencyAxes,'tight');

                    title(app.TimeFrequencyAxes,'Noisy Sine CWT Scalogram');
                    xlabel(app.TimeFrequencyAxes,'Time (s)');
                    ylabel(app.TimeFrequencyAxes,'Frequency (Hz)');
                    colorbar(app.TimeFrequencyAxes);

                
              

            end
            if strcmp(selection,"ECG Signal")

                % Load ECG data
                ecgSignal = load('ecg.dat');

                % Store signal
                app.OriginalSignal = ecgSignal;
                app.CleanReferenceSignal = [];


                % Create sample numbers
                t = 1:length(ecgSignal);

                % Plot ECG
                plot(app.OriginalAxes,t,ecgSignal,'r','LineWidth',1)

                grid(app.OriginalAxes,'on')

                title(app.OriginalAxes,'Input Signal')
                xlabel(app.OriginalAxes,'Samples')
                ylabel(app.OriginalAxes,'Amplitude')
                app.SampleSignalLoadedLabel.Text = 'ECG Signal Loaded';
            
                cla(app.TimeFrequencyAxes);
                Fs = 500;
                t = (0:length(app.OriginalSignal)-1)/Fs;

                [cfs,f] = cwt(app.OriginalSignal,Fs);

                surf(app.TimeFrequencyAxes,...
                    t,...
                    f,...
                    abs(cfs),...
                    'EdgeColor','none');

                view(app.TimeFrequencyAxes,2);
                axis(app.TimeFrequencyAxes,'tight');

                title(app.TimeFrequencyAxes,...
                    'ECG CWT Scalogram')
                xlabel(app.TimeFrequencyAxes,'Time (s)');
                ylabel(app.TimeFrequencyAxes,'Frequency (Hz)');
                colormap(app.TimeFrequencyAxes,jet);
                colorbar(app.TimeFrequencyAxes);
            end

                if strcmp(selection,'Speech Signal')

                    % Load speech data
                    load('orig.dat');

                    speechSignal = orig;

                    % Store signal
                    app.OriginalSignal = speechSignal;
                    app.CleanReferenceSignal = [];

                    % Sample numbers
                    t = 1:length(speechSignal);

                    % Plot speech
                    plot(app.OriginalAxes,t,speechSignal,'b')

                    grid(app.OriginalAxes,'on')

                    title(app.OriginalAxes,'Input Signal')
                    xlabel(app.OriginalAxes,'Samples')
                    ylabel(app.OriginalAxes,'Amplitude')

                    app.SampleSignalLoadedLabel.Text = 'Speech Signal Loaded';
                    cla(app.TimeFrequencyAxes);
                    Fs = 8000;
                    t = (0:length(app.OriginalSignal)-1)/Fs;

                    [cfs,f] = cwt(app.OriginalSignal,Fs);

                    surf(app.TimeFrequencyAxes,...
                        t,...
                        f,...
                        abs(cfs),...
                        'EdgeColor','none');

                    view(app.TimeFrequencyAxes,2);

                    axis(app.TimeFrequencyAxes,'tight');

                    title(app.TimeFrequencyAxes,'Speech CWT Scalogram');

                    xlabel(app.TimeFrequencyAxes,'Time (s)');

                    ylabel(app.TimeFrequencyAxes,'Frequency (Hz)');

                    colormap(app.TimeFrequencyAxes,jet);

                    colorbar(app.TimeFrequencyAxes);
                
                

            end
        end

        % Button pushed function: BrowseCustomSignalButton
        function BrowseCustomSignalButtonPushed(app, event)
            [file, path] = uigetfile({'*.dat;*.txt;*.mat','Signal Files'});

            if isequal(file,0)
                return;
            end

            filename = fullfile(path,file);

            signal = load(filename);

            if isstruct(signal)

                fn = fieldnames(signal);

                signal = signal.(fn{1});

            end

            signal = signal(:);

            app.OriginalSignal = signal;
            app.OriginalSignal = signal;

            plot(app.OriginalAxes, signal, 'b', 'LineWidth',1);

            grid(app.OriginalAxes,'on')

            title(app.OriginalAxes,'Loaded Signal')

            xlabel(app.OriginalAxes,'Samples')

            ylabel(app.OriginalAxes,'Amplitude')
        end

        % Button pushed function: PerformDWTButton
        function PerformDWTButtonPushed(app, event)
        tic

        if isempty(app.OriginalSignal)

            uialert(app.UIFigure,...
                'Please load a signal first.',...
                'No Signal');

            return

        end

        signal = app.OriginalSignal(:);

        wavelet = app.WaveletFamilyDropDown.Value;

        [cA,cD] = dwt(signal,wavelet);

        app.WaveletCoefficients = cA;
        app.DetailCoefficients = cD;


        plot(app.CoefficientAxes,cA,'b','LineWidth',1.5)
        grid(app.CoefficientAxes,'on')

        title(app.CoefficientAxes,...
            'Approximation Coefficients (Low Frequency)')
        xlabel(app.CoefficientAxes,'Coefficient Index');
        ylabel(app.CoefficientAxes,...
            'Coefficient Magnitude')
        plot(app.ProcessedAxes,cA,'r','LineWidth',1.5)
        grid(app.ProcessedAxes,'on')

        title(app.ProcessedAxes,'Approximation Coefficients')
        xlabel(app.ProcessedAxes,'Coefficient Index');
        ylabel(app.ProcessedAxes,'Coefficient Magnitude');

        app.SampleSignalLoadedLabel.Text = 'DWT Completed';

        app.sLabel.Text = sprintf('%.3f s',toc);
        end

        % Button pushed function: PerformIDWTButton
        function PerformIDWTButtonPushed(app, event)
            

                tic

                % Check whether DWT has been performed
                if isempty(app.WaveletCoefficients) || isempty(app.DetailCoefficients)

                    uialert(app.UIFigure,...
                        'Please perform DWT first.',...
                        'No Wavelet Coefficients');

                    return;

                end
wavelet = app.WaveletFamilyDropDown.Value;

                % Retrieve coefficients
                cA = app.WaveletCoefficients;
                cD = app.DetailCoefficients;

                % Reconstruct signal
                reconstructedSignal = idwt(cA,cD,wavelet);

                % Match reconstructed signal length to original signal
                n = min(length(app.OriginalSignal), length(reconstructedSignal));
                reconstructedSignal = reconstructedSignal(1:n);

                % Store reconstructed signal
                app.ProcessedSignal = reconstructedSignal;
                app.LastOperation = 'IDWT';

                % Plot reconstructed signal
                plot(app.ProcessedAxes,reconstructedSignal,...
                    'r','LineWidth',1.5)

                grid(app.ProcessedAxes,'on')

                title(app.ProcessedAxes,'Reconstructed Signal')

                xlabel(app.ProcessedAxes,'Samples')

                ylabel(app.ProcessedAxes,'Amplitude')

                % Update labels
                app.SampleSignalLoadedLabel.Text = 'IDWT Completed';

                app.sLabel.Text = sprintf('%.3f s',toc);

            
          
        end

        % Button pushed function: DenoiseSignalButton
        function DenoiseSignalButtonPushed(app, event)
           

                tic

                % Check if a signal is loaded
                if isempty(app.OriginalSignal)

                    uialert(app.UIFigure,...
                        'Please load a signal first.',...
                        'No Signal');

                    return;

                end

                
                signal = app.OriginalSignal;
                wavelet = app.WaveletFamilyDropDown.Value;

                % Perform DWT
                [CA, CD] = dwt(signal, wavelet);

                % Estimate noise level using Median Absolute Deviation
                sigma = median(abs(CD - median(CD))) / 0.6745;

                % Adjusted universal threshold
                threshold = 1.0 * sigma * sqrt(2 * log(length(signal)));

                % Soft thresholding of detail coefficients
                CD_thresholded = wthresh(CD, 's', threshold);

                % Reconstruct denoised signal
                denoisedSignal = idwt(CA, CD_thresholded, wavelet);

                % Match the original signal length
                n = min(length(signal), length(denoisedSignal));
                denoisedSignal = denoisedSignal(1:n);

                


                % Store processed signal
                app.ProcessedSignal = denoisedSignal;
                app.LastOperation = 'Denoising';

                % Plot denoised signal
                plot(app.ProcessedAxes,denoisedSignal,...
                    'g','LineWidth',1.5)

                grid(app.ProcessedAxes,'on')

                title(app.ProcessedAxes,'Denoised Signal')

                xlabel(app.ProcessedAxes,'Samples')

                ylabel(app.ProcessedAxes,'Amplitude')

                % Update status
                app.SampleSignalLoadedLabel.Text = 'Signal Denoised';

                app.sLabel.Text = sprintf('%.3f s',toc);

            
        end

        % Button pushed function: CompressSignalButton
        function CompressSignalButtonPushed(app, event)
        
                tic

                % Check if signal exists
                if isempty(app.OriginalSignal)

                    uialert(app.UIFigure,...
                        'Please load a signal first.',...
                        'No Signal');

                    return;

                end

                signal = app.OriginalSignal;

                % Get selected wavelet
                wavelet = app.WaveletFamilyDropDown.Value;

                % Wavelet decomposition
                [CA, CD] = dwt(signal, wavelet);

                % Combine wavelet coefficients
                allCoefficients = [CA(:); CD(:)];

                % -------------------------------------------------
                % Compression using a fixed coefficient retention
                % -------------------------------------------------

                % Keep the largest 30% of coefficients
                retentionPercentage = 0.30;

                totalCoefficients = numel(allCoefficients);

                numberToKeep = max(1, round(retentionPercentage * totalCoefficients));

                % Sort coefficients according to magnitude
                sortedValues = sort(abs(allCoefficients),'descend');

                % Determine threshold
                threshold = sortedValues(numberToKeep);

                % Copy coefficients
                CA_compressed = CA;
                CD_compressed = CD;

                % Remove small coefficients
                CA_compressed(abs(CA_compressed) < threshold) = 0;
                CD_compressed(abs(CD_compressed) < threshold) = 0;

                % Reconstruct compressed signal
                compressedSignal = idwt(...
                    CA_compressed,...
                    CD_compressed,...
                    wavelet);

                % -------------------------------------------------
                % Calculate compression ratio
                % -------------------------------------------------

                retainedCoefficients = ...
                    nnz(CA_compressed) + nnz(CD_compressed);

                if retainedCoefficients > 0
                    ratio = totalCoefficients / retainedCoefficients;
                else
                    ratio = NaN;
                end

                % Store compression ratio
                app.CompressionRatio = ratio;

                % Store processed signal
                app.ProcessedSignal = compressedSignal;
                app.LastOperation = 'Compression';

                % Plot compressed signal
                plot(app.ProcessedAxes,compressedSignal,...
                    'm','LineWidth',1.5)

                grid(app.ProcessedAxes,'on')

                title(app.ProcessedAxes,'Compressed Signal')
                xlabel(app.ProcessedAxes,'Samples')
                ylabel(app.ProcessedAxes,'Amplitude')

                % Update status
                app.SampleSignalLoadedLabel.Text = 'Signal Compressed';

                app.sLabel.Text = sprintf('%.3f s',toc);

        
                
      
            
        end

        % Button pushed function: CompareResultsButton
        function CompareResultsButtonPushed(app, event)
       
              tic

       % Check that a signal has been processed
          if isempty(app.OriginalSignal) || isempty(app.ProcessedSignal)

        uialert(app.UIFigure,...
            'Please process a signal first.',...
            'Comparison Error');

        return;

    end

      % Get processed signal
        processed = app.ProcessedSignal;
  
        % Select reference signal
          if strcmp(app.LastOperation,'Denoising')

          % For denoising, use clean reference if available
            if ~isempty(app.CleanReferenceSignal)

              original = app.CleanReferenceSignal;

          else

            original = app.OriginalSignal;

        end

    else

        % For DWT, IDWT and Compression
        original = app.OriginalSignal;

    end

    % Convert both signals to column vectors
    original = original(:);
    processed = processed(:);

    % Make vectors the same length
    n = min(length(original),length(processed));

    original = original(1:n);
    processed = processed(1:n);

    % Mean Squared Error
    mse = mean((original - processed).^2);

    % Error signal
    errorSignal = original - processed;

    % Signal-to-Noise Ratio
    if sum(errorSignal.^2) > 0

        snrValue = 10*log10( ...
            sum(original.^2) / sum(errorSignal.^2));

    else

        snrValue = Inf;

    end

    % Compression Ratio
    if strcmp(app.LastOperation,'Compression')

        ratio = app.CompressionRatio;

        if isnan(ratio)

            app.CompressionRatioLabel.Text = ...
                'Compression Ratio : N/A';

        else

            app.CompressionRatioLabel.Text = ...
                sprintf('Compression Ratio : %.2f',ratio);

        end

    else

        ratio = NaN;

        app.CompressionRatioLabel.Text = ...
            'Compression Ratio : N/A';

    end

    % Update GUI
    app.MSELabel.Text = 'MSE : ';
    app.MSELabel.Text = ...
        sprintf('MSE : %.4f',mse);

    app.SNRLabel.Text = ...
        sprintf('SNR : %.2f dB',snrValue);

    app.SampleSignalLoadedLabel.Text = ...
        'Comparison Complete';

    app.dBLabel.Text = ...
        sprintf('%.2f dB',snrValue);
    app.MSELabel.Text = 'MSE : ';

    app.Label_2.Text = ...
        sprintf('%.4f',mse);

    if isnan(ratio)

        app.Label_3.Text = 'N/A';

    else

        app.Label_3.Text = ...
            sprintf('%.2f',ratio);

    end

    app.SystemStatusLabel.Text = ...
        'Comparison Complete';

    app.sLabel.Text = ...
        sprintf('%.3f s',toc);

    % Display results
    msg = sprintf(...
        'Comparison Complete\n\nMSE = %.4f\nSNR = %.2f dB',...
        mse,...
        snrValue);

    uialert(app.UIFigure,msg,'Results');
    
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1100 700];
            app.UIFigure.Name = 'MATLAB App';

            % Create OriginalAxes
            app.OriginalAxes = uiaxes(app.UIFigure);
            title(app.OriginalAxes, 'Original Signal')
            xlabel(app.OriginalAxes, 'X')
            ylabel(app.OriginalAxes, 'Y')
            zlabel(app.OriginalAxes, 'Z')
            app.OriginalAxes.Position = [272 300 300 185];

            % Create ProcessedAxes
            app.ProcessedAxes = uiaxes(app.UIFigure);
            title(app.ProcessedAxes, 'Processed Signal')
            xlabel(app.ProcessedAxes, 'X')
            ylabel(app.ProcessedAxes, 'Y')
            zlabel(app.ProcessedAxes, 'Z')
            app.ProcessedAxes.Position = [617 300 300 185];

            % Create CoefficientAxes
            app.CoefficientAxes = uiaxes(app.UIFigure);
            title(app.CoefficientAxes, 'Wavelet Coefficient')
            xlabel(app.CoefficientAxes, 'X')
            ylabel(app.CoefficientAxes, 'Y')
            zlabel(app.CoefficientAxes, 'Z')
            app.CoefficientAxes.FontWeight = 'bold';
            app.CoefficientAxes.Position = [283 71 300 185];

            % Create TimeFrequencyAxes
            app.TimeFrequencyAxes = uiaxes(app.UIFigure);
            title(app.TimeFrequencyAxes, {'TimeFrequencyAxes'; ' '})
            xlabel(app.TimeFrequencyAxes, 'X')
            ylabel(app.TimeFrequencyAxes, 'Y')
            zlabel(app.TimeFrequencyAxes, 'Z')
            app.TimeFrequencyAxes.Position = [599 79 300 185];

            % Create Waveletbasedsignalprocessingstimulation
            app.Waveletbasedsignalprocessingstimulation = uilabel(app.UIFigure);
            app.Waveletbasedsignalprocessingstimulation.FontSize = 20;
            app.Waveletbasedsignalprocessingstimulation.FontWeight = 'bold';
            app.Waveletbasedsignalprocessingstimulation.Position = [160 593 431 26];
            app.Waveletbasedsignalprocessingstimulation.Text = 'Wavelet-Based Signal Processing Simulator';

            % Create LoadSelectedSignalButton
            app.LoadSelectedSignalButton = uibutton(app.UIFigure, 'push');
            app.LoadSelectedSignalButton.ButtonPushedFcn = createCallbackFcn(app, @LoadSelectedSignalButtonPushed, true);
            app.LoadSelectedSignalButton.FontWeight = 'bold';
            app.LoadSelectedSignalButton.Position = [22 438 135 22];
            app.LoadSelectedSignalButton.Text = 'Load Selected Signal';

            % Create PerformDWTButton
            app.PerformDWTButton = uibutton(app.UIFigure, 'push');
            app.PerformDWTButton.ButtonPushedFcn = createCallbackFcn(app, @PerformDWTButtonPushed, true);
            app.PerformDWTButton.FontWeight = 'bold';
            app.PerformDWTButton.Position = [25 402 100 22];
            app.PerformDWTButton.Text = 'Perform DWT';

            % Create PerformIDWTButton
            app.PerformIDWTButton = uibutton(app.UIFigure, 'push');
            app.PerformIDWTButton.ButtonPushedFcn = createCallbackFcn(app, @PerformIDWTButtonPushed, true);
            app.PerformIDWTButton.FontWeight = 'bold';
            app.PerformIDWTButton.Position = [22 368 100 22];
            app.PerformIDWTButton.Text = 'Perform IDWT';

            % Create DenoiseSignalButton
            app.DenoiseSignalButton = uibutton(app.UIFigure, 'push');
            app.DenoiseSignalButton.ButtonPushedFcn = createCallbackFcn(app, @DenoiseSignalButtonPushed, true);
            app.DenoiseSignalButton.FontWeight = 'bold';
            app.DenoiseSignalButton.Position = [22 332 100 22];
            app.DenoiseSignalButton.Text = 'Denoise Signal';

            % Create CompressSignalButton
            app.CompressSignalButton = uibutton(app.UIFigure, 'push');
            app.CompressSignalButton.ButtonPushedFcn = createCallbackFcn(app, @CompressSignalButtonPushed, true);
            app.CompressSignalButton.FontWeight = 'bold';
            app.CompressSignalButton.Position = [19 300 112 22];
            app.CompressSignalButton.Text = 'Compress Signal';

            % Create CompareResultsButton
            app.CompareResultsButton = uibutton(app.UIFigure, 'push');
            app.CompareResultsButton.ButtonPushedFcn = createCallbackFcn(app, @CompareResultsButtonPushed, true);
            app.CompareResultsButton.FontWeight = 'bold';
            app.CompareResultsButton.Position = [17 263 113 22];
            app.CompareResultsButton.Text = 'Compare Results';

            % Create SignalTypeDropDownLabel
            app.SignalTypeDropDownLabel = uilabel(app.UIFigure);
            app.SignalTypeDropDownLabel.HorizontalAlignment = 'right';
            app.SignalTypeDropDownLabel.FontWeight = 'bold';
            app.SignalTypeDropDownLabel.Position = [17 557 71 22];
            app.SignalTypeDropDownLabel.Text = 'Signal Type';

            % Create SignalTypeDropDown
            app.SignalTypeDropDown = uidropdown(app.UIFigure);
            app.SignalTypeDropDown.Items = {'Sample Noisy Sine Wave', 'ECG Signal', 'Speech Signal'};
            app.SignalTypeDropDown.FontWeight = 'bold';
            app.SignalTypeDropDown.Position = [113 558 100 22];
            app.SignalTypeDropDown.Value = 'Sample Noisy Sine Wave';

            % Create WaveletFamilyDropDownLabel
            app.WaveletFamilyDropDownLabel = uilabel(app.UIFigure);
            app.WaveletFamilyDropDownLabel.HorizontalAlignment = 'right';
            app.WaveletFamilyDropDownLabel.FontWeight = 'bold';
            app.WaveletFamilyDropDownLabel.Position = [17 484 91 22];
            app.WaveletFamilyDropDownLabel.Text = 'Wavelet Family';

            % Create WaveletFamilyDropDown
            app.WaveletFamilyDropDown = uidropdown(app.UIFigure);
            app.WaveletFamilyDropDown.Items = {'haar', 'db2', 'db4', 'db8', 'sym4', 'coif1'};
            app.WaveletFamilyDropDown.FontWeight = 'bold';
            app.WaveletFamilyDropDown.Position = [147 484 100 22];
            app.WaveletFamilyDropDown.Value = 'haar';

            % Create PerformanceMetricsLabel
            app.PerformanceMetricsLabel = uilabel(app.UIFigure);
            app.PerformanceMetricsLabel.FontSize = 14;
            app.PerformanceMetricsLabel.FontWeight = 'bold';
            app.PerformanceMetricsLabel.Position = [30 198 144 22];
            app.PerformanceMetricsLabel.Text = 'Performance Metrics';

            % Create SNRLabel
            app.SNRLabel = uilabel(app.UIFigure);
            app.SNRLabel.FontSize = 14;
            app.SNRLabel.FontWeight = 'bold';
            app.SNRLabel.Position = [10 150 120 25];
            app.SNRLabel.Text = 'SNR';

            % Create MSELabel
            app.MSELabel = uilabel(app.UIFigure);
            app.MSELabel.FontSize = 14;
            app.MSELabel.FontWeight = 'bold';
            app.MSELabel.Position = [10 115 150 25];
            app.MSELabel.Text = {'MSE '; ' '};

            % Create CompressionRatioLabel
            app.CompressionRatioLabel = uilabel(app.UIFigure);
            app.CompressionRatioLabel.FontSize = 14;
            app.CompressionRatioLabel.FontWeight = 'bold';
            app.CompressionRatioLabel.Position = [9 95 210 22];
            app.CompressionRatioLabel.Text = 'Compression Ratio';

            % Create dBLabel
            app.dBLabel = uilabel(app.UIFigure);
            app.dBLabel.FontSize = 14;
            app.dBLabel.FontWeight = 'bold';
            app.dBLabel.Position = [1355 150 100 25];
            app.dBLabel.Text = ': 0 dB';

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.FontSize = 14;
            app.Label_2.FontWeight = 'bold';
            app.Label_2.Position = [165 115 100 25];
            app.Label_2.Text = ': 0';

            % Create Label_3
            app.Label_3 = uilabel(app.UIFigure);
            app.Label_3.FontSize = 14;
            app.Label_3.FontWeight = 'bold';
            app.Label_3.Position = [150 95 25 22];
            app.Label_3.Text = ': 0';

            % Create SystemStatusLabel
            app.SystemStatusLabel = uilabel(app.UIFigure);
            app.SystemStatusLabel.FontSize = 14;
            app.SystemStatusLabel.FontWeight = 'bold';
            app.SystemStatusLabel.Position = [8 24 101 22];
            app.SystemStatusLabel.Text = 'System Status';

            % Create SampleSignalLoadedLabel
            app.SampleSignalLoadedLabel = uilabel(app.UIFigure);
            app.SampleSignalLoadedLabel.FontSize = 14;
            app.SampleSignalLoadedLabel.FontWeight = 'bold';
            app.SampleSignalLoadedLabel.Position = [124 24 163 22];
            app.SampleSignalLoadedLabel.Text = ': Sample Signal Loaded';

            % Create ProcessingTimeLabel
            app.ProcessingTimeLabel = uilabel(app.UIFigure);
            app.ProcessingTimeLabel.FontSize = 14;
            app.ProcessingTimeLabel.FontWeight = 'bold';
            app.ProcessingTimeLabel.Position = [8 58 117 22];
            app.ProcessingTimeLabel.Text = 'Processing Time';

            % Create sLabel
            app.sLabel = uilabel(app.UIFigure);
            app.sLabel.FontSize = 14;
            app.sLabel.FontWeight = 'bold';
            app.sLabel.Position = [129 58 56 22];
            app.sLabel.Text = ': 0.002s';

            % Create BrowseCustomSignalButton
            app.BrowseCustomSignalButton = uibutton(app.UIFigure, 'push');
            app.BrowseCustomSignalButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseCustomSignalButtonPushed, true);
            app.BrowseCustomSignalButton.FontWeight = 'bold';
            app.BrowseCustomSignalButton.Position = [22 518 145 22];
            app.BrowseCustomSignalButton.Text = 'Browse Custom Signal';

            % Create Label_4
            app.Label_4 = uilabel(app.UIFigure);
            app.Label_4.FontSize = 11;
            app.Label_4.FontWeight = 'bold';
            app.Label_4.Position = [916 115 150 133];
            app.Label_4.Text = {'Colour Scale'; ''; 'Blue      = Low Energy'; ''; 'Green     = Medium Energy'; ''; 'Yellow    = High Energy'; ''; 'Red        = Maximum Energy'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end