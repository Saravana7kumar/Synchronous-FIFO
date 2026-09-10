module sync_fifo (
    input clk,
    input rst_n,
    input wr_en,
    input [7:0] din,
    output full,
    input rd_en,
    output reg [7:0] dout,
    output empty
);

    reg [7:0] mem [0:15];
    reg [4:0] wptr, rptr;
    assign full  = (wptr[4] != rptr[4]) && (wptr[3:0] == rptr[3:0]);
    assign empty = (wptr == rptr);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wptr <= 0;
        end else if (wr_en && !full) begin
            mem[wptr[3:0]] <= din;
            wptr <= wptr + 1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rptr <= 0;
            dout <= 0;
        end else if (rd_en && !empty) begin
            dout <= mem[rptr[3:0]];
            rptr <= rptr + 1;
        end
    end

endmodule
