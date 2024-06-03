`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2024 10:09:58 PM
// Design Name: 
// Module Name: router_test_pkg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

package router_test_pkg;
    int run_for_n_packets = 10;
    int TRACE_ON = 1; //1 to fix error
   
    `include "Packet.sv"
    `include "Driver.sv"
    `include "Receiver.sv"
    `include "Generator.sv"
    `include "Scoreboard.sv"
endpackage: router_test_pkg
