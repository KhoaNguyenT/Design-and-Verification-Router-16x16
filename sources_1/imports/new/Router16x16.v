`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Router16x16
// Module Name: Router16x16
// Project Name: Router16x16
// Target Devices: 
// Tool Versions: 
// Description: From Khoa with love
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Router16x16(reset_n, clock, din, valid_n, frame_n, dout, valido_n, frameo_n, busy_n);
// control pins:
input reset_n;
input clock;

// input port pins:
input [15:0] din, valid_n, frame_n;

// output port pins:
output reg [15:0] valido_n, dout; 
output [15:0] frameo_n, busy_n;
//Handling signal output
wire [15:0] temp_dout [15:0];
wire [15:0] temp_valido_n [15:0];
wire [15:0] temp_frameo_n [15:0];
wire [15:0] temp_busy_n [15:0];
wire [15:0] temp_valido_n_1, temp_valido_n_0;
wire [15:0] temp_dout_1, temp_dout_0;

wire [3:0] addr_outport [15:0]; //addr check
reg [3:0] arbitrate[15:0];
reg [15:0] addr_valid; // outport valid of 16 router
Router In0(reset_n, clock, din[0], valid_n[0], frame_n[0], addr_valid[0], temp_dout[0], temp_valido_n[0], temp_frameo_n[0], temp_busy_n[0], addr_outport[0]);
Router In1(reset_n, clock, din[1], valid_n[1], frame_n[1], addr_valid[1], temp_dout[1], temp_valido_n[1], temp_frameo_n[1], temp_busy_n[1], addr_outport[1]);
Router In2(reset_n, clock, din[2], valid_n[2], frame_n[2], addr_valid[2], temp_dout[2], temp_valido_n[2], temp_frameo_n[2], temp_busy_n[2], addr_outport[2]);
Router In3(reset_n, clock, din[3], valid_n[3], frame_n[3], addr_valid[3], temp_dout[3], temp_valido_n[3], temp_frameo_n[3], temp_busy_n[3], addr_outport[3]);
Router In4(reset_n, clock, din[4], valid_n[4], frame_n[4], addr_valid[4], temp_dout[4], temp_valido_n[4], temp_frameo_n[4], temp_busy_n[4], addr_outport[4]);
Router In5(reset_n, clock, din[5], valid_n[5], frame_n[5], addr_valid[5], temp_dout[5], temp_valido_n[5], temp_frameo_n[5], temp_busy_n[5], addr_outport[5]);
Router In6(reset_n, clock, din[6], valid_n[6], frame_n[6], addr_valid[6], temp_dout[6], temp_valido_n[6], temp_frameo_n[6], temp_busy_n[6], addr_outport[6]);
Router In7(reset_n, clock, din[7], valid_n[7], frame_n[7], addr_valid[7], temp_dout[7], temp_valido_n[7], temp_frameo_n[7], temp_busy_n[7], addr_outport[7]);
Router In8(reset_n, clock, din[8], valid_n[8], frame_n[8], addr_valid[8], temp_dout[8], temp_valido_n[8], temp_frameo_n[8], temp_busy_n[8], addr_outport[8]);
Router In9(reset_n, clock, din[9], valid_n[9], frame_n[9], addr_valid[9], temp_dout[9], temp_valido_n[9], temp_frameo_n[9], temp_busy_n[9], addr_outport[9]);
Router In10(reset_n, clock, din[10], valid_n[10], frame_n[10], addr_valid[10], temp_dout[10], temp_valido_n[10], temp_frameo_n[10], temp_busy_n[10], addr_outport[10]);
Router In11(reset_n, clock, din[11], valid_n[11], frame_n[11], addr_valid[11], temp_dout[11], temp_valido_n[11], temp_frameo_n[11], temp_busy_n[11], addr_outport[11]);
Router In12(reset_n, clock, din[12], valid_n[12], frame_n[12], addr_valid[12], temp_dout[12], temp_valido_n[12], temp_frameo_n[12], temp_busy_n[12], addr_outport[12]);
Router In13(reset_n, clock, din[13], valid_n[13], frame_n[13], addr_valid[13], temp_dout[13], temp_valido_n[13], temp_frameo_n[13], temp_busy_n[13], addr_outport[13]);
Router In14(reset_n, clock, din[14], valid_n[14], frame_n[14], addr_valid[14], temp_dout[14], temp_valido_n[14], temp_frameo_n[14], temp_busy_n[14], addr_outport[14]);
Router In15(reset_n, clock, din[15], valid_n[15], frame_n[15], addr_valid[15], temp_dout[15], temp_valido_n[15], temp_frameo_n[15], temp_busy_n[15], addr_outport[15]);

//Handling signal Output
assign temp_dout_0 = temp_dout[0] & temp_dout[1] & temp_dout[2] & temp_dout[3] & temp_dout[4] & temp_dout[5] 
                    & temp_dout[6] & temp_dout[7] & temp_dout[8] & temp_dout[9] & temp_dout[10] 
                    & temp_dout[11] & temp_dout[12] & temp_dout[13] & temp_dout[14] & temp_dout[15];
                    //AND tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
                    //=> s? d?ng AND ?? l?y ra bit 0 và x c?a dout trên n?n bit 1, 0, x
                    
assign temp_dout_1 =  temp_dout[0] | temp_dout[1] | temp_dout[2] | temp_dout[3] | temp_dout[4] | temp_dout[5] 
                    | temp_dout[6] | temp_dout[7] | temp_dout[8] | temp_dout[9] | temp_dout[10] 
                    | temp_dout[11] | temp_dout[12] | temp_dout[13] | temp_dout[14] | temp_dout[15];
                    //OR tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
                    //=> s? d?ng OR ?? l?y ra bit 1 và x c?a dout trên n?n bit 1, 0, x
                    
assign temp_valido_n_0 = temp_valido_n[0] & temp_valido_n[1] & temp_valido_n[2] & temp_valido_n[3] & temp_valido_n[4] & temp_valido_n[5] 
                    & temp_valido_n[6] & temp_valido_n[7] & temp_valido_n[8] & temp_valido_n[9] & temp_valido_n[10] 
                    & temp_valido_n[11] & temp_valido_n[12] & temp_valido_n[13] & temp_valido_n[14] & temp_valido_n[15];
                    //AND tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
                    //=> s? d?ng AND ?? l?y ra bit 0 và x c?a valido trên n?n bit 1, 0, x
                    
assign temp_valido_n_1 = temp_valido_n[0] | temp_valido_n[1] | temp_valido_n[2] | temp_valido_n[3] | temp_valido_n[4] | temp_valido_n[5] 
                    | temp_valido_n[6] | temp_valido_n[7] | temp_valido_n[8] | temp_valido_n[9] | temp_valido_n[10] 
                    | temp_valido_n[11] | temp_valido_n[12] | temp_valido_n[13] | temp_valido_n[14] | temp_valido_n[15];
                    //OR tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
                    //=> s? d?ng OR ?? l?y ra bit 1 và x c?a valido trên n?n bit 1, 0, x
//T?ng h?p ??u ra                                       
integer i, j;
reg [3:0] temp [15:0];
always @* begin
    for(i = 0; i < 16; i = i + 1) begin
        if(temp_dout_0[i] == 0) dout[i] = 0;
        else if(temp_dout_1[i] == 1) dout[i] = 1;
        else dout[i] = 1'bx;
        //Ki?m tra t?ng bit trong temp_dout_0 và temp_dout_1 ?? k?t h?p t?o ra dout Bi?t tr??c ch?c ch?n 
        //Bi?t tr??c ch?c ch?n không x?y ra tr??ng h?p cùng 1 index i mà temp_dout_0[i] == 0 và temp_dout_1[i] == 1
        //Cách t?ng h?p VD
        //temp_dout_0 = 00xx 00xx xxxx 0000
        //temp_dout_1 = xx1x xx11 x1x1 xxxx
        //dout        = 001x 0011 x1x1 0000
        if (temp_valido_n_0[i] == 0) valido_n[i] = 0;
        else if(temp_valido_n_1[i] == 1) valido_n[i] = 1;
        else valido_n[i] = 1'bx;
        //T??ng t? nh? gi?i quy?t dout
        for(j = 0; j < 16; j = j + 1) begin
            if (temp_busy_n[i][j]) begin
                temp[j] = i;
            end
        end
    end
    for(i = 0; i < 16; i = i + 1) addr_valid[i] = 0;
    for(i = 0; i < 16; i = i + 1) begin
//        $display(temp[i]);
        if (temp[i] !== 4'bx) begin
            addr_valid[temp[i]] = 1;
        end
    end 
end
assign frameo_n = temp_frameo_n[0] & temp_frameo_n[1] & temp_frameo_n[2] & temp_frameo_n[3] & temp_frameo_n[4] & temp_frameo_n[5]
                    & temp_frameo_n[6] & temp_frameo_n[7] & temp_frameo_n[8] & temp_frameo_n[9] & temp_frameo_n[10] 
                    & temp_frameo_n[11] & temp_frameo_n[12] & temp_frameo_n[13] & temp_frameo_n[14] & temp_frameo_n[15];
                    //AND tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
                    //=> s? d?ng AND ?? l?y ra bit 0 c?a frameo trên n?n bit 1
assign busy_n = temp_busy_n[0] | temp_busy_n[1] | temp_busy_n[2] | temp_busy_n[3] | temp_busy_n[4] | temp_busy_n[5] 
                    | temp_busy_n[6] | temp_busy_n[7] | temp_busy_n[8] | temp_busy_n[9] | temp_busy_n[10] 
                    | temp_busy_n[11] | temp_busy_n[12] | temp_busy_n[13] | temp_busy_n[14] | temp_busy_n[15];
//                    OR tu?n t? các bit c?a 16 port ?? t?ng h?p thành port cu?i cùng 
//                    => s? d?ng OR ?? l?y ra bit 1 c?a busy trên n?n bit 0
endmodule



