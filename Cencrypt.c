// version 1.0 11/12/2022
#include <stdio.h>
#include "cipher.h"

#ifdef MYENCRYPT_C
TODO("using Cencrypt.c");

int
encrypt(char *iobuf, char *bookbuf, int cnt)
{
    unsigned int reversed = 0;
    unsigned int bookbuf_int = 0;
    for (int i = 0; i < cnt; i++) {					// traverse through iobuf		
	    reversed = 0;
	    unsigned int index  = iobuf[i];
	    bookbuf_int = bookbuf[i];
	    for (int j = 0; j < 8; j++) {				// reverse order of bits
		unsigned int a = ((index>>j) & 0x1);
		unsigned int b = (7 - j);
		unsigned int c = a<<b;
		reversed = reversed | c;
	    }
	    iobuf[i] = (char)(reversed ^ bookbuf_int);			// XOR
    }
    return cnt;
}

#elif defined MYENCRYPT_S
TODO("using encrypt.S");
#else
TODO("using solution encrypt");
#endif
