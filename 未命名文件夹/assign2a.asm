//Assignment2
//Author: Sijia Yin
//Date: May 19th,2019
//Goals:Create an ARMv8 assembly language program that implements the integer multiplication program. Use 32-bit registers for variables declared using int, and 64-bit registers for variables declared using long int. Use m4 macros to name the registers to make your code more readable.

		//32-bit registers
		define(multiplier, w19)         //rename w19 to multiplier
		define(multiplicand, w20)       //rename w20 to multiplicand
		define(product, w21)            //rename w21 to product
		define(i, w22)                  //rename w22 to i
		define(negative, w23)           //rename w23 to negative
		define(false, w24)              //rename w24 to false
		define(true, w25)               //rename w25 to true

		//64-bit registers
		define(result, x19)             //rename x19 to result
		define(temp1, x20)              //rename x20 to temp1
		define(temp2, x21)              //rename x21 to temp2

format1:        .string "multiplier = 0x%08x (%d) multiplicand = 0x%08x (%d)\n\n"
format2:        .string "product = 0x%08x multiplier = 0x%08x\n"
format3:        .string "64-bit result = 0x%016lx (%ld)\n"

		.balign 4                               //make word aligned
		.global main                            //Make "main" visible to the OS

main:       stp x29, x30,[sp,-16]!                  //allocate stack space
			mov x29,sp                              //update fp

			mov     multiplicand, -16843010         //the value of multiplicand
			mov     multiplier, 70                  //the value of muliplier
			mov     product, 0                      //the value of product

			adrp    x0, format1                     //the first output statement
			add     x0, x0, :lo12:format1
			mov     w1, multiplier
			mov     w2, multiplier
			mov     w3, multiplicand
			mov     w4, multiplicand
			bl      printf

			mov     false, 0                        //the value of false
			mov     true, 1                         //the value of true

			cmp     multiplier, 0                   //compare multiplier with 0
			b.lt    truen                           //if multiplier less than 0 then go to truen
			mov     negative, false                 //else give the value of false to negative
			b       loop                            //then go to loop

truen:      mov     negative, true                  //give the value of true to negative

loop:       mov     i, 0                            //the value of i
			b       test                            //then go to test

firif:      and     w26, multiplier, 0x1            //an and operation, give the result to w26
			cmp     w26, false                      //compare w26 with false
			b.eq    secif                           //if w26 equal to false then go to secif
			add     product, product, multiplicand  //else product = product + multiplicand
secif:      and     w27, product, 0x1               //an and operation, give the result to w27
			cmp     w27, false                      //compare w27 with false
			b.eq    else                            //if w27 equal to false then go to else
			orr     multiplier, multiplier, 0x80000000      //else multiplier = multiplier | 0x80000000

else:       and     multiplier, multiplier, 0x7FFFFFFF      //multiplier = multiplier & 0x7FFFFFFF

			asr     product, product, 1             //arithmetic shift right by 1

			add     i, i, 1                         //add 1 to i

test:       cmp     i,32                            //compare i with 32
			b.lt    firif                           //if i less than 32 then go to firif

			cmp     negative, false                 //compare negative with false
			b.eq    outp                            //if negative equal to false then go to outp
			sub     product, product, multiplicand  //product = product - multiplicand

outp:       adrp    x0, format2                     //the second output statement
			add     x0, x0, :lo12:format2
			mov     w1, product
			mov     w2, multiplier
			bl      printf

			sxtw    x22, product                    //signed extend word of product to make it 64bit
			and     temp1, x22, 0xFFFFFFFF          //temp1 = (long int)product & 0xFFFFFFFF
			lsl     temp1, temp1, 32                //logial shift left by 32
			sxtw    x23, multiplier                 //signed extend word of multiplier to make it 64bit
			and     temp2, x23, 0xFFFFFFFF          //temp2 = (long int)multiplier & 0xFFFFFFFF
			add     result, temp1, temp2            //result = temp1 + temp2

			adrp    x0, format3                     //the third output statement
			add     x0, x0, :lo12:format3
			mov     x1, result
			mov     x2, result
			bl      printf

done:       mov w0, 0                               //return the x0 register to 0
			ldp x29, x30,[sp], 16                   //restore FP and LR from stack, post-increment SP
			ret                                     //return to caller

	