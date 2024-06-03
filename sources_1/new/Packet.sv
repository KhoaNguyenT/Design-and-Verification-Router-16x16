`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/25/2024 01:12:16 PM
// Design Name: Packet
// Module Name: Packet
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

//Task 1: Create a Packet Class File
`ifndef INC_PACKET_SV
// Macro is given anyname to point to a block of functions
// if macro INC_PACJKET_SV is define?
`define INC_PACKET_SV
class Packet;
    rand bit[3:0] sa, da;// 4bit
    rand logic [7:0] payload[$];
    string name; 
    
// Define Packet Property Constraints 
    constraint sa_da {
        sa inside {[0:15]};
        da inside {[0:15]};
    }//The value is bound from 0 to 15
    constraint payload_size {
        payload.size() inside {[2:4]};
    }
    
// Define Packet Class Method Prototypes 
    extern function new(input string name = "Packet");
    extern function bit compare(Packet pkt2cmp, ref string message);
    extern function void display(input string prefix = "NOTE");
endclass: Packet

// Define Packet Class new () Constructor 
function Packet::new (input string name);
    this.name = name;
endfunction: new 

// Define Packet compare () Method 
function Packet::compare(Packet pkt2cmp, ref string message);
    //Content compare
endfunction: compare

// Define Packet display () Method 
function Packet::display(input string prefix = "NOTE");
    $display("%s Packet Info:", prefix);
    $display("Source Address Packet: %0h, Destination Address Packet: %0h", sa, da);
    $display("Payload Packet: %s", payload);
    $display("Name Packet: %s", name);
endfunction: display

typedef mailbox #(Packet) pkt_mbox;// Used in task 2

//function Packet pkt_mbox::get();
//    Packet pkt;
//    // Logic to get a Packet object from the mbox
//    return pkt;
//endfunction

//function void pkt_mbox::put(Packet pkt);
//    // Logic to put a Packet object into the mbox
//endfunction

`endif

