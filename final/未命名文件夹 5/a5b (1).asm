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

//define registers
			define(base_r, x19)					//register for base address of month_m
			define(argc_r, w21)					//register to record how many comand-line args provided
			define(argv_r, x22)					//the address of the array of pointers of args
			define(i_r, w23)					//i register
			define(mon_r, w24)					//month register
			define(day_r, w25)					//day regiser
			
//external pointer arrays
			.text
fmt:		.string "%s %d%s is %s\n"			//format string for printing dd mm is season
er1:		.string "usage: a5b mm dd\n"		//error message
er2:		.string "invalid month or day\n"	//error message
sst:		.string "st"						//string literal,suffix st
snd:		.string "nd"						//string literal,suffix nd
srd:		.string "rd"						//string literal,suffix rd
sth:		.string "th"						//string literal,suffix th

jan_m:		.string "January"					//string literal, will be the 1st element of array month_m
feb_m:		.string "February"					//string literal, will be the 2nd element of array month_m
mar_m:		.string "March"						//string literal, will be the 3rd element of array month_m
apr_m:		.string "April"						//string literal, will be the 4th element of array month_m
may_m:		.string "May"						//string literal, will be the 5th element of array month_m
jun_m:		.string "June"						//string literal, will be the 6th element of array month_m
jul_m:		.string "July"						//string literal, will be the 7th element of array month_m
aug_m:		.string "August"					//string literal, will be the 8th element of array month_m
sep_m:		.string "September"					//string literal, will be the 9th element of array month_m
oct_m:		.string "October"					//string literal, will be the 10th element of array month_m
nov_m:		.string "November"					//string literal, will be the 11th element of array month_m
dec_m:		.string "December"					//string literal, will be the 12th element of array month_m

win_m:		.string "Winter"					//string literal, will be the 1st element of array season_m
spr_m:		.string "Spring"					//string literal, will be the 2nd element of array season_m
sum_m:		.string "Summer"					//string literal, will be the 3rd element of array season_m
fal_m:		.string "Fall"						//string literal, will be the 4th element of array season_m

			.data		//create arrays of pointers
			.balign 8	//double-word aligned

month_m:	.dword jan_m, feb_m, mar_m, apr_m, may_m, jun_m, jul_m, aug_m, sep_m, oct_m, nov_m, dec_m	//initilized with the string literals
season_m:	.dword win_m, spr_m, sum_m, fal_m															//initilized with the string literals

			.text
			.balign 4					//word-aligned
			.global main				//make main visiable to the linker

main:		stp x29, x30,[sp, -16]!		 // Allocate memory for queueFull subroutine.
			mov x29, sp					//update x29 to sp
			
			mov argc_r, w0				//copy argc
			mov argv_r, x1				//copy argv
			
			cmp argc_r, 3				//if there are 3 args?
			b.eq satisfied					//if so, branch to satisfied
			adrp x0, er1				//set the 1st arg of printf, to print the error message
			add  x0, x0, :lo12:er1		//set the 1st arg of printf, to print the error message
			bl printf					//call printf
			b  done					//branch to done

satisfied:		mov i_r, 1						//Move the value
			ldr x0,[argv_r, i_r, SXTW 3]	//access the 2nd comand-line arg
			bl atoi							//call atoi to convert it to number
			mov mon_r, w0					//store as the number of month
			
			mov i_r, 2						//Move the value
			ldr x0,[argv_r, i_r, SXTW 3]	//access the 3rd comand-line arg
			bl atoi							//call atoi to convert it to number
			mov day_r, w0					//store the number as the value of day
			
			mov w0, mon_r					//Move the value
			bl numberofDay						//find the number of days in a particular month
			mov w26, w0						//get the return value
			
			cmp mon_r,1						//month < 1 ?
			b.lt outOfbound					//if so it is invalid
			cmp mon_r,12					//month > 12 ?
			b.gt outOfbound					//if so it is invalid
			cmp day_r,1						//day < 1?
			b.lt outOfbound					//if so it is invalid
			cmp day_r,w26					//day > the number of day a surtain month suppose to have?
			b.le next						//if not , the input date is valid , move on
			
outOfbound:	adrp x0, er2					//set the 1st arg of printf
			add  x0, x0, :lo12:er2			//set teh 1st arg of printf
			bl printf						//call printf
			b done						//branch to done
			
next:
			mov w0, day_r					//set the 1st arg of function Switch 			
			bl Switch					//call Switch
			mov x26, x0 					//contain address of which suffix to print
			
			mov w0, mon_r					//set the 1st arg of function SeasonDecided
			mov w1, day_r					//set the 2nd arg
			bl SeasonDecided					//call SeasonDecided
			mov x27, x0 					//contain address of which season to print
			
			adrp x0, fmt					//set 1st arg of printf
			add x0, x0, :lo12:fmt			//set 1st arg of printf
			adrp base_r,month_m				//get the base address of array month_m 
			add base_r, base_r, :lo12:month_m	//get the base address of array month_m 
			sub w20, mon_r,1 					//the index of month is mon_r - 1
			ldr x1,[base_r,w20,SXTW 3]			//set the 2nd arg of printf
			mov w2, day_r						//set the 3rd arg of printf
			mov x3, x26							//set the 4th arg of printf
			mov x4, x27							//sest the 5th arg of printf
			bl printf							//call printf
			
done:	ldp x29, x30, [sp], 16              //restore fp and lr from stack, post-increment sp
			ret									//return to the caller	
//function numberofDay
numberofDay:	cmp w0, 2							//compare the input value of month with 2
			b.ne satisfiedif							//if its not 2 branch to satisfiedif
			mov w9, 28							//if so, month is Feb and has 28 days
			b xdone								//branch to done to end the function
//check if the input month is one of April, June, September and November, that have 30 days
satisfiedif:		cmp w0, 4							//is April?
			b.eq day30							//if so branch to day30
			cmp w0, 6							//June?
			b.eq day30							//if so branch to day30
			cmp w0, 9							//September?
			b.eq day30							//if so branch to day30
			cmp w0, 11							//November?
			b.eq day30							//if so branch to day30
day31:		mov w9, 31							//the remaining untested day31
			b xdone								//branch to done
day30:		mov w9, 30							//set w9 to 30
xdone:		mov w0, w9							//set w0 to w9

			ret									//return how many days the entered month should have

//function SeasonDecided
var_size = 4									//variable size is 4 bytes for all is int
alloc = -(16 + var_size*4)&-16					//compute alloc
dealloc = -alloc								//compute dealloc
m_s = 16										//offset of m 
d_s = 16 + var_size								//offset of d
sum_s = d_s + var_size							//offset of s
i_s = sum_s + var_size							//offset of i

SeasonDecided:
			stp x29, x30,[sp, alloc]!			 // Allocate memory for queueFull subroutine.
			mov x29, sp							//update fp to sp
			
			str w0, [x29,m_s]					//m record the month
			str w1, [x29,d_s]					//d record the day
			
			str wzr,[x29,sum_s]					//sum = 0
			mov w9, 1							//set w9 to 1
			str w9, [x29,i_s]					//i = 1
			//for loop
			b test								//branch to test

loop:		ldr w0,[x29,i_s]					//set the 1st arg of numberofDay
			bl numberofDay							//call numberofDay
			ldr w9,[x29,sum_s]					//get value of sum
			add w9,w9,w0						//added by the return value of numberofDay
			str w9,[x29,sum_s]					//store the changed value back to sum
			
			ldr w9,[x29,i_s]					//get value of i
			add w9, w9, 1						//i++
			str w9,[x29,i_s]					//store the value 

test:		ldr w9,[x29,i_s]					//get i
			ldr w10,[x29,m_s]					//get m
			cmp w9,w10							//i<m?
			b.lt loop							//true then loop

			ldr w9,[x29,sum_s]					//get sum
			ldr w10,[x29,d_s]					//get d
			add w9, w9, w10						//get which day of the dd mm is, for example Feb. 1st is the 32th day of the year
			
			cmp	w9, 172							//June 21 is the 172th day
			b.lt InSpr							//if less than, check if it is spring
			cmp w9, 263							//Sep. 20 is the 263th day
			b.gt InFal							//if greater than, check if it is fall
			adrp x10, season_m 					//calculate the base address of the external array season_m
			add x10, x10, :lo12:season_m 		//calculate the base address of the external array season_m
			mov w11, 2							//is summer
			ldr x0, [x10, w11, SXTW 3]			//return value will be the address of "Summer"
			b SubDone						//branch to SubDone
			
InSpr:		cmp w9, 80						//< 80?(March 21)
			b.lt INwin					//if so it is winter
			adrp x10, season_m 				//calculate the base address of the external array season_m
			add x10, x10, :lo12:season_m 	//calculate the base address of the external array season_m
			mov w11, 1						//is spring
			ldr x0, [x10, w11, SXTW 3]		//return value will be the address of "Spring"
			b SubDone					//branch to SubDone
			
InFal:		cmp w9, 354						//>354(Dec. 20)?
			b.gt INwin					//if so it is winter
			adrp x10, season_m 				//calculate the base address of the external array season_m
			add x10, x10, :lo12:season_m 	//calculate the base address of the external array season_m
			mov w11, 3						//is fall
			ldr x0, [x10, w11, SXTW 3]		//return value will be the address of "Fall"
			b SubDone					//branch to SubDone
			
INwin:	adrp x10, season_m 				//calculate the base address of the external array season_m
			add x10, x10, :lo12:season_m 	//calculate the base address of the external array season_m
			mov w11, 0						//is winter
			ldr x0, [x10, w11, SXTW 3]		//return value will be the address of "Winter"

SubDone:	
			ldp x29, x30, [sp], dealloc                   //restore fp and lr from stack, post-increment sp
			ret                                           // return to caller
			
//function Switch
Switch:
			cmp w0, 1				//day is 1?
			b.eq case_st			//branch to case_st
			cmp w0, 21				//21?
			b.eq case_st			//branch to case_st
			cmp w0, 31				//31?
			b.eq case_st			//branch to case_st
			
			cmp w0, 2				//2?
			b.eq case_nd			//branch to case_nd
			cmp w0, 22				//22?
			b.eq case_nd			//to case_nd
			
			cmp w0, 3				//3?
			b.eq case_rd			//to case_rd
			cmp w0, 23				//23?
			b.eq case_rd			//to case_rd
			
case_th:	adrp x0, sth			//set the return value to the address of "th"
			add x0, x0, :lo12:sth	//set the return value to the address of "th"
			ret						//return to the caller
case_rd:	adrp x0, srd			//set the return value to the address of "rd"
			add x0, x0, :lo12:srd	//set the return value to the address of "rd"
			ret						//return to the caller
case_nd:	adrp x0, snd			//set the return value to the address of "nd"
			add x0, x0, :lo12:snd	//set the return value to the address of "nd"
			ret						//return to the caller
case_st:	adrp x0, sst			//set the return value to the address of "st"
			add x0, x0, :lo12:sst	//set the return value to the address of "st"
			ret						//return to the caller
