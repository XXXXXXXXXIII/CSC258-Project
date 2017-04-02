`include "rotor.v"
`include "reflector.v"

module rero (in, out, wheel_config, state1, state2, state3);
	input [25:0]in; // 26 bits, each representing signal at one position. Do not input with z or x
	output [25:0]out;
	output wire [4:0]state1, state2, state3;
	input [2:0]wheel_config; // 000: I II III, 001: I III II, 010: II I III, 011: II III I, 100: III I II, 101: III II I

	wire turn1, turn2, turn3;
	wire [25:0]w1, w2, w3, w4, w5, w6;
	reg [5:0]wiring;

	always @(*)
	begin
		case(wheel_config)
		3'b000: wiring <= 6'b000110;
		3'b001: wiring <= 6'b001001;
		3'b010: wiring <= 6'b010010;
		3'b011: wiring <= 6'b011000;
		3'b100: wiring <= 6'b100001;
		3'b101: wiring <= 6'b100100;
		default: wiring <= 6'b000110;
		endcase
 	end
	
	assign turn1 = |(in[25:0]);

	rotor r1(.in(in), .out(w1), .rotate(turn1), .notch(turn2), .wiring_config(3'b000 | wiring[1:0]), .state(state1));
	rotor r2(.in(w1), .out(w2), .rotate(turn2), .notch(turn3), .wiring_config(3'b000 | wiring[3:2]), .state(state2));
	rotor r3(.in(w2), .out(w3), .rotate(turn3), .notch(), .wiring_config(3'b000 | wiring[5:4]), .state(state3));
	reflector ref(.in(w3), .out(w4));
	rotor r3r(.in(w4), .out(w5), .rotate(turn3), .notch(), .wiring_config(3'b100 | wiring[5:4]), .state());
	rotor r2r(.in(w5), .out(w6), .rotate(turn2), .notch(), .wiring_config(3'b100 | wiring[3:2])), .state();
	rotor r1r(.in(w6), .out(out), .rotate(turn1), .notch(), .wiring_config(3'b100 | wiring[1:0]), .state());
	
endmodule 