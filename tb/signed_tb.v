module signed_tb;

    reg signed [7:0] a;
    reg signed [3:0] b;
    reg [7:0] c;

    reg signed [3:0] d;


    initial begin
        a = 4;
        b = -1;
        c = a + b;
        // b <= 00001111         无符号扩展
        // signed b <= 11111111  符号扩展
        $display("c = %d\n", c);
        d = 4'b1111;
        $display("d = %d\n", d);
        #10
        $stop;
    end

endmodule