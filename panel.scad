// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Panel for Datalogger-v3 PCB. 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>

ANCHOR = BOTTOM+LEFT+BACK;

// --- generic module to a cover for a PCB   ---------------------------------

module cover(x, y, w, z=Z_PANEL,
             d_screw=2.5, o_screw=3, h_screw=1.4, d2_screw=4.28,
             r=3, edges="Z", screws=true) {
  difference() {
    // solid space
    cuboid([x,y,z], rounding=r, edges=edges, anchor=ANCHOR);
    // minus screw-holes
    if (screws) {
      move([w+o_screw,-w-o_screw,-FUZZ]) {
          cylinder(d=d_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
          zmove(Z_PANEL-h_screw+FUZZ) 
            cylinder(d=d2_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
      }
      move([x-w-o_screw,-w-o_screw,-FUZZ]) { 
        cylinder(d=d_screw, h=Z_PANEL+2*FUZZ,anchor=BOTTOM+CENTER);
        zmove(Z_PANEL-h_screw+FUZZ) 
          cylinder(d=d2_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
      }
      move([w+o_screw,-y+w+o_screw,-FUZZ]) {
        cylinder(d=d_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
        zmove(Z_PANEL-h_screw+FUZZ) 
          cylinder(d=d2_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
      }
      move([x-w-o_screw,-y+w+o_screw,-FUZZ]) { 
        cylinder(d=d_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
        zmove(Z_PANEL-h_screw+FUZZ) 
          cylinder(d=d2_screw, h=Z_PANEL,anchor=BOTTOM+CENTER);
      }
    }
  }
}

// --- final object   -------------------------------------------------------

module panel() {
  Z_PANEL_FUZZ = Z_PANEL+2*FUZZ;
  // cover minus all cutouts
  difference() {
    // create a slightly larger cover and move it to simplify coordinates 
    move([-W_PANEL,W_PANEL,0])
      cover(X_PANEL, Y_PANEL, W_PANEL);
    // JST-PH2 (remove for 300_3, 300_5)
    move([-W_PANEL-FUZZ,-8,-FUZZ])
      cuboid([13+W_PANEL+FUZZ,11,Z_PANEL_FUZZ], anchor=ANCHOR);
    // pins battery-holder (remove for 300_3, 300_5)
    move([22,-5.5,-FUZZ]) cylinder(d=2.5, h=H_PINS+FUZZ,anchor=ANCHOR);
    move([37,-5.5,-FUZZ]) cylinder(d=2.5, h=H_PINS+FUZZ,anchor=ANCHOR);
    // power-switch (remove for 300_3, 300_5)
    move([54,0,-FUZZ]) cuboid([11.5,13,Z_PANEL_FUZZ], anchor=ANCHOR);
    // pins Pico-W
    move([71,0,-FUZZ]) cuboid([3,52,H_PINS+FUZZ], anchor=ANCHOR);
    move([88.7,0,-FUZZ]) cuboid([3,52,H_PINS+FUZZ], anchor=ANCHOR);
    // JST-SH4 (i2c0) (remove vor 300_5)
    move([76,+W_PANEL+FUZZ,-FUZZ])
      cuboid([11,6.5+W_PANEL+FUZZ,Z_PANEL_FUZZ], anchor=ANCHOR);
    // JST-SH4 (i2c1) + GH6 (SEN66) (xsize+12: UART5V)  (remove for 300_5)
    move([92.3,+W_PANEL+FUZZ,-FUZZ])
      cuboid([21,8+W_PANEL+FUZZ,Z_PANEL_FUZZ], anchor=ANCHOR); // I2C1+GH6
      //cuboid([11,8+W_PANEL+FUZZ,Z_PANEL_FUZZ], anchor=ANCHOR);   // only I2C1
    // SCD40/OLED
    move([91.88,-10.95,-FUZZ])
       cuboid([6.42,12,Z_PANEL_FUZZ], anchor=ANCHOR);
    // AHT20  (remove for 300_3, 300_5)
    move([119,-11,-FUZZ])
       cuboid([9.1,10.5,Z_PANEL_FUZZ], anchor=ANCHOR);
    // Buttons A-C
    move([93,-24,-FUZZ]) cuboid([28,12,Z_PANEL_FUZZ], anchor=ANCHOR);
    // LoRa-antenna
    move([112,-57.5,-FUZZ]) cylinder(d=4, h=H_PINS+FUZZ,anchor=ANCHOR);
    // Buttons Reset+ON
    move([72,-52.5,-FUZZ]) cuboid([19,12,Z_PANEL_FUZZ], anchor=ANCHOR);
    // Buttons Reset only (for 300_3, 300_5)
    //move([72,-52.5,-FUZZ]) cuboid([9.5,12,Z_PANEL_FUZZ], anchor=ANCHOR);
    // Display-connector SURS (remove for 300_3, 300_5)
    move([53,-59.5,-FUZZ]) cuboid([14,4.5,Z_PANEL_FUZZ], anchor=ANCHOR);
    // Display-connector THT
    move([48.30,-54.145,-FUZZ]) cuboid([22.5,4.5,Z_PANEL_FUZZ], anchor=ANCHOR);
  }
}

// final object, rotated for printing
xrot(180)
  panel();
