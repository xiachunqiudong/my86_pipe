`include "define.v"

module execute_reg(
    input wire           clk_i,
    input wire           rstn_i,
    input wire           E_bubble_i,
    input wire [`NIBBLE] D_stat_i,
    input wire [`NIBBLE] D_icode_i,
    input wire [`NIBBLE] D_ifun_i,
    input wire [`D_WORD] D_valC_i,
    input wire [`D_WORD] d_valA_i,
    input wire [`D_WORD] d_valB_i,
    input wire [`NIBBLE] d_srcA_i,
    input wire [`NIBBLE] d_srcB_i,
    input wire [`NIBBLE] d_dstE_i,
    input wire [`NIBBLE] d_dstM_i,
    // output 
    output reg [`NIBBLE] E_stat_o,
    output reg [`NIBBLE] E_icode_o,
    output reg [`NIBBLE] E_ifun_o,
    output reg [`D_WORD] E_valC_o,
    output reg [`D_WORD] E_valA_o,
    output reg [`D_WORD] E_valB_o,
    output reg [`NIBBLE] E_srcA_o,
    output reg [`NIBBLE] E_srcB_o,
    output reg [`NIBBLE] E_dstE_o,
    output reg [`NIBBLE] E_dstM_o
);

    always @(posedge clk_i) begin
        if(~rstn_i) begin
            E_stat_o  <= 0;
            E_icode_o <= 0;
            E_ifun_o  <= 0;
            E_valC_o  <= 0;
            E_valA_o  <= 0;
            E_valB_o  <= 0;
            E_srcA_o  <= 0;
            E_srcB_o  <= 0;
            E_dstE_o  <= 0;
            E_dstM_o  <= 0;
        end
        else if(E_bubble_i) begin
            E_stat_o  <= `SAOK;
            E_icode_o <= `IHALT;
            E_ifun_o  <= 0;
            E_valC_o  <= 0;
            E_valA_o  <= 0;
            E_valB_o  <= 0;
            E_srcA_o  <= `RNONE;
            E_srcB_o  <= `RNONE;
            E_dstE_o  <= `RNONE;
            E_dstM_o  <= `RNONE;
        end  
        else begin
            E_stat_o  <= D_stat_i;
            E_icode_o <= D_icode_i;
            E_ifun_o  <= D_ifun_i;
            E_valC_o  <= D_valC_i;
            E_valA_o  <= d_valA_i;
            E_valB_o  <= d_valB_i;
            E_srcA_o  <= d_srcA_i;
            E_srcB_o  <= d_srcB_i;
            E_dstE_o  <= d_dstE_i;
            E_dstM_o  <= d_dstM_i;    
        end   
    end

endmodule