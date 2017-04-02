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
    rero rotors_reflector(.in(front_plug_out), .out(rero_out), .wheel_config(SW[2:0]), .state1(state1), .state2(state2), .state2(state3));
    gui gui0(.CLOCK_50(CLOCK_50), .in(rear_plug_out), .state1(state1), .state2(state2), .state3(state3), .reset(KEY[0]), 
    	.VGA_CLK(VGA_CLK), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));

endmodule


