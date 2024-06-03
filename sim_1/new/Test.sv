`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/26/2024 01:32:42 PM
// Design Name: Test
// Module Name: Test
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
program automatic Test (router_io.TB rtr_io);
    int run_for_n_packets = 5;
    int TRACE_ON = 1; //1 to fix error

    `include "Packet.sv"
    `include "Driver.sv"
    `include "Receiver.sv"
    `include "Generator.sv"
    `include "Scoreboard.sv"
    
    semaphore sem[];
    Driver drvr[];
    Receiver rcvr[];
    Generator ge; 
    Scoreboard sb;
    
    initial begin
        sem = new[16];
        drvr = new[16];
        rcvr = new[16];
        ge = new();
        sb = new();
        foreach (sem[i])
            sem[i] = new(1);
        foreach (drvr[i])
            drvr[i] = new($sformatf("drvr[%0d]", i), i, sem, ge.out_box[i], sb.driver_mbox, rtr_io);
        foreach (rcvr[i])
            rcvr[i] = new($sformatf("rcvr[%0d]", i), i, sb.receiver_mbox, rtr_io);  
        reset();
        $display("Starting");
        ge.start();
        sb.start();     
        $display("Count TIME: %d", ge.count_time);
        $display("Driver to Receiver"); 
        foreach(drvr[i]) begin 
            drvr[i].start();
        end
//        $display(ge.count_time + 1);
//        repeat(10) @(rtr_io.cb);
        
        foreach(rcvr[i]) begin
            rcvr[i].start();
        end
        
        repeat(15) @(rtr_io.cb);
        $display(sb.driver_mbox);  
        $display(sb.receiver_mbox); 
        wait(sb.DONE.triggered);
        $finish;
    end
    task reset();
        if (TRACE_ON) $display("[TRACE]%t %m", $realtime);
        rtr_io.reset_n <= 1'b0;
        rtr_io.cb.frame_n <= '1;
        rtr_io.cb.valid_n <= '1;
        repeat(1) @(rtr_io.cb);
        rtr_io.reset_n <= 1'b1;
        repeat(15) @(rtr_io.cb);
    endtask: reset
endprogram: Test
