# Convolution & De-convolution Tool for Audio

## Summary
TBD

## Dependencies
1. Install Python3 and MATLAB.
2. Git clone this repository.
3. Open MATLAB and type `ver` into the terminal. Pick the version # that is the closest to the following list:

    (from versions: 9.13.1, 9.13.4, 9.13.5, 9.13.6, 9.13.7, 9.13.8, 9.13.9, 9.13.10, 9.13.11, 9.14.2, 9.14.3, 9.14.4, \
     9.14.6, 9.14.7, 9.15.2, 23.2.1, 23.2.2, 23.2.3, 24.1.1, 24.1.2, 24.1.3, 24.1.4, 24.2.1, 24.2.2, 25.1.1, 25.1.2)
4. Open `requirements.txt` and replace `9.14.7` on Line 3 with your MATLAB version.
5. Save and close.

## Running the Scripts
1. Open MATLAB and run `matlab.engine.shareEngine` in the terminal.
2. In CMD/terminal, navigate to the folder of the cloned repo and run `.\env_source.bat`.
3. Press Enter.
4. Execute `python conv_wrapper.py`.
5. Use `exit` to quit.
