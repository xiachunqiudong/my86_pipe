# 五级流水Y86-64verilog实现

## 注意

- **`D_`表示源值，以表示信号来自于流水线寄存器D。**
- **`d_`表示结果值，表示信号在译码阶段产生。**

## fetch

![image-20221019223715303](C:\Users\xiadong\Desktop\my86_pipe\record\mk.assets\image-20221019223715303.png)

- 取指阶段需要选择当前需要的pc值，并预测下一阶段的pc值。

## decode

## execute

## memory

## write back





# 测试

```markdown
irmovq r10 4
30 fa 00 00 00 00 00 00 00 00 04
irmovq r11 6
30 fb 00 00 00 00 00 00 00 00 06
icmovq r10 r11
60 ab
```

