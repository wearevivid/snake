# 🐍 VGA Snake for Nandland Go Board

A full **3-color Snake game** implemented entirely in **Verilog** for the **Nandland Go Board (Lattice iCE40HX1K)**.

This project runs a complete VGA video pipeline, real-time snake logic, score tracking on the dual 7-segment display, and button controls — all built from scratch in HDL.

---

## 🎮 Features
- **Resolution:** 640×480 @ 60 Hz VGA output  
- **Colors:**  
  - Background – Deep Blue  
  - Snake – Bright Lime Green  
  - Food – Hot Pink  
- **Gameplay:**  
  - Directional control via board buttons  
  - Snake grows each time food is eaten  
  - Movement speed increases after every meal  
  - Score displayed live on 7-segment display (00–99)  
- **Language:** Pure Verilog (no soft CPU)  
- **Hardware:** Nandland Go Board (iCE40HX1K-TQ144)

---

## 🧠 Project Structure
```
snake_vga/
├── snake_game.v        # Top-level integration
├── snake_logic.v       # Snake movement, food, speed & score logic
├── vga_sync.v          # VGA 640×480@60Hz timing generator
├── clock_divider.v     # General-purpose clock divider
├── seven_seg.v         # 7-segment score display driver
├── go_board.pcf        # Pin constraints for Nandland Go Board
├── build.sh            # One-command build & flash script
└── README.md           # This file
```

---

## ⚙️ Requirements
Make sure the **IceStorm toolchain** is installed and in your PATH:

```bash
sudo apt install yosys nextpnr-ice40 icestorm
```

On macOS:
```bash
brew install yosys nextpnr-ice40 icestorm
```

On Windows, use the official [Nandland Go Board installer](https://nandland.com/go-board/).

---

## 🧩 Building & Flashing

### 1️⃣ Clone or download
```bash
git clone https://github.com/YOUR_USERNAME/snake_vga.git
cd snake_vga
```

### 2️⃣ Build & flash
```bash
chmod +x build.sh
./build.sh
```

This script:
1. Synthesizes all Verilog with **Yosys**
2. Runs **nextpnr-ice40** to place & route
3. Creates the `.bin` bitstream with **icepack**
4. Programs the FPGA with **iceprog**

---

## 🖥️ VGA Pinout (Typical)
| VGA Signal | Go Board Pin | FPGA Net |
|-------------|--------------|-----------|
| Red         | J4-59        | rgb[2]    |
| Green       | J4-60        | rgb[1]    |
| Blue        | J4-61        | rgb[0]    |
| HSYNC       | J4-56        | hsync     |
| VSYNC       | J4-57        | vsync     |
| GND         | Any Ground   | —         |

*(See `go_board.pcf` for exact pin mapping.)*

---

## 🔘 Button Mapping
| Button | Action |
|--------|--------|
| **Up** | Move up |
| **Down** | Move down |
| **Left** | Move left |
| **Right** | Move right |
| **Reset** | Restart game |

---

## 💡 Gameplay Notes
- The snake wraps around screen edges (no wall collision).  
- Each apple increases both **length** and **speed**.  
- Score updates on the 7-segment display.  
- Optimized for the 12 MHz oscillator.

---

## 🧾 License
MIT License — feel free to remix, improve, or port to other FPGAs.

---

## 🧑‍💻 Author
Created with ❤️  
Designed to be compact, readable, and easy to hack for beginners learning Verilog and VGA timing.

---
