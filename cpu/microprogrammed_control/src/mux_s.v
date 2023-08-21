
module mux_s(
input               [2:0]        i_ms,
input                            i_n,
input                            i_z,
input                            i_v,
input                            i_c,
output    reg                    o_ms
    );
    
always@*
    case(i_ms)
        3'b111     :       o_ms    =       ~i_z;
        3'b110     :       o_ms    =       ~i_c;
        3'b101     :       o_ms    =        i_n;
        3'b100     :       o_ms    =        i_z;
        3'b011     :       o_ms    =        i_v;
        3'b010     :       o_ms    =        i_c;
        3'b001     :       o_ms    =        1'b1;
        default    :       o_ms    =        1'b0;
    endcase
    
endmodule
