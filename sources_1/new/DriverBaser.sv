`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/25/2024 02:33:13 PM
// Design Name: Driver
// Module Name: DriverBase
// Project Name: Verification Components
// Target Devices: Simulators
// Tool Versions: Xilinx Vivado 2023.2.2
// Description: From Khoa with love
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Task 2: Develop Driver class
`include "Packet.sv"
class DriverBase;
    virtual router_io.TB rtr_io; //interface signal
    string name; // unique identifier
    bit[3: 0] sa, da; // source and destination addresses
    logic [7:0] payload[$] ; // Packet payload
    Packet pkt2send; // stimulus Packet object
    // show info :D
    extern function void display(input string prefix = "NOTE");
endclass: DriverBase

function DriverBase:: display(input string prefix = "NOTE");
    $display("%s DriverBase Info:", prefix);
    $display("Source Address DriverBase: %0h, Destination Address DriverBase: %0h", sa, da);
    $display("Payload DriverBase: %0d", payload.size());
    $display("Name DriverBase: %s", name);
    // Display stimulus Packet object info
    $display("Packet to Send:");
    pkt2send.display(prefix);
endfunction: display