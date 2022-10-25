`include "define.v"

module fetch_reg(
    input  wire           clk_i,
    input  wire           rstn_i,
    input  wire           F_stall_i,
    input  wire [`D_WORD] f_pred_pc_i,
    output wire [`D_WORD] F_pred_pc_o
);

    reg [`D_WORD] pred_pc_reg;

    assign F_pred_pc_o = pred_pc_reg;

    always@(posedge clk_i) begin
        if(~rstn_i)
            pred_pc_reg <= 0;
        else if(F_stall_i)
            pred_pc_reg <= pred_pc_reg;
        else
            pred_pc_reg <= f_pred_pc_i;
    end

endmodule