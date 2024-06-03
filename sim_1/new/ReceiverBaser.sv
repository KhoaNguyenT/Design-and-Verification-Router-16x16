`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: LongAnChip
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/25/2024 05:41:34 PM
// Design Name: Receiver
// Module Name: ReceiverBase
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
`ifndef INC_RECEIVERBASE_SV
`define INC_RECEIVERBASE_SV

class ReceiverBase;
    virtual router_io.TB rtr_io; //interface signal
    string name; // unique identifier
    bit[3:0] da; // source and destination addresses
    logic [7:0] pkt2cmp_payload[$] ; // Packet payload
    Packet pkt2cmp; // stimulus Packet object
    // show info :D
    extern function void display(input string prefix = "NOTE");
    ////
    extern function new(input string name = "ReceiverBase",input virtual router_io.TB rtr_io);
    extern virtual task recv();
    extern virtual task get_payload();
endclass: ReceiverBase
//initial RB
function ReceiverBase::new(input string name = "ReceiverBase", input virtual router_io.TB rtr_io);
    if (TRACE_ON) $display("[TRACE]%t %s:%m", $realtime, name);
    this.name = name;
    this.rtr_io = rtr_io;
    pkt2cmp = new();
endfunction: new 

task ReceiverBase::recv();
    static int pkt_cnt = 0; // packet counter
    if (TRACE_ON) $display("[TRACE] recv operation: %t:%s:%m", $realtime, name);
    get_payload(); // get data
    // Assign da, payload
    pkt2cmp.da = da;
    pkt2cmp.payload = pkt2cmp_payload;
    // Assign name ex: rcvdPkt[0]
    pkt2cmp.name = $sformatf("rcvdPkt[%0d]", pkt_cnt++);
endtask: recv

task ReceiverBase::get_payload();
    if (TRACE_ON) $display("[TRACE] get_payload operation: %t:%s:%m", $realtime, name);
    pkt2cmp_payload.delete(); //ensures that only the latest data is stored.
//    fork
//        begin: wd_timer_fork
//            fork: frameo_wd_timer
//                @(negedge rtr_io.cb.frameo_n[da]); // timer_out when frameo_n negedge
//                begin
//                    repeat(1000) @(rtr_io.cb); // Timer 1s
//                    $display("\n%m\n[ERROR]%t Frame signal timed out!\n", $realtime);
//                    $finish;
//                end
//            join_any: frameo_wd_timer
//        disable fork;
//        end: wd_timer_fork
//    join
    begin//    Loop for get payload
        logic [7:0] data;
        for (int i=0; i<8; i++) begin
            if (!rtr_io.cb.valido_n[da]) begin
                data[7-i] = rtr_io.cb.dout[da];
//                $display("%t da: %d  dout: %b", $realtime, da, rtr_io.cb.dout[da]);
            end
            else if (rtr_io.cb.valido_n[da]) begin
                i = i - 1;
            end
        @(rtr_io.cb);
        end
        pkt2cmp_payload.push_back(data);
        $display("pkt2cmp_payload[0]: %b",pkt2cmp_payload[0]);
    end
endtask: get_payload

function ReceiverBase:: display(input string prefix = "NOTE");
    $display("%s ReceiverBase Info:", prefix);
    $display("Destination Address ReceiverBase: %0d", da);
    $display("Payload ReceiverBase: %0d", pkt2cmp_payload.size());
    $display("Name ReceiverBase: %s", name);
    // Display stimulus Packet object info
    $display("Packet to Recv:");
    pkt2cmp.display(prefix);
endfunction: display


`endif