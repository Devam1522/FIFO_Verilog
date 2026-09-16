`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////
// Module Name : fifo
// Description : 4-word deep, 8-bit wide synchronous FIFO with
//               full/empty flag generation.
//////////////////////////////////////////////////////////////////////////////

module fifo (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

reg [7:0] mem [0:3];
reg [1:0] wr_ptr, rd_ptr;
reg [2:0] count;

// Write
always @(posedge clk) begin
    if (rst)
        wr_ptr <= 0;
    else if (wr_en && !full) begin
        mem[wr_ptr] <= data_in;
        wr_ptr <= wr_ptr + 1;
    end
end

// Read
always @(posedge clk) begin
    if (rst)
        rd_ptr <= 0;
    else if (rd_en && !empty) begin
        data_out <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
    end
end

// Count
always @(posedge clk) begin
    if (rst)
        count <= 0;
    else begin
        case ({wr_en, rd_en})
            2'b10: if (!full) count <= count + 1;
            2'b01: if (!empty) count <= count - 1;
        endcase
    end
end

assign full  = (count == 4);
assign empty = (count == 0);

endmodule