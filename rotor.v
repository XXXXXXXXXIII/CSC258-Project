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
	input [4:0]in;
	input [1:0]wiring_config;
	output reg [4:0]out;

	localparam A = 5'd0, B = 5'd1, C = 5'd2, D = 5'd3, E = 5'd4, F = 5'd5, G = 5'd6, H = 5'd7, I = 5'd8, J = 5'd9, K = 5'd10, L = 5'd11, M = 5'd12, N = 5'd13, 
			O = 5'd14, P = 5'd15, Q = 5'd16, R = 5'd17, S = 5'd18, T = 5'd19, U = 5'd20, V = 5'd21, W = 5'd22, X = 5'd23, Y = 5'd24, Z = 5'd25;

	always@(*)
	begin
		if (wiring_config == 2'b00)
		begin
			case(in)
				A: out = E;
				B: out = K;
				C: out = M;
				D: out = F;
				E: out = L;
				F: out = G;
				H: out = D;
				H: out = Q;
				I: out = V;
				J: out = Z;
				K: out = N;
				L: out = T;
				M: out = O;
				N: out = W;
				O: out = Y;
				P: out = H;
				Q: out = X;
				R: out = U;
				S: out = S;
				T: out = P;
				U: out = A;
				V: out = I;
				W: out = B;
				X: out = R;
				Y: out = C;
				Z: out = J;
				default: out = 1;
			endcase
		end
		else if (wiring_config == 2'b01)
		begin
			case(in)
				A: out = A;
				B: out = J;
				C: out = D;
				D: out = K;
				E: out = S;
				F: out = I;
				H: out = R;
				H: out = U;
				I: out = X;
				J: out = B;
				K: out = L;
				L: out = H;
				M: out = W;
				N: out = T;
				O: out = M;
				P: out = C;
				Q: out = Q;
				R: out = G;
				S: out = Z;
				T: out = N;
				U: out = P;
				V: out = Y;
				W: out = F;
				X: out = V;
				Y: out = O;
				Z: out = E;
				default: out = 1;
			endcase
		end
		else if (wiring_config == 2'b10)
		begin
			case(in)
				A: out = B;
				B: out = D;
				C: out = F;
				D: out = H;
				E: out = J;
				F: out = L;
				H: out = C;
				H: out = P;
				I: out = R;
				J: out = T;
				K: out = X;
				L: out = V;
				M: out = Z;
				N: out = N;
				O: out = Y;
				P: out = E;
				Q: out = I;
				R: out = W;
				S: out = G;
				T: out = A;
				U: out = K;
				V: out = M;
				W: out = U;
				X: out = S;
				Y: out = Q;
				Z: out = O;
				default: out = 1;
			endcase
		end
	end
endmodule

