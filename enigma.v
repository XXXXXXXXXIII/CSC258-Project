
module enigma (CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
		PS2_CLK, PS2_DAT,HEX0, HEX1,HEX2, HEX3);

	input CLOCK_50;
	output[6:0] HEX0, HEX1, HEX2, HEX3;
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

	wire [25:0]rero_out, front_plug_out, rear_plug_out, out_to_ui;
	wire [4:0]state1, state2, state3;
	
	input PS2_CLK, PS2_DAT;
	wire [25:0] r;
	
	reg counter;
	reg [25:0] r1, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10;
	reg [25:0] output1, output2, output3, output4, output5, output6, output7, output8, output9, output10;
	
	

	initial begin
	counter <= 0;
		r1 <= 0;
		input1 <= 0; input2 <= 0; input3 <= 0; input4 <= 0; input5 <= 0; input6 <= 0; input7 <= 0; input8 <= 0; input9 <= 0; input10 <= 0;
		output1 <= 0; output2 <= 0; output3 <= 0; output4 <= 0; output5 <= 0; output6 <= 0; output7 <= 0; output8 <= 0; output9 <= 0; output10 <= 0;
	end

	
    keyboardu kbd(.PS2_CLK(PS2_CLK), .PS2_DAT(PS2_DAT), .CLOCK_50(CLOCK_50), .r(r), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3));
    
    
/*plugboardChanger plugboard (.in(r), .r1(front_plug_out), .in1(input1), .in2(input2)
    , .in3(input3), .in4(input4), .in5(input5), .in6(input6),.in7(input7), .in8(input8), .in9(input9),
    .in10(input10), .out1(output1), .out2(output2), .out3(output3),.out4(output4), .out5(output5), .out6(output6),
    .out7(output7), .out8(output8), .out9(output9), .out10(output10)); */
    
    
    rero rotors_reflector(.in(r), .out(rero_out), .wheel_config(SW[2:0]), .rotate1(KEY[1]), .rotate2(KEY[2]), .rotate3(KEY[3]), .state1(state1), .state2(state2), .state3(state3));
    
    /*plugboardChanger plugboardr (.in(rear_plug_out), .r1(out_to_ui), .in1(input1), .in2(input2)
    , .in3(input3), .in4(input4), .in5(input5), .in6(input6),.in7(input7), .in8(input8), .in9(input9),
    .in10(input10), .out1(output1), .out2(output2), .out3(output3),.out4(output4), .out5(output5), .out6(output6),
    .out7(output7), .out8(output8), .out9(output9), .out10(output10)); */
    
    gui gui0(.CLOCK_50(CLOCK_50), .in(out_to_ui), .state1(state1), .state2(state2), .state3(state3), .reset(KEY[0]), 
    	.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
	
    

endmodule

/*
module plugboardChanger(in, r1, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10,
			out1, out2, out3, out4, out5, out6, out7, out8, out9, out10);

	input [25:0] in, change;
	output reg [25:0]r1;
	
	inout [25:0] in1, in2, in3, in4, in5, in6, in7, in8, in9, in10;
	inout [25:0] out1, out2, out3, out4, out5, out6, out7, out8, out9, out10;
	reg counter;

	always @(*)
	begin
		if (counter < 20)
			begin
				case(counter)
					5'd1:in1 = in;
					5'd2:out1 = in;
					5'd3:in2 = in;
					5'd4:out2 = in;
					5'd5:in3 = in;
					5'd6:out3 = in;
					5'd7:in4 = in;
					5'd8:out4 = in;
					5'd9:in5 = in;
					5'd10:out5 = in;
					5'd11:in6 = in;
					5'd12:out6 = in;
					5'd13:in7 = in;
					5'd14:out7 = in;
					5'd15:in8 = in;
					5'd16:out8 = in;
					5'd17:in9 = in;
					5'd18:out9 = in;
					5'd19:in10 = in;
					5'd20:out10 = in;
				endcase
				counter = counter + 1;
			end
		else
			begin
				case(in)
					in1: r1 = out1;
					in2: r1 = out2;
					in3: r1 = out3;
					in4: r1 = out4;
					in5: r1 = out5;
					in6: r1 = out6;
					in7: r1 = out7;
					in8: r1 = out8;
					in9: r1 = out9;
					in10: r1 = out10;
					out1: r1 = in1;
					out2: r1 = in2;
					out3: r1 = in3;
					out4: r1 = in4;
					out5: r1 = in5;
					out6: r1 = in6;
					out7: r1 = in7;
					out8: r1 = in8;
					out9: r1 = in9;
					out10: r1 = in10;
					default: r1 = in;
				endcase
			end
	end
endmodule*/


module keyboardu (PS2_CLK,PS2_DAT,CLOCK_50, r, HEX0, HEX1, HEX2, HEX3);
	
	input PS2_CLK, PS2_DAT, CLOCK_50;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4;

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
				scan_history[2] <= scan_history[1];
				scan_history[1] <= scan_code;
	end
	
	hex_7seg dsp0(.hex_digit(scan_history[1][3:0]),.seg(HEX0));
	hex_7seg dsp1(.hex_digit(scan_history[1][7:4]),.seg(HEX1));
	
	hex_7seg dsp2(.hex_digit(scan_history[2][3:0]),.seg(HEX2));
	hex_7seg dsp3(.hex_digit(scan_history[2][7:4]),.seg(HEX3));
	
	always @(posedge scan_ready)
	
	begin
		case({scan_history[1],scan_history[2][7:4]})
			12'h1CF: r = 26'h1; 				//A
			12'h32F: r = 26'h2;				//B
			12'h21F: r = 26'h4;				//C
			12'h23F: r = 26'h8;				//D
			12'h24F: r = 26'h10;				//E
			12'h2BF: r = 26'h20;				//F
			12'h34F: r = 26'h40;				//G
			12'h33F: r = 26'h80;				//H
			12'h43F: r = 26'h100;			//I
			12'h3BF: r = 26'h200;			//J
			12'h42F: r = 26'h400;			//K
			12'h4BF: r = 26'h800;			//L
			12'h3AF: r = 26'h1000;			//M
			12'h31F: r = 26'h2000;			//N
			12'h44F: r = 26'h4000;			//O
			12'h4DF: r = 26'h8000;			//P
			12'h15F: r = 26'h10000;			//Q
			12'h2DF: r = 26'h20000;			//R
			12'h1BF: r = 26'h40000;			//S
			12'h2CF: r = 26'h80000;			//T
			12'h3CF: r = 26'h100000;			//U
			12'h2AF: r = 26'h200000;			//V
			12'h1DF: r = 26'h400000;			//W
			12'h22F: r = 26'h800000;			//X
			12'h35F: r = 26'h1000000;			//Y
			12'h1AF: r = 26'h2000000;		//Z
			default: r = 26'h0;
		endcase
	end

endmodule 