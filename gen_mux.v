module gen_mux
#(parameter BUS_WIDTH = 32 ,
  parameter SEL = 2      )
( input wire [(BUS_WIDTH * (2**SEL) )-1:0] i_in,
  input wire [SEL-1:0] i_sel,
  output wire [BUS_WIDTH-1:0] i_out );

    assign i_out = i_in[i_sel*BUS_WIDTH +: BUS_WIDTH];  
  
endmodule