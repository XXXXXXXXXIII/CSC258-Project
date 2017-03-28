// emulating UKW (7 February 1941): 
module reflector(in, out);

    input [25:0] in;
    output [25:0] out;

            // A            Q
            assign out[0] = in[16];
            // B            Y
            assign out[1] = in[24];
            // C            H
            assign out[2] = in[7];
            // D            O
            assign out[3] = in[14];
            // E            G
            assign out[4] = in[6];
            // F            N
            assign out[5] = in[13];
            // G            E
            assign out[6] = in[4];
            // H            C
            assign out[7] = in[2];
            // I            V
            assign out[8] = in[21];
            // J            P
            assign out[9] = in[15];
            // K            U
            assign out[10] = in[20];
            // L            Z
            assign out[11] = in[25];
            // M            T
            assign out[12] = in[19];
            // N            F
            assign out[13] = in[5];
            // O            D
            assign out[14] = in[3];
            // P            J
            assign out[15] = in[9];
            // Q            A
            assign out[16] = in[0];
            // R            X
            assign out[17] = in[23];
            // S            W
            assign out[18] = in[22];
            // T            M
            assign out[19] = in[12];
            // U            K
            assign out[20] = in[10];
            // V            I
            assign out[21] = in[8];
            // W            S
            assign out[22] = in[18];
            // X            R
            assign out[23] = in[17];
            // Y            B
            assign out[24] = in[1];
            // Z            L
            assign out[25] = in[11];
endmodule