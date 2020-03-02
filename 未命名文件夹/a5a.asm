
        define(operation, w19)
        define(value,w20)
       
        QUEUESIZE = 8
        MADMASK = 0x7
        FALSE = 0
        TURE = 1

        .bss

queue_m:        .skip  QUEUESIZE*4
head_m:         .skip  -1
tail_m:         .skip  -1
   
         .text
print_1:        .string "### Queue Operations ###\n\n"
print_2:        .string "Press 1 - Enqueue, 2 - Dequeue, 3 - Display, 4 - Exit\n"
print_3:        .string "Your option? "

         .global queue_m
         .global head_m
         .global tail_m
         .global enqueue_v
         .global enqueue_i
         .global dequeue
         .global queueFull
         .global queueEmpty
         .global display

         .balign 4
    


queueFull: 
        stp x29,x30,[sp, -16]!
        mov x29,sp

         
        add w21, tail_m, 1
        and w21, tail_m, MADMASK 
        mov w22, head_m
        cmp w21, w22
        b.eq   FullTure
        b   FullFalse


FullTure: 
        mov w0, TURE
        ldp 	x29, x30, [sp], 16
        ret

FullFalse:
        mov w0, FALSE
        ldp 	x29, x30, [sp], 16
        ret

queueEmpty: 
        stp x29,x30,[sp, -16]!
        mov x29,sp
  
        mov w21, -1
        mov w22, head_m
        cmp w21, w22
        b.eq   FullTure
        b   FullFalse


EmptyTure: 
        mov w0, TURE
        ldp 	x29, x30, [sp], 16
        ret

EmptyFalse:
        mov w0, FALSE
        ldp 	x29, x30, [sp], 16
        ret








        












