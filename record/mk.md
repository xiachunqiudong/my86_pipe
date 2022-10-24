# 五级流水Y86-64verilog实现

## 注意

- **`D_`表示源值，以表示信号来自于流水线寄存器D。**
- **`d_`表示结果值，表示信号在译码阶段产生。**

## fetch

![image-20221019223715303](C:\Users\xiadong\Desktop\my86_pipe\record\mk.assets\image-20221019223715303.png)

- 取指阶段需要选择当前需要的pc值，并预测下一阶段的pc值。
- 预测总是预测分支发生。
- 处理分支预测错误：当`M_icode==IJXX`并且`M_Cnd == 0`,从`M_valA`处取地址。
- 处理`ret`指令: 当`W_icode == IRET`,从`W_valM`处取地址。

## decode

- 从执行阶段前递过来

    `e_dstE = d_srcA/d_srcB` `e_valE`

- 从访存阶段前递过来

    `M_dsE = d_srcA/d_srcB ` `M_valE`

    `M_dsM = d_srcA/d_srcB ` `m_valM`

- 从写回阶段前递过来

    `W_dsE = d_srcA/d_srcB ` `W_valE`

    `W_dsM = d_srcA/d_srcB ` `W_valM`

## execute

## memory

## write back



## Y86流水线控制逻辑

![image-20221024230109641](C:\Users\xiadong\Desktop\my86_pipe\record\mk.assets\image-20221024230109641.png)

有四种情况需要特殊处理

- 加载/使用冒险

    解决方法:在加载内存数据和使用该数据之间暂停一个时钟周期。

    只有mrmovq和popq指令才需要从内存中读取数据。当加载指令处于执行阶段并且使用指令处于译码阶段时候，将使用指令停止在译码阶段，并在下一个时钟周期往执行阶段中插入一个气泡。

    保持流水线寄存器F和D的状态，并往执行阶段插入气泡。

- 分支预测错误

    取消掉预测错误的指令，并且跳转到正确指令处

- ret指令

    流水线必须暂停到ret指令到达写回阶段。

    只有到达写回阶段的时候才从内存中读出数据并放入了`W_valM`,这个时候下一条指令的取指阶段可以将这个值作为要取指令的地址。

    流水线需要暂停三个时钟周期直到ret指令经过访存阶段读出返回地址。

- 异常

    禁止后面指令更新程序员可见状态，并且当发生异常的指令到达写回阶段停止执行



# 测试

```markdown
irmovq r10 4
30 fa 00 00 00 00 00 00 00 00 04
irmovq r11 6
30 fb 00 00 00 00 00 00 00 00 06
icmovq r10 r11
60 ab
```

