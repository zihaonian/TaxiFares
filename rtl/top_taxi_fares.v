module top_taxi_fares
(
    input   wire            sys_clk         ,   
    input   wire            sys_rst_n       , 
    input   wire            encoder_pulses  ,      
    input   wire            key_launch      , 
    input   wire            key_step        ,  
    
    
    output wire             stcp            ,
    output wire             shcp            , 
    output wire             ds              , 
    output wire             oe              , 
    output wire             flag_key_launch ,
    output wire             flag_key_step   ,
    output wire [3:0]       StepDrive               
);    
wire    [19:0]      distance_binary ; 
wire    [19:0]      price_binary    ;

wire    [3:0]       distance_unit   ;
wire    [3:0]       distance_ten    ;
wire    [3:0]       distance_hun    ; 

wire    [3:0]       price_unit      ;
wire    [3:0]       price_ten       ;
wire    [3:0]       price_hun       ; 
 
wire    [7:0]       seg             ;
wire    [5:0]       sel             ;
 
wire    [3:0]      invalid_distance_tho         ;
wire    [3:0]      invalid_distance_t_tho       ;  
wire    [3:0]      invalid_distance_h_tho       ; 
wire    [3:0]      invalid_price_tho            ;
wire    [3:0]      invalid_price_t_tho          ;  
wire    [3:0]      invalid_price_h_tho          ;   

key_filter
#(
   .CNT_MAX(20'd399_999)
)key_filter_inst1
(
    .sys_clk    (sys_clk)       ,
    .sys_rst_n  (sys_rst_n)     ,
    .key_in     (key_launch)    ,

    .key_flag   (flag_key_launch)     
);

key_filter
#(
   .CNT_MAX(20'd399_999)
)key_filter_inst2
(
    .sys_clk    (sys_clk)       ,
    .sys_rst_n  (sys_rst_n)     ,
    .key_in     (key_step)      ,

    .key_flag   (flag_key_step)     
);

Stepper_motors
#(
    .CNT_MAX(20'd399_999)
)Stepper_motors_inst
(
    .sys_clk        (sys_clk)           ,   
    .sys_rst_n      (sys_rst_n)         ,    
    .flag_key_launch(flag_key_launch)   , 
    .flag_key_step  (flag_key_step)     ,  

    .StepDrive      (StepDrive)
);

distance_cnt distance_cnt_inst
(
    .encoder_pulses  (encoder_pulses),      
    .sys_rst_n       (sys_rst_n),    
    .flag_key_launch (flag_key_launch), 
    .flag_key_step   (flag_key_step),  

    .distance        (distance_binary)
);

price_cnt 
#(
    .CNT_2S (27'd100_0000_0000)
)price_cnt_inst
(
    .sys_clk        (sys_clk)           ,
    .encoder_pulses (encoder_pulses)    ,      
    .sys_rst_n      (sys_rst_n)         ,    
    .flag_key_launch(flag_key_launch)   , 
    .flag_key_step  (flag_key_step)     ,  

    .price          (price_binary)
);

binary2bcd_216 binary2bcd_216_inst1
(
    .sys_clk   (sys_clk)                ,
    .sys_rst_n (sys_rst_n)              ,
    .in_data   (distance)               ,

    .unit      (distance_unit)          ,
    .ten       (distance_ten)           ,
    .hun       (distance_hun)           ,
    .tho       (invalid_distance_tho)   ,
    .t_tho     (invalid_distance_t_tho) ,
    .h_tho     (invalid_distance_h_tho)     
);
binary2bcd_216 binary2bcd_216_inst2
(
    .sys_clk   (sys_clk)                ,
    .sys_rst_n (sys_rst_n)              ,
    .in_data   (price_binary)           ,

    .unit      (price_unit)             ,
    .ten       (price_ten)              ,
    .hun       (price_hun)              ,
    .tho       (invalid_price_tho)      ,
    .t_tho     (invalid_distance_t_tho) ,
    .h_tho     (invalid_distance_h_tho)    
);

seg_dynamic
#(
   .cnt_max(16'd499_99)
)seg_dynamic_inst
(
    . sys_clk   (sys_clk)       ,
    . sys_rst_n (sys_rst_n)     ,
    . point     (6'd0)          ,
    . unit      (price_unit)    ,                                                                  
    . ten       (price_ten)     , 
    . hun       (price_hun)     , 
    . tho       (distance_unit) , 
    . t_tho     (distance_ten)  , 
    . h_tho     (distance_hun)  , 
    . seg_on    (1'b1)          ,

    .seg        (seg)           ,
    .sel        (sel)     
);

hc595_ctrl  hc595_ctrl_inst //hc595串行信号转并行信号
(
    . sys_clk    (sys_clk)      ,
    . sys_rst_n  (sys_rst_n)    ,   
    .  sel       (sel)          ,
    .  seg       (seg)          ,

    .stcp        (stcp)         ,
    .shcp        (shcp)         ,  
    .ds          (ds)           , 
    .oe          (oe)  
    
);
endmodule