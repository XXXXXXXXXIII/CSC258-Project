module rotor (in, out, rotate, wiring_config);
	input [4:0]in;
	input rotate;
	input [1:0]wiring_config;
	output reg [4:0]out;

	reg [4:0]curr_position;

	localparam A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5, G = 5'd6, H = 5'd7, I = 5'd8, J = 5'd9, K = 5'd10, L = 5'd11, M = 5'd12, N = 5'd13, 
			O = 5'd14, P = 5'd15, Q = 5'd16, R = 5'd17, S = 5'd18, T = 5'd19, U = 5'd20, V = 5'd21, W = 5'd22, X = 5'd23, Y = 5'd24, Z = 5'd25;
	
	reg [5:0]offseti;
	wire [5:0]offseto;

	always @(*)
	begin		
		if ((in[4:0] + curr_position[4:0]) > 5'd25)
			offseti = in + curr_position - 4'd25;
		else
			offseti = in + curr_position;	

		if ((offseto[4:0] + curr_position[4:0]) > 5'd25)
			out = offseto[4:0] + curr_position - 4'd25;
		else
			out = offseto[4:0] + curr_position;
	end

	rotor_wiring w1(.in(offseti[4:0]), .out(offseto[4:0]), .wiring_config(wiring_config[1:0]));
	
	always @(posedge rotate)
	begin
		if (curr_position == Z)
			curr_position <= A;
		else
			curr_position = curr_position + 1'b1;
	end
	
endmodule

module rotor (in, out, rotate, wiring_config);
	input [25:0]in;
	input [1:0]wiring_config;
	input rotate;
	output [25:0]out;

	localparam A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5, G = 5'd6, H = 5'd7, I = 5'd8, J = 5'd9, K = 5'd10, L = 5'd11, M = 5'd12, N = 5'd13, 
			O = 5'd14, P = 5'd15, Q = 5'd16, R = 5'd17, S = 5'd18, T = 5'd19, U = 5'd20, V = 5'd21, W = 5'd22, X = 5'd23, Y = 5'd24, Z = 5'd25;

	reg [4:0]curr_pos;
	

	always @(*)
	begin
		
	end

	always @(posedge rotate)
	begin
		if (curr_position == Z)
			curr_position <= A;
		else
			curr_position = curr_position + 1'b1;
	end
	
endmodule



module rotor_wiring (in, out, wiring_config);
	input [25:0]in;
	input [1:0]wiring_config; // Rotor I: 00, Rotor II: 01, Rotor III: 10, No Encryption: 10
	output [25:0]out;

	always@(*)
	begin
		if (wiring_config == 2'b00)
		begin
			assign out[0] = in[4];
			assign out[1] = in[10];
			assign out[2] = in[12];
			assign out[3] = in[5];
			assign out[4] = in[11];
			assign out[5] = in[6];
			assign out[6] = in[3];
			assign out[7] = in[16];
			assign out[8] = in[21];
			assign out[9] = in[25];
			assign out[10] = in[13];
			assign out[11] = in[19];
			assign out[12] = in[14];
			assign out[13] = in[22];
			assign out[14] = in[24];
			assign out[15] = in[7];
			assign out[16] = in[23];
			assign out[17] = in[20];
			assign out[18] = in[18];
			assign out[19] = in[15];
			assign out[20] = in[0];
			assign out[21] = in[8];
			assign out[22] = in[2];
			assign out[23] = in[17];
			assign out[24] = in[2];
			assign out[25] = in[9];
		end
		else if (wiring_config == 2'b01)
		begin
			assign out[0] = in[0];
			assign out[1] = in[9];
			assign out[2] = in[3];
			assign out[3] = in[10];
			assign out[4] = in[18];
			assign out[5] = in[8];
			assign out[6] = in[17];
			assign out[7] = in[20];
			assign out[8] = in[23];
			assign out[9] = in[1];
			assign out[10] = in[11];
			assign out[11] = in[7];
			assign out[12] = in[22];
			assign out[13] = in[19];
			assign out[14] = in[12];
			assign out[15] = in[2];
			assign out[16] = in[14];
			assign out[17] = in[6];
			assign out[18] = in[25];
			assign out[19] = in[13];
			assign out[20] = in[15];
			assign out[21] = in[24];
			assign out[22] = in[5];
			assign out[23] = in[21];
			assign out[24] = in[14];
			assign out[25] = in[4];
		end
		else if (wiring_config == 2'b10)
		begin
			assign out[0] = in[1];
			assign out[1] = in[3];
			assign out[2] = in[5];
			assign out[3] = in[7];
			assign out[4] = in[9];
			assign out[5] = in[11];
			assign out[6] = in[2];
			assign out[7] = in[15];
			assign out[8] = in[17];
			assign out[9] = in[19];
			assign out[10] = in[23];
			assign out[11] = in[21];
			assign out[12] = in[25];
			assign out[13] = in[13];
			assign out[14] = in[24];
			assign out[15] = in[4];
			assign out[16] = in[8];
			assign out[17] = in[22];
			assign out[18] = in[6];
			assign out[19] = in[0];
			assign out[20] = in[10];
			assign out[21] = in[12];
			assign out[22] = in[20];
			assign out[23] = in[18];
			assign out[24] = in[16];
			assign out[25] = in[14];
		end
		else
		begin
			assign out[0] = in[0];
			assign out[1] = in[1];
			assign out[2] = in[2];
			assign out[3] = in[3];
			assign out[4] = in[4];
			assign out[5] = in[5];
			assign out[6] = in[6];
			assign out[7] = in[7];
			assign out[8] = in[8];
			assign out[9] = in[9];
			assign out[10] = in[10];
			assign out[11] = in[11];
			assign out[12] = in[12];
			assign out[13] = in[13];
			assign out[14] = in[14];
			assign out[15] = in[15];
			assign out[16] = in[16];
			assign out[17] = in[17];
			assign out[18] = in[18];
			assign out[19] = in[19];
			assign out[20] = in[20];
			assign out[21] = in[21];
			assign out[22] = in[22];
			assign out[23] = in[23];
			assign out[24] = in[24];
			assign out[25] = in[25];
		end
	end
endmodule

