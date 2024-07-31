/* MIT License

Copyright (c) 2024 Hugh Kern <hkern0@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

/* Door latch actuator
On this old door latch mechanism, the doorknobs are connected to a square-
profile axle that engages with an actuator whose arms push the latch.

On two of these latch mechanisms, the cast steel actuator's arms have broken
off -- probably because of stress concentration at the sharp angle where the
arms meet the body.

This actuator replaces the cast steel actuators. The relative weakness of the
plastic is compensated by the larger bulk of the part. The plastic is also
more quiet and smooth-acting.
 */

include <BOSL2/std.scad>
include <BOSL2/shapes3d.scad>

include <Round-Anything/polyround.scad>

$fn=90;

axle_h = 20;
axle_od = 15.1;

center_od = 18;
center_h = 10;
center_half = center_h / 2;

act_h = 8;
act_half = act_h/2;
act_od = 40;

bearing_id = center_od + 1;
bearing_od1 = bearing_id + 3;
bearing_od2 = bearing_id + 1;
bearing_lip = 0.5;
bearing_h = act_h + bearing_lip;

module main_axle() {
  // main axle
  cyl( h=axle_h, d=axle_od, center=true );
  cyl( h=center_h, d=center_od, center=true );
}

module bearing_surface() {
  // lower bearing surface
  translate( [0, 0, -(center_half + bearing_lip)] ) //act_half])
    tube( h=bearing_h, od1=bearing_od1, od2=bearing_od2, id=bearing_id, anchor=BOTTOM );
  translate( [0, 0, -center_half] )
    tube( h=act_h, od=bearing_id, id=center_od, anchor=BOTTOM );
}

module actuator() {
  off = bearing_id/2;
  points = [
    [ 1, off + 0, 0],
    [ 5, off + 1, 2],
    [ 2, off + 8,25],
    [ 5, off + 20, 3],
    [20, off - 4,20],
    ];
  translate([0,0,-(center_half+bearing_lip)])
  rotate([0,0,90])
  difference() {
    linear_extrude(bearing_h)
      polygon( polyRound( mirrorPoints(points, 0, [0,0]), 30 ) );
    union() {
      main_axle();
      bearing_surface();
    }
  }
}
 
module body() { 
  main_axle();
  bearing_surface();
  actuator();
}

module center_hole() {
  slop=0.5;
  side=8-slop;
  cuboid( [side, side, axle_h *1.5], rounding=1 ); //, edges=[RIGHT+FRONT, LEFT+FRONT, RIGHT+BACK, LEFT+BACK] );
//  cylinder( h=axle_h, d=side, $fn=4 );
}


difference() {
  body();
  center_hole();
}

