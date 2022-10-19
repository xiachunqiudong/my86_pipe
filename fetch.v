module fetch(
    input  wire [`D_WORD] F_pred_pc_i,
    output reg  [`NIBBLE] f_icode_o,
    output reg  [`NIBBLE] f_ifun_o,
    output reg  [`NIBBLE] f_rA_o,
    output reg  [`NIBBLE] f_rB_o,
    output reg [`D_WORD]  f_valC_o,
    output reg [`D_WORD] f_valP_o,
    output reg [`D_WORD] f_pred_pc_o
    output reg [`NIBBLE] f_stat_o
);

    wire need_reg, need_valC;
    reg [`D_WORD] f_pc;
    reg [79:0] instr;
    reg [`BYTE] instr_mem [0:1023];

    // 根据 f_pc 从指令内存中取指令
    integer i;
    always@(*) begin
        for(i = 0; i < 10; i = i + 1)
            instr[(8*(10 - i) - 1) -: 8] = instr_mem[f_pc + i];
    end


    // split
    always@(*) begin
        f_icode_o = instr[79:76];
        f_ifun    = instr[75:72];
    end

    
    // align
    always@(*) begin
        if(need_reg) begin
            f_rA_o   = instr[71:68];
            f_rB_o   = instr[67:64];
            f_valC_o = instr[63:0];
        end
        else begin
            f_rA_o   = `RNONE;
            f_rB_o   = `RNONE;
            f_valC_o = instr[71:8];
        end
    end
    
    

    assign imem_error  = (f_pc > 1023);
    assign instr_valid = (f_icode_o <= 4'hb);


    // instr mem
    


endmodule