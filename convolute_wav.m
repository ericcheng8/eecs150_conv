function output_file = convolute_wav(input_file, impulse_file, outputPath)
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

    disp(['Convolved audio saved to: ', outputFilePath]);
end