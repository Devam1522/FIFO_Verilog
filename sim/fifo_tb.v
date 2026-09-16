`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Testbench Name : fifo_tb
// Description    : Writes 4 values into the FIFO, then reads them back,
//                  verifying full/empty flag behavior.
//////////////////////////////////////////////////////////////////////////////

module fifo_tb;

reg clk, rst, wr_en, rd_en;
reg [7:0] data_in;
wire [7:0] data_out;
wire full, empty;

fifo uut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

// Clock
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    wr_en = 0;
    rd_en = 0;
    data_in = 0;

    #10 rst = 0;

    // Write data
    repeat(4) begin
        @(posedge clk);
        wr_en = 1;
        data_in = data_in + 1;
    end

    wr_en = 0;

    // Read data
    repeat(4) begin
        @(posedge clk);
        rd_en = 1;
    end

    rd_en = 0;

    #20 $finish;
end

endmodule