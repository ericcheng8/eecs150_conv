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

% Call the deconvolve_wav function using the selected files.
% The output is saved in the inputPath.
y = deconvolve_wav(inputFilePath, impulseFilePath, inputPath);

function deconvolved_signal = deconvolve_wav(input_file, impulse_file, outputPath)
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
    % h = h / max(abs(h)); % Ensure max amplitude is 1

    % Ensure the sampling rates match
    if fs ~= fs_h
        disp('Sampling rates do not match. Resampling impulse response using interp1.');
        t_orig = (0:length(h)-1) / fs_h;
        t_new = (0:1/fs:(t_orig(end)))';
        h = interp1(t_orig, h, t_new, 'linear');
        h = h(:);
    end

    % Zero-pad to the same length
    N = max(length(x), length(h));
    x = [x; zeros(N - length(x), 1)];
    h = [h; zeros(N - length(h), 1)];

    % Compute the Fourier transforms
    X = fft(x, N);
    H = fft(h, N);

    % Avoid division by zero by adding a small epsilon
    epsilon = 1e-10;
    H = H + epsilon;

    % Perform deconvolution in the frequency domain
    Y = X ./ H;
    deconvolved_signal = real(ifft(Y));

    % Normalize the output to avoid clipping
    deconvolved_signal = deconvolved_signal / max(abs(deconvolved_signal));

    % Save the output audio
    outputFilePath = fullfile(outputPath, 'deconvolved_output.wav');
    audiowrite(outputFilePath, deconvolved_signal, fs);

    % Compute frequency axis
    f = (0:N-1) * (fs / N);
    disp(N)
    
    % Plot the frequency spectra (magnitude)
    figure;
    subplot(2,1,1);
    plot(f, abs(X));
    title('Frequency Spectrum of Input Signal');
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
    xlim([0 fs/2]); % Limit x-axis to Nyquist frequency

    subplot(2,1,2);
    plot(f, abs(Y));
    title('Frequency Spectrum of Deconvolved Signal');
    xlabel('Frequency [Hz]');
    ylabel('Magnitude');
    xlim([0 fs/2]); % Limit x-axis to Nyquist frequency
end
