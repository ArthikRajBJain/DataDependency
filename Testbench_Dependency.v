`timescale 1ns / 1ps
`include "DependencyCheck.v"

module Testbench_Dependency();

reg [3:0] data [63:0];
wire [5:0] address;
reg [3:0] send;
//reg [5:0] addr;
reg [7:0] Register [7:0];
reg [7:0] Register_Send;
wire [2:0] Register_Address;
wire [7:0] result;

DependencyCheck D1(address, Register_Address, result, send, Register_Send);

initial
begin

	//ADD R5, R0, R1
	data[0] = 0;
	data[1] = 5;
	data[2] = 0;
	data[3] = 1;
	
	//MUL R6, R2, R5
        data[4] = 2;
        data[5] = 6;
        data[6] = 2;
        data[7] = 5;

	//SUB R5, R3, R6
        data[8] = 1;
        data[9] = 5;
        data[10] = 3;
        data[11] = 6;

	//DIV R6, R5, R4
        data[12] = 3;
        data[13] = 6;
        data[14] = 5;
        data[15] = 4;
	
	//DIV R2, R3, R4
        data[16] = 2;
        data[17] = 2;
        data[18] = 3;
        data[19] = 4;
	
	//DIV R6, R5, R4
        data[20] = 1;
        data[21] = 6;
        data[22] = 5;
        data[23] = 4;
	
	//MUL R6, R2, R1
        data[24] = 2;
        data[25] = 6;
        data[26] = 2;
        data[27] = 1;

	//END
	data[28] = 4;
	
	//Register Initialization
	Register[0] = 2;
	Register[1] = 3;
	Register[2] = 4;
	Register[3] = 5;
	Register[4] = 6;
	Register[5] = 7;
	Register[6] = 8;
	Register[7] = 9;
	
	//Initialization of variables
	
	
end

always @ (address)
begin
	send = data[address];
end

always @ (Register_Address)
begin
	Register_Send = Register[Register_Address];
end

always @ (result)
begin
	Register[Register_Address] = result;
end



endmodule
