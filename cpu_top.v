`include "define.v"

module cpu_top(
    input wire clk,
    input wire rstn
);
    
    // 取值时钟寄存器
    // output
    wire [`D_WORD] F_pred_pc;

    // 取指阶段
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
    wire [`NIBBLE] D_ifun;
    wire [`NIBBLE] D_rA;
    wire [`NIBBLE] D_rB;
    wire [`D_WORD] D_valC;
    wire [`D_WORD] D_valP;
    wire [`NIBBLE] D_stat;

    // 译码阶段
    // output
    wire [`NIBBLE] d_srcA;
    wire [`NIBBLE] d_srcB;
    wire [`NIBBLE] d_dstE;
    wire [`NIBBLE] d_dstM;
    wire [`D_WORD] d_valA;
    wire [`D_WORD] d_valB;

    // 执行时钟寄存器
    // output 
    wire [`NIBBLE] E_stat;
    wire [`NIBBLE] E_icode;
    wire [`NIBBLE] E_ifun;
    wire [`D_WORD] E_valC;
    wire [`D_WORD] E_valA;
    wire [`D_WORD] E_valB;
    wire [`NIBBLE] E_srcA;
    wire [`NIBBLE] E_srcB;
    wire [`NIBBLE] E_dstE;
    wire [`NIBBLE] E_dstM;

    // 执行阶段
    // output 
    wire           e_Cnd;
    wire [`NIBBLE] e_dstE;
    wire [`D_WORD] e_valE;

    // 访存时钟寄存器 
    // output
    wire [`NIBBLE] M_stat;
    wire [`NIBBLE] M_icode;
    wire           M_Cnd;
    wire [`D_WORD] M_valE;
    wire [`D_WORD] M_valA;
    wire [`NIBBLE] M_dstE;
    wire [`NIBBLE] M_dstM;

    // 访存
    // output
    wire [`D_WORD] m_valM;
    wire [`NIBBLE] m_stat;

    // 写回时钟寄存器
    // output
    wire [`NIBBLE] W_stat;
    wire [`NIBBLE] W_icode;
    wire [`D_WORD] W_valE;
    wire [`D_WORD] W_valM;
    wire [`NIBBLE] W_dstE;
    wire [`NIBBLE] W_dstM;
    
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
        .e_dstE_i(e_dstE),
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

    // 执行
    execute e(
        .clk_i(clk),
        .rstn_i(rstn),
        .E_icode_i(E_icode),
        .E_ifun_i(E_ifun),
        .E_valC_i(E_valC),
        .E_valA_i(E_valA),
        .E_valB_i(E_valB),
        .E_dstE_i(E_dstE),
        .m_stat_i(m_stat),
        .W_stat_i(W_stat),
        .e_Cnd_o(e_Cnd),
        .e_dstE_o(e_dstE),
        .e_valE_o(e_valE)
    );

    // 访存寄存器
    mem_reg m_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .E_stat_i(E_stat),
        .E_icode_i(E_icode),
        .e_Cnd_i(e_Cnd),
        .e_valE_i(e_valE),
        .E_valA_i(E_valA),
        .e_dstE_i(e_dstE),
        .E_dstM_i(E_dstM),
        .M_stat_o(M_stat),
        .M_icode_o(M_icode),
        .M_Cnd_o(M_Cnd),
        .M_valE_o(M_valE),
        .M_valA_o(M_valA),
        .M_dstE_o(M_dstE),
        .M_dstM_o(M_dstM)
    );

    // 访存
    mem m(
        .clk_i(clk),
        .rstn_i(rstn),
        .M_stat_i(M_stat),
        .M_icode_i(M_icode),
        .M_valE_i(M_valE),
        .M_valA_i(M_valA),
        .m_stat_o(m_stat),
        .m_valM_o(m_valM)
    );

    // 写回时钟寄存器
    wb_reg w_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .m_stat_i(m_stat),
        .M_icode_i(M_icode),
        .M_valE_i(M_valE),
        .m_valM_i(m_valM),
        .M_dstE_i(M_dstE),
        .M_dstM_i(M_dstM),
        .W_stat_o(W_stat),
        .W_icode_o(W_icode),
        .W_valE_o(W_valE),
        .W_valM_o(W_valM),
        .W_dstE_o(W_dstE),
        .W_dstM_o(W_dstM)
    );

endmodule