`include "define.v"

module cpu;
    
    wire [`D_WORD] F_pred_pc;
    wire [`D_WORD] f_pred_pc;

    //input
    reg [`NIBBLE] M_icode;
    reg [`NIBBLE] M_Cnd;
    reg [`D_WORD] M_valA;
    reg [`NIBBLE] W_icode;
    reg [`NIBBLE] W_valM;

    reg clk;
    reg rstn;

    // output
    wire [`NIBBLE] icode, ifun;
    wire [`NIBBLE] rA, rB;
    wire [`D_WORD] valC;
    wire [`D_WORD] valP;
    wire [`NIBBLE] stat;

    fetch_reg f_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .f_pred_pc_i(f_pred_pc),
        .F_pred_pc_o(F_pred_pc)
    );

    wire [`NIBBLE] f_icode;
    wire [`NIBBLE] f_ifun;
    wire [`NIBBLE] f_rA;
    wire [`NIBBLE] f_rB;
    wire [`D_WORD] f_valC;
    wire [`D_WORD] f_valP;
    wire [`NIBBLE] f_stat;

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
        .D_icode_o(icode),
        .D_ifun_o(ifun),
        .D_rA_o(rA),
        .D_rB_o(rB),
        .D_valC_o(valC),
        .D_valP_o(valP),
        .D_stat_o(stat)
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