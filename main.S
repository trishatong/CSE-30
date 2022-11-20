    // version 1.0 05/22/2022 //
#ifndef MYMAIN_S
#else
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // imports
    #include "main.h"
    #include "rdbuf.h"
    #include "setup.h"
    #include "cipher.h"
    .extern fwrite
    .extern stdin
    .extern stdout
    .extern stderr

    .section .rodata
.Lbdrd:  .string "%s: read failed\n"
.Lbdwr:  .string "%s: write failed\n"

    .text

    //
    // encrypter [-d | -e] -b bookfile
    //
    // int main(int argc, char **argv)
    //

    .global main
    .type   main, %function

    //
    // stack frame layout
    //
    // TODO PA9: complete the following stack frame design
    //
    .equ    FP_OFF,     32          // fp offset in main stack frame
    .equ    FPBOOK,                 // FILE * to book file
    .equ    IOBUF,                  // buffer for input file
    .equ    MODE,                   // decrypt or encrypt mode
    .equ    BOOKBUF,                // buffer for book file
    .equ    ARGV0,                  // save argv[0] for error printing
    //
    // add your local variables here if you need them:
    // NOTICE: Adjust PAD so FRMADD + FP_OFF + 4 divides by 8 EVENLY!
    //
    .equ    PAD,                    // Stack frame PAD
    .equ    OARG5,                  // output arg5 must be at bottom
    .equ    FRMADD,    OARG5-FP_OFF // space in frame for locals+passed args

    // TODO PA9: list how you are using the preserved registers
    // preserved register use
    // r4 
    // r5
    // r6 mode flag
    // r7
    // r8
    // r9
    // r10

main:
    push    {r4-r10, fp, lr}        // push all preserved registers
    add     fp, sp, FP_OFF          // set frame pointer to frame base
    ldr     r3, =FRMADD             // get space needed for locals+passed args
    sub     sp, sp, r3              // allocate space for locals and passed args 
     
    // save argv[0] in argv0

    // call int setup(argc, argv, *mode, *FPBOOK)

    // set up for main loop

.Lloop:
    // int rdbuf(r0=stdin, r1=fpbook, r2=BUFSZ, r3=iobuf,OARG5=bookbuf)



    // int XXcrypt(char *iobuf, char *bookbuf, int cnt)
    // encrypt or decrypt 
    // returns cnt



    //
    // fwrite(iobuf, 1, cnt, stdout)
    // 

.Lexit:
    sub     sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}
    bx      lr

    .size   main, (. - main)
    .section .note.GNU-stack,"",%progbits
.end
#endif
