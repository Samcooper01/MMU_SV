`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2024 07:44:15 PM
// Design Name: 
// Module Name: MMU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MMU_tb();

    logic clk;
    logic rst_n;
    
    logic [15:0] MMU_rx_data;
    logic [15:0] MMU_addr;
    logic MMU_get;
    logic MMU_set;
    logic MMU_rdy;
    logic [15:0] MMU_tx_data;
    
    MMU iMMU(.clk(clk), .rst_n(rst_n), .MMU_rx_data(MMU_rx_data), .MMU_addr(MMU_addr), .MMU_get(MMU_get), .MMU_set(MMU_set), .MMU_rdy(MMU_rdy), .MMU_tx_data(MMU_tx_data));
    
    initial begin
    @(posedge clk);
    rst_n = 0;
    @(posedge clk);
    @(posedge clk);
    
    rst_n = 1;
    @(posedge clk);
    @(posedge clk);
    
    //Test Get operation
    MMU_addr = 0;
    MMU_get = 1;
    MMU_set = 0;
    @(posedge MMU_rdy);
    
    @(posedge clk);
    @(posedge clk);
    MMU_get = 0;
    MMU_set = 0;
    @(posedge clk);
    @(posedge clk);
    
    //Test Set operaiton
    MMU_addr = 100;
    MMU_rx_data = 69;
    MMU_set = 1;
    MMU_get = 0;
    @(posedge MMU_rdy);
    
    @(posedge clk);
    @(posedge clk);
    
    //Test Get Operation
    MMU_addr = 100;
    MMU_get = 1;
    MMU_set = 0;
    @(posedge MMU_rdy);
    
    @(posedge clk);
    @(posedge clk);
    MMU_get = 0;
    @(posedge clk);
    @(posedge clk);
        
    end
    
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

endmodule
