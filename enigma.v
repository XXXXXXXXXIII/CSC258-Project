module enigma (CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B);

	input CLOCK_50;
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

	wire [25:0]rero_out, front_plug_out, rear_plug_out;
	wire [4:0]state1, state2, state3;


    
    // plugboardChanger plugboard (.in(in), .out(w1), .changeto(changeto), .change(change)); //TODO keyboard/plugboard. connect front_plug_out to output, add pin-input as needed.
    rero rotors_reflector(.in(front_plug_out), .out(rero_out), .wheel_config(SW[2:0]), .rotate1(KEY[1]), .rotate2(KEY[2]), .rotate3(KEY[3]), .state1(state1), .state2(state2), .state2(state3));
    gui gui0(.CLOCK_50(CLOCK_50), .in(rear_plug_out), .state1(state1), .state2(state2), .state3(state3), .reset(KEY[0]), 
    	.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

endmodule


module plugboardChanger(in, change);

	input [25:0] in, change;

	reg counter = 4'd0;
	reg [25:0] r1, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10;
	reg [25:0] output1, output2, output3, output4, output5, output6, output7, output8, output9, output10;

	always @(*)
	begin
		if (counter < 20)
			begin
				case(counter)
					5'd1:input1 = in;
					5'd2:output1 = change;
					5'd3:input2 = in;
					5'd4:output2 = change;
					5'd5:input3 = in;
					5'd6:output3 = change;
					5'd7:input4 = in;
					5'd8:output4 = change;
					5'd9:input5 = in;
					5'd10:output5 = change;
					5'd11:input6 = in;
					5'd12:output6 = change;
					5'd13:input7 = in;
					5'd14:output7 = change;
					5'd15:input8 = in;
					5'd16:output8 = change;
					5'd17:input9 = in;
					5'd18:output10 = change;
					5'd19:input11 = in;
					5'd20:output11 = change;
				endcase
				counter = counter + 1;
			end
		else
			begin
				case(in)
					input1: r1 = output1;
					input2: r1 = output2;
					input3: r1 = output3;
					input4: r1 = output4;
					input5: r1 = output5;
					input6: r1 = output6;
					input7: r1 = output7;
					input8: r1 = output8;
					input9: r1 = output9;
					input10: r1 = output10;
					default: r1 = in;
				endcase
			end
	end
endmodule


module keyboard (PS2_CLK,PS2_DAT,CLOCK_50, r);
	
	input PS2_CLK, PS2_DAT, CLOCK_50;

	wire [7:0] scan_code;
	wire read, scan_ready;
	reg [7:0] scan_history[1:2];
	
	output reg [25:0] r;
	
	
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
		case(scan_ready)
			8'h1C: r = 26'h1; 			//A
			8'h32: r = 26'h2;			//B
			8'h21: r = 26'h4;			//C
			8'h23: r = 26'h8;			//D
			8'h24: r = 26'h10;			//E
			8'h2B: r = 26'h20;			//F
			8'h34: r = 26'h40;			//G
			8'h33: r = 26'h80;			//H
			8'h43: r = 26'h100;			//I
			8'h3B: r = 26'h200;			//J
			8'h42: r = 26'h400;			//K
			8'h4B: r = 26'h800;			//L
			8'h3A: r = 26'h1000;			//M
			8'h31: r = 26'h2000;			//N
			8'h44: r = 26'h4000;			//O
			8'h4D: r = 26'h8000;			//P
			8'h15: r = 26'h10000;			//Q
			8'h2D: r = 26'h20000;			//R
			8'h1B: r = 26'h40000;			//S
			8'h2C: r = 26'h80000;			//T
			8'h3C: r = 26'h100000;			//U
			8'h2A: r = 26'h200000;			//V
			8'h1D: r = 26'h400000;			//W
			8'h22: r = 26'h800000;			//X
			8'h35: r = 26'h1000000;			//Y
			8'h1A: r = 26'h20000000;		//Z
		endcase
	end
endmodule