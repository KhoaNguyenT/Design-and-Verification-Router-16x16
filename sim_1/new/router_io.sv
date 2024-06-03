`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Interface Router
// Module Name: router_io
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

interface router_io(input bit clock);
        logic reset_n;
        logic [15:0] din;
        logic [15:0] valid_n;
        logic [15:0] frame_n;
        logic [15:0] dout;
        logic [15:0] valido_n;
        logic [15:0] frameo_n;
        logic [15:0] busy_state;
    
    clocking cb @(posedge clock);
    
        default input #0 output #0;
        output reset_n;
        output din;
        output valid_n;
        output frame_n;
        input dout;
        input valido_n;
        input frameo_n; 
        input busy_state;
    
    endclocking: cb
    modport TB(clocking cb, output reset_n);
        
endinterface: router_io
