module fetch_reg(
    input wire clk_i,
    input wire rstn_i,
    input wire [`D_WORD] pred_pc_i,
    output reg [`D_WORD] f_pred_pc_o
);

    always@(posedge clk) begin
        if(~rstn_i)
            f_pred_pc_o <= 0;
        else
            f_pred_pc_o <= pred_pc_i;
    end


endmodule