module  binary2bcd_216
(
    input   wire        sys_clk     ,
    input   wire        sys_rst_n   ,
    input   wire [19:0] in_data        ,
    
    output  reg [3:0]   unit        ,
    output  reg [3:0]   ten         ,
    output  reg [3:0]   hun         ,
    output  reg [3:0]   tho         ,
    output  reg [3:0]   t_tho       ,
    output  reg [3:0]   h_tho       
);
reg         shift_flag  ;
reg [4:0]   cnt_flag    ;
reg [43:0]  data        ;
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        shift_flag  <=   1'b0;
    else
        shift_flag  <=   ~shift_flag;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        cnt_flag  <=   5'b0;
    else    if((cnt_flag    ==  5'd21)    &&  (shift_flag   ==  1'b1))
        cnt_flag  <=   5'b0;
    else    if(shift_flag   ==  1'b1)
        cnt_flag  <=  cnt_flag   +   1'b1;
    else
        cnt_flag  <=  cnt_flag;
        
always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        data  <=   44'd0;
    else    if(cnt_flag    ==  5'd0)
        data  <=   {24'd0,in_data};
    else    if((cnt_flag    <=  5'd20)    &&  (shift_flag  ==  1'b0))
        begin
            data[23:20] <= (data[23:20] > 4) ? (data[23:20] + 2'd3) : (data[23:20]);
            data[27:24] <= (data[27:24] > 4) ? (data[27:24] + 2'd3) : (data[27:24]);
            data[31:28] <= (data[31:28] > 4) ? (data[31:28] + 2'd3) : (data[31:28]);
            data[35:32] <= (data[35:32] > 4) ? (data[35:32] + 2'd3) : (data[35:32]);
            data[39:36] <= (data[39:36] > 4) ? (data[39:36] + 2'd3) : (data[39:36]);
            data[43:40] <= (data[43:40] > 4) ? (data[43:40] + 2'd3) : (data[43:40]);
        end
    else    if((cnt_flag    <=  5'd20)    &&  (shift_flag  ==  1'b1))
        data  <=  data   << 1;
    else
        data  <=  data;

always@(posedge sys_clk or  negedge sys_rst_n)
    if(sys_rst_n    ==  1'b0)
        begin
            unit    <=  4'd0;
            ten     <=  4'd0;
            hun     <=  4'd0;
            tho     <=  4'd0;
            t_tho   <=  4'd0;
            h_tho   <=  4'd0;
        end
    else    if(cnt_flag    ==  5'd21)
        begin
            unit    <=  data[23:20];
            ten     <=  data[27:24];
            hun     <=  data[31:28];
            tho     <=  data[35:32];
            t_tho   <=  data[39:36];
            h_tho   <=  data[43:40];
        end
    else
        begin
            unit    <=  unit ;
            ten     <=  ten  ;
            hun     <=  hun  ;
            tho     <=  tho  ;
            t_tho   <=  t_tho;
            h_tho   <=  h_tho;
        end

endmodule