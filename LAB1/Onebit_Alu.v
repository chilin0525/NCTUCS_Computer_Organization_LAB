// 0711282 邱頎霖
module Onebit_Alu(a,b,carry_in,Alu_ctrol,result,carry_out,bonus_input,bonus_output,eq_input,eq_output);

	input a,b,carry_in,bonus_input,eq_input;
	input [3:0] Alu_ctrol;
	output  carry_out,eq_output;	
	output  result;
	output  bonus_output;
	
	wire inverse_a,inverse_b;
	wire [31:0] temp;
	wire temp_bonus;

	assign inverse_b=!b;
	
	/* 
		AND:0000 OR:0001 ADD:0010 SUB:0110 NOR:1100 NAND:1101 SLT:01111
	*/

	assign temp[0] = (Alu_ctrol==0)? (a&b) :0 ;					 // and
	assign temp[1] = (Alu_ctrol==1)? (a|b) :0 ;					 // or
	assign temp[2] = (Alu_ctrol==13)? (!(a&b)) :0;			 	 // nand
	assign temp[3] = (Alu_ctrol==12)? (!(a|b)) :0;				 //	nor
	Onebit_Adder add_mod(a,b,carry_in,temp[6],temp[4]);			 // add
	Onebit_Adder sub_mod(a,inverse_b,carry_in,temp[7],temp[5]);  // sub

	assign result = (temp[0] || temp[1] || temp[2] || temp[3] || (Alu_ctrol==2 && temp[4]) || (Alu_ctrol==6 && temp[5]));
	assign carry_out = (Alu_ctrol==6 && temp[7]) || (temp[6] && Alu_ctrol==2);

	assign temp_bonus = (a==b)?bonus_input:0;   // for bonus compare
	assign bonus_output = (a>b)? 1:temp_bonus;  // for bonus compare
	assign eq_output= (a==b)?eq_input:0;
// Onebit_Adder:a,b,carry_in,carry_out,result
/*	always @(Alu_ctrol)begin
		case(Alu_ctrol)
			4'b0000: result <= a&b;
			4'b0001: result <= a|b;
			4'b0010: begin
					//result <= ((a&b) || (a & carry_in) || (b & carry_in)) ;
					//result <= temp[0]; 
					 carry_out <= ((a & b) || (a & carry_in) || (b & carry_in));
					 result <= (( (!a) & (!b) & carry_in) || ((!a) & b & carry_in) || (a & (!b) & (!carry_in)) || (a & b & carry_in));
					 end
			4'b0110: result <= temp[4];
			4'b1100: result <= !(a|b);
			4'b1101: result <= !(a&b);
			4'b0111: result <= b;			
	endcase
	end
*/
endmodule













