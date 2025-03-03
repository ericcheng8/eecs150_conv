clc; clear;

% Select input audio file
[inputFile, inputPath] = uigetfile({'*.wav'}, 'Select an input audio file');
if isequal(inputFile, 0)
    disp('No input file selected. Exiting.');
    return;
end
inputFilePath = fullfile(inputPath, inputFile);

% Select impulse response file
[impulseFile, impulsePath] = uigetfile({'*.wav'}, 'Select an impulse response file');
if isequal(impulseFile, 0)
    disp('No impulse response file selected. Exiting.');
    return;
end
impulseFilePath = fullfile(impulsePath, impulseFile);

% Call the convolute_wav function using the selected files.
% For saving the output, we're using the inputPath (or you can choose another folder).
y = convolute_wav(inputFilePath, impulseFilePath, inputPath);

function convolved_signal = convolute_wav(input_file, impulse_file, outputPath)
    % Read input audio file
    [x, fs] = audioread(input_file);
    if size(x, 2) > 1
        x = mean(x, 2); % Convert stereo to mono
    end

    % Read impulse response file
    [h, fs_h] = audioread(impulse_file);
    if size(h, 2) > 1
        h = mean(h, 2); % Convert stereo to mono
    end

    % Normalize impulse response
    h = h / max(abs(h)); % Ensure max amplitude is 1

    % Ensure the sampling rates match
    if fs ~= fs_h
        disp('Sampling rates do not match. Resampling impulse response using interp1.');
        t_orig = (0:length(h)-1) / fs_h;
        t_new = (0:1/fs:(t_orig(end)))';
        h = interp1(t_orig, h, t_new, 'linear');
        h = h(:);
    end

    % Perform convolution
    convolved_signal = conv(x, h, 'same');

    % Normalize the output to avoid clipping
    convolved_signal = convolved_signal / max(abs(convolved_signal));

    % Save the output audio
    outputFilePath = fullfile(outputPath, 'output.wav');
    audiowrite(outputFilePath, convolved_signal, fs);

    % Plot frequency spectra of the original and convolved signals
    N = length(x); % Length of the signal
    fft_x = fft(x, N);
    fft_convolved = fft(convolved_signal, N);
    
    % Compute frequency axis
    f = (0:N-1) * (fs / N);
    
    % Plot the frequency spectra (magnitude)
    figure;
    subplot(2,1,1);
    plot(f, abs(fft_x));
    title('Frequency Spectrum of Original Signal');
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
    xlim([0 fs/2]); % Limit x-axis to Nyquist frequency

    subplot(2,1,2);
    plot(f, abs(fft_convolved));
    title('Frequency Spectrum of Convolved Signal');
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
    xlim([0 fs/2]); % Limit x-axis to Nyquist frequency
end
