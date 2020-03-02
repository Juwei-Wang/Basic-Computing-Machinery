/*
*	Assignment 4
*	
*	Lecture Section: L01
*
*	Juwei wang
*	UCID: 30053278
*	Date: 2019-06-09
*
*	assign4.asm: 
*	An assignment, which practices utilization of subroutines and structs. This program allows the "main" method to act as a driver, which creates instances of two boxes. 
*	It then invokes various methods (subroutines) in the program, which modifies the first box. The output is printed, which indicates the details of the first and second
*	boxes. 
*/







print1:	.string "Box %s origin = (%d, %d)  width = %d  height = %d  box_area = %d\n"   // Print function, displaying details of a given box.

print2:	.string "\nChanged box values:\n"                // String for printing before box values.

print3:	.string "Initial box values:\n"                  // String for printing before box values.

print_first:	.string "first"                          // String for "first" box.

print_second:	.string "second"                         // String for "second" box.



        define(first_Box, x19)							//base address of first_Box in stack
        define(second_Box, x20)							//base address of second_Box in stack

        .balign 4								     	//make word aligne

		point_x = 0										//Offset of #point_x# from base of struct point
		point_y = 4										//Offset of #point_y# from base of struct point
		
		D_width_s = 0									// Offset of #dimension_width# from base of struct dimension
		D_height_s = 4								    // Offset of #dimension_height# from base of struct dimension

		box_point_s = 0									//stack address of point
		box_dimension_s = 8								//Size of struct "dimension". (Two ints, each of size 4 bytes)
		box_area = 16									//Offset of int "area".


		SIZE = 50										//size = 50
        FALSE = 0										//false = 0
        TRUE = 1										//true = 1

        first_Box_s = 16								//first_Box location in stack
        second_Box_s = 36								//second_Box location in stack

        first_Box_size = 20								// "Creating" an instance of box 1 struct in memory
        second_Box_size = 20							// "Creating" an instance of box 2 struct in memory
        Bopoint_xize = first_Box_size + second_Box_size   // total sizes

        alloc = -(16 + Bopoint_xize) & -16			    //total size allocate from stack
        dealloc = -alloc								//total size deallocate from stack

		fp .req x29						            	// Define fp as x29
		lr .req x30							            // Define lr as x30	

/*+**********************************************************************************************/

newBox:	stp 	x29, x30, [sp, alloc]!              // Allocate memory for the newbox frame record.
		mov		x29, sp                             // Move the stack pointer to the frame pointer.
		
		mov		x7, x0								//Moving the starting location of the box into start register
		
		mov 	x13, 0								// Use temp register w9 to hold value of 0.
		mov 	x14, 1								// Use temp register w9 to hold value of 1.
		mul		x15, x14, x14						// box_area calculating
		
		str 	x13, [x7, box_point_s + point_x]			// b.origin.x = 0 
		str 	x13, [x7, box_point_s + point_y]			// b.origin.y = 0 
		str 	x14, [x7, box_dimension_s + D_width_s]	    // b.size.width = 1
		str 	x14, [x7, box_dimension_s + D_height_s]	    // b.size.height = 1
		str 	x15, [x7, box_area]						// b.size.area = 1*1 = 1
		
		mov 	x0, x7								//store box to x0 to return
		
		ldp 	x29, x30, [sp], dealloc				//Restore fp and lr from stack
		ret											//return to main
		
move: 	stp 	x29, x30, [sp, alloc]!              // Allocate memory for the newbox frame record.
		mov		x29, sp                             // Move the stack pointer to the frame pointer.
		
		mov     x28,x0                              // x28 = base address of box struct to be moved.
		mov     x22, x1						     	// x22 = int deltaX (amount to move x)
		mov     x23, x2                             // x23 = int deltaY (amount to move y)

		ldr 	x13, [x28, box_point_s + point_x]		// Load current box x value to x13
		ldr 	x14, [x28, box_point_s + point_y]		// Load current box y value to x14
		
		add 	x13, x13, x22						//b.origin.x + deltaX
		str 	x13, [x28, box_point_s + point_x]			//b.origin.x = b.origin.x + deltaX

		add 	x14, x14, x23						//b.origin.y + deltaY
		str 	x14, [x28, box_point_s + point_y]			//b.origin.y = b.origin.y + deltaY
		
		mov x0, 0							
		mov w1, 0

		ldp 	x29, x30, [sp], dealloc				//Restore fp and lr from stack
		ret											//return to main
		
expand:	
        stp 	x29, x30, [sp, alloc]!               // Allocate memory for the newbox frame record.
		mov		x29, sp                              // Move the stack pointer to the frame pointer.
		
		ldr 	x13, [x0, box_dimension_s + D_width_s]		// Load current box width value to x13
		ldr 	x14, [x0, box_dimension_s + D_height_s]		// Load current box height value to x14
		
		mul		x13, x13, x1						//b.origin.x * factor
		str 	x13, [x0, box_dimension_s + D_width_s]	//b.origin.x = b.origin.x * factor

		mul 	x14, x14, x1						//b.origin.y * factor
		str 	x14, [x0, box_dimension_s + D_height_s]	//b.origin.y = b.origin.y * factor
		
		mul 	x15, x13, x14						//b.origin.x * b.origin.y	
     	str 	x15, [x0, box_area]						//b.origin.box_area = b.origin.x * b.origin.y
		
		mov x0, 0						         	 // Return x0 to 0
		mov w1, 0                                    // Return w2 to 0

		ldp 	x29, x30, [sp], dealloc				//Restore fp and lr from stack
		ret											//return to main

printBox:
		stp 	x29, x30, [sp, alloc]!              // Allocate memory for the newbox frame record.
		mov		x29, sp                             // Move the stack pointer to the frame pointer.
		
		mov 	x13, x1
		mov 	x1, x0
		
		adrp 	x0, print1							//print print1
		add 	x0, x0, :lo12:print1
		ldr 	x2, [x13, box_point_s + point_x]				// Load current box x value to x2
		ldr 	x3, [x13, box_point_s + point_y]				// Load current box y value to x3
		ldr 	x4, [x13, box_dimension_s + D_width_s]		    // Load current box width value to x4
		ldr 	x5, [x13, box_dimension_s + D_height_s]      	// Load current box height value to x5
		ldr 	x6, [x13, box_area]						        // Load current box area value to x6
		bl 		printf			
		
		ldp 	x29, x30, [sp], dealloc				//Restore fp and lr from stack
		ret											//return to main
	
equal: 	stp 	x29, x30, [sp, alloc]!                // Allocate memory for the newbox frame record.
		mov		x29, sp                               // Move the stack pointer to the frame pointer.
		
		ldr 	x13, [x0, box_point_s + point_x]			//b1.origin.x
		ldr 	x14, [x1, box_point_s + point_x]			//b2.origin.x
		cmp 	x13, x14							//Compare b1.origin.x with b2.origin.x
		b.ne 	false								//If not equal then branch to notEqual
		
		ldr 	x13, [x0, box_point_s + point_y]			//b1.origin.y
		ldr 	x14, [x1, box_point_s + point_y]			//b2.origin.y
		cmp 	x13, x14							//Compare b1.origin.y with b2.origin.y	
		b.ne 	false								//If not equal then branch to notEqual
		
		ldr 	x13, [x0, box_dimension_s + D_width_s]	//b1.size.width
		ldr 	x14, [x1, box_dimension_s + D_width_s]	//b2.size.width
		cmp 	x13, x14							//Compare b1.size.width with b2.size.width
		b.ne 	false								//If not equal then branch to notEqual
		
		ldr 	x13, [x0, box_dimension_s + D_height_s]	//b1.size.height
		ldr 	x14, [x1, box_dimension_s + D_height_s]	//b2.size.height
		cmp 	x13, x14							//Compare b1.size.height with b2.size.height
		b.ne 	false								//If not equal then branch to notEqual
		
		mov x0, TRUE							// If the program has got to this point, all variables are equal. Set x0 to true.
		b done_eq	                            // Branch to the end of the program.

false:		
		mov x0, FALSE	                // Set x0 to false.
		b done_eq						// Branch to the end of the program.

done_eq:	
        ldp x29, x30, [sp], dealloc						// De-allocate the frame record
		ret		


/*+**********************************************************************************************/

		
		.global main								//Make "main" visible to the OS
main:	stp		x29, x30, [sp, alloc]!				// Allocate memory for the newbox frame record.
		mov 	x29, sp								// Move the stack pointer to the frame pointer.
		
		add 	first_Box, x29, first_Box_s			//set the base in the stack for first_Box
		mov 	x0, first_Box						//let first_Box address as argument
		bl 		newBox								//call subroutine newBox
		
		add 	second_Box, x29, second_Box_s			//set the base in the stack for second_Box
		mov 	x0, second_Box						//let second_Box address as argument
		bl 		newBox								//call subroutine newBox
		
		adrp 	x0, print3							//print print3
		add 	x0, x0, :lo12:print3
		bl 		printf
		


		
print_b:		
        mov 	x1, first_Box
        adrp 	x0, print_first						//print print_first
		add 	x0, x0, :lo12:print_first	        // Load the lower 12 bits into "first"
		bl 		printBox							//call subroutine printBox

        mov 	x1, second_Box
		adrp 	x0, print_second					//print print_second
		add 	x0, x0, :lo12:print_second          // Load the lower 12 bits into "first"
		bl 		printBox							//call subroutine printBox
		
		mov 	x0, first_Box						//Store the pointer of first_Box to x0
		mov 	x1, second_Box						//Store the pointer of second_Box to x0
		bl 		equal								//call subroutine equal


		mov 	x23, x0								//Store the results of equal to x23
		cmp 	x23, TRUE							//compare x23 with true
		b.ne	next								//If equal not equal to true then branch to test
		
		mov		x0, first_Box						//Store the pointer of first_Box to x0
		mov 	x1, -5								//Store -5 as second argument x1
		mov		x2, 7								//Store 7 as third argument x2
		bl 		move								//call subroutine move
		
		mov 	x0, second_Box						//Store the pointer of second_Box to x0
		mov 	x1, 3								//Store 3 as second argument x1
		bl 		expand								//call subroutine expand

next: 			
	    
		adrp x0, print2					          	// Print out "Changed box values"
		add x0, x0, :lo12:print2					// Load the lower 12 bits into "first"
		bl printf                                   // Branch to prinf function

print_a:
   
        mov 	x1, first_Box                       // x1 = base address of box_1
		adrp 	x0, print_first					    //print print_first
		add 	x0, x0, :lo12:print_first           // Load the lower 12 bits into "first"
		bl 		printBox							//call subroutine printBox

        mov 	x1, second_Box                      // x1 = base address of box_2
		adrp 	x0, print_second					//print print_second
		add 	x0, x0, :lo12:print_second	        // Load the lower 12 bits into "first"
		bl 		printBox							//call subroutine printBox

done:	
        mov     x0, 0                               // Return 0 to OS
		ldp 	x29, x30, [sp], dealloc				//Restoring fp and lr	
		ret											//Return function for program


		