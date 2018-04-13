      /IF NOT DEFINED(BASICS1R7)
      /DEFINE BASICS1R7
      *
      *  Constants
      *
      *  Generate UUID:
     D cUUID_HEX...
     D                 C                   const(1)
     D cUUID_STRING...
     D                 C                   const(2)
      *
     D uuid_t          DS                  qualified
     D  length                        5U 0
     D  value                        32A
      *
      *  Generate MD5:
     D cMD5_HEX...
     D                 C                   const(4352)                           256 + 4096
     D cMD5_STRING...
     D                 C                   const(4608)                           512 + 4096
     D cMD5_ONLY...
     D                 C                   const(17)                               1 +   16
     D cMD5_FIRST...
     D                 C                   const(18)                               2 +   16
     D cMD5_MIDDLE...
     D                 C                   const(20)                               4 +   16
     D cMD5_FINAL...
     D                 C                   const(24)                               8 +   16
      *
     D md5_t           DS                  qualified
     D  length                        5U 0
     D  value                        32A
      *
      *  Generate SHA-1:
     D cSHA1_HEX...
     D                 C                   const(8448)                           256 + 8192
     D cSHA1_STRING...
     D                 C                   const(8704)                           512 + 8192
     D cSHA1_ONLY...
     D                 C                   const(33)                               1 +   32
     D cSHA1_FIRST...
     D                 C                   const(34)                               2 +   32
     D cSHA1_MIDDLE...
     D                 C                   const(36)                               4 +   32
     D cSHA1_FINAL...
     D                 C                   const(40)                               8 +   32
      *
     D sha1_t          DS                  qualified
     D  length                        5U 0
     D  value                        40A
      *
      *  Generate CRC32:
     D cCRC32_ONLY...
     D                 C                   const(33)                               1 +   64
     D cCRC32_FIRST...
     D                 C                   const(34)                               2 +   64
     D cCRC32_MIDDLE...
     D                 C                   const(36)                               4 +   64
     D cCRC32_FINAL...
     D                 C                   const(40)                               8 +   64
      *
     D crc32_t         DS                  qualified
     D  length                        5U 0
     D  value                        40A
      *
      *  Tests for one or more bits.
     D f_isBitOn...
     D                 PR              N
     D                                     extproc('BASICS1R7+
     D                                     _f_isBitOn+
     D                                     ')
     D  i_testBit                    10U 0 value
     D  i_value                      10U 0 value
      *
      *  Computes the logarithm base 10 of a given value.
     D f_log10...
     D                 PR             8F
     D                                     extproc('BASICS1R7+
     D                                     _f_log10+
     D                                     ')
     D  i_value                       8F   value
      *
      *  Computes the length of a RPG integer field from its buffer length
     D f_clcLengthOfRPGIntFieldFromBufSize...
     D                 PR             5U 0
     D                                     extproc('BASICS1R7+
     D                                     _f_clcLengthOfRPGIntFieldFromBufSize+
     D                                     ')
     D  i_buffSize                    5U 0 value
      *
      *  Generates a Universal Unique Identifier (UUID).
     D f_genUUID...
     D                 PR                         likeds(uuid_t  )
     D                                     extproc('BASICS1R7+
     D                                     _f_genUUID+
     D                                     ')
     D  i_option                      5U 0 value  options(*nopass)
      *
      *  Generates a MD5 fingerprint (hash code).
     D f_genMD5...
     D                 PR                         likeds(md5_t   )
     D                                     extproc('BASICS1R7+
     D                                     _f_genMD5+
     D                                     ')
     D  i_pString                      *   const  options(*string)
     D  i_option                      5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      *  Generates a SHA-1 fingerprint (hash code).
     D f_genSHA1...
     D                 PR                         likeds(sha1_t  )
     D                                     extproc('BASICS1R7+
     D                                     _f_genSHA1+
     D                                     ')
     D  i_pString                      *   const  options(*string)
     D  i_option                      5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      *  Generates a CRC32 checksum.
     D f_genCRC32...
     D                 PR                         likeds(crc32_t )
     D                                     extproc('BASICS1R7+
     D                                     _f_genCRC32+
     D                                     ')
     D  i_pString                      *   const  options(*string)
     D  i_option                      5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R3                   Strings
      /COPY QBASICS1,PBASICS1R4                   Assert/This/Caller
      *
      /if defined(C_COMPILER)
      /COPY QBASICS1,PBASICS1C7                   C-Helpers
      /endif
      *
      /ENDIF
