# Collatz Conjecture Tester on DE1-SoC Board

## Overview
This project involves creating a system to test the Collatz conjecture over a range of values using SystemVerilog. The project was simulated using Verilator and waveforms were observed with GTKWave. Additionally, the project was compiled and downloaded to the DE1-SoC FPGA board using Quartus Prime 21.1.

## Features
- **User Interface**: Utilizes DE1-SoC board's pushbuttons and switches for input.
- **Display Output**: Leverages seven-segment displays to show the start value and number of iterations taken to reach 1 for a given start value of the Collatz sequence.
- **Input Handling**: Processes inputs from buttons, including regular, fast, slow, press and hold, and multiple button presses.

## Getting Started
To run this project, ensure you have the following software installed:
- Quartus Prime 21.1 (available [here](https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime/resource.html))
- Verilator for SystemVerilog simulation
- GTKWave for viewing simulated waveforms

### Installation
1. Download Quartus Prime 21.1 from Intel's website and install it on a Windows or Linux machine.
2. Install Verilator and GTKWave on your system.
3. Clone this repository to your local machine.

### Usage
1. Use the switches `sw[9:0]` to set the starting value `n` for the range to test.
2. Press `key[3]` to run the range module over 256 values starting from the value on the switches.
3. Observe the value of `n` and the number of iterations on the seven-segment displays.

## Contact
For any queries regarding this project, please open an issue on this repository or contact the repository owner.
