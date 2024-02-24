module Stepper_motors
#(
    parameter   CNT_MAX =   20'd399_999
)
(
    input   wire            sys_clk         ,   
    input   wire            sys_rst_n       ,    
    input   wire            flag_key_launch , 
    input   wire            flag_key_step   ,  
    
    
    output  reg     [3:0]   StepDrive       

);
reg [19:0]  cnt_20ms;
reg [2:0]   State   ;
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_20ms    <=   20'd0;
    else if(cnt_20ms ==  CNT_MAX)
        cnt_20ms    <=  20'd0;
    else if( flag_key_launch == 1'b1 && flag_key_step == 1'b0)   
        cnt_20ms    <=  cnt_20ms    +   20'd1;
    else 
        cnt_20ms    <=  cnt_20ms;


always @(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		State <= 3'b000;
    else if(cnt_20ms ==  CNT_MAX)
        State <= State + 3'b1;
    else
        State <= State;
        
always @(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'b0)
		StepDrive <= StepDrive;
	else 
        case(State)
            3'b000  : StepDrive <= 4'b0001  ;//A
            3'b001  : StepDrive <= 4'b0011  ;//AB
            3'b010  : StepDrive <= 4'b0010  ;//B
            3'b011  : StepDrive <= 4'b0110  ;//BC
            3'b100  : StepDrive <= 4'b0100  ;//C
            3'b101  : StepDrive <= 4'b1100  ;//CD
            3'b110  : StepDrive <= 4'b1000  ;//D
            3'b111  : StepDrive <= 4'b1001  ;//DA
            default : StepDrive <= StepDrive;
         endcase
endmodule