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
H_BULGE = 1.8;

module lid(x, y, z=BT+2*FUZZ, w, r, chamfer=0, bulge="BOTTOM",
           hull=false, reverse=false) {
  c = chamfer?chamfer:z;
  xrot(reverse?180:0,cp=[0,0,z/2]) {
    zm = bulge == "BOTTOM" ? -H_BULGE/2 : z-H_BULGE/2;
    move([-x/2+w+H_BULGE/2+GAP,0,zm])
        ycyl(d=H_BULGE,h=Y_GRIP/4, anchor=BOTTOM+CENTER);
    difference() {
      prismoid(size1=[x,y], size2=[x,y-2*c], h=z,
             rounding=r,
             anchor=BOTTOM+CENTER);
      if (!hull) {
        move([-x/2+x/5,0,-FUZZ])
          cuboid([X_GRIP,Y_GRIP,z+2*FUZZ], anchor=BOTTOM+CENTER);
      }
    }
  }
}

//lid(30,50, w=W4, r=[0,3,3,0], reverse=true, hull=false);
