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
