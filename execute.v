`include "define.v"

module execute(
    input wire                  clk_i,
    input wire                  rstn_i,
    input wire        [`NIBBLE] E_icode_i,
    input wire        [`NIBBLE] E_ifun_i,
    input wire signed [`D_WORD] E_valC_i,
    input wire signed [`D_WORD] E_valA_i,
    input wire signed [`D_WORD] E_valB_i,
    input wire        [`NIBBLE] E_dstE_i,
    input wire        [`NIBBLE] m_stat,
    input wire        [`NIBBLE] W_stat,
    output reg                  e_Cnd_o;
    output reg        [`NIBBLE] e_dstE_o,
    output reg signed [`D_WORD] e_valE_o
);

    reg signed [`D_WORD] aluA;
    reg signed [`D_WORD] aluB;
    reg [`NIBBLE] alu_fun;
    reg [2:0] cc;
    wire set_cc;

    wire zf = cc[2];
    wire sf = cc[1];
    wire of = cc[0];

    always @(*) begin
        e_dstE_o = e_Cnd_o ? E_dstE_i : `RNONE;
    end

    // 计算aluA aluB
    always @(*) begin
        case(E_icode_i)
            `ICMOVQ: begin
                aluA = E_valA_i;
                aluB = 0;
            end
            `IIRMOVQ: begin
                aluA = E_valC_i;
                aluB = 0;
            end
            `IRMMOVQ: begin
                aluA = E_valC_i;
                aluB = E_valB_i;
            end
            `IMRMOVQ: begin
                aluA = E_valC_i;
                aluB = E_valB_i;
            end
            `IOPQ: begin
                aluA = E_valA_i;
                aluB = E_valB_i;
            end
            `IPUSHQ: begin
                aluA = -8;
                aluB = E_valB_i;
            end
            `IPOPQ: begin
                aluA = 8;
                aluB = E_valB_i;
            end
            `ICALL: begin
                aluA = -8;
                aluB = E_valB_i;
            end
            `IRET: begin
                aluA = 8;
                aluB = E_valB_i;
            end
            default: begin
                aluA = 0;
                aluB = 0;
            end
        endcase
    end

    always @(*) begin
        if(E_icode_i == `IOPQ)
            alu_fun = E_ifun_i;
        else
            alu_fun = `ALUADD;
    end

    assign set_cc = (E_icode_i == `IOPQ) & (m_stat == `SAOK) & (W_stat == `SAOK);

    always @(*) begin
        case(alu_fun) begin
            `ALUADD: e_valE_o = aluB + aluA;
            `ALUSUB: e_valE_o = aluB - aluA;
            `ALUAND: e_valE_o = aluB & aluA;
            `ALUXOR: e_valE_o = aluB ^ aluA;
        end
    end

    // cc[2] zf cc[1] sf cc[0] of
    always@(posedge clk_i) begin
        if(~rstn_i)
            cc <= 3'b100;
        else if(set_cc) begin
            cc[2] <= (e_valE_o == 0);
            cc[1] <= e_valE_o[63];
            if(alu_fun == `ALUADD)
                cc[0] = (aluA[63] == aluB[63]) & (aluB[63] != e_valE_o[63]);
            else if(alu_fun == `ALUSUB)
                cc[0] = (aluA[63] != aluB[63]) & (aluB[63] != e_valE_o[63]);
            else
                cc[0] = 0;
        end
        else
            cc <= cc;
    end

    
endmodule