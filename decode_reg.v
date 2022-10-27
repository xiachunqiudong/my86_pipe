`include "define.v"

module decode_reg(
    // 输入
    input wire           clk_i,
    input wire           rstn_i,
    input wire           D_stall_i,
    input wire           D_bubble_i,
    input wire [`NIBBLE] f_icode_i,
    input wire [`NIBBLE] f_ifun_i,
    input wire [`NIBBLE] f_rA_i,
    input wire [`NIBBLE] f_rB_i,
    input wire [`D_WORD] f_valC_i,
    input wire [`D_WORD] f_valP_i,
    input wire [`NIBBLE] f_stat_i,
    // 输出
    output wire [`NIBBLE] D_icode_o,
    output wire [`NIBBLE] D_ifun_o,
    output wire [`NIBBLE] D_rA_o,
    output wire [`NIBBLE] D_rB_o,
    output wire [`D_WORD] D_valC_o,
    output wire [`D_WORD] D_valP_o,
    output wire [`NIBBLE] D_stat_o
);

    reg [`NIBBLE] icode_reg;
    reg [`NIBBLE] ifun_reg;
    reg [`NIBBLE] rA_reg;
    reg [`NIBBLE] rB_reg;
    reg [`D_WORD] valC_reg;
    reg [`D_WORD] valP_reg;
    reg [`NIBBLE] stat_reg;
    
    assign D_icode_o   = icode_reg;
    assign D_ifun_o    = ifun_reg;
    assign D_rA_o      = rA_reg;
    assign D_rB_o      = rB_reg;
    assign D_valC_o    = valC_reg;
    assign D_valP_o    = valP_reg;
    assign D_stat_o    = stat_reg;

    always@(posedge clk_i) begin
        if(~rstn_i) begin
            icode_reg <= 0;
            ifun_reg  <= 0;
            rA_reg    <= 0;
            rB_reg    <= 0;
            valC_reg  <= 0;
            valP_reg  <= 0;
            stat_reg  <= `SAOK;
        end
        else if(D_stall_i) begin
            icode_reg <= icode_reg;
            ifun_reg  <= ifun_reg;
            rA_reg    <= rA_reg;
            rB_reg    <= rB_reg;
            valC_reg  <= valC_reg;
            valP_reg  <= valP_reg;
            stat_reg  <= stat_reg;
        end
        else if(D_bubble_i) begin
            icode_reg <= `IHALT;
            ifun_reg  <= 0;
            rA_reg    <= `RNONE;
            rB_reg    <= `RNONE;
            valC_reg  <= 0;
            valP_reg  <= 0;
            stat_reg  <= 0;
        end
        else begin
            icode_reg <= f_icode_i;
            ifun_reg  <= f_ifun_i;
            rA_reg    <= f_rA_i;
            rB_reg    <= f_rB_i;
            valC_reg  <= f_valC_i;
            valP_reg  <= f_valP_i;
            stat_reg  <= f_stat_i;
        end
    end
    
endmodule