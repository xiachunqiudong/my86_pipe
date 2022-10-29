`include "define.v"

module pipe_controller(
    input wire [`NIBBLE] D_icode_i,
    input wire [`NIBBLE] d_srcA_i,
    input wire [`NIBBLE] d_srcB_i,
    input wire [`NIBBLE] E_icode_i,
    input wire [`NIBBLE] E_dstM_i,
    input wire           e_Cnd_i,
    input wire [`NIBBLE] M_icode_i,
    input wire [`NIBBLE] m_stat_i,
    input wire [`NIBBLE] W_stat_i,
    output wire          F_stall_o,                
    output wire          D_stall_o,          
    output wire          D_bubble_o, 
    output wire          E_bubble_o, 
    output wire          M_bubble_o, 
    output wire          W_stall_o 
);  

    /*
     *                                  组合情况
     *        |        load-use             |          mis-predict  |       ret
     *  icode |  E_icode = mrmovq | pop     |        E_icode = jxx  |   D_icode = ret     |                                             
     *
    */

    /*
     *  执行阶段为 MRMOVQ或者POP 译码阶段使用E_dstM作为源寄存器
     *  需要暂停 F D 寄存器 往E寄存器中插入气泡
    */
    wire load_use     = (E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i);
    
    /*
     *  译码 执行 访存 阶段为 RET 指令
     *  往D寄存器中插入气泡 暂停
     *  F寄存器无所谓 因为到达写回阶段 这时候W_icode = RET pc = W_valM
    */
    wire ret          =  D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET; 
    
    /*
    * 执行阶段 E_icode = JXX && e_Cnd = 0 不跳转 预测错误
    * 取指 译码 阶段往 D E 寄存器中加入气泡
    * 等到访存阶段就可以确定是否跳转 M_icode = JXX && M_Cnd = 0 这时候选取valA作为指令地址开始取指
    */
    wire mis_pred     = (E_icode_i == `IJXX) && (e_Cnd_i == 0);

    /*
     * 当发生load/use + ret指令时
     * load/use会暂停 D 而ret指令会往 D 中插入气泡
     * 这时候让D暂停就可以 相当于让ret指令推迟一个周期执行
    */

    assign F_stall_o  = load_use || ret;
    
    assign D_stall_o  = load_use;
    assign D_bubble_o = (~load_use & ret) || mis_pred;
    
    assign E_bubble_o = mis_pred || load_use;
    
    assign M_bubble_o = m_stat_i != `SAOK || W_stat_i != `SAOK;
    assign W_stall_o  = W_stat_i != `SAOK;

endmodule