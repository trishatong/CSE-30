#ifndef MYDECRYPT_S
#else
// version 1.0 11/12/2022
    .arch armv6
    .arm
    .fpu vfp
    .syntax unified

    #include "cipher.h"

    .text     // start of text segment

    //////////////////////////////////////////////////
    // int decrypt(char *iobuf, char *bookbuf, int cnt)
    // decrypts iobuf using bookbuf; result in iobuf
    //////////////////////////////////////////////////
    .global decrypt
    .type   decrypt, %function
    .equ    FP_OFF, 20

decrypt:
    push    {r4-r7, fp, lr}
    add     fp, sp, FP_OFF
    // do not alter anything above this line

    cmp     r2, 0               // if buffer empty we are done
    ble     .Ldone

    // your code here

    // do not alter anything below this line
.Ldone:
    mov     r0, r2              // return cnt processed
    sub     sp, fp, FP_OFF
    pop     {r4-r7, fp, lr}
    bx      lr

    .size decrypt, (. - decrypt)
    .section .note.GNU-stack,"",%progbits
.end
#endif
