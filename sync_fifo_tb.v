`timescale 1ns/1ps

module sync_fifo_tb;

    reg clk, rst_n;
    reg wr_en, rd_en;
    reg  [7:0] din;
    wire [7:0] dout;
    wire full, empty;
    sync_fifo dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .din(din), .full(full),
        .rd_en(rd_en), .dout(dout), .empty(empty)
    );
    
    always #5 clk = ~clk;
    initial begin
        clk   = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        #20 rst_n = 1;
        repeat (20) begin
            @(posedge clk);
            if (!full) begin
                wr_en <= 1;
                din   <= din + 1;
            end else begin
                wr_en <= 0;
                $display("T=%0t FIFO FULL, stopped writing, din was %0d", $time, din);
            end
        end
        wr_en <= 0;
        repeat (20) begin
            @(posedge clk);
            if (!empty) begin
                rd_en <= 1;
            end else begin
                rd_en <= 0;
                $display("T=%0t FIFO EMPTY", $time);
            end
        end
        rd_en <= 0;

        #20;
        $display("done");
        $finish;
    end
    always @(posedge clk)
        if (rd_en && !empty)
            $display("T=%0t read dout=%0d", $time, dout);

endmodule