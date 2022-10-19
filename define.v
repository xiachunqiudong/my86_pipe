//Operation codes
`define     IHALT           4'H0 
`define     INOP            4'H1
`define     ICMOVQ          4'H2
`define     IIRMOVQ         4'H3
`define     IRMMOVQ         4'H4
`define     IMRMOVQ         4'H5
`define     IOPQ            4'H6
`define     IJXX            4'H7
`define     ICALL           4'H8
`define     IRET            4'H9
`define     IPUSHQ          4'HA
`define     IPOPQ           4'HB

//Function codes
`define     FADDL           4'H0
`define     FSUBL           4'H1
`define     FANDL           4'H2
`define     FXORL           4'H3

//Jump & move conditions function code.
`define     C_YES           4'H0
`define     C_LE            4'H1
`define     C_L             4'H2
`define     C_E             4'H3
`define     C_NE            4'H4
`define     C_GE            4'H5
`define     C_G             4'H6

// alu_fun
`define     ALUADD          4'H0
`define     ALUSUB          4'H1
`define     ALUAND          4'H2
`define     ALUXOR          4'H3

`define D_WORD 63:0
`define WORD   31:0
`define H_WORD 15:0
`define BYTE   7:0
`define NIBBLE 3:0

//Register Code
`define RRAX  4'h0
`define RRCX  4'h1
`define RRDX  4'h2
`define RRBX  4'h3
`define RRSP  4'h4
`define RRBP  4'h5
`define RRSI  4'h6
`define RRDI  4'h7
`define RR8   4'h8
`define RR9   4'h9
`define RR10  4'ha
`define RR11  4'hb
`define RR12  4'hc
`define RR13  4'hd
`define RR14  4'he
`define RNONE 4'hf

//Status Codes
`define     SAOK            4'H1
`define     SHLT            4'H2
`define     SADR            4'H3
`define     SINS            4'H4

`define ENABLE  1
`define DISABLE 0
