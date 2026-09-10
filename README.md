# Synchronous FIFO

A 16-deep, 8-bit wide FIFO operating entirely in a single clock domain, written in Verilog.

## Files

```
sync_fifo.v       # RTL
sync_fifo_tb.v    # testbench
```

## Design

- Full/empty detection uses the standard "extra MSB" pointer trick: 5-bit read/write pointers for a 16-deep memory (4 address bits + 1 wrap bit).
- `full` asserts when the wrap bits differ but the address bits match.
- `empty` asserts when the pointers are exactly equal.
- Single `clk` domain, so no clock-domain-crossing concerns — pointers are compared directly.

## Ports

| Signal   | Dir | Width | Description            |
|----------|-----|-------|-------------------------|
| clk      | in  | 1     | clock                  |
| rst_n    | in  | 1     | active-low async reset |
| wr_en    | in  | 1     | write enable            |
| din      | in  | 8     | write data              |
| full     | out | 1     | FIFO full flag          |
| rd_en    | in  | 1     | read enable              |
| dout     | out | 8     | read data                |
| empty    | out | 1     | FIFO empty flag          |

## Testbench

Fills the FIFO past its depth to verify `full` asserts correctly and writes stop, then drains it fully to verify `empty` asserts, printing every read as it happens via `$display`.

## Running the simulation

```bash
iverilog -o sim_sync sync_fifo.v sync_fifo_tb.v
vvp sim_sync
```

## Notes

`mem` will infer as distributed RAM on FPGA synthesis tools by default. For deeper FIFOs, retarget to block RAM (e.g. Xilinx `xpm_memory` primitives on Artix-7).
