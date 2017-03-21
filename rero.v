`include "rotor.v"
`include "reflector.v"

module rero (in, out, wheel_config)
	input [25:0]in;
	output [25:0] out;
	input [2:0]wheel_config;
endmodule 