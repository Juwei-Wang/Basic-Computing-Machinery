/*  CPSC 355 - Computing Machinery 1
	Assignment 3
	
	Lecture Section: L01
	
     Juwei wang
	UCID: 30053278
	Date: 2019-06-01

	assign3.asm: A sample ARMv8 program, which builds an array of size 50. It then initializes the array with each of the elements being random positive integers between 
	0 and 255. The array is then sorted using the selection sort, such that the array is ordered from smallest to largest. The program then prints the resulting array.
	

*/

define(arr_base, x20)                   // Define the register holding the stack adress for the base of the array.
define(index_i, w21)                    // Define the register holding the index i as register w21.
define(index_j, w22)                    // Define the register holding the index j as register w22.




size = 50                                // set the length of size = 50
as_size = size * 4                       // Size of each element in the array = 4 bytes 
i_size = 4                               // Size of i =  4 bytes                    
j_size = 4                               // Size of j = 4 bytes 
temp_size = 4                            // Size of temp = 4 bytes 
i_add = 16                               // Set the stack offset (from fp) for variable i to 16
j_add = i_add + i_size                   // Set the stack offset (from fp) for variable i to 20
te_add = j_add+ j_size                   // Set the stack offset (from fp) for variable i to 24
iarr_add = te_add + te_add               // Set the stack offset (from fp) for variable i to 28
var_size = as_size + i_size + j_size + temp_size    // Set the stack offset in all 

alloc = -(16 + var_size) & -16           // Set the pre-increment value "alloc"
dealloc = -alloc                         // Set the post-increment value, for updating SP after frame record is popped.
fp .req x29                              // Define fp as x29
lr .req x30	                          // Define lr as x30	


print_1:  .string "v[%d]: %d\n"               // The first print label, for printing each line in the array. 

print_2:  .string "\nSorted array:\n"         // The second print function, which produces the title "Sorted array: "


 
       .balign 4                              // Instructions must be aligned word aligned (4 bytes)
       .global main                           // Makes "main" visible to the OS
main: 

     stp x29, x30, [sp, alloc]!              // Save FP and LR to stack, allocating by the amount "alloc", pre-increment SP. 
     mov fp,sp                               // Update frame pointer (FP) to current stack pointer (SP)

     mov arr_base, fp                        // Calculates the base address of the array.
     add arr_base, arr_base, iarr_add        // Location of Base of array = (fp + offset from fp to arr_base)

     mov index_i, 0                          // Set index to zero.
     str index_i, [fp, i_add]                // Write index i to stack.

     b test1                                 // Branch to optimized test_1	

loop1:

     bl rand                                 // Get a random number from the pseudo-random number generator.
     and w23, w0, 0xFF                       // AND value of random with 0xFF, so that the number is between 0 and 255
     add arr_base, fp, iarr_add              // Location of Base of array = (fp + offset from fp to arr_base)
     ldr index_i, [fp, i_add]                // Load the value for i from memory
     str w23, [arr_base, index_i, SXTW 2]    // Write index w23 to stack.

     adrp x0, print_1                       // Print out the value to standard output
     add w0, w0, :lo12:print_1              // Add lower-order bits to x0 
     mov w1, index_i                        // Move i into x1
     mov w2, w23                            // Load v[i] from memory, and put it into register w2
     bl printf                              // Use bl (branch to label) to call function printf()

     ldr index_i, [fp, i_add]               // Load the value for i from memory
     add index_i, index_i, 1                // i++
     str index_i, [fp, i_add]               // Write index i to stack.
     b test1                                // Branch to optimized test_1	

test1: 
     
     cmp index_i, size                      // if i < 50 
     b.lt loop1                             // Branch to optimized loop1

     mov index_i, 1                         // i = 1
     str index_i, [fp, i_add]               // Write index i to stack.
     b test2a                               // Branch to optimized test2a	

loop2a:


     // w24 = v[i]
     ldr index_i, [fp, i_add]              // Load the value for i from memory
     ldr w24, [arr_base, index_i, SXTW 2]  // Load the value for w24 from memory


    // temp = v[i]
     mov w25, w24                         // temp = v[i]
     str w25, [fp, te_add]                // Write temp to stack.
     
     // j = i
     ldr index_i, [fp, i_add]             // Load the value for i from memory
     mov index_j, index_i                 //j = i
     str index_j, [fp, j_add]             // Write index j to stack.


     b test2b                            // Branch to optimized test2b	  

loop2b:


     // j
     ldr index_j, [fp, j_add]           // Load the value for j from memory
     
     
     // j - 1
     sub w19, index_j, 1                // j-1

     //v[j-1]
     ldr w23, [arr_base, w19, SXTW 2]   // Load the value for v[j-1] from memory

     // v[j] = v[j-1]
     str w23, [arr_base, index_j, SXTW 2]   // Write w23 to stack.
  

     str w19, [fp,j_add]                 // Write j to stack.
   
     b test2b                           // Branch to optimized test2b	

     

test2a: 

     cmp index_i, size                // if i < 50 ...
     b.lt loop2a                      // Branch to optimized loop2a

     mov index_i, 0                   //renew index_i
     str index_i, [fp, i_add]         // Write index i to stack.

     adrp x0, print_2                 // Print out the value to standard output
     add w0, w0, :lo12:print_2        // Add lower-order bits to x0 
     bl printf                       // Use bl (branch to label) to call function printf()

     b test3                        // Branch to optimized test3	


test2b:

     // j > 0 
     ldr index_j, [fp, j_add]       // Load the value for j from memory
     cmp index_j, 0                 // if j < 0 
     b.gt nextcmp                   // Branch to optimized nextcmp
 

     // v[j] = temp
     ldr index_j, [fp,j_add]         // Load the value for j from memory
     ldr w25, [fp,te_add]            // Load the value for temp from memory
     str w25, [arr_base, index_j, SXTW 2]   // Write w25 to stack.

     // i++
     ldr index_i, [fp, i_add]       // Load the value for i from memory
     add index_i, index_i, 1        // i++
     str index_i, [fp, i_add]       // Write index i to stack.

     b test2a                       // Branch to optimized test2a

nextcmp:

 
     // j-1
     ldr index_j, [fp, j_add]     // Load the value for jfrom memory
     sub w26, index_j, 1          // i-1

     //v[j-1]
     ldr w27, [arr_base, w26, SXTW 2]   // Load the value for v[j-1] from memory

     //w28 = temp 
     ldr w28, [fp, te_add]          // Load the value for temp from memory


     //temp < v[j-1]
     cmp w28, w27                      // if temp < v[j-1] ...
     b.lt loop2b                       // Branch to optimized loop2b
     
     //v[j] = temp
     ldr index_j, [fp,j_add]           // Load the value for j from memory
     ldr w25, [fp,te_add]              // Load the value for temp from memory
     str w25, [arr_base, index_j, SXTW 2]   // Write w25 to stack.

     // i++
     ldr index_i, [fp, i_add]           // Load the value for i from memory
     add index_i, index_i, 1            // i++
     str index_i, [fp, i_add]           // Write index i to stack.


     b test2a                          // Branch to optimized test2a	

loop3:
     
     ldr index_i, [fp, i_add]          // Load the value for i from memory
     ldr w23, [arr_base, index_i, SXTW 2]   // Load the value for v[i] from memory

     adrp x0, print_1                    // Print out the value to standard output
     add w0, w0, :lo12:print_1           // Add lower-order bits to x0 
     mov w1, index_i                     // Move i into x1
     mov w2, w23                         // Load v[i] from memory, and put it into register w2
     bl printf                           // Use bl (branch to label) to call function printf()
     

     ldr index_i, [fp, i_add]       // Load the value for i from memory
     add index_i, index_i, 1        // i++
     str index_i, [fp, i_add]       // Write index i to stack.

     b test3                        // Branch to optimized test3	

test3:

     cmp index_i,size               // if i < 50 
     b.lt loop3                     // Branch to optimized loop3
    
     mov w0, 0                      // Return 0 to OS
     ldp fp, lr, [sp], dealloc      // De-allocate stack memory.
     ret                            // Returns to calling code in OS




    


     
