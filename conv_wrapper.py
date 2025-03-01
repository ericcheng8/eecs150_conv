import sounddevice as sd
import numpy as np
import wave
import matlab.engine
import winsound
import os
import time


FS = 44100  # Sampling rate
DURATION = 5  # Duration of recording (sec)
AUD_SRC = "audio_src"
INPUT_WAV = AUD_SRC + "/" + "input.wav"
OUTPUT_WAV = AUD_SRC + "/" + "output.wav"
IMPULSE_WAV = AUD_SRC + "/" + "impulse_response.wav"


def record_audio(filename, duration, fs):
    audio_data = sd.rec(int(duration * fs), samplerate=fs, channels=1, dtype=np.float32)
    print("Recording audio in 3 seconds...")
    sd.wait()
    
    audio_data = (audio_data * 32767).astype(np.int16)  # Convert to 16-bit PCM
    with wave.open(filename, "wb") as wf:
        wf.setnchannels(1)
        wf.setsampwidth(2)
        wf.setframerate(fs)
        wf.writeframes(audio_data.tobytes())
    print(f"Saved recorded audio as {filename}")

def play_audio(filename):
    print("Playing convolved audio...")
    winsound.PlaySound(filename, winsound.SND_FILENAME)

def main():
  print("Starting MATLAB engine...")
  eng = matlab.engine.start_matlab()

  record_audio(INPUT_WAV, DURATION, FS)

  print("Calling MATLAB function for convolution...")
  output_path = os.getcwd() + "/" + AUD_SRC
  eng.convolute_wav(INPUT_WAV, IMPULSE_WAV, output_path, nargout=0)

  time.sleep(2)

  play_audio(OUTPUT_WAV)

  eng.quit()
  print("Finished.")





if __name__ == "__main__":
    main()
