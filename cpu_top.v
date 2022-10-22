`include "define.v"

module cpu_top;
    
    reg clk;
    reg rstn;

    // 取值时钟寄存器
    // output
    wire [`D_WORD] F_pred_pc;

    // 取指阶段
    // input
    reg [`NIBBLE] M_icode;
    reg           M_Cnd;
    reg [`D_WORD] M_valA;
    reg [`NIBBLE] W_icode;
    reg [`D_WORD] W_valM;
    // output
    wire [`D_WORD] f_pred_pc;
    wire [`NIBBLE] f_icode;
    wire [`NIBBLE] f_ifun;
    wire [`NIBBLE] f_rA;
    wire [`NIBBLE] f_rB;
    wire [`D_WORD] f_valC;
    wire [`D_WORD] f_valP;
    wire [`NIBBLE] f_stat;


    // 译码时钟寄存器
    // output
    wire [`NIBBLE] D_icode;
    wire [`NIBBLE] D_if;
    wire [`NIBBLE] D_rA;
    wire [`NIBBLE] D_rB;
    wire [`D_WORD] D_valC;
    wire [`D_WORD] D_valP;
    wire [`D_WORD] D_stat;

    // 译码阶段
    // input
    reg [`D_WORD] e_valE;
    reg [`NIBBLE] M_dstE;
    reg [`D_WORD] M_valE;
    reg [`NIBBLE] M_dstM;
    reg [`D_WORD] m_valM;
    reg [`NIBBLE] W_dstE;
    reg [`D_WORD] W_valE;
    reg [`NIBBLE] W_dstM;
    // output
    wire [`NIBBLE] d_srcA;
    wire [`NIBBLE] d_srcB;
    wire [`NIBBLE] d_dstE;
    wire [`NIBBLE] d_dstM;
    wire [`D_WORD] d_valA;
    wire [`D_WORD] d_valB;

    // 执行时钟寄存器
    // output 
    reg [`NIBBLE] E_stat;
    reg [`NIBBLE] E_icode;
    reg [`NIBBLE] E_ifun;
    reg [`D_WORD] E_valC;
    reg [`D_WORD] E_valA;
    reg [`D_WORD] E_valB;
    reg [`NIBBLE] E_srcA;
    reg [`NIBBLE] E_srcB;
    reg [`NIBBLE] E_dstE;
    reg [`NIBBLE] E_dstM;
    
    // 取指令时钟寄存器
    fetch_reg f_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .f_pred_pc_i(f_pred_pc),
        .F_pred_pc_o(F_pred_pc)
    );

    // 取指
    fetch f(
        .F_pred_pc_i(F_pred_pc),
        .M_icode_i(M_icode),
        .M_Cnd_i(M_Cnd),
        .M_valA_i(M_valA),
        .W_icode_i(W_icode),
        .W_valM_i(W_valM),
        .f_icode_o(f_icode),
        .f_ifun_o(f_ifun),
        .f_rA_o(f_rA),
        .f_rB_o(f_rB),
        .f_valC_o(f_valC),
        .f_valP_o(f_valP),
        .f_pred_pc_o(f_pred_pc),
        .f_stat_o(f_stat)
    );

    // 译码时钟寄存器
    decode_reg d_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .f_icode_i(f_icode),
        .f_ifun_i(f_ifun),
        .f_rA_i(f_rA),
        .f_rB_i(f_rB),
        .f_valC_i(f_valC),
        .f_valP_i(f_valP),
        .f_stat_i(f_stat),
        .D_icode_o(D_icode),
        .D_ifun_o(D_ifun),
        .D_rA_o(D_rA),
        .D_rB_o(D_rB),
        .D_valC_o(D_valC),
        .D_valP_o(D_valP),
        .D_stat_o(D_stat)
    );

    // 译码 & 写回
    decode_wb d_w(
        .clk_i(clk),
        .rstn_i(rstn),
        .D_icode_i(D_icode),
        .D_rA_i(D_rA),
        .D_rB_i(D_rB),
        .D_valP_i(D_valP),
        .E_dstE_i(E_dstE),
        .e_valE_i(e_valE),
        .M_dstE_i(M_dstE),
        .M_valE_i(M_valE),
        .M_dstM_i(M_dstM),
        .m_valM_i(m_valM),
        .W_dstE_i(W_dstE),
        .W_valE_i(W_valE),
        .W_dstM_i(W_dstM),
        .W_valM_i(W_valM),
        .d_srcA_o(d_srcA),
        .d_srcB_o(d_srcB),
        .d_dstE_o(d_dstE),
        .d_dstM_o(d_dstM),
        .d_valA_o(d_valA),
        .d_valB_o(d_valB)
    );

    // 执行时钟寄存器
    execute_reg e_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .D_stat_i(D_stat),
        .D_icode_i(D_icode),
        .D_ifun_i(D_ifun),
        .D_valC_i(D_valC),
        .d_valA_i(d_valA),
        .d_valB_i(d_valB),
        .d_srcA_i(d_srcA),
        .d_srcB_i(d_srcB),
        .d_dstE_i(d_dstE),
        .d_dstM_i(d_dstM),
        .E_stat_o(E_stat),
        .E_icode_o(E_icode),
        .E_ifun_o(E_ifun),
        .E_valC_o(E_valC),
        .E_valA_o(E_valA),
        .E_valB_o(E_valB),
        .E_srcA_o(E_srcA),
        .E_srcB_o(E_srcB),
        .E_dstE_o(E_dstE),
        .E_dstM_o(E_dstM)
    );

    initial begin
        rstn = 0;
        clk  = 1;
        M_icode = `IOPQ;
        M_Cnd = 0;
        M_valA = 0;
        W_icode = `IOPQ;
        W_valM = 0;
        #10
        clk = 0;
        #10
        rstn = 1;
        clk = 1;
        #10
        clk = 0;
        $stop;
    end

endmodule