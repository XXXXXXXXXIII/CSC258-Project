<<<<<<< HEAD
module GUI

task paintLamp;
input [24:0]letter; // letter from letterLUT
output [48:0]lamp; // lamp with each pixel draw
begin
	assign lamp = {8'b01111101,~letter[24:20],2'b11,~letter[19:15],2'b11,~letter[14:10],2'b11,~letter[9:5],2'b11,~letter[4:0],8'b10111110};
end
endtask

=======
module gui(CLOCK_50, in, state1, state2, state3, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);
	input CLOCK_50;				//	50 MHz
	input [25:0]in;
	input [4:0]state1, state2, state3;
	output	VGA_CLK;   				//	VGA Clock
	output	VGA_HS;					//	VGA H_SYNC
	output	VGA_VS;					//	VGA V_SYNC
	output	VGA_BLANK_N;				//	VGA BLANK
	output	VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [7:0] cx;
	wire [7:0] cy;
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(X),
			.y(Y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	wire writeEn;
	reg [2:0] colour;
	reg [5:0]curr, next, index;
	reg draw_which; // 0 for lampboard, 1 for wheel
	wire [48:0]lamp;
	wire [25:0]wheelletter;
	wire [7:0]X, xl, xw;
	wire [6:0]Y, yl, yw;

	initial begin
		curr <= 6'b000001;
		next <= 0;
		draw_which <= 0;
		index <= 0;
	end

	assign writeEn = 1'b1;

	lampboard LB(.in(in[25:0]), .x(xl[7:0]), .y(yl[6:0]), .lamp(lamp[48:0]));
	wheel W1(.in(in), .x(xw), .y(yw), .letter(wheelletter));

	always @(*)
	begin
		if (draw_which == 1'b0) begin
			next <= curr + 1'b1;
			X = xl + curr[2:0];
			Y = yl + curr[5:3];
			if (lamp[index] == 1'b0) begin
				colour <= 3'b000;
			end else begin
				case (|(in))
					1'b1: colour <= 3'b110;
					default: colour <= 3'b111;
				endcase
			end
		end	else begin
			next <= curr + 1'b1;
			X = xw + curr[2:0];
			Y = yw + curr[5:3];
			if (wheelletter[index] == 1'b1) begin
				colour <= 3'b111;
			end else begin
				colour <= 3'b000;
			end
		end
	end

	always @(posedge CLOCK_50)
	begin
		if (draw_which == 1'b0) begin
			if (next[2:0] == 3'b111) begin
				next[2:0] += 1'b1;
			end
			if (next == 6'b111000) begin
				curr <= 6'b000000;
				index <= 0;
				draw_which <= 1'b1;
			end else begin
				curr <= next;
				index += 1'b1;
			end
		end else begin
			if (next[2:0] == 3'b101) begin
				next[2:0] += 1'b1;
			end
			if (next == 6'b101000) begin
				curr <= 6'b000000;
				index <= 0;
				draw_which <= 1'b0;
			end else begin
				curr <= next;
				index += 1'b1;
			end
		end
	end
endmodule

module wheel(in, x, y, letter);
	input [25:0]in;
	output [7:0]x;
	output [6:0]y;
	output [24:0]letter;

	wheelPosLUT wpLUT(.in(in), .x(x), .y(y));
	letterLUT lLUT(.in(in), .letter(letter));
endmodule

module wheelPosLUT (in, x, y);
	input [1:0]in;
	output [7:0]x;
	output [6:0]y;

	assign x = in == 2'b00 ? 8'd56 : in == 2'b01 ? 8'd77 : in == 2'b10 ? 8'd99 : 8'd160;
	assign y = 7'd82;
endmodule

module lampboard(in, x, y, lamp);
	input [25:0]in;
	output [7:0]x;
	output [6:0]y;
	output [48:0]lamp;

	wire [24:0]letter;
	wire [7:0]xo;
	wire [6:0]yo;

	letterLUT lLUT(.in(in[25:0]), .letter(letter[24:0]));
	lampPosLUT lpLUT(.in(in[25:0]), .x(xo[7:0]), .y(yo[6:0]));
	paintlamp(letter[24:0], lamp[48:0]);
	assign x = xo;
	assign y = yo;

	task paintLamp;
	input [24:0]letter; // letter from letterLUT
	output [48:0]lamp; // lamp with each pixel draw
	begin
		assign lamp = {8'b01111101,~letter[24:20],2'b11,~letter[19:15],2'b11,~letter[14:10],2'b11,~letter[9:5],2'b11,~letter[4:0],8'b10111110};
	end
	endtask
endmodule

module lampPosLUT (in, x, y);
	input [25:0] in;
	output reg[7:0] x;
	output reg[6:0] y;

	localparam A = 26'h1, B = 26'h2, C = 26'h4, D = 26'h8, E = 26'h10, F = 26'h20, G = 26'h40, H = 26'h80, I = 26'h100, J = 26'h200, K = 26'h400, L = 26'h800, 
				M = 26'h1000, N = 26'h2000, O = 26'h4000, P = 26'h8000, Q = 26'h10000, R = 26'h20000, S = 26'h40000, T = 26'h80000, U = 26'h100000, V = 26'h200000, 
				W = 26'h400000, X = 26'h800000, Y = 26'h1000000, Z = 26'h2000000;

	initial begin
		x <= 0;
		y <= 0;
	end

	alwyas @(*)
	begin: pos_LUT
		case(in)
			A: begin
				x <= 8'd28;
				y <= 7'd35;
			end
			B: begin
				x <= 8'd88;
				y <= 7'd47;
			end
			C: begin
				x <= 8'd64;
				y <= 7'd47;
			end
			D: begin
				x <= 8'd52;
				y <= 7'd35;
			end
			E: begin
				x <= 8'd46;
				y <= 7'd23;
			end
			F: begin
				x <= 8'd64;
				y <= 7'd35;
			end
			G: begin
				x <= 8'd76;
				y <= 7'd35;
			end
			H: begin
				x <= 8'd88;
				y <= 7'd35;
			end
			I: begin
				x <= 8'd106;
				y <= 7'd23;
			end
			J: begin
				x <= 8'd100;
				y <= 7'd35;
			end
			K: begin
				x <= 8'd112;
				y <= 7'd35;
			end
			L: begin
				x <= 8'd124;
				y <= 7'd35;
			end
			M: begin
				x <= 8'd112;
				y <= 7'd47;
			end
			N: begin
				x <= 8'd100;
				y <= 7'd47;
			end
			O: begin
				x <= 8'd118;
				y <= 7'd23;
			end
			P: begin
				x <= 8'd130;
				y <= 7'd23;
			end
			Q: begin
				x <= 8'd22;
				y <= 7'd23;
			end
			R: begin
				x <= 8'd58;
				y <= 7'd23;
			end
			S: begin
				x <= 8'd40;
				y <= 7'd35;
			end
			T: begin
				x <= 8'd70;
				y <= 7'd23;
			end
			U: begin
				x <= 8'd94;
				y <= 7'd23;
			end
			V: begin
				x <= 8'd76;
				y <= 7'd47;
			end
			W: begin
				x <= 8'd34;
				y <= 7'd23;
			end
			X: begin
				x <= 8'd52;
				y <= 7'd47;
			end
			Y: begin
				x <= 8'd82;
				y <= 7'd23;
			end
			Z: begin
				x <= 8'd40;
				y <= 7'd47;
			end
			default: begin
				x <= 8'd160;
				y <= 7'd120;
			end			
		endcase
	end
>>>>>>> 343f710201fe42c3125b0467580f21c46f3ee00e
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