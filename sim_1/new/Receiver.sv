`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/25/2024 05:39:42 PM
// Design Name: Receiver
// Module Name: Receiver
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
//Task 5: Develop Receiver Class

`ifndef INC_RECEIVER_SV
`define INC_RECEIVER_SV
`include "ReceiverBaser.sv"
//int run_for_n_packets = 15;
//int TRACE_ON = 1; //1 to fix error
class Receiver extends ReceiverBase;
    pkt_mbox out_box;	// Scoreboard mailbox

    extern function new(input string name = "Receiver", input int port_id, pkt_mbox out_box, input virtual router_io.TB rtr_io);
    extern virtual task start();
    extern function void display(input string prefix = "NOTE");
endclass: Receiver
    
//Task 6: Fill in Receiver Class new ()
function Receiver::new(input string name = "Receiver", input int port_id, pkt_mbox out_box, input virtual router_io.TB rtr_io);
    // Call base class constructor
    super.new(name, rtr_io);
    
    // Trace statement
    if (TRACE_ON) $display("[TRACE] Receive %t %s:%m", $realtime, name);
    
    // Assign port_id to da
    this.da = port_id;
    // Assign out_box
    this.out_box = out_box;
endfunction: new

//Task 7: Fill in Receiver Class start () Method
task Receiver::start(); 
    // Trace statement
    if (TRACE_ON) $display("[TRACE] %t %s: Starting Receiver operation", $realtime, name);
    
    // Non-blocking fork-join block
    fork
        begin
//             Infinite loop
            while (1) begin
                recv();
//                $display("HELLO MOTHER FUCKIN' %t", $realtime);
//                $display("Payload: %b", pkt2cmp_payload[0]);
                if($isunknown(pkt2cmp_payload[0])) continue;
                begin
                    Packet pkt2receive = new pkt2cmp;
                    // Deposit a copy of the Packet object into out_box
                    out_box.put(pkt2receive);
                    pkt2receive.display();
                end
            end
        end
    join_none
endtask: start

function void Receiver::display(input string prefix = "NOTE");
    $display("%t %s Receiver Info:", $realtime, prefix);
    // Display additional Driver info
    $display("Output Mailbox: %h", out_box);
    // Display ReceiverBase info
    super.display(prefix);
endfunction: display
`endif