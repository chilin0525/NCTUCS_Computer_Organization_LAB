// Author:0711282 邱頎霖

module Branch_type(
    Branch_type_i,
	Zero_i,
	ALU_result_i,
	branch_type_result_o
    );

input [2-1:0] Branch_type_i;
input Zero_i;
input ALU_result_i;

output branch_type_result_o;
reg branch_type_result_o;
always @(*) begin
	if(Branch_type_i==0)begin //beq
		if(Zero_i==1)begin
			branch_type_result_o <= 1;			
		end
		else begin
			branch_type_result_o <= 0;		
		end
	end
	else if(Branch_type_i==1)begin //bne
		if(Zero_i==1)begin
			branch_type_result_o <= 0;	
		end
		else begin
			branch_type_result_o <= 1;
		end
	end
	else if(Branch_type_i==2)begin //blez <=
		if(Zero_i==1 || ALU_result_i==1)begin
			branch_type_result_o <= 1;		
		end
		else begin
			branch_type_result_o <= 0;		
		end
	end
	else if(Branch_type_i==3)begin
		if(ALU_result_i==0 && Zero_i!=1)begin
			branch_type_result_o <= 1;
		end
		else begin
			branch_type_result_o <= 0;		
		end
	end
end

endmodule





















