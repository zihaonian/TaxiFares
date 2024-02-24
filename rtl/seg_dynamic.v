module  seg_dynamic
#(
    parameter   cnt_max =   16'd499_99
)
(
    input   wire            sys_clk     ,
    input   wire            sys_rst_n   ,
    input   wire    [5:0]   point       ,
    input   wire    [3:0]   unit        ,                                                                  
    input   wire    [3:0]   ten         , 
    input   wire    [3:0]   hun         , 
    input   wire    [3:0]   tho         , 
    input   wire    [3:0]   t_tho       , 
    input   wire    [3:0]   h_tho       , 
    input   wire            seg_on      ,

    
    output  reg [7:0]   seg         ,
    output  reg [5:0]   sel              
);


parameter   seg_0   =   7'b100_0000, seg_1   =   7'b111_1001, 
            seg_2   =   7'b010_0100, seg_3   =   7'b011_0000, 
            seg_4   =   7'b001_1001, seg_5   =   7'b001_0010, 
            seg_6   =   7'b000_0010, seg_7   =   7'b111_1000, 
            seg_8   =   7'b000_0000, seg_9   =   7'b001_0000;

reg     [15:0]  cnt_1ms     ;
reg             cnt_flag    ;
reg     [2:0]   cnt_sel     ;

wire    [6:0]   in_point    ;
reg     [3:0]   data_disp   ;
reg             dot_disp    ;
reg     [5:0]   sel_reg     ;

assign  in_point    =   {2'd0,point}        ;
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_1ms <=   16'd0;
    else    if(cnt_1ms  ==  cnt_max)
        cnt_1ms <=   16'd0;
    else
        cnt_1ms <=   cnt_1ms    +   1'b1;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_flag <=   1'b0;
    else    if(cnt_1ms  ==  cnt_max -   1'b1)
        cnt_flag <=   1'b1;
    else
        cnt_flag <=   1'b0; 
        
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_sel <=   3'd0;
    else    if((cnt_flag ==   1'b1) &&  (cnt_sel ==   3'd5))
        cnt_sel <=   3'd0;
    else    if(cnt_flag ==   1'b1)
        cnt_sel <=   cnt_sel    +   1'b1; 
    else
        cnt_sel <=   cnt_sel;
        

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        data_disp   <=  4'b0000;
    else    if(seg_on  ==  1'b1)
        case(cnt_sel)
            3'd0    :   data_disp   <=  unit    ;
            3'd1    :   data_disp   <=  ten     ;
            3'd2    :   data_disp   <=  hun     ;
            3'd3    :   data_disp   <=  tho     ;
            3'd4    :   data_disp   <=  t_tho   ;
            3'd5    :   data_disp   <=  h_tho   ;
            default :   data_disp   <=  4'b0000 ;
        endcase
    else
        data_disp      <=  4'b0000 ;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        dot_disp <=   1'b1;
    else    if(cnt_flag ==   1'b1)
        dot_disp <=   ~in_point[cnt_sel +   2'b01]; 
    else
        dot_disp <= dot_disp;
        
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        seg <=   8'd0   ;
    else
        case(data_disp)
            4'd0    :   seg <=  {dot_disp,seg_0};
            4'd1    :   seg <=  {dot_disp,seg_1};
            4'd2    :   seg <=  {dot_disp,seg_2};
            4'd3    :   seg <=  {dot_disp,seg_3};
            4'd4    :   seg <=  {dot_disp,seg_4};
            4'd5    :   seg <=  {dot_disp,seg_5};
            4'd6    :   seg <=  {dot_disp,seg_6};
            4'd7    :   seg <=  {dot_disp,seg_7};
            4'd8    :   seg <=  {dot_disp,seg_8};
            4'd9    :   seg <=  {dot_disp,seg_9};
            default :   seg <=  8'd0            ;
        endcase
                   
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        sel_reg <=   6'd1;
    else    if((cnt_flag ==   1'b1) &&  (cnt_sel == 3'd5))
        sel_reg <=   6'd1; 
    else    if(cnt_flag ==   1'b1)
        sel_reg <=   sel_reg    << 1'b1; 
    else
        sel_reg <=   sel_reg            ;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        sel <=   6'b000_000 ;
    else
        sel <=   sel_reg    ;
endmodule