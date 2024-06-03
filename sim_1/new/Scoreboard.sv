`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/26/2024 12:16:55 PM
// Design Name: Scoreboard
// Module Name: Scoreboard
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

`ifndef INC_SCOREBOARD_SV
`define INC_SCOREBOARD_SV
//int run_for_n_packets = 15;
int TRACE_ON = 1; //1 to fix error
class Scoreboard;
    string   name;		   // unique identifier
    event DONE;		       // flag to indicate goal reached
    Packet refPkt[$];	   // reference Packet array
    Packet pkt2send;	   // Packet object from Drivers
    Packet pkt2cmp;		   // Packet object from Receivers
    pkt_mbox driver_mbox;  // mailbox for Packet objects from Drivers
    pkt_mbox receiver_mbox;// mailbox for Packet objects from Receivers
    
    bit[3:0] sa, da;
     
     
    extern function new(input string name = "Scoreboard", input pkt_mbox driver_mbox = null, receiver_mbox = null);
    extern virtual task start();
    extern virtual task check();
endclass: Scoreboard

function Scoreboard::new(input string name = "Scoreboard", input pkt_mbox driver_mbox = null, receiver_mbox = null);
    if (TRACE_ON) $display("[TRACE]%0t %s:%m", $time, name);
    this.name = name;
    if (driver_mbox == null) driver_mbox = new(); // initial driver_mbox
    this.driver_mbox = driver_mbox;
    if (receiver_mbox == null) receiver_mbox = new(); // initial receiver_mbox
    this.receiver_mbox = receiver_mbox;
    
endfunction: new

task Scoreboard::start();
    if (TRACE_ON) $display("[TRACE]%0t starting Scoreboard %s:%m", $time, name);
    fork
        // Infinite loop for monitoring packets
        while (1) begin
//            // Wait for a Packet object to be deposited in receiver_mbox
            wait(receiver_mbox.num() > 0);
            $display("Packet Received: %d",receiver_mbox.num());
            this.receiver_mbox.get(this.pkt2cmp);
            this.pkt2cmp.display();
            while (this.driver_mbox.num()) begin
                Packet pkt;
                this.driver_mbox.get(pkt);
                this.refPkt.push_back(pkt);
                $display(refPkt.size());
            end 
            // Call the check() function to compare Packet objects
            this.check();
        end     
    join_none
endtask

task Scoreboard::check();
    int index[$];
    string message;
    static int  pkts_checked = 0;
    $display("CHECKING OPERATION");
    if (TRACE_ON) $display("[TRACE]%0t checking %s:%m", $time, name);
    index = this.refPkt.find_first_index() with (item.da == this.pkt2cmp.da);
    $display(this.refPkt.find_first_index()with (item.da == this.pkt2cmp.da));
    //Cheking Queue of Scoreboards
    if (index.size() <= 0) begin
        $display("\n%m\n[ERROR]%0t %s not found in Reference Queue\n", $time, this.pkt2cmp.name);
        this.pkt2cmp.display("ERROR");
        $finish;
    end
    
    this.pkt2send = this.refPkt[index[0]];
    this.refPkt.delete(index[0]);
//     push firt pkt in refPkt
    
    if (!this.pkt2send.compare(this.pkt2cmp, message)) begin
        $display("\n%m\n[ERROR]%0t Packet #%0d %s\n", $time, pkts_checked, message);
        this.pkt2send.display("ERROR");
        this.pkt2cmp.display("ERROR");
        $finish;
    end
    else pkts_checked = pkts_checked + 1;
    // Trigger DONE event if the number of Packet objects checked matches run_for_n_packets
    $display("pkts_checked = %d", pkts_checked);
    if ((run_for_n_packets > 0) && pkts_checked >= run_for_n_packets) begin
        $display("OHhhhhh YEAHhhhhh");
        ->this.DONE;
    end
endtask: check

`endif
