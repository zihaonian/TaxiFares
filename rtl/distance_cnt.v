module distance_cnt
(
    input   wire            encoder_pulses  ,      
    input   wire            sys_rst_n       ,    
    input   wire            flag_key_launch , 
    input   wire            flag_key_step   ,  
    
    
    output  reg [19:0]      distance       
);

always@(posedge encoder_pulses or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        distance    <=   20'd0;
    else if( flag_key_launch == 1'b1 && flag_key_step == 1'b0)   
        distance    <=  distance    +   20'd1;
    else 
        distance    <=  distance;
endmodule