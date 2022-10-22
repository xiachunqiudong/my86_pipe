`include "define.v"

module decode_wb(
    input wire  clk_i,
    input wire  rstn_i,
    // 译码
    input wire  [`NIBBLE] D_icode_i,
    input wire  [`NIBBLE] D_rA_i,
    input wire  [`NIBBLE] D_rB_i,
    input wire  [`D_WORD] D_valP_i,
    // 执行阶段
    input wire  [`NIBBLE] E_dstE_i,
    input wire  [`D_WORD] e_valE_i,
    // 访存阶段
    input wire  [`NIBBLE] M_dstM_i,
    input wire  [`D_WORD] m_valM_i,
    input wire  [`NIBBLE] M_dstE_i,
    input wire  [`D_WORD] M_valE_i,
    // 写回阶段
    input wire  [`NIBBLE] W_dstE_i,
    input wire  [`NIBBLE] W_dstM_i,
    input wire  [`D_WORD] W_valE_i,
    input wire  [`D_WORD] W_valM_i,
    // output
    output reg [`NIBBLE] d_dstE_o,
    output reg [`NIBBLE] d_dstM_o,
    output reg [`NIBBLE] d_srcA_o,
    output reg [`NIBBLE] d_srcB_o,
    output reg [`D_WORD] d_valA_o,
    output reg [`D_WORD] d_valB_o
);

    // 从寄存器中读取的值
    reg [`D_WORD] d_rvalA, d_rvalB;

    // 真正输出的valA and valB
    always @(*) begin
        if(D_icode_i == `ICALL || D_icode_i == `IJXX) // call 以及 jxx 指令后续不需要valA的值 所以用valA取传递valP的值
            d_valA_o = D_valP_i;
        else if(E_dstE_i == d_srcA_o)
            d_valA_o = e_valE_i;
        else if(M_dstE_i == d_srcA_o)
            d_valA_o = M_valE_i;
        else if(M_dstM_i == d_srcA_o)
            d_valA_o = m_valM_i;
        else if(W_dstE_i == d_srcA_o)
            d_valA_o = W_valE_i;
        else if(W_dstM_i == d_srcA_o)
            d_valA_o = W_valM_i;
        else
            d_valA_o = d_rvalA;
    end

    always @(*) begin
        if(E_dstE_i == d_srcB_o)
            d_valB_o = e_valE_i;
        else if(M_dstE_i == d_srcB_o)
            d_valB_o = M_valE_i;
        else if(M_dstM_i == d_srcB_o)
            d_valB_o = m_valM_i;
        else if(W_dstE_i == d_srcB_o)
            d_valB_o = W_valE_i;
        else if(W_dstM_i == d_srcB_o)
            d_valB_o = W_dstM_i;
        else
            d_valB_o = d_rvalB;
    end

    // 根据D_icode计算 srcA, srcB, dstE, dstM
    always @(*) begin
        case(D_icode_i)
            `ICMOVQ: begin
                d_srcA_o = D_rA_i;
                d_srcB_o = `RNONE;
                d_dstE_o = D_rB_i;
                d_dstM_o = `RNONE;
            end
            `IIRMOVQ: begin
                d_srcA_o = `RNONE;
                d_srcB_o = `RNONE;
                d_dstE_o = D_rB_i;
                d_dstE_o = `RNONE;
            end
            `IMRMOVQ: begin
                d_srcA_o = `RNONE;
                d_srcB_o = D_rB_i;
                d_dstE_o = `RNONE;
                d_dstM_o = D_rA_i;
            end
            `IMRMOVQ: begin
                d_srcA_o = D_rA_i;
                d_srcB_o = D_rB_i;
                d_dstE_o = `RNONE;
                d_dstM_o = `RNONE;
            end
            `IOPQ: begin
                d_srcA_o = D_rA_i;
                d_srcB_o = D_rB_i;
                d_dstE_o = D_rB_i;
                d_dstM_o = `RNONE;
            end
            `IJXX: begin
                d_srcA_o = `RNONE;
                d_srcB_o = `RNONE;
                d_dstE_o = `RNONE;
                d_dstM_o = `RNONE;
            end
            `IPUSHQ: begin
                d_srcA_o = D_rA_i;
                d_srcB_o = `RRSP;
                d_dstE_o = `RRSP;
                d_dstM_o = `RNONE;
            end
            `IPOPQ: begin
                d_srcA_o = `RRSP;
                d_srcB_o = `RRSP;
                d_dstE_o = `RRSP;
                d_dstM_o = D_rA_i;
            end
            `ICALL: begin
                d_srcA_o = `RNONE;
                d_srcB_o = `RRSP;
                d_dstE_o = `RRSP;
                d_dstM_o = `RNONE;
            end
            `IRET: begin
                d_srcA_o = `RRSP;
                d_srcB_o = `RRSP;
                d_dstE_o = `RRSP;
                d_dstM_o = `RNONE;
            end
            default: begin
                d_srcA_o = `RNONE;
                d_srcB_o = `RNONE;
                d_dstE_o = `RNONE;
                d_dstM_o = `RNONE;
            end
        endcase
    end

    reg [`BYTE] regs [0:14];

    // 译码阶段 读寄存器
    always @(*) begin
        if(d_srcA_o != `RNONE)
            d_rvalA = regs[d_srcA_o];
        else
            d_rvalA = 0;
        
        if(d_srcB_o != `RNONE)
            d_rvalB = regs[d_srcB_o];
        else 
            d_rvalB = 0;
    end

    // 写回阶段
    integer i;
    always @(posedge clk_i) begin
        if(~rstn_i) begin
            for(i = 0; i < 15; i = i + 1) 
                regs[i] <= 0;
        end
        else begin
            if(W_dstE_i != `RNONE)
                regs[W_dstE_i] <= W_valE_i;
            if(W_dstM_i != `RNONE)
                regs[W_dstM_i] <= W_valM_i;
        end
    end 

endmodule