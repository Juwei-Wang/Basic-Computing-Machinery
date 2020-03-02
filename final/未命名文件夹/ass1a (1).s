/*
    Name: Juwei wang
	UCID: 30053278
	Date: 2019-05-17

	Assignment 1: Part A
	Prof. Tamer Jarada
	Lecture: 01
	Tut: 02
    
	This program is to find the maximum of y = -5x^3 - 31x^2 + 4x + 31 in the range -6 <= x <= 5, by stepping through the range
	one by one in a loop and testing and using A64 assembling language.

	This program is written without macros, and only the mul, add, and mov instructions are
	used to do calculations.
*/



values:	.string "For X =  %d, Y = %d.\n     The current maximum of Y = %d.\n"		//Set a print label for values of x, y, and set the result step by step in loop.
		.balign 4									//This aligns instructions by 4 bits.


		.global main 									//visible instructions


main:		
        stp x29, x30, [sp, -16]! 							//Save FP and LR to stack, allocating 16 bytes, pre-increment SP
		mov x29, sp 									//Update frame pointer (FP) to current stack pointer (SP)

		mov x20, -6								//Reserve a register for X. Begin with a value of -6.
		mov x21, 0									//Initialize a register to 0 to start.
		mov x22, 0									//Initialize a register to 0 for y.

		mov x28, 0									//Loop local vairable for counting the times of calculation


test:		
        cmp x20, 5									//Compare x19 (X variable) with the immediate 5
		b.gt completion									//If X > 5, branch to "completion"

												// <--- Start of code inside the loop.

		mov x21, 0									//Re-initialize result to 0 at the beginning of each start of loop .

		add x21, x21, 31								//Add 31 to result

		mov x23, 4									//x22 register used as temporary register. Start by placing 4 into it.
		mul x23, x23, x20								//Multiply 4*x and store in x22
		add x21, x21, x23								//x21 = x21 + x22 (Y = 31 + 4X)

		mov x23, -31									//Place -31 into x22 register
		mul x23, x23, x20								//x22 = x22 * x19 (Temp = -31X)
		mul x23, x23, x20								//x22 = x22 * x19 (Temp = -31X^2)
		add x21, x21, x23								//x21 = x21 + x22 (result = 31 + 4X -31X^2)

		mov x23, -5								//Place the value of -5 into x22
		mul x23, x23, x20								// Temp = -5X
		mul x23, x23, x20								// Temp = -5X*X
		mul x23, x23, x20								// Temp = -5X*X*X
		add x21, x21, x23								//x21 = x21 + x22 (result = 31 + 13X -24X^2 -5X^3)


		cmp x28, 0									//If the loop counter is 0, then the Y_max should be set to the current Y value.
		b.eq YmaxCondition
		
		cmp x21, x22									//Compares Y and Y_max. If Y is greater than current Y_max, then branch to update Y max.
		b.gt YmaxCondition									// If Y > Y-Max, set Y-Max = Y 


AddValue:
        
		adrp x0, values									// Set the 1st argument of printf
		add x0, x0, :lo12:values							// Add the low 12 bits to x0
		mov x1, x20									// Place the value of X into the x1 register for the printf argument.
		mov x2, x21									// Place the value of Y into the x2 register for the printf argument.
		mov x3, x22									// Place the value of result into the x3 register for the printf argument.
		bl printf									//Calls the printf function.
		
		add x20, x20, 1									//Increments X by 1.
		add x28, x28, 1									//Increments loop counter by 1.
		b test										// <--- End of code inside the loop. Return to test if loop should go again.
	

YmaxCondition:	
        mov x22, x21									//store the value of Y into Y_max
		b AddValue									//Returns to the end of the loop.
	
completion:		
        mov x0, 0									// <--- Code upon completion. (When X > 5) 
												// Return the x0 register to 0.
		ldp x29, x30, [sp], 16								// Restore FP and LR from stack, post-increment SP

		ret										// Return to caller
