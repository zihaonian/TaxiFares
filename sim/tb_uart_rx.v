`timescale  1ns/1ns
module  ();
reg sys_clk     ;
reg sys_rst_n   ;



initial 
    begin
        sys_clk     =   1'b1;
        sys_rst_n   <=  1'b0;
        
    end
always  #10 sys_clk =   ~sys_clk;





endmodule