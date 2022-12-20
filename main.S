    // version 1.1 10/29/2022 //
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
    // error messages
.Lbdrd:  .string "%s: read failed\n"
.Lbdwr:  .string "%s: write failed\n"

    .text

    //
    // encrypter [-d | -e] -b bookfile
    //
    // int main(int argc, char **argv)
    // int main(r0=argc, r1=argv)

    .global main
    .type   main, %function

    // stack frame layout
    .equ    FP_OFF,     32                       // fp offset in main stack frame
    .equ    FPBOOK,     FP_OFF + 4               // FILE * to book file
    .equ    IOBUF,      FPBOOK + BUFSZ           // buffer for input file
    .equ    MODE,       IOBUF + 4                // decrypt or encrypt mode
    .equ    BOOKBUF,    MODE + BUFSZ             // buffer for book file
    .equ    ARGV0,      BOOKBUF + 4              // save argv[0] for error printing
    .equ    PAD,        ARGV0 + 4                // Stack frame PAD
    .equ    OARG5,      PAD + 4                  // output arg5 must be at bottom
    .equ    FRMADD,    OARG5-FP_OFF              // space in frame for locals+passed args

    // preserved register use
    // r4 stderr
    // r5 stdout
    // r6 mode flag
    // r7 fpbook, cnt
    // r8 stdin
    // r9 iobuf
    // r10 bookbuf

main:
    push    {r4-r10, fp, lr}        // push all the usable preserved registers
    add     fp, sp, FP_OFF          // set frame pointer to frame base
    ldr     r3, =FRMADD             // get space needed for locals+passed args
    sub     sp, sp, r3              // allocate space for locals and passed args 
         
    ldr r2, =ARGV0
    ldr r5, [r1]
    str r5, [fp, -r2] 		    // argv0 = *argv
    ldr r2, =MODE
    sub r2, fp, r2			    // r2 = &mode
    ldr r3, =FPBOOK
    sub r3, fp, r3			    // r3 = &fpbook     
    bl setup
    cmp r0, EXIT_FAIL		    // if (setup(argc, arv, &mode, &fpbook) == EXIT_FAIL)
    beq .Lexit

    // this loop runs until rdbuf indicates the EOF on stdin
    // was reached or there was an error.
.Lloop:
    ldr r0, =stdin
    ldr r0, [r0]		    // r0 = stdin
    ldr r1, =FPBOOK	    
    ldr r1, [fp, -r1]       // r1 = fpbook
    ldr r2, =BUFSZ	    	// r2 = BUFSZ
    ldr r3, =IOBUF      
    sub r3, fp, r3		    // r3 = iobuf
    ldr r5, =OARG5
    ldr r10, =BOOKBUF
    sub r10, fp, r10
    str r10, [fp, -r5]      // r10 = bookbuf
    bl rdbuf			    // rdbuf(stdin, fpbook, BUFSZ, iobuf, bookbuf)
    cmp r0, 0               // if (cnt = rdbuf(stdin, fpbook, BUFSZ, iobuf, bookbuf)) > 0
    mov r7, r0              // r7 = cnt
    ble .Ldone              

    mov r7, r0              // r7 = cnt
    ldr r6, =MODE
    ldr r6, [fp, -r6]       // r6 = mode
    cmp r6, ENCRYPT_MODE	// if (mode ==encrypt_mode)
    bne .Lelse  
    
    ldr r0, =IOBUF
    sub r0, fp, r0		    // r0 = iobuf
    ldr r1, =BOOKBUF
    sub r1, fp, r1		    // r1 = bookbuf
    mov r2, r7			    // r2 = cnt
    bl encrypt
    mov r2, r0			    // r2 = cnt = encrypt(iobuf, bookbuf, cnt)
    b .Lendif
   
.Lelse:				        // else   
    ldr r0, =IOBUF
    sub r0, fp, r0			// r0 = iobuf 
    ldr r1, =BOOKBUF
    sub r1, fp, r1      	// r1 = bookbuf
    mov r2, r7			    // r2 = cnt
    bl decrypt
    mov r2, r0			    // r2 = cnt = decrypt(iobuf, bookbuf, cnt)

.Lendif:
    mov r7, r2			    // r7 = cnt
    ldr r0, =IOBUF
    sub r0, fp, r0 			// r0 = iobuf
    mov r1, 1			    // r1 = 1   
    ldr r3, =stdout         // r3 = stdout
    ldr r3, [r3]
    bl fwrite
    cmp r0, r7			    // if (fwrite(iobuf, 1, cnt, stdout) != (size_t)cnt)
    beq .Lendloop	
    
    ldr r0, =stderr
    ldr r0, [r0]            // r0 = stderr
    ldr r1, =.Lbdwr	    	// r1 = "%s: write failed\n"
    ldr r2, =ARGV0
    ldr r2, [fp, -r2]       // r2 = argv0
    bl fprintf
    ldr r0, =FPBOOK    
    ldr r0, [fp, -r0]       // r0 = fpbook
    bl fclose			    // fclose(fpbook)
    mov r0, EXIT_FAIL
    b .Lexit

.Lendloop:
    b .Lloop			    // end while loop

.Ldone:
    ldr r0, =FPBOOK    
    ldr r0, [fp, -r0]   // r0 = fpbook
    bl fclose 
    cmp r7, EXIT_FAIL   // if (cnt == EXIT_FAIL)
    beq .Lreadfailed
    mov r0, EXIT_SUCCESS
    b .Lexit 

.Lreadfailed:
    ldr r0, =stderr
    ldr r0, [r0]        // r0 = stderr
    ldr r1, =.Lbdrd		// r1 = "%s: read failed\n"
    ldr r2, =ARGV0
    ldr r2, [fp, -r2]   // r2 = argv0 
    bl fprintf
    mov r0, EXIT_FAIL

.Lexit:
    sub     sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}
    bx      lr

    .size   main, (. - main)
    .section .note.GNU-stack,"",%progbits
.end
#endif
