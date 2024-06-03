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
`ifndef INC_DRIVERBASE_SV
`define INC_DRIVERBASE_SV
class DriverBase;
    virtual router_io.TB rtr_io; //interface signal
    string name; // unique identifier
    bit[3: 0] sa, da; // source and destination addresses
    logic [7:0] payload[$] ; // Packet payload
    Packet pkt2send; // stimulus Packet object
    // show info :D
    extern function void display(input string prefix = "NOTE");
////    
    extern function new(input string name = "DriverBase", virtual router_io.TB rtr_io);
    extern virtual task send();
    extern virtual task send_addrs();
    extern virtual task send_pad();
    extern virtual task send_payload();
endclass: DriverBase

function DriverBase:: display(input string prefix = "NOTE");
    $display("%s DriverBase Info:", prefix);
    $display("Source Address DriverBase: %0d, Destination Address DriverBase: %0d", sa, da);
    $display("Payload DriverBase: %0d", payload.size());
    $display("Name DriverBase: %s", name);
    // Display stimulus Packet object info
    $display("Packet to Send:");
    pkt2send.display(prefix);
endfunction: display

////
function DriverBase::new(string name, virtual router_io.TB rtr_io);
    if (TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    this.name   = name;
    this.rtr_io = rtr_io;
endfunction: new

task DriverBase::send();
    if (TRACE_ON) $display("[TRACE] SENDING %t %s:%m", $realtime, name);
    send_addrs();
    send_pad();
    send_payload();
endtask: send

task DriverBase::send_addrs();
    if (TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    rtr_io.cb.frame_n[sa] <= 1'b0;
    for(int i=0; i < 4; i++) begin
        rtr_io.cb.din[sa] <= da[3-i];
        @(rtr_io.cb);
    end
    
endtask: send_addrs

task DriverBase::send_pad();
    if (TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    rtr_io.cb.din[sa] <= 1'bx;
    rtr_io.cb.valid_n[sa] <= 1'b1;
    repeat(4) @(rtr_io.cb);
endtask: send_pad

task DriverBase::send_payload();
    if (TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    foreach(payload[index]) begin
        for(int i=0; i<8; i++) begin
            rtr_io.cb.din[sa] <= payload[index][7-i];
            rtr_io.cb.valid_n[sa] <= 1'b0;
            rtr_io.cb.frame_n[sa] <= ((index == (payload.size() - 1)) && (i == 7));
            @(rtr_io.cb);
        end
        rtr_io.cb.din[sa] <= 1'bx;
        rtr_io.cb.valid_n[sa] <= 1'b1;
        rtr_io.cb.frame_n[sa] <= 1'b1;
    end
endtask: send_payload
`endif