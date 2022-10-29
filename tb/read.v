module read;

    reg [7:0] data [0:1023];
    reg clk;

    always #5 clk = ~clk;

    initial begin
        $readmemh("C:/Users/xiadong/Desktop/my86_pipe/rsum.txt", data);
        clk = 1;
        #50
        $stop;
    end

endmodule