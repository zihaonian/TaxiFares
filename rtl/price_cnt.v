module price_cnt
#(
    parameter   CNT_2S =   27'd100_0000_0000
)
(
    input   wire            sys_clk         ,
    input   wire            encoder_pulses  ,      
    input   wire            sys_rst_n       ,    
    input   wire            flag_key_launch , 
    input   wire            flag_key_step   ,  
    
    
    output  reg [19:0]      price   
);
reg [26:0]  cnt_2s;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_2s    <=   27'd0;
    else    if(cnt_2s ==  CNT_2S)
        cnt_2s    <=  27'd0;
    else    if(flag_key_launch == 1'b1 && flag_key_step == 1'b1)   
        cnt_2s    <=  cnt_2s    +   20'd1;
    else    
        cnt_2s    <=  cnt_2s;
        
always@(posedge encoder_pulses or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        price    <=   20'd0;
    else    if( flag_key_launch == 1'b1 && flag_key_step == 1'b0)   
        price    <=  price    +   20'd1;
    else    if(flag_key_launch == 1'b1 && flag_key_step == 1'b1 && cnt_2s ==  CNT_2S - 1'b1)
        price    <=  price    +   20'd2;    
    else 
        price    <=  price;
endmodule