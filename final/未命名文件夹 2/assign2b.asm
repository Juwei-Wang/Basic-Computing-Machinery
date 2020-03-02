/*  CPSC 355 - Computing Machinery 1
	Assignment 
	
	Juwei wang
	UCID: 30053278
	
	Overview: This program is a sample ARMv8 A64 assembly language program that has been developed to practice bitwise logical and shift operations,
	use of branching and condition code tests, and understanding of hexidecimal and binary numbers.

	The original code was written in the C language, and was translated into the ARMv8 A64 assembly language. Refer to CPSC 355 Assignment 2 sheet for original C code.

	Part A) "assign2a.asm": Direct translation of C code.
	Part B) "assign2b.asm": Same as part A, except 522133279 is used for the multiplicand, and 200 for the multiplier. 
	Part C) "assign2c.asm": Same as part A, except -252645136 is used for the multiplicand, and -256 for the multiplier.

*/

define(multiplier_s, w19)							// Assign "multiplier_s", and store it to the 32bits register w19
define(multiplicand_s, w20)							// Assign "multiplicand_s", and store it to the 32bits register w20
define(product_s, w21)								// Assign "product_s", and store it to the 32bits register w21
define(i, w22)								        // Assign i, and store it to the 32bits register w22
define(negative, w23)								// Assign "negative", and store it to the 32bits register w23
define(temp1_s, x24)								// Assign "temp1_s", and store it to the 64bits register x24
define(temp2_s, x25)								// Assign "temp2_s", and store it to the 64bits register x25
define(result_s, x26)	                        	// Assign "result_s", and store it to the 64bits register w26
define(true, w24)                                   // Assign "true", and store it to the 32bits register w24
define(false, w25)                                  // Assign "false", and store it to the 32bits register w25




values_1:	.string "multiplier = 0x%08x (%d)  multiplicand = 0x%08x (%d)\n\n"		// The print label for values "multiplier_s", and "multiplicand_s", displaying 8 digits of hex, and in decimal.
										

values_2:	.string "product = 0x%08x multiplier = 0x%08x\n"				// The 2nd print label for the values "product" and "multiplier_s", following some bitwise operations.  
										

values_3:	.string "64-bit result = 0x%016lx (%ld)\n"					// The 3rd print label, for the 64-bit of the 32-bit "product" and "multiplier_s" side-by-side. 
								
        .balign 4
		.global main								  // Makes "main" visible to the OS

main:		
        stp x29, x30, [sp, -16]!					  // Save FP and LR to stack, allocating 16 bytes, pre-increment SP
		mov x29, sp				                      // Update frame pointer (FP) to current stack pointer (SP)
        mov true, 1                                   // Initialize "true" variable with the value 1.
        mov false,0	                                  // Initialize "false" variable with the value 0.
        mov i, 0                          			  // Initialize "i" variable with the value 0.		
        mov multiplicand_s, 522133279                 // Initialize "multiplicand_s" variable with the value 522133279. Place the first half of 0xFEFEFEFE in.
		mov multiplier_s, 200						  // Initialize "multiplier_s" variable with the value 200.
		mov product_s, 0						      // Initialize "product" variable with the value 0.	  
		
        
												        // ** First print statement **
		adrp x0, values_1								// Set the 1st argument of printf
		add x0, x0, :lo12:values_1						// Add the low 12 bits to x0
		mov w1, multiplier_s							// Place the value of "multiplier_s" into the x1 register for the printf argument.
		mov w2, multiplier_s							// Place the value of "multiplier_s" into the x2 register for the printf argument.
		mov w3, multiplicand_s 							// Place the value of "multiplicand_s" into the x3 register for the printf argument.
		mov w4, multiplicand_s							// Place the value of "multiplicand_s" into the x4 register for the printf argument.

		bl printf	                                    // Calls the printf function.

        cmp multiplier_s, 0                             // Test to see if w17 is equal to zero or not
        b.lt neg_true                                   // if the condition is satisfied, jump into the neg_true loop
        b neg_false                                     // if the condition is not satisfied, jump into the neg_false loop


neg_true: 
        mov negative, true                             // Place the value of "true into the negative register for the printf argument.
        b test                                         // jump into the test loop

neg_false:
        mov negative, false                           // Place the value of "false" into the negative register for the printf argument.
        b test                                        // jump into the test loop

test:   
        cmp i, 32                                     // Test to see if i is less than 32 or not
        b.lt first_T                                 // if the condition is satisfied, jump into the first_T loop
        b third_T                                    // jump into the third_T loop

first_T: 
       and w26, multiplier_s, 0x1
       cmp w26, true                                  // Test to see if w26 is equal to the value true or not
       b.eq add_product                               // if the condition is satisfied, jump into the add_product loop
       b second_T                                     // jump into the second_T loop

add_product:
       add product_s, product_s, multiplicand_s      
       b second_T                                    // jump into the second_T loop

second_T:
       asr multiplier_s, multiplier_s, 1             // Arithmetic shift right the combined product and multiplier
       and w27, product_s, 0x1                       // Completes an AND operation, placing the result into the W27 register
       cmp w27, true                                 // Test to see if w27 is equal to the value true or not 
       b.eq product_true                             // if the condition is satisfied, jump into product_true loop
       AND multiplier_s, multiplier_s, 0x7FFFFFFF    // Completes an AND operation, placing the result into the multiplier register
       asr product_s, product_s, 1                   // Arithmetic shift right by 1.
       add i, i,1                                   // i++
       b test                                       // return to the start of for loop


product_true:
       orr multiplier_s, multiplier_s, 0x80000000   // Complete an ORR operation and store result in multiplier.
       asr product_s, product_s, 1                  // Arithmetic shift right by 1.
       add i, i, 1                                  // i++
       b test                                       // return to the start of for loop

third_T:
       cmp negative,true                          // Test to see if negative is equal to the value of true or not
       b.eq  minor_product                        // if the condition is satisfied, jump into the minor_product loop
       b print3                                   // jump into the print3 loop

minor_product:
       sub product_s, product_s, multiplicand_s  // If multiplier is negative, then do product = product - mulitplicand
       b print3                                  // jump into the print3 loop

print3:
        adrp    x0, values_2                     //the second output statement
	    add     x0, x0, :lo12:values_2            // Add the low 12 bits to x0
		mov     w1, product_s                     // Place the value of "profuct_s" into the w1 register for the printf argument.
		mov     w2, multiplier_s                  // Place the value of "multiplier_s" into the w2 register for the printf argument.
		bl      printf                            // Calls the printf function.

        sxtw    x22, product_s                    //signed extend word of product to make it 64bit
		and     temp1_s, x22, 0xFFFFFFFF          //temp1_s = (long int)product & 0xFFFFFFFF
		lsl     temp1_s, temp1_s, 32              //logial shift left by 32
		sxtw    x23, multiplier_s                 //signed extend word of multiplier to make it 64bit
		and     temp2_s, x23, 0xFFFFFFFF          //temp2_s = (long int)multiplier & 0xFFFFFFFF
		add     result_s, temp1_s, temp2_s

        adrp    x0, values_3                    //the third output statement
		add     x0, x0, :lo12:values_3          // Add the low 12 bits to x0
		mov     x1, result_s                    // Place the value of "result_s" into the x1 register for the printf argument.
		mov     x2, result_s                    // Place the value of "result_s" into the x2 register for the printf argument.
		bl      printf                          // Calls the printf function.
       

done:       
        mov w0, 0                               //return the x0 register to 0
		ldp x29, x30,[sp], 16                   //restore FP and LR from stack, post-increment SP
		ret                                     // Return to caller