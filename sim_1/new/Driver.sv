`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/25/2024 04:20:17 PM
// Design Name: Driver
// Module Name: Driver
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
`ifndef INC_DRIVER_SV
`define INC_DRIVER_SV
`include "DriverBaser.sv"
//int run_for_n_packets = 15;
//int TRACE_ON = 1; //1 to fix error
class Driver extends DriverBase;
    pkt_mbox in_box;        // Generator mail box
    pkt_mbox out_box;       // Generator mail box
    semaphore sem[];        // Output port arbitration 1 key
    
    extern function new(input string name, input int port_id, input semaphore sem[], 
input pkt_mbox in_box, out_box, input virtual router_io.TB rtr_io);
    extern virtual task start();
    extern function void display(input string prefix = "NOTE");
endclass: Driver

//Task 3: Fill in Driver class new () method
function Driver::new(input string name, input int port_id, input semaphore sem[], 
input pkt_mbox in_box, out_box, input virtual router_io.TB rtr_io);
    // Call base class constructor
    super.new(name, rtr_io);
    
    // Trace statement
    if (TRACE_ON) $display("[TRACE] new Driver operation  %t %s:%m", $realtime, name);
    
    // Assign port_id to sa, sem[], in_box, and out_box
    this.sa = port_id;
    this.sem = sem;
    this.in_box = in_box;
    this.out_box = out_box;
endfunction: new

//Task 4: Fill in Driver Class start () Method 
task Driver::start();
     // Trace statement
     if (TRACE_ON) $display("[TRACE] %t %s: Starting Driver operation", $realtime, name);
     // Non-blocking fork-join block
     fork
        begin
            // Infinite loop6
            while (1) begin
                // Retrieve a Packet object from in_box (Generator to Diver)
                in_box.get(pkt2send);
                //GENERATOR
                // Check if sa matches this.sa
                if (pkt2send.sa != this.sa) continue;               
                // Update da and payload class properties
                this.da = pkt2send.da;
                this.payload = pkt2send.payload;
                // Use semaphore sem[] to arbitrate for access to the output port specified by da
//                sem[this.da].get(1);
                this.send_addrs();
                this.send_pad();
                sem[this.da].get(1);
                this.send_payload();
//                $display("sem[%d]: %d", this.da, sem[this.da]);
//                this.send();    
                // Deposit Packet object into out_box
//                out_box.put(pkt2send); // Assuming out_box has a put() method
                //SCOREBOARD
                sem[this.da].put(1);   
                out_box.put(pkt2send);
                pkt2send.display();
//                $display(pkt2send.name); 
            end
        end
     join_none 
endtask:start 

function void Driver::display(input string prefix = "NOTE");
    $display("\n%s Driver[%d][%d] Info:", prefix, sa, da);
    // Display additional Driver info
    $display("Input Mailbox: %h", in_box);
    $display("Output Mailbox: %h", out_box);
    $display("semaphore: %h", sem);
    // Display DriverBase info
    super.display(prefix);
endfunction: display
`endif