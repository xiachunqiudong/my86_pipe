`timescale 1ps/1ps

module cpu_top_tb;

    reg clk;
    reg rstn;
    
    cpu_top cpu(
        .clk(clk),
        .rstn(rstn)
    );

    always #5 clk = ~clk;

    initial begin
        rstn = 0;
        clk  = 1;
        #10
        rstn = 1;
        #40
        $stop;
    end

endmodule