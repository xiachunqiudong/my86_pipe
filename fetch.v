`include "define.v"

module fetch(
    // input
    input wire [`D_WORD] F_pred_pc_i,
    // 访存阶段 分支预测错误
    input wire [`NIBBLE] M_icode_i,
    input wire           M_Cnd_i,
    input wire [`D_WORD] M_valA_i,
    // 写回阶段 得到ret返回地址
    input wire [`NIBBLE] W_icode_i,
    input wire [`D_WORD] W_valM_i,
    // output
    output reg [`NIBBLE] f_icode_o,
    output reg [`NIBBLE] f_ifun_o,
    output reg [`NIBBLE] f_rA_o,
    output reg [`NIBBLE] f_rB_o,
    output reg [`D_WORD] f_valC_o,
    output reg [`D_WORD] f_valP_o,
    // 流水线cpu在取指阶段就需要计算出下一条指令地址
    output reg [`D_WORD] f_pred_pc_o,
    output reg [`NIBBLE] f_stat_o
);

    wire need_reg, need_valC;
    reg [`D_WORD] f_pc;
    reg [79:0] instr;
    reg [`BYTE] instr_mem [0:1023];

    assign imem_error  = (f_pc > 1023);
    assign instr_valid = (f_icode_o <= 4'hb);

    // f_stat_o
    always@(*) begin
        if(imem_error)
            f_stat_o = `SADR;
        else if(~instr_valid)
            f_stat_o = `SINS;
        else if(f_icode_o == `IHALT)
            f_stat_o = `SHLT;
        else
            f_stat_o = `SAOK;         
    end

    /*
        pc选择器从三个pc值中选择
        当jxx指令进入访存阶段并且预测错误时，从流水线寄存器M(M_valA)读取valP的值
        当ret指令进入写回阶段是，从流水线寄存器W中读取W_valM的值
        其他情况使用流水线寄存器F中预测的pc值
    */
    always@(*) begin
        if(M_icode_i == `IJXX && M_Cnd_i == 0) // 分支预测错误 并没有跳转
            f_pc = M_valA_i;
        else if(W_icode_i == `IRET) // 返回指令
            f_pc = W_valM_i;
        else
            f_pc = F_pred_pc_i;
    end

    // 根据 f_pc 从指令内存中取指令
    integer i;
    always@(*) begin
        for(i = 0; i < 10; i = i + 1)
            instr[(8*(10 - i) - 1) -: 8] = instr_mem[f_pc + i];
    end

    // split
    always@(*) begin
        f_icode_o = instr[79:76];
        f_ifun_o  = instr[75:72];
    end

    assign need_reg  = f_icode_o == `IIRMOVQ || f_icode_o == `IMRMOVQ || f_icode_o == `IRMMOVQ 
                    || f_icode_o == `ICMOVQ  || f_icode_o == `IOPQ    || f_icode_o == `IPUSHQ  
                    || f_icode_o == `IPOPQ;

    assign need_valC = f_icode_o == `IIRMOVQ || f_icode_o == `IMRMOVQ || f_icode_o == `IRMMOVQ
                    || f_icode_o == `ICALL   || f_icode_o == `IJXX;
    
    // align
    always@(*) begin
        if(need_reg) begin
            f_rA_o   = instr[71:68];
            f_rB_o   = instr[67:64];
            f_valC_o = instr[63:0];
        end
        else begin
            f_rA_o   = `RNONE;
            f_rB_o   = `RNONE;
            f_valC_o = instr[71:8];
        end
    end

    //assign f_valP_o = f_pc + 1 + need_reg + (need_valC);
    always@(*) begin
        f_valP_o = f_pc + 1 + need_reg;
        if(need_valC)
            f_valP_o = f_valP_o + 8;
    end

    // predict pc
    // 分支预测JXX总是跳转
    always@(*) begin
        if(f_icode_o == `ICALL || f_icode_o == `IJXX)
            f_pred_pc_o = f_valC_o;
        else
            f_pred_pc_o = f_valP_o;
    end
    
    initial begin
        $readmemh("C:/Users/xiadong/Desktop/my86_pipe/mycode.txt", instr_mem);
    end
endmodule