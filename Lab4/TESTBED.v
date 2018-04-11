//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright 
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2015 DLAB Course
//   Lab02      :   Matrix
//   Author     :   Hsiao-Kai, Liao
//   File name  :   TESTBED.v
//###########################################################################

`timescale 1ns/10ps
`include "PATTERN.v"

`ifdef RTL
	`include "Circle.vp"
`endif
`ifdef RTL2
	`include "Circle2.vp"
`endif
`ifdef RTL3
	`include "Circle3.vp"
`endif
`ifdef RTL4
	`include "Circle4.vp"
`endif
`ifdef RTL5
	`include "Circle5.vp"
`endif
`ifdef RTL6
	`include "Circle6.vp"
`endif
`ifdef RTL7
	`include "Circle7.vp"
`endif
`ifdef RTL8
	`include "Circle8.vp"
`endif


module TESTBED();

wire             clk;
wire    [2:0]    circle1;
wire    [2:0]    circle2;
wire             rst_n;
wire             in_valid;
wire 	[4:0]    in;
wire             out_valid;
wire    [5:0]    out;



PATTERN I_PATTERN(
        .clk(clk),
        .circle1(circle1),
        .circle2(circle2),
        .in(in),
        .in_valid(in_valid),
        .rst_n(rst_n),
        .out(out),
        .out_valid(out_valid)
);

Circle I_Circle(
        .clk(clk),
        .circle1(circle1),
        .circle2(circle2),
        .rst_n(rst_n),
        .in_valid(in_valid),
        .in(in),
        .out_valid(out_valid),
        .out(out)
);

initial begin
`ifdef RTL
	$fsdbDumpfile("Circle.fsdb");
	$fsdbDumpvars;
`endif


`ifdef RTL1
        $fsdbDumpfile("Circle1.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL2
        $fsdbDumpfile("Circle2.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL3
        $fsdbDumpfile("Circle3.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL4
        $fsdbDumpfile("Circle4.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL5
        $fsdbDumpfile("Circle5.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL6
        $fsdbDumpfile("Circle6.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL7
        $fsdbDumpfile("Circle7.fsdb");
        $fsdbDumpvars;
`endif

`ifdef RTL8
        $fsdbDumpfile("Circle8.fsdb");
        $fsdbDumpvars;
`endif
//---------------------------------
//   module connection
//---------------------------------  				  					  

end
endmodule
