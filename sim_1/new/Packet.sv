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
int run_for_n_packets = 5;
int TRACE_ON = 1; //1 to fix error
class Packet;
    rand bit[3:0] sa, da;// 4bit
    rand logic [7:0] payload[$];
    string name; 
    
// Define Packet Property Constraints 
    constraint sa_da {
        sa inside {[0:15]};
        da inside {0,1};
    }//The value is bound from 0 to 15
    constraint payload_size {
        payload.size() inside {1};
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
function bit Packet::compare(Packet pkt2cmp, ref string message);
    if (payload == null || pkt2cmp.payload == null) begin
        message = "Null payload detected.\n";
        return (0);
    end
  
    if (payload.size() != pkt2cmp.payload.size()) begin
        message = "Payload Size Mismatch:\n";
        return(0);
    end
    if (payload == pkt2cmp.payload);
    else begin
        message = "Payload Content Mismatch:\n";
        return(0);
    end
    message = "Successfully Compared";
    return(1);
endfunction

// Define Packet display () Method 
function void Packet::display(input string prefix = "NOTE");
    $display("[%s]%s sa = %0d, da = %0d", prefix, name, sa, da);
    foreach(payload[i])
        $display("[%s]%s payload[%0d] = %8b", prefix, name, i, payload[i]);
endfunction

typedef mailbox #(Packet) pkt_mbox;// Used in task 2 - 1 mang chieu FIFO voi moi gia tri la packet
`endif