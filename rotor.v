module rotor (in, out, rotate, wiring_config);
	input [25:0]in;
	input [1:0]wiring_config;
	input rotate;
	output [25:0]out;

	localparam A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5, G = 5'd6, H = 5'd7, I = 5'd8, J = 5'd9, K = 5'd10, L = 5'd11, M = 5'd12, N = 5'd13, 
			O = 5'd14, P = 5'd15, Q = 5'd16, R = 5'd17, S = 5'd18, T = 5'd19, U = 5'd20, V = 5'd21, W = 5'd22, X = 5'd23, Y = 5'd24, Z = 5'd25;

	reg [4:0]curr_position;
	wire [51:0]offseti, offseto;
	wire [25:0]out2;
	assign offseti = in[25:0] << curr_position;
	assign offseto = out2[25:0] << curr_position;
	assign out[25:0] = (offseto[25:0] | offseto[51:26]);

	rotor_wiring w1(.in(offseti[25:0] | offseti[51:26]), .out(out2[25:0]), .wiring_config(wiring_config));

	always @(posedge rotate)
	begin
		case(curr_position)
		A: curr_position = B;
		B: curr_position = C;
		C: curr_position = D;
		D: curr_position = E;
		E: curr_position = F;
		F: curr_position = G;
		G: curr_position = H;
		H: curr_position = I;
		I: curr_position = J;
		J: curr_position = K;
		K: curr_position = L;
		L: curr_position = M;
		M: curr_position = N;
		N: curr_position = O;
		O: curr_position = P;
		P: curr_position = Q;
		Q: curr_position = R;
		R: curr_position = S;
		S: curr_position = T;
		T: curr_position = U;
		U: curr_position = V;
		V: curr_position = W;
		W: curr_position = X;
		X: curr_position = Y;
		Y: curr_position = Z;
		Z: curr_position = A;
		default: curr_position = A;
		endcase
	end
	
endmodule



module rotor_wiring (in, out, wiring_config);
	input [25:0]in;
	input [1:0]wiring_config; // Rotor I: 00, Rotor II: 01, Rotor III: 10, No Encryption: 10
	output reg [25:0]out;

	always@(*)
	begin
		if (wiring_config == 2'b00)
		begin
			out[4] <= in[0];
			out[10] <= in[1];
			out[12] <= in[2];
			out[5] <= in[3];
			out[11] <= in[4];
			out[6] <= in[5];
			out[3] <= in[6];
			out[16] <= in[7];
			out[21] <= in[8];
			out[25] <= in[9];
			out[13] <= in[10];
			out[19] <= in[11];
			out[14] <= in[12];
			out[22] <= in[13];
			out[24] <= in[14];
			out[7] <= in[15];
			out[23] <= in[16];
			out[20] <= in[17];
			out[18] <= in[18];
			out[15] <= in[19];
			out[0] <= in[20];
			out[8] <= in[21];
			out[1] <= in[22];
			out[17] <= in[23];
			out[2] <= in[24];
			out[9] <= in[25];
		end
		else if (wiring_config == 2'b01)
		begin
			out[0] <= in[0];
			out[9] <= in[1];
			out[3] <= in[2];
			out[10] <= in[3];
			out[18] <= in[4];
			out[8] <= in[5];
			out[17] <= in[6];
			out[20] <= in[7];
			out[23] <= in[8];
			out[1] <= in[9];
			out[11] <= in[10];
			out[7] <= in[11];
			out[22] <= in[12];
			out[19] <= in[13];
			out[12] <= in[14];
			out[2] <= in[15];
			out[16] <= in[16];
			out[6] <= in[17];
			out[25] <= in[18];
			out[13] <= in[19];
			out[15] <= in[20];
			out[24] <= in[21];
			out[5] <= in[22];
			out[21] <= in[23];
			out[14] <= in[24];
			out[4] <= in[25];
		end
		else if (wiring_config == 2'b10)
		begin
			out[1] <= in[0];
			out[3] <= in[1];
			out[5] <= in[2];
			out[7] <= in[3];
			out[9] <= in[4];
			out[11] <= in[5];
			out[2] <= in[6];
			out[15] <= in[7];
			out[17] <= in[8];
			out[19] <= in[9];
			out[23] <= in[10];
			out[21] <= in[11];
			out[25] <= in[12];
			out[13] <= in[13];
			out[24] <= in[14];
			out[4] <= in[15];
			out[8] <= in[16];
			out[22] <= in[17];
			out[6] <= in[18];
			out[0] <= in[19];
			out[10] <= in[20];
			out[12] <= in[21];
			out[20] <= in[22];
			out[18] <= in[23];
			out[16] <= in[24];
			out[14] <= in[25];
		end
		else
		begin
			out[0] <= in[0];
			out[1] <= in[1];
			out[2] <= in[2];
			out[3] <= in[3];
			out[4] <= in[4];
			out[5] <= in[5];
			out[6] <= in[6];
			out[7] <= in[7];
			out[8] <= in[8];
			out[9] <= in[9];
			out[10] <= in[10];
			out[11] <= in[11];
			out[12] <= in[12];
			out[13] <= in[13];
			out[14] <= in[14];
			out[15] <= in[15];
			out[16] <= in[16];
			out[17] <= in[17];
			out[18] <= in[18];
			out[19] <= in[19];
			out[20] <= in[20];
			out[21] <= in[21];
			out[22] <= in[22];
			out[23] <= in[23];
			out[24] <= in[24];
			out[25] <= in[25];
		end
	end
endmodule

