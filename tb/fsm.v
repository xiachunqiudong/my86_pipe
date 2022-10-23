module fsm(
    input wire clk,
    input wire [3:0] a,
    input wire [3:0] b,
    output reg [3:0] c
);

    reg [3:0] r;

    always @(*) begin
        r = a + b;
    end

    always @(posedge clk) begin
        c <= r;
    end

endmodule

module fsm_tb;

    reg clk;
    reg  [3:0] a, b;
    wire [3:0] c;

    fsm f(clk, a, b, c);

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        a = 1;
        b = 1;
        #10
        a = 2;
        b = 2;
        #10
        $stop;
    end

endmodule