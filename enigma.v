module enigma (CLOCK_50, KEY, SW, VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N, VGA_R, VGA_G, VGA_B,
		PS2_CLK, PS2_DAT);

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

	wire [25:0]rero_out, front_plug_out, rear_plug_out, out_to_ui;
	wire [4:0]state1, state2, state3;
	
	input PS2_CLK, PS2_DAT;
	reg [25:0] r;
	
	reg counter;
	reg [25:0] r1, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10;
	reg [25:0] output1, output2, output3, output4, output5, output6, output7, output8, output9, output10;
	
	

	initial begin
		counter <= 0;
		r1 <= 0;
		input1 <= 0; input2 <= 0; input3 <= 0; input4 <= 0; input5 <= 0; input6 <= 0; input7 <= 0; input8 <= 0; input9 <= 0; input10 <= 0;
		output1 <= 0; output2 <= 0; output3 <= 0; output4 <= 0; output5 <= 0; output6 <= 0; output7 <= 0; output8 <= 0; output9 <= 0; output10 <= 0;
	end


    keyboard kbd(.PS2_CLK(PS2_CLK),.PS2_DAT(PS2_DAT),.CLOCK_50(CLOCK_50), .r(r));
    
    
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
	
	always @(posedge |(scan_ready))
	
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
			8'h1A: r = 26'h2000000;		//Z
		endcase
	end
endmodule */