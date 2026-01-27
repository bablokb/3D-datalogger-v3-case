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
include <fase.scad>
include <ruthex.scad>
include <sliding_lid.scad>

Z_CASE = 20;
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

// --- basic case   ----------------------------------------------------------

module case(x, y, z, b, w, r) {
  // base plate
  cuboid([x,y,b], rounding=r, edges="Z", anchor=BOTTOM+CENTER);
  // sides
  rect_tube(size=[x,y], wall=w, h=b+z,
            rounding=r, anchor=BOTTOM+CENTER);
}

// --- support for PCB   -----------------------------------------------------

module support(x,y,w,h) {
  move([-x+w-FUZZ,0,h])
    fase(w,y,w+3,orient="yl");
  move([+x-w+FUZZ,0,h])
    fase(w,y,w+3,orient="yr");
  move([0,-y+w-FUZZ,h])
    fase(x,w,w+3,orient="xf");
  move([0,+y-w+FUZZ,h])
    fase(x,w,w+3,orient="xb");
}

// --- thread pockets   -------------------------------------------------------

module pockets(x, y, h, w, offset) {
  xflip_copy() yflip_copy() {
    move([-x+offset,-y+offset,h]) ruthex25(do_extra=w/2);
  }
}

// --- base composite object   ------------------------------------------------

module base() {
  difference() {
    union() {
      // case and all supports
      case(X_PANEL, Y_PANEL, Z_CASE, BT, W_PANEL, R_PANEL);
      support(X_PANEL/2, Y_PANEL/2, W_PANEL, h=Z_CASE-Z_PCB+BT);
      pockets(X_PCB/2, Y_PCB/2,
              h=Z_CASE-Z_PCB+BT, w=W_PANEL,
              offset=R_PANEL);
      // AHT20 wall
      xmove(X_PCB/2-O_AHT20)
        cuboid([W2,Y_PANEL,Z_CASE-Z_PCB+BT], anchor=BOTTOM+CENTER);
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
    
    // battery lid
    zmove(-FUZZ) xmove(-X_PANEL/2+X_LID/2-FUZZ)
      color("blue") lid(X_LID,Y_PANEL-2*W_PANEL, w=W_PANEL, r=[0,3,3,0], reverse=true, hull=true);  
  }
}

// --- final objects   --------------------------------------------------------

xdistribute(10, sizes=[X_LID,X_PANEL]) {
  color("blue") lid(X_LID,Y_PANEL-2*W_PANEL-GAP, w=W_PANEL, r=[0,3,3,0],
                    reverse=true, hull=false);  
  base();
}
