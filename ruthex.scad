// ---------------------------------------------------------------------------
// 3D-Model (OpenSCAD): generic component for Ruthex threads.
//
// Author: Bernhard Bablok
// License: GPL3
//
// https://github.com/bablokb/pcb-pico-datalogger
// ---------------------------------------------------------------------------

include <BOSL2/std.scad>
include <dimensions.scad>
include <fase.scad>

RUTHEX_DI_25  = 4;
RUTHEX_DO_25  = 7.2;
RUTHEX_H_25   = 5.7;
RUTHEX_ADD_25 = 1;


// --- ruthex thread pocket   ------------------------------------------------

module ruthex(di, do, h, add=1, circular=true, fase=true) {
  difference() {
    if (circular) {
      cyl(h=h+add, d=do, anchor=TOP+CENTER);
    } else {
      cuboid([do,do,h+add], anchor=TOP+CENTER);
    }
    zmove(add+FUZZ) cyl(h=h, d=di, anchor=TOP+CENTER);
  }
  if (fase && circular) {
    zmove(-h-add) cfase(d=do,h=do,orient="fl");
  } else if (fase && !circular) {
    move([-do/2,0,-h-add]) fase(x=do,y=do,h=do,orient="yl");
  }

}

// --- standard module for M2.5 threads   ------------------------------------

module ruthex25(do_extra=0, h_extra=0, add_extra=0,
                circular=true, fase=true) {
  ruthex(di=RUTHEX_DI_25,
         do=do_extra+RUTHEX_DO_25,
         h=h_extra+RUTHEX_H_25,
         add=add_extra+RUTHEX_ADD_25,circular=circular,fase=fase);
}

//xdistribute(20) {
//  ruthex25();
//  ruthex25(circular=false);
//  ruthex25(do_extra=10, fase=false);
//  ruthex25(circular=false, fase=false);
//}
