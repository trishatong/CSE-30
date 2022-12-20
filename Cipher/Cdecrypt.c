// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYDECRYPT_C
TODO("using Cdecrypt.c");

int
decrypt(char *iobuf, char *bookbuf, int cnt)
{	
	
    unsigned int reversed = 0;
    unsigned int bookbuf_int = 0;
    for (int i = 0; i < cnt; i++) {					// traverse through iobuf		
	    reversed = 0;
	    unsigned int index  = iobuf[i];
	    unsigned int byte = 0;
	    bookbuf_int = bookbuf[i];
	    byte = (unsigned int)(index ^ bookbuf_int);			// XOR
	    for (int j = 0; j < 8; j++) {				// reverse order of bits
		unsigned int a = ((byte>>j) & 0x1);
		unsigned int b = (7 - j);
		unsigned int c = a<<b;
		reversed = reversed | c;   
	    }
	    iobuf[i] = (char)(reversed);
    }
    return cnt;
}

#elif defined MYDECRYPT_S
TODO("using decrypt.S");
#else
TODO("using solution decrypt");
#endif
