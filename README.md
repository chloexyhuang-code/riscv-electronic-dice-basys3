# riscv-electronic-dice-basys3
# RISC-V Electronic Dice System on Basys 3 FPGA

## Project Overview

This project implements an interactive electronic dice system using the PicoRV32 RISC-V processor on the Digilent Basys 3 FPGA board.

The system demonstrates memory-mapped I/O communication between a RISC-V CPU and FPGA peripherals.

When the user presses the BTNC button, the CPU reads the button state through a memory-mapped input register and writes the dice result to the seven-segment display.

## Hardware Platform

- FPGA Board: Digilent Basys 3
- FPGA Device: Xilinx Artix-7 XC7A35T
- CPU Core: PicoRV32

## Development Environment

- Vivado Design Suite: [Fill in your version]
- RISC-V Toolchain: riscv32-unknown-elf-gcc
- Programming Language: Verilog HDL, C

## Memory Map

| Address | Function |
|----------|----------|
| 0x00000000 - 0x00000FFF | Instruction Memory |
| 0x00001000 - 0x00001FFF | Data Memory |
| 0x40000000 | Button Input Register |
| 0x40000004 | Seven-Segment Output Register |

## Operation

1. Program the FPGA with the generated bitstream.
2. Press the BTNC button.
3. Observe the seven-segment display.
4. The displayed number changes from 1 to 6.

## External Resources

- PicoRV32: https://github.com/YosysHQ/picorv32

## Author

- Name: Pei-Hsien Lee
- Student ID: 1123707
- Course: EEB318A Digital System Design with Lab
- Yuan Ze University
