#!/bin/bash
#==============================================================
# build.sh
# One-step build script for Nandland Go Board Snake (VGA)
# Requires: yosys, nextpnr-ice40, icepack, iceprog
#==============================================================

set -e
PROJECT="snake_game"

echo "=== 1. Synthesis (Yosys) ==="
yosys -p "synth_ice40 -top ${PROJECT} -blif ${PROJECT}.blif" ${PROJECT}.v snake_logic.v vga_sync.v clock_divider.v seven_seg.v

echo "=== 2. Place-and-Route (nextpnr-ice40) ==="
nextpnr-ice40 --hx1k --package tq144 --pcf go_board.pcf --blif ${PROJECT}.blif --asc ${PROJECT}.asc

echo "=== 3. Bitstream Packing (icepack) ==="
icepack ${PROJECT}.asc ${PROJECT}.bin

echo "=== 4. Programming FPGA (iceprog) ==="
iceprog ${PROJECT}.bin

echo "=== DONE! ==="
echo "Bitstream ${PROJECT}.bin successfully flashed to FPGA."
