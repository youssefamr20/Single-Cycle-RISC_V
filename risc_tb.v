`timescale 1ns / 1ps

module risc_tb ();
 reg clk , rst_n ; 
 
  risc_v_top u_risc (clk , rst_n );

  initial begin 
  	clk =0  ;
  	rst_n=0 ;
  	#10 
  	rst_n=1 ;
  	 repeat (20) begin 
  	  @(posedge clk);
  	 end 
  	 $stop ;
  end

  initial begin 
  	forever #5 clk=~clk ;
  end

endmodule