`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Router1x16
// Module Name: Router
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

// control pins:
// input: reset_n	- active low reset
// input: clock		- master clock input

// input port pins:
// input: frame_n	- must be active during whole input packet
// input: valid_n	- valid data input
// input: din		- the data input

// output port pins:
// output: dout		- the data output
// output: valido_n	- tells output device that "do" contain valid data
// output: frameo_n	- active during the whole output packet

//busy_state        - Is the output port receiving another input port?

// frame format:
//
// Frame start must look like this:
//
// din:		|  X | A0 | A1 | A2 | A3 |  1 |  X |  X |  X | D0  | ...
// valid_n:	|  X |  X |  X |  X |  X |  X |  1 |  1 |  1 | 0/1 | ...
// frame_n:	|  1 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0 |  0  | ...

// note1: frame_n must deasserted at least one cycle between packets.
// note2: address data does not have to wait for busy_n = 1.
// note3: di must wait for busy_n = 1.
// note4: a di is taken by the chip if:  busy_n == 1 && valid_n == 0
// note5: frame_n must be deasserted with the last data bit in the frame.
// note6: once connection is successfully made, busy_n is guaranteed to
//stay inactive until to the end of the current frame.


module Router(reset_n, clock, din, valid_n, frame_n, addr_isok, dout, valido_n, frameo_n, busy_n,addr_o);
input reset_n;
input clock;
// input port pins:
input  din, valid_n, frame_n;
input   addr_isok;   // output port valid?
// output port pins:
output reg [15:0] dout, valido_n, frameo_n,busy_n;
output [3:0] addr_o ; // address of output port


reg [3:0] State_bit = 4'b1111;
reg [3:0] Address_out = 4'bx;
reg first = 1'b1;
reg [3:0]i = 0;
// parameter
//make simple:
assign addr_o = Address_out;
assign reset = ~reset_n;

//SOURCE CODE
always @(posedge clock or posedge reset_n) begin
    if (reset_n == 0) begin
        repeat(16) begin
            dout[i] = 1'bx;
            valido_n[i] = 1'bx;
            frameo_n[i] = 1'b1;
            busy_n[i] = 1'b0; 
            State_bit = 4'b1111; 
            first = 1'b1;
            i = i + 1;
        end
    end
    else begin
        //Start sending packed
        if (State_bit == 4'b1111) begin
            dout[Address_out] = 1'bx;
            valido_n[Address_out] = 1'bx;
            frameo_n[Address_out] = 1'b1;
            busy_n[Address_out] = 0;
            Address_out = 4'bx;
        end
        if (frame_n == 0) begin
            State_bit = State_bit + 1;
            first = 0;
            // Address and Padding
            if (State_bit >= 0 && State_bit <= 7) 
                begin
                //Get Address of Port Out
                if (State_bit >= 0 && State_bit <= 3) 
                begin
                    Address_out[3-State_bit] =  din;
                end
                //Starting get input port
                else begin
                    // Padding Stage
                    //check if outport is valid at state 3
                    if(addr_isok == 0 && State_bit >= 5 && State_bit <= 7)begin
                        State_bit = 4;
                    end
                    if(State_bit == 4) //busy = 1 at state 4
                        busy_n[Address_out] = 1;
                end
            end
            // Port Out Active
            else if (State_bit >= 8 && State_bit <= 15 && addr_isok == 1)begin
                frameo_n[Address_out] = 0;
                valido_n[Address_out] = valid_n;
                // Data In Invalid
                if (valid_n == 1) begin
                    //Wait 1 clock to handle invalid bit
                    State_bit = State_bit - 1;
                    dout[Address_out] = 1'bx;
                end
                // Data In valid
                else if (valid_n == 0) begin
                    dout[Address_out] = din;
                end
            end
        end
        //End sending packed
        else if (frame_n == 1 && State_bit >= 8 && State_bit <= 15) begin
            State_bit = State_bit + 1;
            frameo_n[Address_out] = 1;
            valido_n[Address_out] = valid_n;
            //Checking last bit data
            if (valid_n == 1) begin
                //Wait 1 clock to handle invalid bit
                State_bit = State_bit - 1;
                dout[Address_out] = 1'bx;
            end
            // Data In valid
            else if (valid_n == 0) begin
                dout[Address_out] = din;
            end
        end
    end
end

endmodule
