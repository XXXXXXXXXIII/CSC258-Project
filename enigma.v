module enigma (CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
		PS2_CLK, PS2_DAT,HEX0, HEX1,HEX2, HEX3, HEX4);

	input CLOCK_50;
	output[6:0] HEX0, HEX1, HEX2, HEX3, HEX4;
	input [3:0]KEY;
	input [9:0]SW;

	output	VGA_CLK;   				//	VGA Clock
	output	VGA_HS;					//	VGA H_SYNC
	output	VGA_VS;					//	VGA V_SYNC
	output	VGA_BLANK_N;				//	VGA BLANK
	output	VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;

	wire [25:0]rero_out, front_plug_out, rear_plug_out, out_to_ui, p1_out, r, p2_out;
	wire [4:0]state1, state2, state3;
	
	input PS2_CLK, PS2_DAT;				// KEYBOARD CLK and DAT Pin
		
	
    keyboardu kbd(.PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .CLOCK_50(CLOCK_50), .r(r), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3));
    
    plugboardChanger plugboard (.in(r), .out(p1_out));
    
    rero rotors_reflector(.in(p1_out), .out(rero_out), .wheel_config(SW[2:0]), .rotate1(~KEY[1]), .rotate2(~KEY[2]), .rotate3(~KEY[3]), .state1(state1), .state2(state2), .state3(state3));
    
    plugboardChanger plugboardr (.in(rero_out), .out(p2_out));
	 
	 hex_7seg dsp5(.hex_digit(|(p1_out)),.seg(HEX4));
    
    gui gui0(.CLOCK_50(CLOCK_50), .in(p2_out), .state1(state1), .state2(state2), .state3(state3), .reset(KEY[0]), 
    	.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
	
    

endmodule

module plugboardChanger(out, in);
input [25:0] in;
output reg [25:0] out;

	always @(*)
		begin
			// BF SD AY HG OU QC WI RL XP ZK : CURRENT PLUGBOARD SETTING
			case (in)
				26'h2:	out = 26'h20;			//B-F
				26'h40000: out = 26'h8;			//S-D
				26'h80: out = 26'h40;			//H-G
				26'h4000: out =26'h100000;		//O-U
				26'h10000: out = 26'h4;			//Q-C
				26'h400000: out = 26'h100;		//W-I
				26'h20000: out = 26'h800;		//R-L
				26'h800000: out = 26'h8000;		//X-P	
				26'h2000000: out = 26'h400;		//Z-K
				
				26'h20: out= 26'h2; 			//F-B
				26'h8: out= 26'h40000;			//D-S
				26'h40: out= 26'h80;			//G-H
				26'h100000: out= 26'h4000;		//U-O
				26'h4: out= 26'h10000;			//C-Q
				26'h100: out= 26'h400000;		//I-W
				26'h800: out= 26'h20000;		//L-R
				26'h8000: out=	26'h800000;		//P-X
				26'h400: out= 26'h2000000;		//K-Z
				default out= in;
				
			endcase
		end
		
endmodule


module keyboardu (PS2_CLK,PS2_DAT,CLOCK_50, r, HEX0, HEX1, HEX2, HEX3);
	
	input PS2_CLK, PS2_DAT, CLOCK_50;
	output [6:0] HEX0, HEX1, HEX2, HEX3;

	wire [7:0] scan_code;
	wire read, scan_ready;
	reg [7:0] scan_history[1:2];
	
	output reg [25:0] r;
	
	initial begin
		scan_history[2] <= 8'hff; 
		scan_history[1] <= 8'hff;
	end
	
	keyboard kbd(
	  .keyboard_clk(PS2_CLK),
	  .keyboard_data(PS2_DAT),
	  .clock50(CLOCK_50),
	  .reset(0),
	  .read(read),
	  .scan_ready(scan_ready),
	  .scan_code(scan_code)
	);
	
	oneshot pulser(
	   .pulse_out(read),
	   .trigger_in(scan_ready),
	   .clk(CLOCK_50)
	);
	
	always @(posedge scan_ready)		
	begin
		scan_history[2] <= scan_history[1];
		scan_history[1] <= scan_code;
	end

	always @(*)
	begin
		if (scan_history[2][7:4] == 4'hf) begin
			r = 0;
		end else begin case({scan_history[1],scan_history[1]})
			16'h1C1C: r = 26'h1; 				//A
			16'h3232: r = 26'h2;				//B
			16'h2121: r = 26'h4;				//C
			16'h2323: r = 26'h8;				//D
			16'h2424: r = 26'h10;				//E
			16'h2B2B: r = 26'h20;				//F
			16'h3434: r = 26'h40;				//G
			16'h3333: r = 26'h80;				//H
			16'h4343: r = 26'h100;				//I
			16'h3B3B: r = 26'h200;				//J
			16'h4242: r = 26'h400;				//K
			16'h4B4B: r = 26'h800;				//L
			16'h3A3A: r = 26'h1000;				//M
			16'h3131: r = 26'h2000;				//N
			16'h4444: r = 26'h4000;				//O
			16'h4D4D: r = 26'h8000;				//P
			16'h1515: r = 26'h10000;				//Q
			16'h2D2D: r = 26'h20000;				//R
			16'h1B1B: r = 26'h40000;				//S
			16'h2C2C: r = 26'h80000;				//T
			16'h3C3C: r = 26'h100000;			//U
			16'h2A2A: r = 26'h200000;			//V
			16'h1D1D: r = 26'h400000;			//W
			16'h2222: r = 26'h800000;			//X
			16'h3535: r = 26'h1000000;			//Y
			16'h1A1A: r = 26'h2000000;			//Z
			default: r = 26'h0;
		endcase end
	end
	hex_7seg dsp0(.hex_digit(scan_history[1][3:0]),.seg(HEX0));
	hex_7seg dsp1(.hex_digit(scan_history[1][7:4]),.seg(HEX1));
	
	hex_7seg dsp2(.hex_digit(scan_history[2][3:0]),.seg(HEX2));
	hex_7seg dsp3(.hex_digit(scan_history[2][7:4]),.seg(HEX3));

endmodule 
