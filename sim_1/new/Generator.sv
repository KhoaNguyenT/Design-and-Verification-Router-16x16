`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/26/2024 11:51:41 AM
// Design Name: Generator
// Module Name: Generator
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

//Task 8: Fill in Generator Class start () Method
`ifndef INC_GENERATOR_SV
`define INC_GENERATOR_SV
//int run_for_n_packets = 15;
//int TRACE_ON = 1; //1 to fix error
class Generator;
    string  name;		// unique identifier
    Packet  pkt2send;	// stimulus Packet object
    pkt_mbox out_box[];	// mailbox to Drivers
    int count_time;
    
    extern function new(input string name = "Generator", input int count_time = 0);
    extern function gen();
    extern virtual task start();
    extern function display(input string prefix = "NOTE");
endclass: Generator

function Generator::new(input string name = "Generator", input int count_time = 0);
    if (TRACE_ON) $display("[TRACE] new Generator operation:s %t %s:%m", $realtime, name);
    this.name = name;
    this.pkt2send = new();
    this.out_box = new[16];
    this.count_time = count_time;
    foreach(this.out_box[i])
        this.out_box[i] = new();
endfunction: new 
  
function Generator::gen();
//    Packet random;
    static int pkts_generated = 0;// Counter Generated packet
    if (TRACE_ON) $display("[TRACE]gen operation: %t %s:%m", $realtime, name);
    pkt2send.name = $sformatf("Packet[%0d]", pkts_generated++);
    if (!pkt2send.randomize()) begin
        $display("\n%m\n[ERROR]%t Randomization Failed!\n", $realtime);
        $finish;
    end
endfunction: gen

task Generator::start();
    // Trace statement
    if (TRACE_ON) $display("[TRACE] %t %s: Starting Generator operation", $realtime, name);
    // Non-blocking fork-join block
    fork
        begin
            // Infinite loop or loop for a specified number of packets
            for (int i = 0;run_for_n_packets <= 0 || i < run_for_n_packets; i++) begin
                // Call gen() to generate a Packet object
                gen();
                // Create a copy of the randomized Packet object
                begin
//                    Packet copypkt = new();
                    Packet copypkt = new pkt2send;
                    // Deposit the copy of the Packet object into Drivers' out_box mailboxes
                    out_box[copypkt.sa].put(copypkt);
                    if(this.count_time < out_box[copypkt.sa].num()) this.count_time = out_box[copypkt.sa].num();
                end
            end
        end
    join
endtask: start

function Generator:: display(input string prefix = "NOTE");
    $display("%s Generator Info:", prefix);
    pkt2send.display(prefix);
    $display("Output Mailbox: %s", out_box);
endfunction   
`endif