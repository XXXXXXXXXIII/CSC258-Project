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
	datapath d0 (.in(in), .state1(state1), .state2(state2), .state3(state3), .clk(CLOCK_50), .reset(reset), .clko(), .xo(X), .yo(Y), .coloro(C));
	
endmodule

/*
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

endmodule */

module datapath (in, state1, state2, state3, clk, reset, clko, xo, yo, coloro);
	input [25:0]in;
	input [4:0]state1, state2, state3;
	input clk, reset;
	output wire clko;
	output reg [7:0]xo;
	output reg [6:0]yo;
	output reg [2:0]coloro;
	
	wire [7:0]xw, xl;
	wire [6:0]yw, yl;
	wire [24:0]letter;
	reg [7:0]xp;
	reg [6:0]yp;
	wire [48:0]lamp;
	wire [25:0]wheel_letter;
	reg [4:0]draw_which; 
	wire press = (in == (26'b1 << draw_which));
	reg [5:0]curr, next;
	reg [5:0]index;
	reg [8:0]paint_point;
	localparam y_offset = 'd10;
	
	initial begin
		draw_which <= 0;
		index <= 0;
		curr <= 0;
		next <= 0;
		paint_point <= 0;
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
			yo = yl + curr[5:3] + y_offset;
			coloro <= lamp['d48 - index]==1'b0 ? 3'b000 : reset==1'b0 ? 3'b111 : press==1'b1 ? 3'b110 : 3'b111;
		end else if (draw_which == 'd29) begin
			next <= curr + 1'b1;
			xo = xp;
			yo = yp;
			coloro <= 3'b111;
		end else begin
			next <= curr + 1'b1;
			xo = xw + curr[2:0];
			yo = yw + curr[5:3] + y_offset;
			coloro <= letter['d24 - index]==1'b0 ? 3'b000 : 3'b111;
		end
	end

	always @(posedge clk)
	begin
		if (draw_which == 5'd30) begin
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
		end else if (draw_which == 'd29) begin
			if (paint_point == 'd322) begin
				draw_which = draw_which + 1'b1;
				curr <= 0;
				paint_point <= 0;
			end else begin
				case (paint_point)
					9'd0: begin
						xp <= 'd46;
						yp <= 'd12;
					end
					'd1: begin
						xp <= 'd47;
						yp <= 'd12;
					end
					'd2: begin
						xp <= 'd48;
						yp <= 'd12;
					end
					'd3: begin
						xp <= 'd49;
						yp <= 'd12;
					end
					'd4: begin
						xp <= 'd50;
						yp <= 'd12;
					end
					'd5: begin
						xp <= 'd51;
						yp <= 'd12;
					end
					'd6: begin
						xp <= 'd52;
						yp <= 'd12;
					end
					'd7: begin
						xp <= 'd46;
						yp <= 'd13;
					end
					'd8: begin
						xp <= 'd46;
						yp <= 'd14;
					end
					'd9: begin
						xp <= 'd46;
						yp <= 'd15;
					end
					'd10: begin
						xp <= 'd46;
						yp <= 'd16;
					end
					'd11: begin
						xp <= 'd46;
						yp <= 'd17;
					end
					'd12: begin
						xp <= 'd46;
						yp <= 'd18;
					end
					'd13: begin
						xp <= 'd46;
						yp <= 'd19;
					end
					'd14: begin
						xp <= 'd46;
						yp <= 'd20;
					end
					'd15: begin
						xp <= 'd46;
						yp <= 'd21;
					end
					'd16: begin
						xp <= 'd46;
						yp <= 'd22;
					end
					'd17: begin
						xp <= 'd46;
						yp <= 'd23;
					end
					'd18: begin
						xp <= 'd46;
						yp <= 'd24;
					end
					'd19: begin
						xp <= 'd47;
						yp <= 'd18;
					end
					'd20: begin
						xp <= 'd48;
						yp <= 'd18;
					end
					'd21: begin
						xp <= 'd49;
						yp <= 'd18;
					end
					'd22: begin
						xp <= 'd50;
						yp <= 'd18;
					end
					'd23: begin
						xp <= 'd51;
						yp <= 'd18;
					end
					'd24: begin
						xp <= 'd52;
						yp <= 'd18;
					end
					'd25: begin
						xp <= 'd47;
						yp <= 'd24;
					end
					'd26: begin
						xp <= 'd48;
						yp <= 'd24;
					end
					'd27: begin
						xp <= 'd49;
						yp <= 'd24;
					end
					'd28: begin
						xp <= 'd50;
						yp <= 'd24;
					end
					'd29: begin
						xp <= 'd51;
						yp <= 'd24;
					end
					'd30: begin
						xp <= 'd52;
						yp <= 'd24;
					end
					'd31: begin
						xp <= 'd57;
						yp <= 'd12;
					end
					'd32: begin
						xp <= 'd57;
						yp <= 'd13;
					end
					'd33: begin
						xp <= 'd57;
						yp <= 'd14;
					end
					'd34: begin
						xp <= 'd57;
						yp <= 'd15;
					end
					'd35: begin
						xp <= 'd57;
						yp <= 'd16;
					end
					'd36: begin
						xp <= 'd57;
						yp <= 'd17;
					end
					'd37: begin
						xp <= 'd57;
						yp <= 'd18;
					end
					'd38: begin
						xp <= 'd57;
						yp <= 'd19;
					end
					'd39: begin
						xp <= 'd57;
						yp <= 'd20;
					end
					'd40: begin
						xp <= 'd57;
						yp <= 'd21;
					end
					'd41: begin
						xp <= 'd57;
						yp <= 'd22;
					end
					'd42: begin
						xp <= 'd57;
						yp <= 'd23;
					end
					'd43: begin
						xp <= 'd57;
						yp <= 'd24;
					end
					'd44: begin
						xp <= 'd58;
						yp <= 'd12;
					end
					'd45: begin
						xp <= 'd58;
						yp <= 'd13;
					end
					'd46: begin
						xp <= 'd59;
						yp <= 'd14;
					end
					'd47: begin
						xp <= 'd59;
						yp <= 'd15;
					end
					'd48: begin
						xp <= 'd60;
						yp <= 'd16;
					end
					'd49: begin
						xp <= 'd60;
						yp <= 'd17;
					end
					'd50: begin
						xp <= 'd60;
						yp <= 'd18;
					end
					'd51: begin
						xp <= 'd61;
						yp <= 'd18;
					end
					'd52: begin
						xp <= 'd61;
						yp <= 'd19;
					end
					'd53: begin
						xp <= 'd61;
						yp <= 'd20;
					end
					'd54: begin
						xp <= 'd62;
						yp <= 'd21;
					end
					'd55: begin
						xp <= 'd62;
						yp <= 'd22;
					end
					'd56: begin
						xp <= 'd63;
						yp <= 'd23;
					end
					'd57: begin
						xp <= 'd63;
						yp <= 'd24;
					end
					'd58: begin
						xp <= 'd64;
						yp <= 'd24;
					end
					'd59: begin
						xp <= 'd64;
						yp <= 'd23;
					end
					'd60: begin
						xp <= 'd64;
						yp <= 'd22;
					end
					'd61: begin
						xp <= 'd64;
						yp <= 'd21;
					end
					'd62: begin
						xp <= 'd64;
						yp <= 'd20;
					end
					'd63: begin
						xp <= 'd64;
						yp <= 'd19;
					end
					'd63: begin
						xp <= 'd64;
						yp <= 'd18;
					end
					'd64: begin
						xp <= 'd64;
						yp <= 'd17;
					end
					'd65: begin
						xp <= 'd64;
						yp <= 'd16;
					end
					'd66: begin
						xp <= 'd64;
						yp <= 'd15;
					end
					'd67: begin
						xp <= 'd64;
						yp <= 'd14;
					end
					'd68: begin
						xp <= 'd64;
						yp <= 'd13;
					end
					'd69: begin
						xp <= 'd64;
						yp <= 'd12;
					end
					'd70: begin
						xp <= 'd69;
						yp <= 'd12;
					end
					'd71: begin
						xp <= 'd70;
						yp <= 'd12;
					end
					'd72: begin
						xp <= 'd71;
						yp <= 'd12;
					end
					'd73: begin
						xp <= 'd72;
						yp <= 'd12;
					end
					'd74: begin
						xp <= 'd73;
						yp <= 'd12;
					end
					'd75: begin
						xp <= 'd74;
						yp <= 'd12;
					end
					'd76: begin
						xp <= 'd75;
						yp <= 'd12;
					end
					'd77: begin
						xp <= 'd69;
						yp <= 'd24;
					end
					'd78: begin
						xp <= 'd70;
						yp <= 'd24;
					end
					'd79: begin
						xp <= 'd71;
						yp <= 'd24;
					end
					'd80: begin
						xp <= 'd72;
						yp <= 'd24;
					end
					'd81: begin
						xp <= 'd73;
						yp <= 'd24;
					end
					'd82: begin
						xp <= 'd74;
						yp <= 'd24;
					end
					'd83: begin
						xp <= 'd75;
						yp <= 'd24;
					end
					'd84: begin
						xp <= 'd72;
						yp <= 'd13;
					end
					'd85: begin
						xp <= 'd72;
						yp <= 'd14;
					end
					'd86: begin
						xp <= 'd72;
						yp <= 'd15;
					end
					'd87: begin
						xp <= 'd72;
						yp <= 'd16;
					end
					'd88: begin
						xp <= 'd72;
						yp <= 'd17;
					end
					'd89: begin
						xp <= 'd72;
						yp <= 'd18;
					end
					'd90: begin
						xp <= 'd72;
						yp <= 'd19;
					end
					'd91: begin
						xp <= 'd72;
						yp <= 'd20;
					end
					'd92: begin
						xp <= 'd72;
						yp <= 'd21;
					end
					'd93: begin
						xp <= 'd72;
						yp <= 'd22;
					end
					'd94: begin
						xp <= 'd72;
						yp <= 'd23;
					end
					'd95: begin
						xp <= 'd80;
						yp <= 'd24;
					end
					'd96: begin
						xp <= 'd80;
						yp <= 'd23;
					end
					'd97: begin
						xp <= 'd80;
						yp <= 'd22;
					end
					'd98: begin
						xp <= 'd80;
						yp <= 'd21;
					end
					'd99: begin
						xp <= 'd80;
						yp <= 'd20;
					end
					'd100: begin
						xp <= 'd80;
						yp <= 'd19;
					end
					'd101: begin
						xp <= 'd80;
						yp <= 'd18;
					end
					'd102: begin
						xp <= 'd80;
						yp <= 'd17;
					end
					'd103: begin
						xp <= 'd80;
						yp <= 'd16;
					end
					'd104: begin
						xp <= 'd80;
						yp <= 'd15;
					end
					'd105: begin
						xp <= 'd80;
						yp <= 'd14;
					end
					'd106: begin
						xp <= 'd80;
						yp <= 'd13;
					end
					'd107: begin
						xp <= 'd80;
						yp <= 'd12;
					end
					'd108: begin
						xp <= 'd81;
						yp <= 'd12;
					end
					'd109: begin
						xp <= 'd82;
						yp <= 'd12;
					end
					'd110: begin
						xp <= 'd83;
						yp <= 'd12;
					end
					'd111: begin
						xp <= 'd84;
						yp <= 'd12;
					end
					'd112: begin
						xp <= 'd85;
						yp <= 'd12;
					end
					'd113: begin
						xp <= 'd86;
						yp <= 'd12;
					end
					'd114: begin
						xp <= 'd87;
						yp <= 'd12;
					end
					'd115: begin
						xp <= 'd81;
						yp <= 'd24;
					end
					'd116: begin
						xp <= 'd82;
						yp <= 'd24;
					end
					'd117: begin
						xp <= 'd83;
						yp <= 'd24;
					end
					'd118: begin
						xp <= 'd84;
						yp <= 'd24;
					end
					'd119: begin
						xp <= 'd85;
						yp <= 'd24;
					end
					'd120: begin
						xp <= 'd86;
						yp <= 'd24;
					end
					'd121: begin
						xp <= 'd87;
						yp <= 'd24;
					end
					'd122: begin
						xp <= 'd84;
						yp <= 'd18;
					end
					'd123: begin
						xp <= 'd85;
						yp <= 'd18;
					end
					'd124: begin
						xp <= 'd86;
						yp <= 'd18;
					end
					'd125: begin
						xp <= 'd87;
						yp <= 'd18;
					end
					'd126: begin
						xp <= 'd87;
						yp <= 'd19;
					end
					'd127: begin
						xp <= 'd87;
						yp <= 'd20;
					end
					'd128: begin
						xp <= 'd87;
						yp <= 'd21;
					end
					'd129: begin
						xp <= 'd87;
						yp <= 'd22;
					end
					'd130: begin
						xp <= 'd87;
						yp <= 'd23;
					end
					'd131: begin
						xp <= 'd92;
						yp <= 'd12;
					end
					'd132: begin
						xp <= 'd92;
						yp <= 'd13;
					end
					'd133: begin
						xp <= 'd92;
						yp <= 'd14;
					end
					'd134: begin
						xp <= 'd92;
						yp <= 'd15;
					end
					'd135: begin
						xp <= 'd92;
						yp <= 'd16;
					end
					'd136: begin
						xp <= 'd92;
						yp <= 'd17;
					end
					'd137: begin
						xp <= 'd92;
						yp <= 'd18;
					end
					'd138: begin
						xp <= 'd92;
						yp <= 'd19;
					end
					'd139: begin
						xp <= 'd92;
						yp <= 'd20;
					end
					'd140: begin
						xp <= 'd92;
						yp <= 'd21;
					end
					'd141: begin
						xp <= 'd92;
						yp <= 'd22;
					end
					'd142: begin
						xp <= 'd92;
						yp <= 'd23;
					end
					'd143: begin
						xp <= 'd92;
						yp <= 'd24;
					end
					'd144: begin
						xp <= 'd100;
						yp <= 'd12;
					end
					'd145: begin
						xp <= 'd100;
						yp <= 'd13;
					end
					'd146: begin
						xp <= 'd100;
						yp <= 'd14;
					end
					'd147: begin
						xp <= 'd100;
						yp <= 'd15;
					end
					'd148: begin
						xp <= 'd100;
						yp <= 'd16;
					end
					'd149: begin
						xp <= 'd100;
						yp <= 'd17;
					end
					'd150: begin
						xp <= 'd100;
						yp <= 'd18;
					end
					'd151: begin
						xp <= 'd100;
						yp <= 'd19;
					end
					'd152: begin
						xp <= 'd100;
						yp <= 'd20;
					end
					'd153: begin
						xp <= 'd100;
						yp <= 'd21;
					end
					'd154: begin
						xp <= 'd100;
						yp <= 'd22;
					end
					'd155: begin
						xp <= 'd100;
						yp <= 'd23;
					end
					'd156: begin
						xp <= 'd100;
						yp <= 'd24;
					end
					'd157: begin
						xp <= 'd93;
						yp <= 'd12;
					end
					'd158: begin
						xp <= 'd93;
						yp <= 'd13;
					end
					'd159: begin
						xp <= 'd94;
						yp <= 'd14;
					end
					'd160: begin
						xp <= 'd94;
						yp <= 'd15;
					end
					'd161: begin
						xp <= 'd95;
						yp <= 'd16;
					end
					'd162: begin
						xp <= 'd95;
						yp <= 'd17;
					end
					'd163: begin
						xp <= 'd96;
						yp <= 'd18;
					end
					'd164: begin
						xp <= 'd97;
						yp <= 'd17;
					end
					'd165: begin
						xp <= 'd97;
						yp <= 'd16;
					end
					'd166: begin
						xp <= 'd98;
						yp <= 'd15;
					end
					'd167: begin
						xp <= 'd98;
						yp <= 'd14;
					end
					'd168: begin
						xp <= 'd99;
						yp <= 'd13;
					end
					'd169: begin
						xp <= 'd99;
						yp <= 'd12;
					end
					'd170: begin
						xp <= 'd105;
						yp <= 'd16;
					end
					'd171: begin
						xp <= 'd105;
						yp <= 'd17;
					end
					'd172: begin
						xp <= 'd105;
						yp <= 'd18;
					end
					'd173: begin
						xp <= 'd105;
						yp <= 'd19;
					end
					'd174: begin
						xp <= 'd105;
						yp <= 'd20;
					end
					'd175: begin
						xp <= 'd105;
						yp <= 'd21;
					end
					'd176: begin
						xp <= 'd105;
						yp <= 'd22;
					end
					'd177: begin
						xp <= 'd105;
						yp <= 'd23;
					end
					'd178: begin
						xp <= 'd105;
						yp <= 'd24;
					end
					'd179: begin
						xp <= 'd112;
						yp <= 'd16;
					end
					'd180: begin
						xp <= 'd112;
						yp <= 'd17;
					end
					'd181: begin
						xp <= 'd112;
						yp <= 'd18;
					end
					'd182: begin
						xp <= 'd112;
						yp <= 'd19;
					end
					'd183: begin
						xp <= 'd112;
						yp <= 'd20;
					end
					'd184: begin
						xp <= 'd112;
						yp <= 'd21;
					end
					'd185: begin
						xp <= 'd112;
						yp <= 'd22;
					end
					'd186: begin
						xp <= 'd112;
						yp <= 'd23;
					end
					'd187: begin
						xp <= 'd112;
						yp <= 'd24;
					end
					'd188: begin
						xp <= 'd106;
						yp <= 'd19;
					end
					'd189: begin
						xp <= 'd107;
						yp <= 'd19;
					end
					'd190: begin
						xp <= 'd108;
						yp <= 'd19;
					end
					'd191: begin
						xp <= 'd109;
						yp <= 'd19;
					end
					'd192: begin
						xp <= 'd110;
						yp <= 'd19;
					end
					'd193: begin
						xp <= 'd111;
						yp <= 'd19;
					end
					'd194: begin
						xp <= 'd106;
						yp <= 'd14;
					end
					'd195: begin
						xp <= 'd106;
						yp <= 'd15;
					end
					'd196: begin
						xp <= 'd107;
						yp <= 'd13;
					end
					'd197: begin
						xp <= 'd108;
						yp <= 'd12;
					end
					'd198: begin
						xp <= 'd109;
						yp <= 'd12;
					end
					'd199: begin
						xp <= 'd110;
						yp <= 'd13;
					end
					'd200: begin
						xp <= 'd111;
						yp <= 'd14;
					end
					'd201: begin
						xp <= 'd111;
						yp <= 'd15;
					end
					'd202: begin
						xp <= 'd53;
						yp <= 'd87;
					end
					'd203: begin
						xp <= 'd54;
						yp <= 'd87;
					end
					'd204: begin
						xp <= 'd55;
						yp <= 'd87;
					end
					'd205: begin
						xp <= 'd56;
						yp <= 'd87;
					end
					'd206: begin
						xp <= 'd57;
						yp <= 'd87;
					end
					'd207: begin
						xp <= 'd58;
						yp <= 'd87;
					end
					'd208: begin
						xp <= 'd59;
						yp <= 'd87;
					end
					'd209: begin
						xp <= 'd60;
						yp <= 'd87;
					end
					'd210: begin
						xp <= 'd61;
						yp <= 'd87;
					end
					'd211: begin
						xp <= 'd62;
						yp <= 'd87;
					end
					'd212: begin
						xp <= 'd63;
						yp <= 'd87;
					end
					'd213: begin
						xp <= 'd53;
						yp <= 'd97;
					end
					'd214: begin
						xp <= 'd54;
						yp <= 'd97;
					end
					'd215: begin
						xp <= 'd55;
						yp <= 'd97;
					end
					'd216: begin
						xp <= 'd56;
						yp <= 'd97;
					end
					'd217: begin
						xp <= 'd57;
						yp <= 'd97;
					end
					'd218: begin
						xp <= 'd58;
						yp <= 'd97;
					end
					'd219: begin
						xp <= 'd59;
						yp <= 'd97;
					end
					'd220: begin
						xp <= 'd60;
						yp <= 'd97;
					end
					'd221: begin
						xp <= 'd61;
						yp <= 'd97;
					end
					'd222: begin
						xp <= 'd62;
						yp <= 'd97;
					end
					'd223: begin
						xp <= 'd63;
						yp <= 'd97;
					end
					'd224: begin
						xp <= 'd74;
						yp <= 'd87;
					end
					'd225: begin
						xp <= 'd75;
						yp <= 'd87;
					end
					'd226: begin
						xp <= 'd76;
						yp <= 'd87;
					end
					'd227: begin
						xp <= 'd77;
						yp <= 'd87;
					end
					'd228: begin
						xp <= 'd78;
						yp <= 'd87;
					end
					'd229: begin
						xp <= 'd79;
						yp <= 'd87;
					end
					'd230: begin
						xp <= 'd80;
						yp <= 'd87;
					end
					'd231: begin
						xp <= 'd81;
						yp <= 'd87;
					end
					'd232: begin
						xp <= 'd82;
						yp <= 'd87;
					end
					'd233: begin
						xp <= 'd83;
						yp <= 'd87;
					end
					'd234: begin
						xp <= 'd84;
						yp <= 'd87;
					end
					'd235: begin
						xp <= 'd74;
						yp <= 'd97;
					end
					'd236: begin
						xp <= 'd75;
						yp <= 'd97;
					end
					'd237: begin
						xp <= 'd76;
						yp <= 'd97;
					end
					'd238: begin
						xp <= 'd77;
						yp <= 'd97;
					end
					'd239: begin
						xp <= 'd78;
						yp <= 'd97;
					end
					'd240: begin
						xp <= 'd79;
						yp <= 'd97;
					end
					'd241: begin
						xp <= 'd80;
						yp <= 'd97;
					end
					'd242: begin
						xp <= 'd81;
						yp <= 'd97;
					end
					'd243: begin
						xp <= 'd82;
						yp <= 'd97;
					end
					'd244: begin
						xp <= 'd83;
						yp <= 'd97;
					end
					'd245: begin
						xp <= 'd84;
						yp <= 'd97;
					end
					'd246: begin
						xp <= 'd95;
						yp <= 'd87;
					end
					'd247: begin
						xp <= 'd96;
						yp <= 'd87;
					end
					'd248: begin
						xp <= 'd97;
						yp <= 'd87;
					end
					'd249: begin
						xp <= 'd98;
						yp <= 'd87;
					end
					'd250: begin
						xp <= 'd99;
						yp <= 'd87;
					end
					'd251: begin
						xp <= 'd100;
						yp <= 'd87;
					end
					'd252: begin
						xp <= 'd101;
						yp <= 'd87;
					end
					'd253: begin
						xp <= 'd102;
						yp <= 'd87;
					end
					'd254: begin
						xp <= 'd103;
						yp <= 'd87;
					end
					'd255: begin
						xp <= 'd104;
						yp <= 'd87;
					end
					'd256: begin
						xp <= 'd105;
						yp <= 'd87;
					end
					'd257: begin
						xp <= 'd95;
						yp <= 'd97;
					end
					'd258: begin
						xp <= 'd96;
						yp <= 'd97;
					end
					'd259: begin
						xp <= 'd97;
						yp <= 'd97;
					end
					'd260: begin
						xp <= 'd98;
						yp <= 'd97;
					end
					'd261: begin
						xp <= 'd99;
						yp <= 'd97;
					end
					'd262: begin
						xp <= 'd100;
						yp <= 'd97;
					end
					'd263: begin
						xp <= 'd101;
						yp <= 'd97;
					end
					'd264: begin
						xp <= 'd102;
						yp <= 'd97;
					end
					'd265: begin
						xp <= 'd103;
						yp <= 'd97;
					end
					'd266: begin
						xp <= 'd104;
						yp <= 'd97;
					end
					'd267: begin
						xp <= 'd105;
						yp <= 'd97;
					end
					'd268: begin
						xp <= 'd53;
						yp <= 'd88;
					end
					'd269: begin
						xp <= 'd53;
						yp <= 'd89;
					end
					'd270: begin
						xp <= 'd53;
						yp <= 'd90;
					end
					'd271: begin
						xp <= 'd53;
						yp <= 'd91;
					end
					'd272: begin
						xp <= 'd53;
						yp <= 'd92;
					end
					'd273: begin
						xp <= 'd53;
						yp <= 'd93;
					end
					'd274: begin
						xp <= 'd53;
						yp <= 'd94;
					end
					'd275: begin
						xp <= 'd53;
						yp <= 'd95;
					end
					'd276: begin
						xp <= 'd53;
						yp <= 'd96;
					end
					'd277: begin
						xp <= 'd63;
						yp <= 'd88;
					end
					'd278: begin
						xp <= 'd63;
						yp <= 'd89;
					end
					'd279: begin
						xp <= 'd63;
						yp <= 'd90;
					end
					'd280: begin
						xp <= 'd63;
						yp <= 'd91;
					end
					'd281: begin
						xp <= 'd63;
						yp <= 'd92;
					end
					'd282: begin
						xp <= 'd63;
						yp <= 'd93;
					end
					'd283: begin
						xp <= 'd63;
						yp <= 'd94;
					end
					'd284: begin
						xp <= 'd63;
						yp <= 'd95;
					end
					'd285: begin
						xp <= 'd63;
						yp <= 'd96;
					end
					'd286: begin
						xp <= 'd74;
						yp <= 'd88;
					end
					'd287: begin
						xp <= 'd74;
						yp <= 'd89;
					end
					'd288: begin
						xp <= 'd74;
						yp <= 'd90;
					end
					'd289: begin
						xp <= 'd74;
						yp <= 'd91;
					end
					'd290: begin
						xp <= 'd74;
						yp <= 'd92;
					end
					'd291: begin
						xp <= 'd74;
						yp <= 'd93;
					end
					'd292: begin
						xp <= 'd74;
						yp <= 'd94;
					end
					'd293: begin
						xp <= 'd74;
						yp <= 'd95;
					end
					'd294: begin
						xp <= 'd74;
						yp <= 'd96;
					end
					'd295: begin
						xp <= 'd84;
						yp <= 'd88;
					end
					'd296: begin
						xp <= 'd84;
						yp <= 'd89;
					end
					'd297: begin
						xp <= 'd84;
						yp <= 'd90;
					end
					'd298: begin
						xp <= 'd84;
						yp <= 'd91;
					end
					'd299: begin
						xp <= 'd84;
						yp <= 'd92;
					end
					'd300: begin
						xp <= 'd84;
						yp <= 'd93;
					end
					'd301: begin
						xp <= 'd84;
						yp <= 'd94;
					end
					'd302: begin
						xp <= 'd84;
						yp <= 'd95;
					end
					'd303: begin
						xp <= 'd84;
						yp <= 'd96;
					end
					'd304: begin
						xp <= 'd95;
						yp <= 'd88;
					end
					'd305: begin
						xp <= 'd95;
						yp <= 'd89;
					end
					'd306: begin
						xp <= 'd95;
						yp <= 'd90;
					end
					'd307: begin
						xp <= 'd95;
						yp <= 'd91;
					end
					'd308: begin
						xp <= 'd95;
						yp <= 'd92;
					end
					'd309: begin
						xp <= 'd95;
						yp <= 'd93;
					end
					'd310: begin
						xp <= 'd95;
						yp <= 'd94;
					end
					'd311: begin
						xp <= 'd95;
						yp <= 'd95;
					end
					'd312: begin
						xp <= 'd95;
						yp <= 'd96;
					end
					'd313: begin
						xp <= 'd105;
						yp <= 'd88;
					end
					'd314: begin
						xp <= 'd105;
						yp <= 'd89;
					end
					'd315: begin
						xp <= 'd105;
						yp <= 'd90;
					end
					'd316: begin
						xp <= 'd105;
						yp <= 'd91;
					end
					'd317: begin
						xp <= 'd105;
						yp <= 'd92;
					end
					'd318: begin
						xp <= 'd105;
						yp <= 'd93;
					end
					'd319: begin
						xp <= 'd105;
						yp <= 'd94;
					end
					'd320: begin
						xp <= 'd105;
						yp <= 'd95;
					end
					'd321: begin
						xp <= 'd105;
						yp <= 'd96;
					end
					
				endcase
				paint_point = paint_point + 1'b1;
			end
		end else begin
			if (next == 6'b100101) begin
				curr <= 6'b000000;
				index <= 0;
				draw_which <= draw_which + 1'b1;
			end else if (next[2:0] == 3'b101) begin
				curr <= next + 'd3;
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
	
	assign lamp = {8'b01111101,~letterWire[24:20],2'b11,~letterWire[19:15],2'b11,~letterWire[14:10],2'b11,~letterWire[9:5],2'b11,~letterWire[4:0],8'b10111110};

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