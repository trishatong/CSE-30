#ifndef MYRDBUF_S
#else
// version 1.0 10/12/2022 //
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // global constants
    #include "cipher.h"

    .extern fread
    .extern feof
    .extern ferror
    .text

    // int rdbuf(r0=FILE *in, r1=FILE *book, r2=int cnt, r3=char *iobuf, 
    //            on the stack in IARG5=char *bookbuf)
    // returns number of bytes read EXIT_FAIL otherwise

    .type   rdbuf, %function
    .global rdbuf
    .equ    ARG5,  4 
    .equ    FP_OFF, 28
 
rdbuf:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF

    mov r4, r0                      // r4 = in
    mov r5, r1                      // r5 = book
    mov r6, r2                      // r6 = cnt
    mov r7, r3                      // r7 = iobuf
 
    bl feof						    // if (feof(in))
    cmp r0, 0						// if (r0 != 0)		
    bne .Lendsetzero				

    mov r0, r4                      // r0 = in
    bl ferror						// if (ferror(in))
    cmp r0, 0						// if (r0 == 0)
    bne .Lendfail

    mov r0, r7						// r0 = iobuf					
    mov r1, 1						// r1 = 1
    mov r2, r6						// r2 = cnt	
    mov r3, r4						// r3 = in

    bl fread						
    cmp r0, 0						// if (fread <= 0)
    ble .Lendsetzero				
     
    mov r6, r0						// r6 = bytes
    ldr r0, [fp, ARG5]			    // r0 = bookbuf					
    mov r1, 1						// r1 = 1
    mov r2, r6						// r2 = bytes	
    mov r3, r5						// r3 = fpbook
    
    bl fread
    cmp r0, r6						// if (fread != bytes)
    bne .Lendfail       

.Lendreturnbytes:         
    mov r0, r6                      // r0 = bytes
    cmp r0, 0                       // if (bytes == 0)
    bne .Ldone


.Lendsetzero:
    mov r0, 0                       // r0 = 0
    cmp r0, 0                       // if (r0 == 0)
    beq .Ldone

.Lendfail:
	mov r0, EXIT_FAIL               // r0 = EXIT_FAIL   

.Ldone:
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size   rdbuf, (. - rdbuf)
    .section .note.GNU-stack,"",%progbits
.end
#endif
