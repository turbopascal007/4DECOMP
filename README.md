# 4DECOMP

4DECOMP V1.0 (c) 1993 by Akisoft, Vienna

4DOSs New Version 5.0 came up right now! It has a lot of new features,
including BATCOMP.EXE, also from JP Software, which is assumed to compress
.BTM-Files.

Its purpose is to make .BTM-files shorter (to use less space on the hard-
disk) and to make .BTM-files something like "encrypted". That makes it
possible for batch-file-programmers to distribute their files without
distributing the batch-file-source-code, which is imanent to distributing
flat batch-files. The encryption algorithm is as simple as the decryption
algorithm. A very short program, with pascal-source-code, can decrypt such
batch-files. The maximum file-length is, like in .BTM-files, limited to 64k.

File-format of the compressed file:
===================================
(like everything in this package distributed without any warranty)

The first 2 Bytes are equal to EBh BEh, the indicator for compressed 4DOS-
.BTM-files. the next 2 Bytes contain the size of the original BATCH-file.

The encryption (compression) uses the following cheme: from position 5 there
are 30 characters stored, which are the most frequently used characters. The
rest of the file contains nibbles (2 nibbles per byte).The first 14 of the
most frequently used characters have nibble-codes from 2 to 15 (2h to Fh),
the others have 2-nibble-codes (use the same size as one byte, but may be lo-
cated separated inside 2 bytes), the first nibble is always 1 and the second
goes from 0 to 15 (0h to Fh). The nibble code 0 (at a first-level-nibble-
position) is used to indicate that the following 2 nibbles represent one char
in ASCII, but the lower 4 bits swapped with the upper 4 (the 2 nibbles are
swapped). Summary: If there are only a few different chars inside the text,
for example by using a lot of ECHO-directives, the text can be compressed to
one half of its original size (1 char uses only 1 nibble of storage place). If
there are a lot of different characters in the text, and most of them appear
often, it is possible that the "compressed" file is larger than the original
batch-file.

A short example:

Original .BTM-File:

ECHO OFF
echo abcdefghijklmnopqrstuvwxyz

Compressed .BTM-File (HEX-output of DEBUG):

0000  EB BE 28 00 20 46 4F 63-65 68 6F 0D 43 45 48 61   ..(. FOceho.CEHa
0010  62 64 66 67 69 6A 6B 6C-6D 6E 70 71 72 73 74 75   bdfgijklmnpqrstu
0020  76 77 BA C4 24 33 96 57-82 DE 5F 61 01 17 12 13   vw..$3.W.._a....
0030  14 15 16 17 81 81 91 A1-B1 C1 D1 E1 F0 87 09 70   ...............p
0040  A7                                                .

*)      0000: EB BE, indicates compressed .BTM-file.
*)      0002: 28 00, size of original .BTM-file (0028h=40 bytes).
*) 0005-0011: The very most frequently used characters, 0dh stands
              for both 0dh and 0ah (carriage return+line feed).
*) 0012-0022: The other most frequently used characters.
*) 0023-0040: Token for the used characters in the original .BTM-file:
              BA = Token bh (Token 11 is "E"), Token ah (Token 10 is "C")
              C4 = Token for "H" and "O"
              24 = Token for " " and "O"
              33 = twice the Token for "F"
              96 = Token for NEW-LINE and "e"
              57 82 DE 5F = Token for "cho abcd"
              61 = Token for "e" and prefix for second table
              01 = Token 0 from second table = "f" + prefix for second table
              17 = Token 1 from second table = "g" + first Token 7 = "h"
              12 13 14 15 16 17 = all token from second table "ijklmn"
              81 = Token "o" + prefix, second table
              81 91 A1 B1 C1 D1 E1 = Token "pqrstuv" from second table
              F0 87 = Token 15 from second table "w" and character 78h="x"
              09 70 A7 = again Token for character, character "y", token, "z"

That's it!

Use the program as long as JP software doesn't change the encryption
algorithm ...

The program, source, documentation is uploaded "as is", without any warranty,
etc. Use, modify, copy, and delete the program excessively the way you want,
but keep in mind, the idea was MINE (pow!)!

mfg to all my hacking friends i don't know yet 

and "Viele Gruesse aus Oesterreich!"

Akisoft, Vienna (c) december 1993
