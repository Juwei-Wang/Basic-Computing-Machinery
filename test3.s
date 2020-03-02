     .global main
main:
     stp x29, x30, [sp,-16]!
     mov x29, sp

     ldr x0,  =greeting
     bl  printf

     ldp x29, x30, [sp], 16
     ret

greeting: .asciz "Hello World!\n"