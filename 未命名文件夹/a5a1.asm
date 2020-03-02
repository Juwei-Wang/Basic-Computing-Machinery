//Assignment5
//Author: Sijia Yin
//Date: June 12, 2019
//Goals: Translate all functions except main() into ARMv8 assembly language and put them into a separate assembly source code file called a5a.asm. These functions will be called from the main() function given above, which will be in its own C source code file called a5aMain.c. Also move the global variables into a5a.asm. Your assembly functions will call the printf() library routine. Be sure to handle the global variables and format strings in the appropriate way. Input will come from standard input. Run the program to show that it is working as expected, capturing its output using the script UNIX command, and name the output file script1.txt.

QUEUESIZE = 8
MODMASK = 0x7
FALSE = 0
TRUE = 1

define(tail_r, x19)							//set register for tail
define(head_r, x20)							//set register for head
define(queue_r, x21)						//set register for queue

//*****************************************
			
			.bss							//uninitialized variable
			.global queue_m					//queue_m is global
queue_m:	.skip	QUEUESIZE*4				//array
			
			.data							//initialized variable
			.global head_m					//head_m is global
head_m:		.word -1						//head_m = -1
			.global tail_m					//tail_m is global
tail_m:		.word -1						//tail_m = -1

//*****************************************

			.text							//formats
format1:	.string "\nQueue overflow! Cannot enqueue into a full queue.\n"
format2:	.string "\nQueue underflow! Cannot dequeue from an empty queue.\n"
format3:	.string "\nEmpty queue\n"
format4:	.string "\nCurrent queue contents:\n"
format5:	.string "  %d"
format6:	.string " <-- head of queue"
format7:	.string " <-- tail of queue"
format8:	.string "\n"

//*****************************************

			.balign 4								//make word aligned
			.global enqueue							//enqueue is global
enqueue:	stp		x29, x30, [sp, -16]!			//allocate stack space
			mov 	x29, sp							//update fp

			mov 	w22, w0							//let input store in the w22
			bl 		queueFull						//branch to queueFull
			
			cmp 	w0, TRUE						//compare w0 with TRUE
			b.ne 	ifEn							//if w0 != TRUE branch to ifEn
			
			adrp 	x0, format1						//Add format1 to first print arg
			add 	x0, x0, :lo12:format1			//set format1 to lower 12 bits
			bl 		printf							//call printf
			
ifEn:		bl 		queueEmpty						//branch to queueEmpty
			
			cmp 	w0, TRUE						//compare w0 with TRUE
			b.ne 	elseEn							//if w0 != TRUE branch to elseEn
			
			mov 	w9, 0							//let w9 = 0
			
			adrp 	head_r, head_m					//set up head_r as head_m
			add 	head_r, head_r, :lo12:head_m	//load to lower 12 bits
			str 	w9, [head_r]					//store head = 0

			adrp 	tail_r, tail_m					//set up tail_r as tail_m
			add 	tail_r, tail_r, :lo12:tail_m	//load to lower 12 bits
			str 	w9, [tail_r]					//store tail = 0
						
			ldr 	w23,[tail_r]					//load w23 to current tail_r
			
			adrp 	queue_r, queue_m				//set up x21 as queue_m
			add 	queue_r, queue_r, :lo12:queue_m	//load to lower 12 bits
			str 	w22, [queue_r, w23, SXTW 2]		//store w22 into queue
			b 		eqDone							//branch to eqDone

elseEn: 	adrp 	tail_r, tail_m					//set up tail_r as tail_m
			add 	tail_r, tail_r, :lo12:tail_m	//load to lower 12 bits
			ldr 	w23, [tail_r]					//load w23 to current tail_r
			
			add 	w23, w23, 1						//++tail
			and 	w23, w23, MODMASK				//++tail & MODMASK
			str 	w23, [tail_r]					//store w23 to tail_r
			
			adrp 	queue_r, queue_m				//set up x21 as queue_m
			add 	queue_r, queue_r, :lo12:queue_m	//load to lower 12 bits
			str 	w22, [queue_r, w23, SXTW 2]		//store w22 into queue

eqDone:		ldp 	x29, x30, [sp], 16				//Restoring fp and lr
			ret										//Return function for program
						
//*****************************************
			
			.balign 4								//make word aligned
			.global dequeue							//dequeue is global
dequeue:	stp		x29, x30, [sp, -16]!			//allocate stack space
			mov 	x29, sp							//update fp
			
			bl 		queueEmpty						//branch to queueEmpty
			
			cmp 	w0, TRUE						//compare w0 with TRUE
			b.ne 	ifDe							//if w0 != TRUE branch to ifDe
			
			adrp 	x0, format2						//Add format2 to first print arg
			add 	x0, x0, :lo12:format2			//load to lower 12 bits
			bl 		printf							//call printf
			mov 	w0, -1							//return -1
			
ifDe:		adrp 	head_r, head_m					//set up head_r as head_m
			add 	head_r, head_r, :lo12:head_m	//load to lower 12 bits
			ldr 	w9, [head_r]					//load w9 to head
			
			adrp 	tail_r, tail_m					//set up tail_r as tail_m
			add 	tail_r, tail_r, :lo12:tail_m	//load to lower 12 bits
			ldr 	w10, [tail_r]					//load tail to w10
			
			adrp 	queue_r, queue_m				//set up x21 as queue_m
			add 	queue_r, queue_r, :lo12:queue_m	//load to lower 12 bits
			ldr 	w11, [queue_r, w9, SXTW 2]		//load w11 = queue[head]

			mov  	w0, w11							//let w0 = w11

			cmp 	w9, w10							//compare head with tail
			b.eq 	elseDe							//if head != tail branch to elseDe
			
			add 	w9, w9, 1						//++head
			and 	w9, w9, MODMASK				//++head & MODMASK
			str 	w9, [head_r]					//store head to w10
			
			b 		deDone							//branch to deDone
	
elseDe:		mov 	w12, -1							//let w12 = -1
			str 	w12, [head_r]					//let head = -1
			str 	w12, [tail_r]					//let tail = -1
			
deDone:		ldp 	x29, x30, [sp], 16				//Restoring fp and lr	
			ret										//Return function for program

//*****************************************

queueFull:	stp		x29, x30, [sp, -16]!			//allocate stack space
			mov 	x29, sp							//update fp
			
			adrp 	head_r, head_m					//set up head_r as head_m
			add 	head_r, head_r, :lo12:head_m	//load to lower 12 bits
			ldr 	w9, [head_r]					//load w9 as head

			adrp 	tail_r, tail_m					//set up tail_r as tail_m
			add 	tail_r, tail_r, :lo12:tail_m	//load to lower 12 bits
			ldr 	w10, [tail_r]					//load w10 as tail
			
			add 	w10, w10, 1						//tail + 1
			and 	w10, w10, MODMASK				//(tail + 1) & MODMASK
			
			cmp 	w9, w10							//compare w9 with head
			b.ne 	elseQF							//if w9 != head branch to elseQF
			
			mov 	w0, TRUE 						//let w0 be TRUE
			b 		qfDone							//branch to qfDone
			
elseQF:		mov 	w0, FALSE						//let w0 be FALSE

qfDone: 	ldp 	x29, x30, [sp], 16				//Restoring fp and lr
			ret										//back to caller
//._._._._._._._._._._._._._._._._._._._._.

queueEmpty:	stp		x29, x30, [sp, -16]!			//allocate stack space
			mov 	x29, sp							//update fp

			adrp 	head_r, head_m					//set up head_r as head_m
			add 	head_r, head_r, :lo12:head_m	//load to lower 12 bits
			ldr 	w9, [head_r]					//load w9 as head
			
			cmp 	w9, -1							//compare head with -1
			b.ne 	elseQE							//if head != -1 branch to elseQE
			
			mov 	w0, TRUE 						//let w0 be TRUE
			b 		qeDone							//branch to qeDone
			
elseQE:		mov 	w0, FALSE						//let w0 be FALSE

qeDone: 	ldp 	x29, x30, [sp], 16				//Restoring fp and lr
			ret										//back to caller

//*****************************************			
	
			.balign 4								//make word aligned
			.global display							//display is global
display:	stp		x29, x30, [sp, -16]!			//allocate stack space
			mov 	x29, sp							//update fp

			mov 	w9, 0
			
			bl 	 	queueEmpty						//branch to queueEmpty
			
			cmp 	w0, TRUE						//compare w0 with TRUE
			b.ne 	ifDisplay						//if w0 != TRUE branch to ifDisplay
			
			adrp 	x0, format3						//Add format3 to first print arg
			add 	x0, x0, :lo12:format3			//load to lower 12 bits
			bl 		printf							//call printf
			
ifDisplay: 	adrp 	head_r, head_m					//set up head_r as head_m
			add 	head_r, head_r, :lo12:head_m	//load to lower 12 bits
			ldr 	w10, [head_r]					//load w10 as head
			
			mov 	w27, w10						//let w27 as i and equal to head

			adrp 	tail_r, tail_m					//set up tail_r as tail_m
			add 	tail_r, tail_r, :lo12:tail_m	//load to lower 12 bits
			ldr 	w11, [tail_r]					//load w11 as tail
			
			sub 	w28, w11, w10					//tail - head
			add 	w28, w28, 1						//tail - head + 1
			
			cmp 	w28, 0							//compare count with 0
			b.gt 	ifDisplay2						//if count > 0 branch to forDisplay
			
			add 	w28, w28, QUEUESIZE				//count = count + QUEUESIZE
			
ifDisplay2:	adrp 	x0, format4						//Add format4 to first print arg
			add 	x0, x0, :lo12:format4			//load to lower 12 bits
			bl 		printf							//call printf				
			
						mov 	w26, 0							//let w26 as j and equal to 0
			
			adrp 	queue_r, queue_m				//set up x21 as queue_m
			add 	queue_r, queue_r, :lo12:queue_m	//load to lower 12 bits

			b 		comp

forDisplay: adrp 	x0, format8						//Add format8 to first print arg
			add 	x0, x0, :lo12:format8			//load to lower 12 bits
			bl 		printf							//call printf

			adrp 	x0, format5						//Add format5 to first print arg
			add 	x0, x0, :lo12:format5			//load to lower 12 bits
			ldr 	w1, [queue_r, w27, SXTW 2]		//Set queue[i] as the 2nd argument
			bl 		printf							//call printf
			
			cmp 	w27, w10							//compare i with head
			b.ne 	disfor2							//if i != head branch to disfor2
			
			adrp 	x0, format6						//Add format6 to first print arg
			add 	x0, x0, :lo12:format6			//load to lower 12 bits
			bl 		printf							//call printf
			
disfor2:	add 	w27, w27, 1						//++i
			and 	w27, w27, MODMASK				//++i & MODMASK
		
			add 	w26, w26, 1						//j++

comp:		cmp 	w26, w28						//compare j with count
			b.lt 	forDisplay						//if j>=count branch to dpDone

			adrp 	x0, format7						//Add format7 to first print arg
			add 	x0, x0, :lo12:format7			//load to lower 12 bits
			bl 		printf							//call printf
						
dpDone: 	ldp 	x29, x30, [sp], 16				//Restoring fp and lr
			ret										//Return function for program
