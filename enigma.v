module enigma (in, out, changeto, change, wheel_config);

    input [25:0] in;
    input change;
    input [25:0] changeto;
    input [2:0] wheel_config;
    
    wire [25:0] w1;
    
    output [25:0] out;
    
    plugboardChanger plugboard (.in(in), .out(w1), .changeto(changeto), .change(change));
    rero rotors_reflector(.in(w1), .out(out), .wheel_config(wheel_config));

endmodule