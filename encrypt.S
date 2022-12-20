#ifndef MYENCRYPT_S
#else
// version 1.0 11/12/2022
    .arch armv6
    .arm
    .fpu vfp
    .syntax unified

    #include "cipher.h"

    .text     // start of text segment

    //////////////////////////////////////////////////
    // int encrypt(char *iobuf, char *bookbuf, int cnt)
    // encrypts  iobuf with bookbuf; updating iobuf
    //////////////////////////////////////////////////
    .global encrypt
    .type   encrypt, %function
    .equ    FP_OFF, 28

encrypt:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF
    // do not alter anything above this line
    // r0 contains char *iobuf
    // r1 contains char *bookbuf
    // r2 contains cnt
    // r3 is ok to use
    // r4-r9 preserved registers are ok to use

    cmp     r2, 0               // if buffer empty we are done
    ble     .Ldone

    // MY CODE				C code equivalent
    mov r4, 0				// unsigned int reversed = 0
    mov r5, 0				// unsigned int bookbuf_int = 0
    	mov r3, 0 			// for (int i = 0
    .Lfor1:
	cmp r3, r2			// i < cnt	
	bge .Lendfr1
	mov r4, 0			// reversed = 0
        ldrb r6, [r0, r3]		// unsigned int index = iobuf[i]
	ldrb r5, [r1, r3]		// bookbuf_int = bookbuf[i]
	    mov r9, 0			// for (int j = 0
        .Lfor2:
	    cmp r9, 8			// j < 8
	    bge .Lendfr2 
	    lsr r7, r6, r9		// a = index>>j
	    AND r7, r7, 1		// a = a & 1    (a = (index>>j) & 1)
	    rsb r8, r9, 7		// b = j + -7
	    lsl r8, r7, r8		// c = a<<b
	    ORR r4, r4, r8	    	// reversed = reversed | c
	    add r9, r9, 1		// j++
	    b .Lfor2
    .Lendfr2:				// } end of inner loop
    EOR r6, r4, r5			// index = reversed ^ bookbuf_int
    strb r6, [r0, r3]			// iobuf[i] = index
	add r3, r3, 1			// i++
	b .Lfor1
    .Lendfr1:				// } end of outer loop

    // do not alter anything below this line
.Ldone:
    mov     r0, r2              // return cnt processed
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size encrypt, (. - encrypt)
    .section .note.GNU-stack,"",%progbits
.end
#endif
