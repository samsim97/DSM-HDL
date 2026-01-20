import math

DATA_WIDTH = 16
NUM_SAMPLES = 300 # Approx 1 period
SIN_AMPLITUDE = 0.4

def generate_sine_wave(num_samples, amplitude, data_width):
  max_int = 2**(data_width - 1) - 1
  sine_wave = []
  for n in range(num_samples):
    angle = 2 * math.pi * n / num_samples
    value = int(amplitude * max_int * math.sin(angle))
    sine_wave.append(value)
  return sine_wave

if __name__ == "__main__":
  sine_wave = generate_sine_wave(NUM_SAMPLES, SIN_AMPLITUDE, DATA_WIDTH)
  for i, sample in enumerate(sine_wave):
    print(f"    r_input_signal[{i}] = {DATA_WIDTH}'b{sample & ((1 << DATA_WIDTH) - 1):0{DATA_WIDTH}b};")