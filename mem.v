`include "define.v"

module mem(
    input wire clk_i,
    input wire rstn_i,
    input wire [`NIBBLE] M_stat_i,
    input wire [`NIBBLE] M_icode_i,
    input wire [`D_WORD] M_valE_i,
    input wire [`D_WORD] M_valA_i,
    output reg [`NIBBLE] m_stat_o,
    output reg [`D_WORD] m_valM_o
);

    localparam DISABLE = 0;
    localparam ENABLE  = 1;
    
    reg           mem_read;
    reg           mem_write;
    reg [`D_WORD] mem_addr;
    reg [`D_WORD] mem_data;
    wire          dmem_error;

    // RAM
    reg [`BYTE] data [0:1023];

    always @(*) begin
        if(dmem_error)
            m_stat_o = `SADR;
        else
            m_stat_o = M_stat_i;
    end

    always @(*) begin
        case(M_icode_i)
            `IRMMOVQ: begin
                mem_read  = DISABLE;
                mem_write = ENABLE;
                mem_addr  = M_valE_i;
                mem_data  = M_valA_i;
            end
            `IMRMOVQ: begin
                mem_read  = ENABLE;
                mem_write = DISABLE;
                mem_addr  = M_valE_i;
                mem_data  = 0;
            end
            `IPUSHQ: begin
                mem_read  = DISABLE;
                mem_write = ENABLE;
                mem_addr  = M_valE_i;
                mem_data  = M_valA_i;
            end
            `IPOPQ: begin
                mem_read  = ENABLE;
                mem_write = DISABLE;
                mem_addr  = M_valA_i;
                mem_data  = 0;
            end
            `ICALL: begin
                mem_read  = DISABLE;
                mem_write = ENABLE;
                mem_addr  = M_valE_i;
                mem_data  = M_valA_i;
            end
            `IRET: begin
                mem_read  = ENABLE;
                mem_write = DISABLE;
                mem_addr  = M_valA_i;
            end
            default: begin
                mem_read  = DISABLE;
                mem_write = ENABLE;
                mem_addr  = 0;
                mem_data  = 0;
            end
        endcase
    end

    assign dmem_error = mem_addr > 1023;

    // write
    integer i, j, k;
    always @(posedge clk_i) begin
        if(~rstn_i) begin
            for(i = 0; i < 1024; i = i + 1)
                data[i] <= 0;
        end
        else if(mem_write) begin
            for(j = 0; j < 8; j = i + 1)
                data[mem_addr + j] <= mem_data[8*(j+1)-1 -: 8];
        end
    end

    // read
    always @(*) begin
        if(mem_read) begin
            for(k = 0; k < 8; k = k + 1)
                m_valM_o[8*(k+1)-1 -: 8] <= mem_data[mem_addr + k];
        end
        else
            m_valM_o = 0;
    end

endmodule