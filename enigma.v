module enigma(in, change, wheel_config);

	input [25:0] in, change;
	input [2:0] wheel_config;

	reg counter = 4'd0;
	reg [25:0] r1, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10;
	reg [25:0] output1, output2, output3, output4, output5, output6, output7, output8, output9, output10;

	always @(*)
	begin
		if (counter < 10)
			begin
					if (counter == 4'd1)
							begin
								input1 = in;
								output1 = change;
							end
					if (counter == 4'd2)
							begin
								input2 = in;
								output2 = change;
							end
					if (counter == 4'd3)
							begin
								input3 = in;
								output3 = change;
						   end
					if (counter == 4'd4)
							begin
								input4 = in;
								output4 = change;
							end
					if (counter == 4'd5)
							begin
								input5 = in;
								output5 = change;
							end
					if (counter == 4'd6)
							begin
								input6 = in;
								output6 = change;
							end
					if (counter == 4'd7)
							begin
								input7 = in;
								output7 = change;
							end
					if (counter == 4'd8)
							begin
								input8 = in;
								output8 = change;
							end
					if (counter == 4'd9)
							begin
								input9 = in;
								output9 = change;
							end
					if (counter == 4'd10)
							begin
								input10 = in;
								output10 = change;
							end
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
	rero rotors_reflector(.in(w1), .out(out), .wheel_config(wheel_config));
endmodule


