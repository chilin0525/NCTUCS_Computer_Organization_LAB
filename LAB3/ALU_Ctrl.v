// Author:0711282 邱頎霖

module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o,
		jr_o
        );

//I/O ports
input      [6-1:0] funct_i; //function code
input      [3-1:0] ALUOp_i; // aluop
output     [4-1:0] ALUCtrl_o; // 4 bit alu_controi to alu
output     jr_o;

//Internal Signals
reg        [4-1:0] ALUCtrl_o;
reg			jr_o;
//Select exact operation

always @( * ) begin
	jr_o <= 1'b0;
	if(ALUOp_i==3'b000)begin
		if(funct_i==6'b100001)begin //addu 		// ok
			ALUCtrl_o <= 4'b0010; //ADD
		end
		else if(funct_i==6'b100011)begin //subu
			ALUCtrl_o <= 4'b0110; //SUB
		end
		else if(funct_i==6'b100100)begin //and
			ALUCtrl_o <= 4'b0000; //AND
		end
		else if(funct_i==6'b100101)begin //or
			ALUCtrl_o <= 4'b0001; //OR
		end
		else if(funct_i==6'b101010)begin //slt
			ALUCtrl_o <= 4'b0111; //SLT		
		end
		else if(funct_i==6'b000011)begin //sra 		// ok
			ALUCtrl_o <= 4'b1110;		
		end	
		else if(funct_i==6'b000111)begin //srav 	// ok
			ALUCtrl_o <= 4'b1111;		
		end
		else if(funct_i==6'b000000)begin
			ALUCtrl_o <= 4'b1101;  //sLL		
		end
		else if(funct_i==6'b011000)begin
			ALUCtrl_o <= 4'b0100; //mul
		end
		else if(funct_i==6'b001000)begin //jr
			 ALUCtrl_o <= 4'b0000;
			 jr_o <= 1'b1;	
		end
	end	
	else if(ALUOp_i==3'b001)begin //addi
		ALUCtrl_o <= 4'b0010; //ADD
	end
	else if(ALUOp_i==3'b010)begin
		ALUCtrl_o <= 4'b0101; //sltiu
	end
	/*else if(ALUOp_i==3'b110)begin
		ALUCtrl_o <= 4'b1001; //bne
	end
	else if(ALUOp_i==3'b100)begin
		ALUCtrl_o <= 4'b0011; //beq
	end*/
	else if(ALUOp_i==3'b110)begin //branch
		ALUCtrl_o <= 4'b1010;
	end
	else if(ALUOp_i==3'b011)begin
		ALUCtrl_o <= 4'b1011; //LUI		//ok
	end
	else if(ALUOp_i==3'b111)begin
		ALUCtrl_o <= 4'b0001; //ori		//ok
	end
	else if(ALUOp_i==3'b101)begin
		ALUCtrl_o <= 4'b1000; // lw sw	
	end
end


endmodule



















