<<<<<<< df4d4ac2da9978d6a97a09903152063bfe1ec153
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
=======
module plugboardChanger(INPUT, OUTPUT, CHANGETO, CHANGE);

    input [25:0] INPUT;
    input [25:0] CHANGETO;
    input CHANGE;
    
    output [25:0] OUTPUT;
    reg OUTPUT;
    
    always @(*)
	begin
	    if (CHANGE)
		OUTPUT = CHANGETO;
	    else
		OUTPUT = INPUT;
	end
    
endmodule
>>>>>>> more files
