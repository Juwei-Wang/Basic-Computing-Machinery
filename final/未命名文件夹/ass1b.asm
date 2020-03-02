/*
    Name: Juwei wang
	UCID: 30053278
	Date: 2019-05-17

	Assignment 1: Part B
	Prof. Tamer Jarada
	Lecture: 01
	Tut: 02
    
	This program is to find the maximum of y = -5x^3 - 31x^2 + 4x + 31 in the range -6 <= x <= 5, by stepping through the range
	one by one in a loop and testing and using A64 assembling language.

	This program is written with macros, and only the mul, add, and mov instructions are
	used to do calculations.
*/

		define(x_r, x19)								//Define x_r as the x value, and set it to register x19
		define(y_r, x20)								//Define y_r as the y value, and set it to register x20
		define(maxResult_r, x21)								//Define maxResult_r as the y maximum value, and set it to register x21
		define(temp_r, x22)								//Define a temporary variable used to hold temporary values.
		define(element1_r, x23)							//Define a coefficient for the 1st term in the polynomial
		define(element2_r, x24)							//Define a coefficient for the 2nd term in the polynomial
		define(element3_r, x25)							//Define a coefficient for the 3rd term in the polynomial
		define(element4_r, x26)							//Define a coefficient for the 4th term in the polynomial
		define(loopCounter, x28)						//Loop loopCounter. Used to initialize the first Y_max.	


values:		
        .string "For X =  %d, Y = %d.\n     The current maximum of Y = %d.\n"		//The print label for values of x, y, and z to be completed each interval. 
		.balign 4									     //This aligns instructions by 4 bits.


		.global main 									//Makes "main" visible to the OS


main:		
        stp x29, x30, [sp, -16]! 					    //Save FP and LR to stack, allocating 16 bytes, pre-increment SP
		mov x29, sp 									//Update frame pointer (FP) to current stack pointer (SP)		

		mov element1_r, -5	                            // set element1_r to a value of -5
		mov element2_r, -31		                        // set element1_r to a value of -31
		mov element3_r, 4		                        // set element1_r to a value of -4
		mov element4_r, 31                              // set element1_r to a value of 31
	
		mov x_r, -6								     	//Set X to a value of -6.

		mov loopCounter, 0								//Set loop loopCounter to 0.


		b test									    	//Branch to test at bottom of loop.

												        // <--- Start of code inside the loop.
top:		
        mov y_r, 0								     	//Re-initialize Y to 0 for the beginning of each iteration.
		mov temp_r, 0									//Re-set temp_r to 0

		add y_r, y_r, element4_r						//Add 31 to Y

		madd y_r, element3_r, x_r, y_r					//y_r = y_r + (x_r * element3_r) (Y = 31 + 4X)
				

		mul temp_r, element2_r, x_r						//temp_r = element2_r * x_r (Temp = -31X)
		madd y_r, temp_r, x_r, y_r						//y_r = temp_r * x_r + temp_r   (Y = 31 + 4X - 31X^2)

		mov temp_r, 0									//Re-set temp_r to 0
		mul temp_r, element1_r, x_r						// temp_r = element1_r * X ( = -5X)
		mul temp_r, temp_r, x_r							// temp_r = temp_r * X ( = -5X^2)
		madd y_r, temp_r, x_r, y_r						// y_r = temp_r * X + y_r   (Y = 31 + 4X - 31X^2 - -5X^3)


		

		cmp loopCounter, 0								//If the loop loopCounter is 0, then the Y_max should be set to the current Y value.
		b.eq YmaxCondition
		
		cmp y_r, maxResult_r									//Compares Y and Y_max. If Y is greater than current Y_max, then branch to update Y max.
		b.gt YmaxCondition									// If Y > Y-Max, set Y-Max = Y 




AddValue:

        adrp x0, values									// Set the 1st argument of printf
		add x0, x0, :lo12:values						// Add the low 12 bits to x0
		mov x1, x_r									    // Place the value of X into the x1 register for the printf argument.
		mov x2, y_r									    // Place the value of Y into the x2 register for the printf argument.
		mov x3, maxResult_r									// Place the value of Y-maximum into the x3 register for the printf argument.
        bl printf									    //Calls the printf function.


		add x_r, x_r, 1									//Increments X by 1.
		add loopCounter, loopCounter, 1					//Increments loop loopCounter by 1.


		b test										    // <--- End of code inside the loop. Return to test if loop should go again.


YmaxCondition:	
        mov maxResult_r, y_r							 //Places the value of Y into Y_max
		b AddValue								     	//Returns to the end of the loop.
	
test:		
        cmp x_r, 5								     	//Compare X variable with the immediate 5
		b.le top								    	//If X < 5, branch to "top"

completion:		
        mov x0, 0								    	// <--- Code upon completion. (When X > 5) 
												        // Return the x0 register to 0.
		ldp x29, x30, [sp], 16							// Restore FP and LR from stack, post-increment SP

		ret										        // Return to caller
