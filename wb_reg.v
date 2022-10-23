`include "define.v"

module wb_reg(
    input wire           clk_i,
    input wire           rstn_i,
    input wire [`NIBBLE] m_stat_i,
    input wire [`NIBBLE] M_icode_i,
    input wire [`D_WORD] M_valE_i,
    input wire [`D_WORD] m_valM_i,
    input wire [`NIBBLE] M_dstE_i,
    input wire [`NIBBLE] M_dstM_i,
    output reg [`NIBBLE] W_stat_o,
    output reg [`NIBBLE] W_icode_o,
    output reg [`D_WORD] W_valE_o,
    output reg [`D_WORD] W_valM_o,
    output reg [`NIBBLE] W_dstE_o,
    output reg [`NIBBLE] W_dstM_o
);
    always @(posedge clk_i) begin
        if(rstn_i) begin
            W_stat_o  <= 1;
            W_icode_o <= 0;
            W_valE_o  <= 0;
            W_valM_o  <= 0;
            W_dstE_o  <= 0;
            W_dstM_o  <= 0;
        end
        else begin
            W_stat_o  <= m_stat_i;
            W_icode_o <= M_icode_i;
            W_valE_o  <= M_valE_i;
            W_valM_o  <= m_valM_i;
            W_dstE_o  <= M_dstE_i;
            W_dstM_o  <= M_dstM_i;            
        end
    end

endmodule