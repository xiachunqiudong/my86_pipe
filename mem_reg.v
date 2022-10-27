`include "define.v"

module mem_reg(
    input wire           clk_i,
    input wire           rstn_i,
    input wire           M_bubble_i,
    input wire [`NIBBLE] E_stat_i,
    input wire [`NIBBLE] E_icode_i,
    input wire           e_Cnd_i,
    input wire [`D_WORD] e_valE_i,
    input wire [`D_WORD] E_valA_i,
    input wire [`NIBBLE] e_dstE_i,
    input wire [`NIBBLE] E_dstM_i,
    // output
    output reg [`NIBBLE] M_stat_o,
    output reg [`NIBBLE] M_icode_o,
    output reg           M_Cnd_o,
    output reg [`D_WORD] M_valE_o,
    output reg [`D_WORD] M_valA_o,
    output reg [`NIBBLE] M_dstE_o,
    output reg [`NIBBLE] M_dstM_o
);

    always @(posedge clk_i) begin
        if(~rstn_i) begin
            M_stat_o  <= `SAOK;
            M_icode_o <= 0;
            M_Cnd_o   <= 0;
            M_valE_o  <= 0;
            M_valA_o  <= 0;
            M_dstE_o  <= 0;
            M_dstM_o  <= 0;
        end
        else if(M_bubble_i) begin
            M_stat_o  <= `SAOK;
            M_icode_o <= `IHALT;
            M_Cnd_o   <= 0;
            M_valE_o  <= 0;
            M_valA_o  <= 0;
            M_dstE_o  <= `RNONE;
            M_dstM_o  <= `RNONE;
        end
        else begin
            M_stat_o  <= E_stat_i;
            M_icode_o <= E_icode_i;
            M_Cnd_o   <= e_Cnd_i;
            M_valE_o  <= e_valE_i;
            M_valA_o  <= E_valA_i;
            M_dstE_o  <= e_dstE_i;
            M_dstM_o  <= E_dstM_i;
        end
    end

endmodule