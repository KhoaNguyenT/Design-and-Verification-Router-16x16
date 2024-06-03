`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Priority arbitrate
// Module Name: output_arbitrate
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

module output_arbitrate(
    input [3:0] addr,
    input [15:0] busy,
    output reg busy_state 
    );
    
    always @(*) begin
        case(addr)
            4'b0000: busy_state = busy[0];
            4'b0001: busy_state = busy[1];
            4'b0010: busy_state = busy[2];
            4'b0011: busy_state = busy[3];
            4'b0100: busy_state = busy[4];
            4'b0101: busy_state = busy[5];
            4'b0110: busy_state = busy[6];
            4'b0111: busy_state = busy[7];
            4'b1000: busy_state = busy[8];
            4'b1001: busy_state = busy[9];
            4'b1010: busy_state = busy[10];
            4'b1011: busy_state = busy[11];
            4'b1100: busy_state = busy[12];
            4'b1101: busy_state = busy[13];
            4'b1110: busy_state = busy[14];
            4'b1111: busy_state = busy[15];
        endcase 
    end
endmodule
