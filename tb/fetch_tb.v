`include "define.v"

module fetch_tb;

    reg clk;
    reg rstn;

    wire [`D_WORD] F_pred_pc;
    wire [`D_WORD] f_pred_pc;

    fetch_reg f_r(
        .clk_i(clk),
        .rstn_i(rstn),
        .f_pred_pc_i(f_pred_pc),
        .F_pred_pc_o(F_pred_pc)
    );

    //input
    reg [`NIBBLE] M_icode;
    reg           M_Cnd;
    reg [`D_WORD] M_valA;
    reg [`NIBBLE] W_icode;
    reg [`NIBBLE] W_valM;

        // output
    wire [`NIBBLE] icode, ifun;
    wire [`NIBBLE] rA, rB;
    wire [`D_WORD] valC;
    wire [`D_WORD] valP;
    wire [`NIBBLE] stat;

    fetch f(
        .F_pred_pc_i(F_pred_pc),
        .M_icode_i(M_icode),
        .M_Cnd_i(M_Cnd),
        .M_valA_i(M_valA),
        .W_icode_i(W_icode),
        .W_valM_i(W_valM),
        .f_icode_o(icode),
        .f_ifun_o(ifun),
        .f_rA_o(rA),
        .f_rB_o(rB),
        .f_valC_o(valC),
        .f_valP_o(valP),
        .f_pred_pc_o(f_pred_pc),
        .f_stat_o(stat)
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