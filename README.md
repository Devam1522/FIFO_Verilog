# Synchronous FIFO (Verilog)

A 4-word deep, 8-bit wide synchronous First-In-First-Out (FIFO) buffer designed in Verilog HDL, built and simulated in Xilinx Vivado, targeting the Artix-7 FPGA.

## Overview

This project implements a synchronous FIFO used to buffer data between two operations running on the same clock domain. It supports independent write and read enables, tracks occupancy internally, and generates `full` and `empty` status flags to prevent overflow and underflow.

## Features

- 8-bit wide data path
- 4-entry deep memory (expandable by changing pointer/count widths)
- Independent write-enable (`wr_en`) and read-enable (`rd_en`) control
- Internal occupancy counter for accurate `full` / `empty` flag generation
- Write is blocked when full; read is blocked when empty (protects data integrity)

## Block Diagram

```
                 ┌─────────────────────────┐
  data_in[7:0]──►│                         │
  wr_en ────────►│      FIFO Memory        │──► data_out[7:0]
  rd_en ────────►│      (4 x 8-bit)        │
  clk ──────────►│  wr_ptr / rd_ptr/count  │──► full
  rst ──────────►│                         │──► empty
                 └─────────────────────────┘
```

## Module Interface

| Signal    | Direction | Width | Description                          |
|-----------|-----------|:-----:|---------------------------------------|
| clk       | input     | 1     | Clock signal                          |
| rst       | input     | 1     | Synchronous active-high reset         |
| wr_en     | input     | 1     | Write enable                          |
| rd_en     | input     | 1     | Read enable                           |
| data_in   | input     | 8     | Data to write into the FIFO           |
| data_out  | output    | 8     | Data read from the FIFO               |
| full      | output    | 1     | High when FIFO has 4 stored entries   |
| empty     | output    | 1     | High when FIFO has 0 stored entries   |

## Repository Structure

```
FIFO_Verilog/
├── src/
│   └── fifo.v          # RTL design
├── sim/
│   └── fifo_tb.v       # Testbench
├── docs/
│   └── waveform.png    # Simulation waveform screenshot
├── README.md
├── .gitignore
└── LICENSE
```

## How It Works

- **Write logic:** On each clock edge, if `wr_en` is high and the FIFO is not full, the incoming data is stored at `mem[wr_ptr]` and the write pointer increments.
- **Read logic:** On each clock edge, if `rd_en` is high and the FIFO is not empty, data is read out from `mem[rd_ptr]` and the read pointer increments.
- **Occupancy tracking:** A 3-bit counter tracks how many entries are currently stored, incrementing on a write-only cycle and decrementing on a read-only cycle. `full` and `empty` are derived directly from this counter.

## How to Simulate

### Using Vivado
1. Create a new RTL project.
2. Add `src/fifo.v` as a design source.
3. Add `sim/fifo_tb.v` as a simulation source.
4. Run **Behavioral Simulation** and inspect `data_out`, `full`, and `empty` in the waveform viewer.

### Using Icarus Verilog (free, open-source alternative)
```bash
iverilog -o fifo_sim src/fifo.v sim/fifo_tb.v
vvp fifo_sim
```

## Testbench Behavior

The testbench writes 4 sequential values (1, 2, 3, 4) into the FIFO, then reads all 4 values back out, exercising both the write and read paths and verifying the `full` flag asserts after the 4th write and `empty` asserts after the 4th read.

## Target Device

- **Part:** xc7a35tcpg236-1 (Artix-7, Basys 3 / Arty A7-compatible)
- **Tool:** Xilinx Vivado

## Possible Extensions

- Parameterize `DEPTH` and `WIDTH` instead of hardcoding 4 and 8
- Add an asynchronous (dual-clock) version using Gray-coded pointers for clock-domain crossing
- Add almost-full / almost-empty threshold flags
- Add a valid/ready handshake interface (AXI-Stream style)

## Author

**Devam Patel**
M.Tech — VLSI & Embedded Systems

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.