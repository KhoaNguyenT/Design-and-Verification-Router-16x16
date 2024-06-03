`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Top level TestBench
// Module Name: Router_Test_Top
// Project Name: Router16x16
// Target Devices: 
// Tool Versions: 
// Description: From Khoa with love
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Router_Test_Top;
    parameter simulation_cycle = 20;
    bit SystemClock, reset_n, reset_complete;
    logic [15:0] din, valid_n, frame_n, dout, valido_n, frameo_n, busy;
    
    router_io top_io(SystemClock);
    Test Run_Router(top_io.TB);
    
    assign reset_n = top_io.reset_n;
    assign din = top_io.din;
    assign valid_n = top_io.valid_n;
    assign frame_n = top_io.frame_n;
    assign dout = top_io.dout;
    assign valido_n = top_io.valido_n;
    assign frameo_n = top_io.frameo_n;
    assign busy = top_io.busy_state;
    
    Router16x16 dut  (
                        .clock(SystemClock),
                        .reset_n(top_io.reset_n), 
                        .din(top_io.din),
                        .valid_n(top_io.valid_n),
                        .frame_n(top_io.frame_n),
                        .dout(top_io.dout),
                        .valido_n(top_io.valido_n),
                        .frameo_n(top_io.frameo_n),
                        .busy_n(top_io.busy_state)
                    );
                    
    initial begin
        SystemClock = 0;
        forever begin 
            #(simulation_cycle/2) SystemClock = ~SystemClock;
        end
    end
endmodule