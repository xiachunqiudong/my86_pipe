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
        #500
        $stop;
    end

    initial begin
        $monitor($time, ": r[rdi] = %h\t    r[rsp] = %h\t    r[10] = %h\t      r[rax] = %h\t    mem[2c] = %h\t    mem[34] = %h\t    mem[3c] = %h\t", 
                           cpu.d_w.regs[7], cpu.d_w.regs[4], cpu.d_w.regs[10], cpu.d_w.regs[0], cpu.m.data[44], cpu.m.data[52], cpu.m.data[60]);
    end

endmodule