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
    // you can change or remove any comments in this file

    .type   rdbuf, %function
    .global rdbuf
    .equ    IARG5,  4 
    .equ    FP_OFF, 28
 
rdbuf:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF

    // save the register args (r0-r3) into preserved registers
    // as there are many function calls
    
    // check for end of file feof(in)
    // if r0 is not zero at EOF, return 0
    // otherwise check for read errors
    // check for error ferror(in)
    // if r0 is zero, no errors, do the reads
    // if r1 is not zero, set r0 to EXIT_FAIL and return

    // bytes = fread(r0=iobuf, r1=1, r2=cnt, r3=in)
    // save bytes so we can check that we read same bytes from bookfile

    // r0 = fread(r0=bookbuf, r1=1, r2=bytes, r3=book)
    // the pointer to bookbuf is passed on the stack so
    // you need to do a ldr from [fp, IARG6] to get the address
    // if r0 as the return from fread is not equal to bytes 
    // actuall read from stdin (into iobuf) return EXIT fail
    // otherwise return bytes

.Ldone:
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size   rdbuf, (. - rdbuf)
    .section .note.GNU-stack,"",%progbits
.end
#endif
