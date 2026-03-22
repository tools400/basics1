**FREE
/IF NOT DEFINED(BASICS1R7)
/DEFINE BASICS1R7

//  Constants

//  Generate UUID:
dcl-c cUUID_HEX
      const(1);
dcl-c cUUID_STRING
      const(2);

dcl-ds uuid_t qualified;
  length          uns(5);
  value           char(32);
end-ds;

//  Generate MD5:
dcl-c cMD5_HEX
      const(4352);                                                       //  256 + 4096
dcl-c cMD5_STRING
      const(4608);                                                       //  512 + 4096
dcl-c cMD5_ONLY
      const(17);                                                         //    1 +   16
dcl-c cMD5_FIRST
      const(18);                                                         //    2 +   16
dcl-c cMD5_MIDDLE
      const(20);                                                         //    4 +   16
dcl-c cMD5_FINAL
      const(24);                                                         //    8 +   16

dcl-ds md5_t qualified;
  length          uns(5);
  value           char(32);
end-ds;

//  Generate SHA-1:
dcl-c cSHA1_HEX
      const(8448);                                                       //  256 + 8192
dcl-c cSHA1_STRING
      const(8704);                                                       //  512 + 8192
dcl-c cSHA1_ONLY
      const(33);                                                         //    1 +   32
dcl-c cSHA1_FIRST
      const(34);                                                         //    2 +   32
dcl-c cSHA1_MIDDLE
      const(36);                                                         //    4 +   32
dcl-c cSHA1_FINAL
      const(40);                                                         //    8 +   32

dcl-ds sha1_t qualified;
  length          uns(5);
  value           char(40);
end-ds;

//  Generate CRC32:
dcl-c cCRC32_ONLY
      const(33);                                                         //    1 +   64
dcl-c cCRC32_FIRST
      const(34);                                                         //    2 +   64
dcl-c cCRC32_MIDDLE
      const(36);                                                         //    4 +   64
dcl-c cCRC32_FINAL
      const(40);                                                         //    8 +   64

dcl-ds crc32_t qualified;
  length          uns(5);
  value           char(40);
end-ds;

//  Tests for one or more bits.
dcl-pr f_isBitOn
       ind
       extproc('BASICS1R7+
       _f_isBitOn+
       ');
  i_testBit       uns(10) value;
  i_value         uns(10) value;
end-pr;

//  Computes the logarithm base 10 of a given value.
dcl-pr f_log10
       float(8)
       extproc('BASICS1R7+
       _f_log10+
       ');
  i_value         float(8) value;
end-pr;

//  Computes the length of a RPG integer field from its buffer length
dcl-pr f_clcLengthOfRPGIntFieldFromBufSize
       uns(5)
       extproc('BASICS1R7+
       _f_clcLengthOfRPGIntFieldFromBufSize+
       ');
  i_buffSize      uns(5) value;
end-pr;

//  Generates a Universal Unique Identifier (UUID).
dcl-pr f_genUUID
       likeds(uuid_t  )
extproc('BASICS1R7+
_f_genUUID+
');
i_option        uns(5) value  options(*nopass);
end-pr;

//  Generates a MD5 fingerprint (hash code).
dcl-pr f_genMD5
       likeds(md5_t   )
extproc('BASICS1R7+
_f_genMD5+
');
i_pString       pointer const  options(*string);
i_option        uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pr;

//  Generates a SHA-1 fingerprint (hash code).
dcl-pr f_genSHA1
       likeds(sha1_t  )
extproc('BASICS1R7+
_f_genSHA1+
');
i_pString       pointer const  options(*string);
i_option        uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pr;

//  Generates a CRC32 checksum.
dcl-pr f_genCRC32
       likeds(crc32_t )
extproc('BASICS1R7+
_f_genCRC32+
');
i_pString       pointer const  options(*string);
i_option        uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R3                   Strings
/COPY QBASICS1,PBASICS1R4                   Assert/This/Caller

/if defined(C_COMPILER)
/COPY QBASICS1,PBASICS1C7                   C-Helpers
/endif

/ENDIF
