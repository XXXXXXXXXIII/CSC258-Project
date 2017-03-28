`inculde "Keyboard_scancoderaw_driver.v"

module keyboardcheck (CLOCK_50, HEX0, HEX1, PS2_DAT, PS2_CLK, reset);

input CLOCK_50;
input PS2_DAT;
input PS2_CLK;
input reset;

output [3:0]HEX0;
output [3:0]HEX1;

wire scan;

reg [7:0]scan_codes;


keyboard_scancoderaw_driver KSD(.CLOCK_50(), .scan_ready(scan), .scan_code(scan_codes), .PS2_DAT(PS2_DAT), .PS2_CLK(PS2_CLK),.reset(reset));

always @(*)
	begin
		if (scan == 1'b1)
		begin
			segDecoder Hex_0 (.val(scan_codes[3:0]), .Hex(HEX0));
			segDecoder Hex_1 (.val(scan_codes[7:4]), .Hex(HEX1));
		end
	end

endmodule

module segDecoder(Val, Hex);
	input [3:0] Val;
	output [6:0] Hex;
	
	// Use wire for simplicity
	wire a, b, c, d;
	assign a = Val[3];
	assign b = Val[2];
	assign c = Val[1];
	assign d = Val[0];
	
	assign Hex[0] = ~(~b&~d | ~a&c | b&c | a&~b&~c | ~a&b&d | a&~d);
	assign Hex[1] = ~(~a&~b | ~d&~b | a&~c&d | ~a&~c&~d | ~a&c&d);
	assign Hex[2] = ~(a&~b | ~a&b | ~c&d | ~a&~c | ~a&d);
	assign Hex[3] = ~(a&~c | ~a&~b&~d | ~b&c&d | b&~c&d | b&c&~d);
	assign Hex[4] = ~(~b&~d | a&b | c&~d | a&c);
	assign Hex[5] = ~(a&~b | ~c&~d | a&c | b&~d | ~a&b&~c);
	assign Hex[6] = ~(a&~b | c&~d | ~b&c | a&d | ~a&b&~c);

endmodule 


