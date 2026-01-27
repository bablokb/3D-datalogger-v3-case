// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Shared dimensions. 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

Z_PCB = 1.6;

X_PCB = 130;
Y_PCB =  65;

H_PINS = 1.6;

W_PANEL  = W4;
R_PANEL  = 3;

X_PANEL = X_PCB + 2*W_PANEL + GAP;
Y_PANEL = Y_PCB + 2*W_PANEL + GAP;
Z_PANEL = 2;
