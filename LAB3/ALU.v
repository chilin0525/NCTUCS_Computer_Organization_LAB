// Author: 0711282 邱頎霖

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    result_o,
    zero_o,
	shamt_i
    );

//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;
input  [5-1:0]   shamt_i;
output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg zero_o;

wire signed [32-1:0] tmp_src1;
wire signed [32-1:0] tmp_src2;
wire signed [5-1:0] tmp_shamt;

assign tmp_src1 = src1_i;
assign tmp_src2 = src2_i;
assign tmp_shamt = shamt_i;

always @(*)begin
	if(ctrl_i==4'b0010)begin //ADD
		result_o <= (src1_i + src2_i);
	end
	else if(ctrl_i==4'b1000)begin // ADD signed
		result_o <= (tmp_src1 + tmp_src2);	
	end
	else if(ctrl_i==4'b0110)begin //SUB
		result_o <= (src1_i - src2_i);
	end
	else if(ctrl_i==4'b1010)begin
		result_o <= (tmp_src1 - tmp_src2);	
	end
	else if(ctrl_i==4'b0000)begin //AND
		result_o <= (src1_i & src2_i);
	end
	else if(ctrl_i==4'b0001)begin //OR
		result_o <= (src1_i | src2_i);	
		//result_o <= src2_i;		
	end
	else if(ctrl_i==4'b0111)begin //SLT
		result_o <= (tmp_src1 < tmp_src2)?1'b1:1'b0;
		//result_o <= (src1_i < src2_i)
	end
	else if(ctrl_i==4'b0101)begin //SLTiu
		result_o <= (src1_i < src2_i)?1'b1:1'b0;
	end
	else if(ctrl_i==4'b1111)begin //SRAV
		result_o <= (tmp_src2 >>> tmp_src1);  // >>> for "signed" -> wire should be signed = =
		//result_o <= tmp_src2; // >>> tmp_src2);
		//SRAV rd, rt, rs
	end
	else if(ctrl_i==4'b1110)begin //SRA
		result_o <= (tmp_src2 >>> tmp_shamt); // >>> for "signed"
	end
	else if(ctrl_i==4'b1101)begin
		result_o <= (src2_i << shamt_i)	; //for SLL
	end
	else if(ctrl_i==4'b1011)begin //lui
		result_o <= src2_i<<16;	
	end
	/*else if(ctrl_i==4'b0011)begin //beq
		result_o <= (src1_i - src2_i);	
	end
	else if(ctrl_i==4'b1001)begin //bne
		result_o <= (src1_i - src2_i);	
	end*/
	else if(ctrl_i==4'b0100)begin // mul
		result_o <= (tmp_src1*tmp_src2);
	end
	
	/* lab2 version
	if(ctrl_i==4'b1001)begin // bne:if not equal->result!=0->but zero should=0
		zero_o <= (result_o==0)?1'b0:1'b1;
	end
	else begin
		zero_o <= (result_o==0)?1'b1:1'b0;
	end*/
	if(result_o==0)begin // bne:if not equal->result!=0->but zero should=0
		zero_o <= 1'b1;
	end
	else begin
		zero_o <= 1'b0;
	end
end

endmodule

































