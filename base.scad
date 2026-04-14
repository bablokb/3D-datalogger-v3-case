// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): Base for Datalogger-v3 PCB. 
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <shared.scad>
include <sliding_lid.scad>
include <threaded_case.scad>

// ethernet (EVB-Pico)
HAVE_ETH = false;
X_ETH = 22;
H_ETH = BT + 2;

Z_CASE = HAVE_ETH ? 30:20;
X_LID  = 50;

// USB-cutout
X_USB = 10;                  // x-size cutout
O_USB = 16.46;               // offset from y==0
Z_USB =  6;                  // z-size cutout
H_USB = BT+Z_CASE-11-Z_USB;  // height of cutout (offset from z==0)
X_PICO_SOCKETS = 9*2.54;     // Pico is 21mm, this is 22.86

// AHT20 wall
O_AHT20 = 10.2;              // offset from right side

// ventilation
X_VENT_B = 30;
Y_VENT_B =  3;
N_VENT_B =  8;
D_VENT_S =  3;
N_VENT_S =  4;

// --- base composite object   ------------------------------------------------

module base(lid=true) {
  difference() {
    union() {
      // case and all supports
      case_threaded(X_PCB, Y_PCB, z_pcb=Z_PCB,
                     z_case=Z_CASE, z_base=BT, wall=W_PANEL, rounding=R_PANEL
                   );
      // AHT20 wall
      if (!HAVE_ETH) {
        xmove(X_PCB/2-O_AHT20)
          cuboid([W2,Y_PANEL,Z_CASE-Z_PCB+BT], anchor=BOTTOM+CENTER);
      }
    }
    // ventilation bottom
    zmove(-FUZZ) xmove(O_USB)
      ycopies(2*Y_VENT_B, n=N_VENT_B)
        cuboid([X_VENT_B,Y_VENT_B,BT+2*FUZZ], anchor=BOTTOM+CENTER);
    // ventilation sides
    zmove(H_USB+Z_USB+D_VENT_S) xmove(O_USB)
      xcopies(1.5*X_USB,n=N_VENT_S)
        ycyl(l=2*Y_PANEL,d=D_VENT_S);
    // USB-cutout
    move([O_USB,Y_PANEL/2,H_USB])
      cuboid([X_USB,6*W_PANEL,Z_USB], anchor=BOTTOM+CENTER);
    // cutout for Pico sockets
    move([O_USB,Y_PANEL/2-2*W_PANEL,BT-FUZZ])
      cuboid([X_PICO_SOCKETS,3*W_PANEL,Z_CASE+2*FUZZ], anchor=BOTTOM+CENTER);
    // ethernet
    if (HAVE_ETH) {
      move([O_USB,-Y_PANEL/2,H_ETH])
        cuboid([X_ETH,6*W_PANEL,Z_CASE], anchor=BOTTOM+CENTER);
    }
    // battery lid
    if (lid) {
      zmove(-FUZZ) xmove(-X_PANEL/2+X_LID/2-FUZZ)
        color("blue")
          lid(X_LID,Y_PANEL-2*W_PANEL, w=W_PANEL,
	                               r=[0,0,0,0], reverse=false, mask=true);
    }
  }
}

// --- final objects   --------------------------------------------------------

// test-print part of base to check lid
//intersection() {
//  base();
//    xmove(-X_PANEL/2+X_LID/2)
//      cuboid([X_LID+10,Y_PANEL+10,5], anchor=BOTTOM+CENTER);
//}

// base and lid
lid = true;
xdistribute(10, sizes=[X_LID,X_PANEL]) {
  if (lid) {
    //xmove(30)
    //xmove(-X_PANEL/2+X_LID/2) zmove(GAP)
       color("aqua") lid(X_LID,Y_PANEL-2*W_PANEL, w=W_PANEL, r=[0,3,3,0],
                         reverse=false, mask=false);
  }
  base(lid);
}
