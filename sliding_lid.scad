// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): generic sliding-lid component.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

X_GRIP  = 2;
Y_GRIP  = 10;
H_BULGE = 1.0;

// --- lid module   -----------------------------------------------------------

module lid(x, y, z=BT+2*FUZZ, w, r, mask=false, reverse=false) {
  ylid = mask ? y : y-4*GAP;
  zlid = mask ? z : z-2*GAP;
  zm = zlid-H_BULGE/2;
  xrot(reverse?180:0,cp=[0,0,z/2]) {
    // add bulge
    move([-x/2+w+H_BULGE/2+GAP,0,zm])
        ycyl(d=H_BULGE,h=Y_GRIP/4, anchor=BOTTOM+CENTER);
    difference() {
      // the lid ...
      zmove(zlid/2) zflip_copy()
         prismoid(size1=[x,ylid], size2=[x,ylid-2*zlid],
                  h=zlid/2, rounding=r,anchor=BOTTOM+CENTER);
      // ... minus the grip cutout
      if (!mask) {
        move([-x/2+x/5,0,-FUZZ])
          cuboid([X_GRIP,Y_GRIP,z+2*FUZZ], anchor=BOTTOM+CENTER);
      }
    }
  }
}

// --- suitable guides for the lid   -------------------------------------------

module guides(x,y,z=BT+2*FUZZ, add=0) {
  yflip_copy() {
    color("blue") zflip_copy(z=z/2)
      ymove(y/2-z/2) wedge([x,z,z/2], spin=180, anchor=BOTTOM+CENTER);
    if (add) {
      color("green") ymove(y/2+add/2-FUZZ) cuboid([x,add,z], anchor=BOTTOM+CENTER);
    }
  }
}


//zmove(GAP) lid(30,50, w=W4, r=[0,0,0,0], reverse=false, mask=false);
//xmove(-30) color("red") lid(30,50, w=W4, r=[0,0,0,0], reverse=false, mask=true);
//guides(30,50, add=W4);
