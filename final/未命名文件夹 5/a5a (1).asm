/*
*	Assignment 5
*	
*	Lecture Section: L01
*	
*
*	Juwei Wang
*	UCID: 30053278
*	Date: 2019-06-16
*
*	a5a.asm:
*       This file is utilized by the C program, which uses these subroutines to accept keyboard 
*       input for calculator commands, in the "reverse polish" notation.
*
*/

        define(operation, w19)  //register for base address of operation
        define(value,w20)       //register for base address of valye
        define(t_regis,x21)     //register for base address of t_regis
        define(h_regis,x22)     //register for base address of h_regis
        define(q_regis,x23)     //register for base address of q_regis
        define(argc,w24)        //register for base address of argc
       
        QUEUESIZE = 8       // Equate for QUEUESIZE
        MADMASK = 0x7       // Equate for MADMASK 
        FALSE = 0           // Equate for FALSE
        TURE = 1            // Equate for TURE

        .bss
queue_m:        .skip  QUEUESIZE*4  // Create an array for val.

        .text
print_1:        .string "### Queue Operations ###\n\n"                              // Print statement 
print_2:        .string "Press 1 - Enqueue, 2 - Dequeue, 3 - Display, 4 - Exit\n"   // Print statement 
print_3:        .string "Your option? "                                             // Print statement 
Print_4:        .string "\nQueue overflow! Cannot enqueue into a full queue.\n"     // Print statement 
print_5:        .string "\nQueue underflow! Cannot dequeue from an empty queue.\n"  // Print statement 
print_6:        .string "\nEmpty queue\n"                                           // Print statement                             
print_7:        .string "\nCurrent queue contents:\n"                               // Print statement 
print_8:        .string "\n"                                                        // Print statement 
print_9:        .string "  %d"                                                      // Print statement 
print_10:       .string " <-- head of queue"                                        // Print statement 
print_11:       .string " <-- tail of queue"                                        // Print statement 
head_m:         .word  -1     //integer                                              
tail_m:         .word  -1     //integer  

         .global queue_m  // Variable for the "queue" (local stack pointer)	
         .global head_m   // Variable for the "head" (local stack pointer)	
         .global tail_m   // Variable for the "tail" (local stack pointer)	

         .balign 4
    

//_______________________________________________________________________________________
        .balign 4								//make word aligned
	.global queueFull   

queueFull: 
        stp x29,x30,[sp, -16]!        // Allocate memory for queueFull subroutine.
        mov x29,sp                    //Move the value
  
	adrp 	t_regis, tail_m	      // Set register to hold 	
	add 	t_regis, t_regis, :lo12:tail_m	 // Load low 12 bits
	ldr 	w10, [t_regis]        // Load value of from pointer address
        add     w10, w10, 1

        adrp 	h_regis, head_m      // Set register to hold 		 		
	add 	h_regis, h_regis, :lo12:head_m	 // Load low 12 bits
	ldr 	w11, [h_regis]       // Load value of from pointer address

        and w10, w10, MADMASK       // calculator 
        
        cmp w10, w11                // compare
        b.eq   FullTure             // Branch to top of loop and go again.
        b   FullFalse               // branch to the next item


FullTure: 
        mov w0, TURE                // Move the value
        ldp 	x29, x30, [sp], 16  // De-allocate memory from stack
        ret                         // Return to caller.

FullFalse:
        mov w0, FALSE              //Move the value
        ldp 	x29, x30, [sp], 16  // De-allocate memory from stack
        ret                          // Return to caller.

//_______________________________________________________________________________________
        .balign 4								//make word aligned
	.global queueEmpty        // Make Function "queueEmpty" visible globally
    
queueEmpty: 
        stp x29,x30,[sp, -16]!                   // Allocate memory for queueEmpty subroutine.
        mov x29,sp                  //Move the value

        adrp 	h_regis, head_m	  // Set register to hold 					
	add 	h_regis, h_regis, :lo12:head_m		// Load low 12 bits
	ldr 	w11, [h_regis]    // Load value of from pointer address
  
        mov w12, -1               //Move the value

        cmp w12, w11              // compare
        b.eq   FullTure           // Branch to top of loop and go again.
        b   FullFalse             // branch to the next item


EmptyTure: 
        mov w0, TURE               //Move the value
        ldp 	x29, x30, [sp], 16   // De-allocate memory from stack
        ret                        // Return to caller.

EmptyFalse:
        mov w0, FALSE              //Move the value
        ldp 	x29, x30, [sp], 16   // De-allocate memory from stack
        ret                        // Return to caller.


//_______________________________________________________________________________________

        .balign 4								//make word aligned
	.global enqueue_v // Make Function "emqueue" visible globally

enqueue_v:
        stp x29,x30,[sp, -16]!             // Allocate memory for enqueue_v subroutine.
        mov x29,sp                  //Move the value
        
        mov w22, w0	           //Move the value
        bl queueFull
        cmp w0, TURE              // compare
        b.eq enTure               // Branch to top of loop and go again.
        b enFalse                 // branch to the next item

enTure:
       	adrp 	x0, Print_4	   // Set register to hold 	
	add 	x0, x0, :lo12:Print_4		// Load low 12 bits
	bl 	printf
        
        ldp 	x29, x30, [sp], 16     // De-allocate memory from stack
        ret                            // Return to caller.

enFalse:
        bl queueEmpty
        cmp w0, TURE                   // compare
        b.eq enFalseTURE               // Branch to top of loop and go again.
        b enFalseFalse                 // branch to the next item

enFalseTURE:
        mov w9, 0                    //Move the value

        adrp 	t_regis, tail_m		 // Set register to hold 				
	add 	t_regis, t_regis, :lo12:tail_m		// Load low 12 bits
	str 	w9, [t_regis]           // Move value of into memory.
      
        adrp 	h_regis, head_m		// Set register to hold 		 		
	add 	h_regis, h_regis, :lo12:head_m	  	// Load low 12 bits
	str	w9, [h_regis]             // Move value of into memory.

        adrp 	t_regis, tail_m		// Set register to hold 			 	
	add 	t_regis, t_regis, :lo12:tail_m	
	ldr 	w10, [t_regis]    // Load value of from pointer address

        adrp 	q_regis, queue_m	// Set register to hold 	
	add 	q_regis, q_regis, :lo12:queue_m	    //load to lower 12 bits
	str 	w22, [q_regis, w10, SXTW 2]    // Move value of into memory.

        ldp 	x29, x30, [sp], 16      // De-allocate memory from stack
        ret                            // Return to caller.

enFalseFalse:
        adrp 	t_regis, tail_m		// Set register to hold 	
	add 	t_regis, t_regis, :lo12:tail_m	//load to lower 12 bits
	ldr 	w23, [t_regis]		// Load value of from pointer address
			
	add 	w23, w23, 1						//++tail
	and 	w23, w23, MADMASK		// calculator 
	str 	w23, [t_regis]			// Move value of into memory.
		
	adrp 	q_regis, queue_m				//set up x21 as queue_m
	add 	q_regis, q_regis, :lo12:queue_m	 //load to lower 12 bits
	str 	w22, [q_regis, w23, SXTW 2]	 // Move value of into memory.
        ldp 	x29, x30, [sp], 16     // De-allocate memory from stack
        ret                           // Return to caller.

//_______________________________________________________________________________________
        .balign 4								//make word aligned
	.global Dequeue             // Make Function "Dequeue" visible globally

Dequeue:
        stp x29,x30,[sp, -16]!              // Allocate memory for Dequeue subroutine.
        mov x29,sp                      //Move the value

        bl queueEmpty
        cmp w0, TURE                    // compare
        b.eq DequeueEmptyTure           // Branch to top of loop and go again.
        b DequeueEmptyFalse             // branch to the next item

DequeueEmptyTure:
        adrp 	x0, print_5		// Set register to hold 		//Add format1 to first print arg
	add 	x0, x0, :lo12:print_5		// Load low 12 bits
	bl 	printf
        
        mov     w0,-1                    //Move the value
        ldp 	x29, x30, [sp], 16       // De-allocate memory from stack
        ret                             // Return to caller.

DequeueEmptyFalse:

        adrp 	h_regis, head_m		// Set register to hold 				
	add 	h_regis, h_regis, :lo12:head_m		// Load low 12 bits
	ldr 	w11, [h_regis] 

        adrp 	q_regis, queue_m	// Set register to hold 	
	add 	q_regis, q_regis, :lo12:queue_m	         // Load low 12 bits
	ldr 	w12, [q_regis, w11, SXTW 2]	// Load value of from pointer address
  
        adrp 	t_regis, tail_m		// Set register to hold 				
	add 	t_regis, t_regis, :lo12:tail_m	    	// Load value of from pointer address
	ldr 	w9, [t_regis]      // Load value of from pointer address

        mov     w0, w12               //Move the value

        cmp     w11,w9                // compare
        b.eq    deIf                  // Branch to top of loop and go again.
        b       deElse                // branch to the next item

deIf: 
        mov     w14, -1                //Move the value
        
        adrp 	t_regis, tail_m		// Set register to hold 			
	add 	t_regis, t_regis, :lo12:tail_m	 	// Load low 12 bits
	str 	w14, [t_regis]          // Move value of into memory.
      
        adrp 	h_regis, head_m		// Set register to hold 			
	add 	h_regis, h_regis, :lo12:head_m	  	// Load low 12 bits
	str	w14, [h_regis]          // Move value of into memory.

        ldp 	x29, x30, [sp], 16      // De-allocate memory from stack
        ret                               // Return to caller.

deElse: 
        
        adrp 	h_regis, head_m		// Set register to hold 	
	add 	h_regis, h_regis, :lo12:head_m		// Load low 12 bits
	ldr 	w23, [h_regis]			// Load value of from pointer address
			
	add 	w23, w23, 1						//++tail
	and 	w23, w23, MADMASK		// calculator 
	str 	w23, [h_regis]			// Move value of into memory.

        ldp 	x29, x30, [sp], 16     // De-allocate memory from stack
        ret                            // Return to caller.
        
//_______________________________________________________________________________________
        .balign 4								//make word aligned
	.global Display                 // Make Function "Display" visible globally
Display:
        stp	x29, x30, [sp, -16]!			// Allocate memory for Display subroutine.
	mov 	x29, sp			 //Move the value

	mov 	w9, 0                     //Move the value
			
	bl 	 queueEmpty						//branch to queueEmpty
			
	cmp 	w0, TURE			// compare
	b.ne 	DisplayTure						//if w0 != TURE branch to DisplayTure
			
	adrp 	x0, print_6						//Add print_6 to first print arg
	add 	x0, x0, :lo12:print_6		// Load low 12 bits
	bl 	printf							//call printf
			
DisplayTure: 	
        adrp 	h_regis, head_m			// Set register to hold 	
	add 	h_regis, h_regis, :lo12:head_m	 	// Load low 12 bits
	ldr 	w10, [h_regis]					//load w10 as head
			
	mov 	w27, w10			 //Move the value
	adrp 	t_regis, tail_m			// Set register to hold 	
	add 	t_regis, t_regis, :lo12:tail_m		// Load low 12 bits
	ldr 	w11, [t_regis]			// Load value of from pointer address
			
	sub 	w28, w11, w10					//tail - head
	add 	w28, w28, 1						//tail - head + 1
			
	cmp 	w28, 0							//compare count with 0
	b.gt 	DisplayTure2		// branch to the next item
	add 	w28, w28, QUEUESIZE				//count = count + QUEUESIZE
			
DisplayTure2:	
        adrp 	x0, print_7						//Add print_7 to first print arg
	add 	x0, x0, :lo12:print_7			// Load low 12 bits
	bl 	printf							//call printf				
			
	mov 	w26, 0			     //Move the value
	adrp 	q_regis, queue_m				//set up x21 as queue_m
	add 	q_regis, q_regis, :lo12:queue_m	   	// Load low 12 bits

	b 	comp                        // branch to the next item

loopDisplay: 
        adrp 	x0, print_8			// Set register to hold 	
	add 	x0, x0, :lo12:print_8		// Load low 12 bits
	bl 	printf							//call printf

	adrp 	x0, print_9			// Set register to hold 	
	add 	x0, x0, :lo12:print_9		// Load low 12 bits
	ldr 	w1, [q_regis, w27, SXTW 2]	// Load value of from pointer address
	bl 	printf							//call printf
			
	cmp 	w27, w10			// compare
	b.ne 	loop2Display							//if i != head branch to loop2Display
			
	adrp 	x0, print_10			// Set register to hold 
	add 	x0, x0, :lo12:print_10		// Load low 12 bits
	bl 	printf							//call printf
			
loop2Display:	
        add 	w27, w27, 1						//++i
	and 	w27, w27, MADMASK				//++i & MADMASK
		
	add 	w26, w26, 1						//j++

comp:		
        cmp 	w26, w28						//compare j with count
	b.lt 	loopDisplay						//if j>=count branch to End

	adrp 	x0, print_11		// Set register to hold 	
	add 	x0, x0, :lo12:print_11		// Load low 12 bits
	bl 	printf							//call printf
						
End: 	
        ldp 	x29, x30, [sp], 16		// De-allocate memory from stack
	ret				       // Return to caller.						//Return function for program
//_______________________________________________________________________________________
        .balign 4								//make word aligned
	.global main            // Make Function "main" visible globally
main:
        stp	x29, x30, [sp, -16]!			// Allocate memory for main subroutine.
	mov 	x29, sp				 //Move the value
        ldp 	x29, x30, [sp], 16		// De-allocate memory from stack
	ret	                             // Return to caller.

       


      
        



        


        

        





 



        
         
       

        

        
        



        


        


        












