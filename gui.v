module GUI

task paintLamp;
input [24:0]letter; // letter from letterLUT
output [48:0]lamp; // lamp with each pixel draw
begin
	assign lamp = {8'b01111101,~letter[24:20],2'b11,~letter[19:15],2'b11,~letter[14:10],2'b11,~letter[9:5],2'b11,~letter[4:0],8'b10111110};
end
endtask

endmodule

module letterLUT (in, letter);
	input [25:0]in;
	output reg[24:0]letter; // Outputs a 5x5 matrix of binary numbers, where 1 is draw and 0 is empty. 

	localparam A = 26'h1, B = 26'h2, C = 26'h4, D = 26'h8, E = 26'h10, F = 26'h20, G = 26'h40, H = 26'h80, I = 26'h100, J = 26'h200, K = 26'h400, L = 26'h800, 
				M = 26'h1000, N = 26'h2000, O = 26'h4000, P = 26'h8000, Q = 26'h10000, R = 26'h20000, S = 26'h40000, T = 26'h80000, U = 26'h100000, V = 26'h200000, 
				W = 26'h400000, X = 26'h800000, Y = 26'h1000000, Z = 26'h2000000;

	initial begin
		letter <= 25'b0;
	end

	alwyas @(*)
	begin: letter_LUT
		case(in)
			A: letter <= 25'b00100 01010 01110 01010 01010;
			B: letter <= 25'b01100 01010 01100 01010 01100;
			C: letter <= 25'b01110 01000 01000 01000 01110;
			D: letter <= 25'b01100 01010 01010 01010 01100;
			E: letter <= 25'b01110 01000 01110 01000 01110;
			F: letter <= 25'b01110 01000 01110 01000 01000;
			G: letter <= 25'b01110 01000 01010 01010 01110;
			H: letter <= 25'b01010 01010 01110 01010 01010;
			I: letter <= 25'b01110 00100 00100 00100 01110;
			J: letter <= 25'b01110 00100 00100 00100 01100;
			K: letter <= 25'b10010 10100 11000 10100 10010;
			L: letter <= 25'b01000 01000 01000 01000 01110;
			M: letter <= 25'b10001 11011 10101 10001 10001;
			N: letter <= 25'b10001 11001 10101 10011 10001;
			O: letter <= 25'b01110 01010 01010 01010 01110;
			P: letter <= 25'b01110 01010 01110 01000 01000;
			Q: letter <= 25'b01110 01010 01010 01010 01111;
			R: letter <= 25'b01100 01010 01100 01010 01010;
			S: letter <= 25'b01110 01000 01110 00010 01110;
			T: letter <= 25'b01110 00100 00100 00100 00100;
			U: letter <= 25'b01010 01010 01010 01010 01110;
			V: letter <= 25'b01010 01010 01010 01010 00100;
			W: letter <= 25'b10001 10001 10101 10101 01010;
			X: letter <= 25'b01010 01010 00100 01010 01010;
			Y: letter <= 25'b01010 01010 00100 00100 00100;
			Z: letter <= 25'b01110 00010 00100 01000 01110;
			default: letter <= 0;
		endcase
	end

endmodule