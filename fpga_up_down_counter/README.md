# FPGA Up/Down Counter on ZedBoard
📌 Overview

This project implements a 4-bit Up/Down Counter system in Verilog HDL, designed, simulated, and deployed on the ZedBoard (Xilinx Zynq-7000 FPGA).

The system includes clock division, debouncing, finite state machine control, and seven-segment display interfacing. The design was verified through simulation and successfully synthesized and implemented on hardware.

🎯 Features

4-bit synchronous Up/Down counter

FSM-based control logic

Push-button debouncing

Clock divider for human-visible counting

Seven-segment display driver

Fully modular RTL design

Hardware validation on ZedBoard

🧠 Design Details
1️⃣ Up/Down Counter

Synchronous design

Parameterizable bit-width (if applicable)

Controlled using FSM logic

Reset and enable supported

2️⃣ FSM Controller

Controls counting direction

Handles enable logic

Designed using behavioral modeling

3️⃣ Clock Divider

Reduces 100 MHz board clock to human-visible frequency

4️⃣ Debounce Module

Eliminates mechanical switch noise

Ensures stable button transitions

5️⃣ Seven Segment Decoder

Converts 4-bit binary output to display format

Active-low/active-high configurable (depending on board wiring)

🛠 Tools Used

Xilinx Vivado

Verilog HDL

ZedBoard (Zynq-7000 SoC FPGA)

🧪 Verification

Functional simulation performed using Vivado simulator

Testbench created for RTL verification

Waveform validation completed before synthesis

🚀 Hardware Implementation

The design was:

Synthesized

Implemented

Bitstream generated

Successfully deployed on ZedBoard

Push buttons control counting direction, and output is displayed on the onboard seven-segment display.

📚 Concepts Applied

RTL design methodology

FSM design

Synchronous sequential logic

Clock domain handling

FPGA synthesis and implementation flow

Hardware debugging

🔮 Future Improvements

Parameterized counter width

Add load functionality

Integrate UART for serial monitoring

Convert to pipelined architecture

Add formal verification

👤 Author

Munim Ahmed
Electronics & Communication Engineering
Focused on VLSI, RTL Design, and FPGA Development
