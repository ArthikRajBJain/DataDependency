`timescale 1ns / 1ps

module DependencyCheck
(
output [5:0] address,
output [2:0] Register_Address,
output [7:0] result,
input [3:0] data,
input [7:0] Register
);

  //Register Address
  //00 - R0
  //01 - R1
  //02 - R2
  //03 - R3
  //04 - R4
  //05 - R5
  //06 - R6
  //07 - R8

  //Instruction Set
  //00 - ADD
  //01 - SUB
  //02 - MUL
  //O3 - DIV
  //04 - END

  //Program Memory
  //Starts from 08 address

reg [5:0] addr;
reg [2:0] raddr;
integer flag;
integer raw, war,waw;
reg clk;
reg [3:0] val1,val2,val3;
reg [3:0] pval1,pval2,pval3;
reg [3:0] operator;
reg [7:0] out,op1,op2;
reg [7:0] res;

assign address = addr;
assign Register_Address = raddr;
assign result = res;
initial
begin
	addr = 0;
	raddr = 0;
	res = 0;
	flag = 0;
	clk = 0;
	pval1 = 8;
	pval2 = 8;
	pval3 = 8;
	raw=0;war=0;waw=0;
	forever #10 clk = ~clk;
end

always @ (posedge clk)
begin

	if(flag == 0)
	begin
		operator = data;
		if(operator == 4)
		begin
			$display("END");
			$finish;
		end
		addr = addr + 1;
	end

	if(flag == 1)
	begin
		if(pval1 == data)
			waw = 1;
		pval1 = val1;
		val1 = data;
		if((val1 == val2)||(val1 == val3))
			war = 1;
		addr = addr + 1;
	end

	if(flag == 2)
	begin
		pval2 = val2;
		val2 = data;
		if(pval1 == val2)
			raw = 1;
		addr = addr + 1;
	end

	if(flag == 3)
	begin
		pval3 = val3;
		val3 = data;
		if(pval1 == val3)
			raw = 1;
		addr = addr + 1;

		case(operator)
			4'b0000 : $write("ADD");
			4'b0001 : $write("SUB");
			4'b0010 : $write("MUL");
			4'b0011 : $write("DIV");
		endcase

		$display(" R%0d, R%0d, R%0d  RAW = %0d  WAR = %0d  WAW = %0d", val1, val2, val3, raw, war, waw);
		raw=0;war=0;waw=0;
	end

	flag = flag + 1;
	if(flag == 4)
	begin
		raddr = val2; #2 op1 = Register;
		raddr = val3; #2 op2 = Register;
		raddr = val1;
		case(operator)
			4'b0000 : res = op1 + op2;
			4'b0001 : res = op1 - op2;
			4'b0010 : res = op1 * op2;
			4'b0011 : res = op1 / op2;
		endcase
		$display("R%0d = %0d, R%0d = %0d, R%0d = %0d", val1, res, val2, op1, val3, op2);
		flag=0;
	end

end

endmodule
