// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): generic fase-component.
//
// The fases are TOP-anchored, so they can easily be moved to the target
// height, e.g. with zmove(h).
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>

// --- rectangular fase   ----------------------------------------------------

module fase(x,y,h,r=[0,0],orient="yl") {
  if (orient == "yl") {           // y-dimension, left side
    // r is [front,back]
    r2 = [0,r[1],r[0],0];
    prismoid(size1=[0,y],
             size2=[x,y],
             rounding2=r2,
             shift=[x/2,0], h=h, anchor=TOP+LEFT);
  } else if (orient == "yr") {   // y-dimension, right side
    // r is [front,back]
    r2 = [r[1],0,0,r[0]];
    prismoid(size1=[0,y],
             size2=[x,y],
             rounding2=r2,
             shift=[-x/2,0], h=h, anchor=TOP+RIGHT);
  } else if (orient == "xf") {   // x-dimension, front
    // r is [left,right]
    r2 = [0,0,r[0],r[1]];
    prismoid(size1=[x,0],
             size2=[x,y],
             rounding2=r2,
             shift=[0,y/2], h=h, anchor=TOP+FRONT);
  } else if (orient == "xb") {   // x-dimension, back
    // r is [left,right]
    r2 = [r[1],r[0],0,0];
    prismoid(size1=[x,0],
             size2=[x,y],
             rounding2=r2,
             shift=[0,-y/2], h=h, anchor=TOP+BACK);
  }
}

// --- round fase   -----------------------------------------------------------

module cfase(d,h,orient="fl") {
  // orient: corners of a rectangle (front-left, front-right, ...)
  angle = orient=="fl" ? 45 :
            orient=="fr" ? 135 :
              orient=="bl" ? -45 :
                orient=="br" ? -135 :
                  orient=="l" ? 0 :
                    orient=="r" ? 180 :
                      orient=="b" ? -90 :
                        orient=="f" ? 90 : 0;
  zrot(angle) xmove(-d/2) cyl(d1=FUZZ, d2=d, h=h, shift=[d/2,0], anchor=TOP+LEFT);
}

//cfase(10,10, orient="b");

// fase for left side
//xmove(-30) fase(5,40,8,r=[3,3], orient="yl");

// fase for right side
//xmove(+30) fase(5,40,8,r=[3,3],orient="yr");

// fase for front side
//ymove(-30) fase(40,5,8,r=[3,3],orient="xf");

// fase for back side
//ymove(+30) fase(40,5,8,r=[0,3],orient="xb");
