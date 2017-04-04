module gui(CLOCK_50, in, state1, state2, state3, reset, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);
	input CLOCK_50, reset;				//	50 MHz
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
	
	wire [7:0]X;
	wire [6:0]Y;
	wire [2:0]C;
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(C),
			.x(X),
			.y(Y),
			.plot(1'b1),
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

	/*
	reg [25:0]letterin;
	wire [25:0]resetout;
	always @(posedge CLOCK_50)
	begin
		if (reset == 1'b0) begin
			letterin = resetout;
		end
		else begin
			letterin = in;
		end
	end */

	//wire resetclk;
	//resetgui r0(.clk(resetclk), .out(resetout));
	datapath d0 (.in(letterin), .state1(state1), .state2(state2), .state3(state3), .clk(CLOCK_50), .reset(reset), .clko(), .xo(X), .yo(Y), .coloro(C));
	
endmodule

module resetgui (clk, out);
	input clk;
	output reg [25:0] out;

	reg [5:0]counter;

	initial begin
		out <= 26'b1;
		counter <= 0;
	end

	always @(posedge clk)
	begin
		if (out == 26'h2000000)
			out <= 1'b1;
		else
			out <= out << 1'b1;
	end

endmodule

module datapath (in, state1, state2, state3, clk, reset, clko, xo, yo, coloro);
	input [25:0]in;
	input [4:0]state1, state2, state3;
	input clk, reset;
	output wire clko;
	output reg [7:0]xo;
	output reg [6:0]yo;
	output reg [2:0]coloro;
	
	wire [7:0]xw;
	wire [6:0]yw;
	wire [24:0]letter;
	wire [7:0]xl;
	wire [6:0]yl;
	wire [48:0]lamp;
	wire press = |(in);
	wire [25:0]wheel_letter;
	reg [4:0]draw_which; 
	reg [5:0]curr, next;
	reg [5:0]index;
	
	initial begin
		draw_which <= 0;
		index <= 0;
		curr <= 0;
		next <= 0;
	end
	
	//wire [25:0]in2;
	//resetgui r0(.clk(clko), .out(in2));
	lampboard LB(.in(26'b1 << draw_which), .x(xl), .y(yl), .lamp(lamp));
	wheel WL(.in(wheel_letter), .no(draw_which[1:0]), .x(xw), .y(yw), .letter(letter));
	
	assign wheel_letter = draw_which == 'd26 ? 25'b1 << state1 : draw_which == 'd27 ? 25'b1 << state2 : draw_which == 'd28 ? 25'b1 << state3 : 25'b0;
	assign clko = ~(|draw_which);
	
	always @(*)
	begin
		if (draw_which < 'd26) begin
			next <= curr + 1'b1;
			xo = xl + curr[2:0];
			yo = yl + curr[5:3];
			coloro <= lamp['d49 - index]==1'b0 ? 3'b000 : reset==1'b0 ? 3'b111 : press==1'b1 ? 3'b110 : 3'b111;
		end else begin
			next <= curr + 1'b1;
			xo = xw + curr[2:0];
			yo = yw + curr[5:3];
			coloro <= letter['d25 - index]==1'b0 ? 3'b000 : 3'b111;
		end
	end

	always @(posedge clk)
	begin
		if (draw_which == 5'd29) begin
			draw_which <= 'b0;
		end
		if (draw_which < 'd26) begin
			if (next == 6'b110111) begin
				curr <= 6'b000000;
				index <= 0;
				draw_which <= draw_which + 1'b1;
			end else if (next[2:0] == 3'b111) begin
				curr <= next + 1'b1;
				index <= index + 1'b1;
			end else begin
				curr <= next;
				index <= index + 1'b1;
			end
		end else begin
			if (next == 6'b100101) begin
				curr <= 6'b000000;
				index <= 0;
				draw_which <= draw_which + 1'b1;
			end else if (next[2:0] == 3'b101) begin
				curr <= next + 2'd3;
				index <= index + 1'b1;
			end else begin
				curr <= next;
				index = index + 1'b1;
			end
		end
	end
	
endmodule


module wheel(in, no, x, y, letter);
	input [25:0]in;
	input [1:0]no;
	output [7:0]x;
	output [6:0]y;
	output [24:0]letter;

	wheelPosLUT wpLUT(.in(no), .x(x), .y(y));
	letterLUT lLUT(.in(in), .letter(letter));
endmodule


module wheelPosLUT (in, x, y);
	input [1:0]in;
	output [7:0]x;
	output [6:0]y;

	assign x = in == 2'b00 ? 8'd56 : in == 2'b11 ? 8'd77 : in == 2'b10 ? 8'd99 : 8'd0;
	assign y = 7'd82;
endmodule

module lampboard(in, x, y, lamp);
	input [25:0]in;
	output [7:0]x;
	output [6:0]y;
	output [48:0]lamp;

	wire [24:0]letterWire;
	wire [7:0]xo;
	wire [6:0]yo;
	
	assign lamp = {8'b01111101,~letterWire[24:20],2'b11,~letterWire[19:15],2'b11,~letterWire[14:10],2'b11,~letterWire[9:5],2'b11,~letterWire[4:0],8'b10111111};

	letterLUT lLUT(.in(in[25:0]), .letter(letterWire[24:0]));
	lampPosLUT lpLUT(.in(in[25:0]), .x(xo[7:0]), .y(yo[6:0]));
	assign x = xo;
	assign y = yo;
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

	always @(*)
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
		endcase
	end
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

	always @(*)
	begin: letter_LUT
		case(in)
			A: letter <= 25'b00100_01010_01110_01010_01010;
			B: letter <= 25'b01100_01010_01100_01010_01100;
			C: letter <= 25'b01110_01000_01000_01000_01110;
			D: letter <= 25'b01100_01010_01010_01010_01100;
			E: letter <= 25'b01110_01000_01110_01000_01110;
			F: letter <= 25'b01110_01000_01110_01000_01000;
			G: letter <= 25'b01110_01000_01010_01010_01110;
			H: letter <= 25'b01010_01010_01110_01010_01010;
			I: letter <= 25'b01110_00100_00100_00100_01110;
			J: letter <= 25'b01110_00100_00100_00100_01100;
			K: letter <= 25'b10010_10100_11000_10100_10010;
			L: letter <= 25'b01000_01000_01000_01000_01110;
			M: letter <= 25'b10001_11011_10101_10001_10001;
			N: letter <= 25'b10001_11001_10101_10011_10001;
			O: letter <= 25'b01110_01010_01010_01010_01110;
			P: letter <= 25'b01110_01010_01110_01000_01000;
			Q: letter <= 25'b01110_01010_01010_01010_01111;
			R: letter <= 25'b01100_01010_01100_01010_01010;
			S: letter <= 25'b01110_01000_01110_00010_01110;
			T: letter <= 25'b01110_00100_00100_00100_00100;
			U: letter <= 25'b01010_01010_01010_01010_01110;
			V: letter <= 25'b01010_01010_01010_01010_00100;
			W: letter <= 25'b10001_10001_10101_10101_01010;
			X: letter <= 25'b01010_01010_00100_01010_01010;
			Y: letter <= 25'b01010_01010_00100_00100_00100;
			Z: letter <= 25'b01110_00010_00100_01000_01110;
		endcase
	end

endmodule


module fps60(clki, clko);
	input clki;
	output reg clko;
	
	reg [19:0] frame;
	
	always @(posedge clki)
	begin
		if (frame == 0) begin
			frame <= 20'b11001011011100110101;
			clko = clki;
		end
		else
			frame <= frame - 1'b1;
			clko = 0;
	end
endmodule 