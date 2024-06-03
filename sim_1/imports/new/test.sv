//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Nguyen Thanh Khoa
// 
// Create Date: 04/04/2024 03:28:58 PM
// Design Name: Test
// Module Name: Test
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


program automatic Test (router_io.TB rtr_io);
    logic [15:0] data_check, answer;
    
    
    
    
    task reset();
        data_check <= 16'b0;                                
        answer <= 16'b0;                                    
        
        rtr_io.cb.din <= 16'hXXXX;                 
        rtr_io.cb.valid_n <= 16'hXXXX;            
        rtr_io.cb.frame_n <= 16'h1111;            
        rtr_io.reset_n <= 0;                              
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    endtask: reset 
    
    initial begin
        Parallel_Connecting();                              // Generate data to transfer (bit-by-bit) (16 port in -> 16 port out + NO Harzard)  
        Conflict_Connecting();                              // Generate data to transfer (bit-by-bit) (6/16 port in -> 6/16 port out + 2 Harzard)
        Check_passed(data_check, answer);                   // Check if router received full data
    end
    
    
    
    task Parallel_Connecting();
        // Reset lai hoat dong router
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        reset();
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        // Bat dau che do khoi dong router
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.reset_n <= 1'b1;                // Tat reset 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        // Ket thuc che do khoi dong router 
        
        // Bat dau qua trinh truyen dia chi
        repeat(15) @(rtr_io.cb);
        rtr_io.cb.din <= 16'hFF00;                // Truyen bit thu 1 cua dia chi 
        rtr_io.cb.valid_n <= 16'h0000;            // Nhan gia tri packet duoc gui
        rtr_io.cb.frame_n <= 16'h0000;            // Cho ket noi song song (Port 0 -> Port 15)
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
                  
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'hF0F0;                // Truyen bit thu 2 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'hCCCC;                // Truyen bit thu 3 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'hAAAA;                // Truyen bit thu 4 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid isn: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        // Ket thuc qua trinh truyen dia chi
        
        // Bat dau qua trinh truyen data cua 1 Packet
        // Data se bat dau truyen sau mot chu ky xung clock tinh tu thoi diem nhan du 4 bit dia chi   
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'hFFFF;                // Truyen tat ca bit 1  
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
    
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'h0000;                // Truyen tat ca bit 0 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        rtr_io.cb.valid_n <= 16'h0000;            // Tat Valid_n de nhan data (Din)
//        rtr_io.cb.valid_n <= 16'hFFFF;            // Bat Valid_n de khong nhan data (Din)
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n); 
    
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
    
        repeat(6) @(rtr_io.cb);                   // Cho 6 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        rtr_io.cb.frame_n <= 16'hFFFF;            // Kich hoat Frame de ket thuc 1 packet, ket noi van dc giu
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);    
        // Ket thuc qua trinh truyen data cua 1 Packet
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
    endtask: Parallel_Connecting
 
    task Conflict_Connecting();
        // Reset lai hoat dong router
        reset();
        
        // Bat dau che do khoi dong router
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.reset_n <= 1'b1;                // Tat reset 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        // Ket thuc che do khoi dong router 
    
        // Truyen dia chi tu port in sang port out
        // port in[0] -> port out[5]                // 5:   0101
        // port in[3] -> port out[15]               // 15:  1111
        // port in[5] -> port out[15]               // 15:  1111
        // port in[7] -> port out[11]               // 11:  1011
        // port in[9] -> port out[5]                // 5:   0101
        // port in[15] -> port out[9]
        
        // Bat dau qua trinh truyen dia chi
        repeat(15) @(rtr_io.cb);
        rtr_io.cb.din <= 16'b1XXXXX0X1X1X1XX0;                // Truyen bit thu 1 cua dia chi 
        rtr_io.cb.valid_n <= 16'b0XXXXX0X0X0X0XX0;            // Nhan gia tri packet duoc gui
        rtr_io.cb.frame_n <= 16'b0111110101010110;            // Cho ket noi song song (Port 0, 3, 5, 7, 9, 15)
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    
        repeat(1) @(rtr_io.cb);                               // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'b0XXXXX1X0X1X1XX1;                // Truyen bit thu 2 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    
        repeat(1) @(rtr_io.cb);                               // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'b0XXXXX0X1X1X1XX0;                // Truyen bit thu 3 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
    
        repeat(1) @(rtr_io.cb);                               // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'b1XXXXX1X1X1X1XX1;                // Truyen bit thu 4 cua dia chi 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        // Ket thuc qua trinh truyen dia chi
    
        // Bat dau qua trinh truyen data cua 1 Packet
        // Data se bat dau truyen sau mot chu ky xung clock tinh tu thoi diem nhan du 4 bit dia chi   
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'hFFFF;                // Truyen tat ca bit 1  
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
    
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= 16'h0000;                // Truyen tat ca bit 0 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        rtr_io.cb.valid_n <= 16'hFFFF;            // Bat Valid_n de khong nhan data (Din)
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        rtr_io.cb.valid_n <= 16'h0000;            // Tat Valid_n de nhan data (Din)
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n); 
    
        // Kiem tra gia tri data out == data in?
        data_check <= rtr_io.cb.dout;             // Data out cua router duoc lay kiem tra
        answer <= rtr_io.din;                  // Lay gia tri dau vao cua router l m goc
        Check_passed(data_check, answer);                   // So sanh data in va data out de kiem tra truyen/ nhan packet
    
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.cb.din <= $random;                 // Truyen random gia tri
        rtr_io.cb.frame_n <= 16'hFFFF;            // Kich hoat Frame de ket thuc 1 packet, ket noi van dc giu
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);     
        // Ket thuc qua trinh truyen data cua 1 Packet
    
        
        repeat(2) @(rtr_io.cb);
        reset();
        
        repeat(1) @(rtr_io.cb);                   // Cho 1 xung clock trong khoi clocking cb
        rtr_io.reset_n <= 1'b1;                // Tat reset 
        $display ("Reset status: %b, Data in: %h, Frame in: %h, Valid in: %h", 
                  rtr_io.reset_n, rtr_io.din, rtr_io.valid_n, rtr_io.frame_n);
        $finish;
    endtask: Conflict_Connecting
    
    task Check_passed(data_check, answer);
        if (data_check == answer) $display ("Data received: %h, Success: Yes", data_check);
        else $display ("Data received: %h, Success: No", data_check);
    endtask: Check_passed
endprogram: Test