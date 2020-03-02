//Assignment4
//Author: Sijia Yin
//Date: June 7th,2019
//Goals:Create an ARMv8 assembly language program. Implement all the subroutines above as unoptimized closed subroutines, using stack variables to store all local variables. Note that the function newBox () must have a local variable (called b) which is returned by value to main(), where it is assigned to the local variables first and second. In other words, create code similar to what the C compiler produces, even if it seems inefficient. Name the program assign4.asm.

format1:	.string "Initial box values:\n"
format2:	.string "\nChanged box values:\n"
format3:	.string "Box %s origin = (%d, %d)  width = %d  height = %d  area = %d\n"
format4:	.string "first"
format5:	.string "second"

SIZE = 50											//size = 50
FALSE = 0											//false = 0
TRUE = 1											//true = 1

firstBox_s = 16										//firstbox location in stack
secondBox_s = 36									//secondbox location in stack

firstBox_size = 20									//size of firstbox
secondBox_size = 20									//size of secondbox

ALLOC = -(16+40) & -16								//total size allocate from stack
DEALLOC = -ALLOC									//total size deallocate from stack

define(firstBox, x19)								//base address of firstbox in stack
define(secondBox, x20)								//base address of secondbox in stack


		.balign 4									//make word aligned
		.global main								//Make "main" visible to the OS
main:	stp		x29, x30, [sp, ALLOC]!				//allocate stack space
		mov 	x29, sp								//update fp
		
		add 	firstBox, x29, firstBox_s			//set the base in the stack for firstbox
		mov 	x0, firstBox						//let firstbox address as argument
		bl 		newBox								//call subroutine newBox
		
		add 	secondBox, x29, secondBox_s			//set the base in the stack for secondbox
		mov 	x0, secondBox						//let secondbox address as argument
		bl 		newBox								//call subroutine newBox
		
		adrp 	x0, format1							//print format1
		add 	x0, x0, :lo12:format1
		bl 		printf
		
		adrp 	x0, format4							//print format4
		add 	x0, x0, :lo12:format4
		mov 	x1, firstBox
		bl 		printBox							//call subroutine printBox

		adrp 	x0, format5							//print format5
		add 	x0, x0, :lo12:format5
		mov 	x1, secondBox
		bl 		printBox							//call subroutine printBox
		
		mov 	x0, firstBox						//Store the pointer of firstbox to x0
		mov 	x1, secondBox						//Store the pointer of secondbox to x0
		bl 		equal								//call subroutine equal
		mov 	x23, x0								//Store the results of equal to x23
		cmp 	x23, TRUE							//compare x23 with true
		b.ne	test								//If equal not equal to true then branch to test
		
		mov		x0, firstBox						//Store the pointer of firstbox to x0
		mov 	x1, -5								//Store -5 as second argument x1
		mov		x2, 7								//Store 7 as third argument x2
		bl 		move								//call subroutine move
		
		mov 	x0, secondBox						//Store the pointer of secondbox to x0
		mov 	x1, 3								//Store 3 as second argument x1
		bl 		expand								//call subroutine expand

test:	adrp	x0, format2							//print format2
		add 	x0, x0, :lo12:format2
		bl		printf

		adrp 	x0, format4							//print format4
		add 	x0, x0, :lo12:format4
		mov 	x1, firstBox
		bl 		printBox							//call subroutine printBox

		adrp 	x0, format5							//print format5
		add 	x0, x0, :lo12:format5
		mov 	x1, secondBox
		bl 		printBox							//call subroutine printBox

done:	ldp 	x29, x30, [sp], DEALLOC				//Restoring fp and lr	
		ret											//Return function for program

//*************************************************
point:	
		x_s = 0										//size of x
		y_s = 4										//size of y
		
dimension:
		width_s = 0									//size of width
		height_s = 4								//size of height
box:	
		point_s = 0									//start address of point
		dimension_s = 8								//start address of dimension
		area = 16									//start address of area
//*************************************************
newBox:	stp 	x29, x30, [sp, ALLOC]!
		mov		x29, sp
		
		mov		x8, x0								//Moving the starting location of the box into start register
		
		mov 	x10, 0								//let x10 = 0
		mov 	x11, 1								//let x11 = 1
		mul		x12, x11, x11						//calculating area
		
		str 	x10, [x8, point_s + x_s]			//store x = 0
		str 	x10, [x8, point_s + y_s]			//store y = 0
		str 	x11, [x8, dimension_s + width_s]	//store width = 1
		str 	x11, [x8, dimension_s + height_s]	//store height = 1
		str 	x12, [x8, area]						//store area
		
		mov 	x0, x8								//store box to x0 to return
		
		ldp 	x29, x30, [sp], DEALLOC				//Restore fp and lr from stack
		ret											//return to main
		
move: 	stp 	x29, x30, [sp, ALLOC]!
		mov		x29, sp
		
		ldr 	x10, [x0, point_s + x_s]			//b.origin.x
		ldr 	x11, [x0, point_s + y_s]			//b.origin.y
		
		add 	x10, x10, x1						//b.origin.x + deltaX

		add 	x11, x11, x2						//b.origin.y + deltaY
		
		str 	x10, [x0, point_s + x_s]			//b.origin.x = b.origin.x + deltaX
		str 	x11, [x0, point_s + y_s]			//b.origin.y = b.origin.y + deltaY
		
		ldp 	x29, x30, [sp], DEALLOC				//Restore fp and lr from stack
		ret											//return to main
		
expand:	stp 	x29, x30, [sp, ALLOC]!
		mov		x29, sp
		
		ldr 	x10, [x0, dimension_s + width_s]	//b.size.width
		ldr 	x11, [x0, dimension_s + height_s]	//b.size.height
		
		mul		x10, x10, x1						//b.origin.x * factor
		mul 	x11, x11, x1						//b.origin.y * factor
		mul 	x12, x10, x11						//b.origin.x * b.origin.y
		
		str 	x10, [x0, dimension_s + width_s]	//b.origin.x = b.origin.x * factor
		str 	x11, [x0, dimension_s + height_s]	//b.origin.y = b.origin.y * factor
		str 	x12, [x0, area]						//b.origin.area = b.origin.x * b.origin.y
		
		ldp 	x29, x30, [sp], DEALLOC				//Restore fp and lr from stack
		ret											//return to main

printBox:
		stp 	x29, x30, [sp, ALLOC]!
		mov		x29, sp
		
		mov 	x10, x1
		mov 	x1, x0
		
		adrp 	x0, format3							//print format3
		add 	x0, x0, :lo12:format3
		ldr 	x2, [x10, point_s + x_s]			//b.origin.x
		ldr 	x3, [x10, point_s + y_s]			//b.origin.y
		ldr 	x4, [x10, dimension_s + width_s]	//b.size.width
		ldr 	x5, [x10, dimension_s + height_s]	//b.size.height
		ldr 	x6, [x10, area]						//b.area
		bl 		printf			
		
		ldp 	x29, x30, [sp], DEALLOC				//Restore fp and lr from stack
		ret											//return to main
	
equal: 	stp 	x29, x30, [sp, ALLOC]!
		mov		x29, sp
		
		mov 	x22, FALSE							//let result to be false
		
		ldr 	x10, [x0, point_s + x_s]			//b1.origin.x
		ldr 	x11, [x1, point_s + x_s]			//b2.origin.x
		cmp 	x10, x11							//Compare b1.origin.x with b2.origin.x
		b.ne 	return								//If not equal then branch to notEqual
		
		ldr 	x10, [x0, point_s + y_s]			//b1.origin.y
		ldr 	x11, [x1, point_s + y_s]			//b2.origin.y
		cmp 	x10, x11							//Compare b1.origin.y with b2.origin.y	
		b.ne 	return								//If not equal then branch to notEqual
		
		ldr 	x10, [x0, dimension_s + width_s]	//b1.size.width
		ldr 	x11, [x1, dimension_s + width_s]	//b2.size.width
		cmp 	x10, x11							//Compare b1.size.width with b2.size.width
		b.ne 	return								//If not equal then branch to notEqual
		
		ldr 	x10, [x0, dimension_s + height_s]	//b1.size.height
		ldr 	x11, [x1, dimension_s + height_s]	//b2.size.height
		cmp 	x10, x11							//Compare b1.size.height with b2.size.height
		b.ne 	return								//If not equal then branch to notEqual
		
		mov 	x22, TRUE							//If all them are equal and the result is true

return: mov 	x0, x22								//Store the result to x0 to be returned to main
		
		ldp 	x29, x30, [sp], DEALLOC				//Restore fp and lr from stack
		ret											//return to main
		
	
		