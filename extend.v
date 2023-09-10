module extend (
	input wire [31:7] i_instr ,
	input wire [1:0] i_immsrc ,
	output reg [31:0] o_immext
	);
	

always@(*) begin
	case(i_immsrc)
	2'b00: o_immext =  {{20 {i_instr[31]} }, i_instr[31:20]};//LW
	2'b01: o_immext = {{20{i_instr[31]}}, i_instr[31:25],i_instr[11:7]};
	2'b10: o_immext = {{20{i_instr[31]}}, i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}; //btype
	2'b11: o_immext = {{12{i_instr[31]}}, i_instr[19:12],i_instr[20], i_instr[30:21], 1'b0};//jal
	default: o_immext = 32'bx;
	endcase
end

endmodule

