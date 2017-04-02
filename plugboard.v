module plugboardchanger(in, out, changeto, change);
    input [25:0] in;
    input [25:0] changeto;
    input change;
    
    output [25:0] out;
    reg out;
    
    always @(*)
    
	begin
	    if (change)
		out = changeto;
	    else
		out = in;
	end
endmodule

