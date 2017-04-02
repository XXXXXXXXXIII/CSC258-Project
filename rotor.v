module rotor (in, out, rotate, notch, wiring_config, state);
	input wire [25:0]in;
	input [2:0]wiring_config; // Rotor I: 000, Rotor II: 001, Rotor III: 010, No Encryption: 011. 1xx for reverse
	input rotate;
	output reg notch;
	output wire [25:0]out;
	output [4:0]state;

	localparam A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5, G = 5'd6, H = 5'd7, I = 5'd8, J = 5'd9, K = 5'd10, L = 5'd11, M = 5'd12, N = 5'd13, 
			O = 5'd14, P = 5'd15, Q = 5'd16, R = 5'd17, S = 5'd18, T = 5'd19, U = 5'd20, V = 5'd21, W = 5'd22, X = 5'd23, Y = 5'd24, Z = 5'd25;

	reg [4:0]curr_position;
	wire [51:0]offseti;
	wire [51:0]offseto;
	wire [25:0]out2;
	assign offseti = ({26'b0,in[25:0]} << curr_position);
	assign offseto = {out2[25:0],26'b0} >> curr_position;
	assign out[25:0] = (offseto[25:0] | offseto[51:26]);
	assign state = curr_position;

	initial begin
		notch <= 0;
		curr_position <= A;
	end

	rotor_wiring w1(.in(offseti[25:0] | offseti[51:26]), .out(out2[25:0]), .wiring_config(wiring_config[2:0]));

	always @(posedge rotate) // Rotational position of the rotor, not to be confused with ringsetting. 
	begin: state_table
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

	always @(*) // Notch for next rotor's turnover, based on rotor#
	begin
		if (curr_position == R && wiring_config == 3'b000)
			notch <= 1;
		else if (curr_position == F && wiring_config == 3'b001)
			notch <= 1;
		else if (curr_position == W && wiring_config == 3'b010)
			notch <= 1;
		else
			notch <= 0;
	end	
endmodule



module rotor_wiring (in, out, wiring_config);
	input wire [25:0]in;
	input [2:0]wiring_config; 
	output wire [25:0]out;

	localparam I = 3'b000, II = 3'b001, III = 3'b010, rI = 3'b100, rII = 3'b101, rIII = 3'b110;

	assign out[0] = wiring_config == I ? in[20] : wiring_config == II ? in[0] : wiring_config == III ? in[19] : wiring_config == rI ? in[4] : wiring_config == rII ? in[0] : wiring_config == rIII ? in[1] : in[0];
	assign out[1] = wiring_config == I ? in[22] : wiring_config == II ? in[9] : wiring_config == III ? in[0] : wiring_config == rI ? in[10] : wiring_config == rII ? in[9] : wiring_config == rIII ? in[3] : in[1];
	assign out[2] = wiring_config == I ? in[24] : wiring_config == II ? in[15] : wiring_config == III ? in[6] : wiring_config == rI ? in[12] : wiring_config == rII ? in[3] : wiring_config == rIII ? in[5] : in[2];
	assign out[3] = wiring_config == I ? in[6] : wiring_config == II ? in[2] : wiring_config == III ? in[1] : wiring_config == rI ? in[5] : wiring_config == rII ? in[10] : wiring_config == rIII ? in[7] : in[3];
	assign out[4] = wiring_config == I ? in[0] : wiring_config == II ? in[25] : wiring_config == III ? in[15] : wiring_config == rI ? in[11] : wiring_config == rII ? in[18] : wiring_config == rIII ? in[9] : in[4];
	assign out[5] = wiring_config == I ? in[3] : wiring_config == II ? in[22] : wiring_config == III ? in[2] : wiring_config == rI ? in[6] : wiring_config == rII ? in[8] : wiring_config == rIII ? in[11] : in[5];
	assign out[6] = wiring_config == I ? in[5] : wiring_config == II ? in[17] : wiring_config == III ? in[18] : wiring_config == rI ? in[3] : wiring_config == rII ? in[17] : wiring_config == rIII ? in[2] : in[6];
	assign out[7] = wiring_config == I ? in[15] : wiring_config == II ? in[11] : wiring_config == III ? in[3] : wiring_config == rI ? in[16] : wiring_config == rII ? in[20] : wiring_config == rIII ? in[15] : in[7];
	assign out[8] = wiring_config == I ? in[21] : wiring_config == II ? in[5] : wiring_config == III ? in[16] : wiring_config == rI ? in[21] : wiring_config == rII ? in[23] : wiring_config == rIII ? in[17] : in[8];
	assign out[9] = wiring_config == I ? in[25] : wiring_config == II ? in[1] : wiring_config == III ? in[4] : wiring_config == rI ? in[25] : wiring_config == rII ? in[1] : wiring_config == rIII ? in[19] : in[9];
	assign out[10] = wiring_config == I ? in[1] : wiring_config == II ? in[3] : wiring_config == III ? in[20] : wiring_config == rI ? in[13] : wiring_config == rII ? in[11] : wiring_config == rIII ? in[23] : in[10];
	assign out[11] = wiring_config == I ? in[4] : wiring_config == II ? in[10] : wiring_config == III ? in[5] : wiring_config == rI ? in[19] : wiring_config == rII ? in[7] : wiring_config == rIII ? in[21] : in[11];
	assign out[12] = wiring_config == I ? in[2] : wiring_config == II ? in[14] : wiring_config == III ? in[21] : wiring_config == rI ? in[14] : wiring_config == rII ? in[22] : wiring_config == rIII ? in[25] : in[12];
	assign out[13] = wiring_config == I ? in[10] : wiring_config == II ? in[19] : wiring_config == III ? in[13] : wiring_config == rI ? in[22] : wiring_config == rII ? in[19] : wiring_config == rIII ? in[13] : in[13];
	assign out[14] = wiring_config == I ? in[12] : wiring_config == II ? in[24] : wiring_config == III ? in[25] : wiring_config == rI ? in[24] : wiring_config == rII ? in[12] : wiring_config == rIII ? in[24] : in[14];
	assign out[15] = wiring_config == I ? in[19] : wiring_config == II ? in[20] : wiring_config == III ? in[7] : wiring_config == rI ? in[7] : wiring_config == rII ? in[2] : wiring_config == rIII ? in[4] : in[15];
	assign out[16] = wiring_config == I ? in[7] : wiring_config == II ? in[16] : wiring_config == III ? in[24] : wiring_config == rI ? in[23] : wiring_config == rII ? in[16] : wiring_config == rIII ? in[8] : in[16];
	assign out[17] = wiring_config == I ? in[23] : wiring_config == II ? in[6] : wiring_config == III ? in[8] : wiring_config == rI ? in[20] : wiring_config == rII ? in[6] : wiring_config == rIII ? in[22] : in[17];
	assign out[18] = wiring_config == I ? in[18] : wiring_config == II ? in[4] : wiring_config == III ? in[23] : wiring_config == rI ? in[18] : wiring_config == rII ? in[25] : wiring_config == rIII ? in[6] : in[18];
	assign out[19] = wiring_config == I ? in[11] : wiring_config == II ? in[13] : wiring_config == III ? in[9] : wiring_config == rI ? in[15] : wiring_config == rII ? in[13] : wiring_config == rIII ? in[0] : in[19];
	assign out[20] = wiring_config == I ? in[17] : wiring_config == II ? in[7] : wiring_config == III ? in[22] : wiring_config == rI ? in[0] : wiring_config == rII ? in[15] : wiring_config == rIII ? in[10] : in[20];
	assign out[21] = wiring_config == I ? in[8] : wiring_config == II ? in[23] : wiring_config == III ? in[11] : wiring_config == rI ? in[8] : wiring_config == rII ? in[24] : wiring_config == rIII ? in[12] : in[21];
	assign out[22] = wiring_config == I ? in[13] : wiring_config == II ? in[12] : wiring_config == III ? in[17] : wiring_config == rI ? in[1] : wiring_config == rII ? in[5] : wiring_config == rIII ? in[20] : in[22];
	assign out[23] = wiring_config == I ? in[16] : wiring_config == II ? in[8] : wiring_config == III ? in[10] : wiring_config == rI ? in[17] : wiring_config == rII ? in[21] : wiring_config == rIII ? in[18] : in[23];
	assign out[24] = wiring_config == I ? in[14] : wiring_config == II ? in[21] : wiring_config == III ? in[14] : wiring_config == rI ? in[2] : wiring_config == rII ? in[14] : wiring_config == rIII ? in[16] : in[24];
	assign out[25] = wiring_config == I ? in[9] : wiring_config == II ? in[18] : wiring_config == III ? in[12] : wiring_config == rI ? in[9] : wiring_config == rII ? in[4] : wiring_config == rIII ? in[14] : in[25];
	
	/*
	always@(*)
	begin
		if (wiring_config == 3'b000)
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
		else if (wiring_config == 3'b001)
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
		else if (wiring_config == 3'b010)
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
		else if (wiring_config == 3'b100)
		begin
			out[0] <= in[4];
			out[1] <= in[10];
			out[2] <= in[12];
			out[3] <= in[5];
			out[4] <= in[11];
			out[5] <= in[6];
			out[6] <= in[3];
			out[7] <= in[16];
			out[8] <= in[21];
			out[9] <= in[25];
			out[10] <= in[13];
			out[11] <= in[19];
			out[12] <= in[14];
			out[13] <= in[22];
			out[14] <= in[24];
			out[15] <= in[7];
			out[16] <= in[23];
			out[17] <= in[20];
			out[18] <= in[18];
			out[19] <= in[15];
			out[20] <= in[0];
			out[21] <= in[8];
			out[22] <= in[1];
			out[23] <= in[17];
			out[24] <= in[2];
			out[25] <= in[9];
		end
		else if (wiring_config == 3'b101)
		begin
			out[0] <= in[0];
			out[1] <= in[9];
			out[2] <= in[3];
			out[3] <= in[10];
			out[4] <= in[18];
			out[5] <= in[8];
			out[6] <= in[17];
			out[7] <= in[20];
			out[8] <= in[23];
			out[9] <= in[1];
			out[10] <= in[11];
			out[11] <= in[7];
			out[12] <= in[22];
			out[13] <= in[19];
			out[14] <= in[12];
			out[15] <= in[2];
			out[16] <= in[16];
			out[17] <= in[6];
			out[18] <= in[25];
			out[19] <= in[13];
			out[20] <= in[15];
			out[21] <= in[24];
			out[22] <= in[5];
			out[23] <= in[21];
			out[24] <= in[14];
			out[25] <= in[4];
		end
		else if (wiring_config == 3'b110)
		begin
			out[0] <= in[1];
			out[1] <= in[3];
			out[2] <= in[5];
			out[3] <= in[7];
			out[4] <= in[9];
			out[5] <= in[11];
			out[6] <= in[2];
			out[7] <= in[15];
			out[8] <= in[17];
			out[9] <= in[19];
			out[10] <= in[23];
			out[11] <= in[21];
			out[12] <= in[25];
			out[13] <= in[13];
			out[14] <= in[24];
			out[15] <= in[4];
			out[16] <= in[8];
			out[17] <= in[22];
			out[18] <= in[6];
			out[19] <= in[0];
			out[20] <= in[10];
			out[21] <= in[12];
			out[22] <= in[20];
			out[23] <= in[18];
			out[24] <= in[16];
			out[25] <= in[14];
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
	*/
endmodule

