**free
/if NOT DEFINED(BASICS1R7)
/define BASICS1R7

//  Constants

//  Generate UUID:
dcl-c cUUID_HEX 1;
dcl-c cUUID_STRING 2;

dcl-ds uuid_t qualified;
  length uns(5);
  value  char(32);
end-ds;

//  Generate MD5:
dcl-c cMD5_HEX 4352; //  256 + 4096
dcl-c cMD5_STRING 4608; //  512 + 4096
dcl-c cMD5_ONLY 17; //    1 +   16
dcl-c cMD5_FIRST 18; //    2 +   16
dcl-c cMD5_MIDDLE 20; //    4 +   16
dcl-c cMD5_FINAL 24; //    8 +   16

dcl-ds md5_t qualified;
  length uns(5);
  value  char(32);
end-ds;

//  Generate SHA-1:
dcl-c cSHA1_HEX 8448; //  256 + 8192
dcl-c cSHA1_STRING 8704; //  512 + 8192
dcl-c cSHA1_ONLY 33; //    1 +   32
dcl-c cSHA1_FIRST 34; //    2 +   32
dcl-c cSHA1_MIDDLE 36; //    4 +   32
dcl-c cSHA1_FINAL 40; //    8 +   32

dcl-ds sha1_t qualified;
  length uns(5);
  value  char(40);
end-ds;

//  Generate CRC32:
dcl-c cCRC32_ONLY 33; //    1 +   64
dcl-c cCRC32_FIRST 34; //    2 +   64
dcl-c cCRC32_MIDDLE 36; //    4 +   64
dcl-c cCRC32_FINAL 40; //    8 +   64

dcl-ds crc32_t qualified;
  length uns(5);
  value  char(40);
end-ds;

//  Tests for one or more bits.
dcl-pr f_isBitOn ind extproc('BASICS1R7_f_isBitOn');
  i_testBit uns(10) value;
  i_value   uns(10) value;
end-pr;

//  Computes the logarithm base 10 of a given value.
dcl-pr f_log10 float(8) extproc('BASICS1R7_f_log10');
  i_value float(8) value;
end-pr;

//  Computes the length of a RPG integer field from its buffer length
dcl-pr f_clcLengthOfRPGIntFieldFromBufSize uns(5)
  extproc('BASICS1R7_f_clcLengthOfRPGIntFieldFromBufSize');
  i_buffSize uns(5) value;
end-pr;

//  Generates a Universal Unique Identifier (UUID).
dcl-pr f_genUUID likeds(uuid_t) extproc('BASICS1R7_f_genUUID');
  i_option uns(5) options(*nopass) value;
end-pr;

//  Generates a MD5 fingerprint (hash code).
dcl-pr f_genMD5 likeds(md5_t) extproc('BASICS1R7_f_genMD5');
  i_pString pointer options(*string) const;
  i_option  uns(5) options(*nopass) const;
  i_length  uns(10) options(*nopass) const;
end-pr;

//  Generates a SHA-1 fingerprint (hash code).
dcl-pr f_genSHA1 likeds(sha1_t) extproc('BASICS1R7_f_genSHA1');
  i_pString pointer options(*string) const;
  i_option  uns(5) options(*nopass) const;
  i_length  uns(10) options(*nopass) const;
end-pr;

//  Generates a CRC32 checksum.
dcl-pr f_genCRC32 likeds(crc32_t) extproc('BASICS1R7_f_genCRC32');
  i_pString pointer options(*string) const;
  i_option  uns(5) options(*nopass) const;
  i_length  uns(10) options(*nopass) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R3                   Strings
/copy QBASICS1,PBASICS1R4                   Assert/This/Caller

/if defined(C_COMPILER)
/copy QBASICS1,PBASICS1C7                   C-Helpers
/endif

/endif