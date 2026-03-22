**FREE
//=====================================================================*
//  BASICS1R7  - SrvPgm: Basic Routines - Mathematics                  *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  08.10.2003                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//   4.02.2005  Th.Raddatz    Added f_genUUID() to generate a          *
//                            Universal Unique Identifier (UUID).      *
//   8.03.2005  Th.Raddatz    Added f_genMD5() to generate a           *
//                            MD5 fingerprint (hash code).             *
//   8.03.2005  Th.Raddatz    Added f_genSHA1() to generate a          *
//                            SHA-1 fingerprint (hash code).           *
//   8.03.2005  Th.Raddatz    Added f_genSHA1() to generate a          *
//                            SHA-1 fingerprint (hash code).           *
//  28.12.2005  Th.Raddatz    Added f_genCRC32() to generate a         *
//                            CRC-32 check sum.                        *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/BASICS1R7) +                *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTIMIZE(*FULL );                                    *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt NOMAIN;
ctl-opt BNDDIR('QC2LE');
//  Standard H-Specs
/COPY QBASICS1,H_SPEC
/COPY QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/COPY QBASICS1,PBASICS1R7

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/COPY QBASICS1,BASICS1R0

/if not defined(*V5R3M0)                                                              //
/COPY QBASICS1,MILIB
/endif

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

/if defined(C_COMPILER)
dcl-pr c_crc32
       uns(10) extproc('crc32');
  crc             uns(10) value;
  buf             pointer value;
  len             uns(10) value;
end-pr;

/else
dcl-pr lp_crc32Table;
  io_crc32Table   uns(10) dim(256);
end-pr;

/endif
/if not defined(*V5R2M0)                                                              //
//  Returns the bit-wise ANDing of the arguments.
dcl-pr lf_bitAND
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pr;

//  Returns the bit-wise ORing of the arguments.
dcl-pr lf_bitOR
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pr;

//  Returns the bit-wise exclusive ORing of the arguments.
dcl-pr lf_bitXOR
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pr;

//  Returns the bit-wise inverse of the bits of the argument.
dcl-pr lf_bitNOT
       uns(10);
  i_arg           uns(10) value;
end-pr;

/endif
// -----------------------------------------
//  Global constants
// -----------------------------------------

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Tests for one or more bits.
//=========================================================================
//  Parameters:
//   i_testBit     - The bits that are tested.
//   i_value       - The numeric value that is tested for the bits.
//
//  Returns:
//   isOn          - Returns cTrue when the bits specified at i_testBit
//                   are set.
//=========================================================================

dcl-proc f_isBitOn export;

dcl-pi f_isBitOn
       ind;
  i_testBit       uns(10) value;
  i_value         uns(10) value;
end-pi;

//  Return value
dcl-s isOn            ind inz(cTrue);

//  Helper fields
dcl-s x               int(3) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

p_assert(i_testBit > 0:
         'i_testBit is out of range. It must be greater than 0');

p_assert(i_value >= 0:
         'i_value is out of range. It must be greater than/equal 0');

isOn = cTrue;

for   x = (%size(i_value) * 8) - 1 downTo 0 ;
   if   tstbts(%addr(i_testBit): x) <> 0;
      if   tstbts(%addr(i_value): x) = 0;
         isOn = cFalse;
         leave;
      endif;
   endif;
endfor;

return   isOn;


end-proc f_isBitOn;

//=========================================================================
//  Computes the logarithm base 10 of a given value.
//=========================================================================
//  Parameters:
//   i_value       - The numeric value.
//
//  Returns:
//   log           - The logarithm value of i_value.
//=========================================================================

dcl-proc f_log10 export;

dcl-pi f_log10
       float(8);
  i_value         float(8) value;
end-pi;

//  Return value
dcl-s log             float(8) inz;

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CEESDLG1(i_value: log);

return   log;


end-proc f_log10;

//=========================================================================
//  Computes the length of a RPG integer field from its buffer length
//=========================================================================
//  Parameters:
//   i_value       - The numeric value.
//
//  Returns:
//   log           - The logarithm value of i_value.
//=========================================================================

dcl-proc f_clcLengthOfRPGIntFieldFromBufSize export;

dcl-pi f_clcLengthOfRPGIntFieldFromBufSize
       uns(5);
  i_buffSize      uns(5) value;
end-pi;

//  Return value
dcl-s tempResult      float(8) inz;
dcl-s rpgLength       uns(5) inz;

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

tempResult = f_log10(2 ** (8 * i_buffSize));

// Always round up to the next unsigned integer
rpgLength  = %unsh(((tempResult * 10) + 5) / 10);

return   rpgLength;


end-proc f_clcLengthOfRPGIntFieldFromBufSize;

//=========================================================================
//  Generates a Universal Unique Identifier (UUID).
//=========================================================================
//  The UUID is unique as an identifier across all time and space and is
//  consistent with the Open Systems Foundation (OSF) Distributed Computing
//  Environments (DCE) version 1 UUID specification described in the DCE's
//  "Architecture Environment Specification/Distributed Computing: for
//  Remote Procedure Calls", Appendix A.
//  http://publib.boulder.ibm.com/infocenter/iseries/v5r3/ic2924/index.htm
//=========================================================================
//  Parameters:
//   i_option      - Specifies how to return the UUID.
//                   Default:        *HEX
//                   cUUID_HEX     - Returns a hexadecimal UUID with
//                                   a length of 16 byte.
//                   cUUID_STRING  - Returns the string representation
//                                   of a UUID with a length of 32 bytes.
//
//  Returns:
//   uuid          - The UUID of type structure of type uuid_t:
//                       uuid.value   - the value of the generated UUID
//                       uuid.length  - the length of the generated UUID
//=========================================================================

dcl-proc f_genUUID export;

dcl-pi f_genUUID
       likeds(uuid_t  );
i_option        uns(5) value  options(*nopass);
end-pi;

//  Return value
dcl-ds uuid likeds(uuid_t) inz;

//  Parameter positions
dcl-c p_option const(1);

//  Fields for optional parameters
dcl-s option          like(i_option) inz;

//  Helper fields
dcl-s uuidHex         char(16) inz;
dcl-s uuidString      char(32) inz;
dcl-ds uuidTemplate likeds(uuid_template_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get optional parameters
if %parms >= p_option;
   option = i_option;
else;
   option = cUUID_HEX;
endif;

p_assert((option = cUUID_HEX) or (option = cUUID_STRING):
         'i_option is not valid.');

// Generate UUID:
uuidTemplate.bytPrv   = %size(uuid_t);
uuidTemplate.bytAvl   = 0;
uuidTemplate.reserved = *ALLx'00';
uuidTemplate.uuid     = *ALLx'00';
genUUID(%addr(uuidTemplate));

if uuidTemplate.bytAvl = 0;
   uuid.value  = '';
   uuid.length = 0;
else;
   if option = cUUID_HEX;
      // Return UUID as hex value
      uuid.value  = uuidTemplate.uuid;
      uuid.length = %size(uuidTemplate.uuid);
   else;
      // Convert hexadecimal UUID to string
      uuid.value  = f_cvtBufferToHexString(%addr(uuidTemplate.uuid):
                                           %size(uuidTemplate.uuid));
      uuid.length = %size(uuidTemplate.uuid) * 2;
   endif;
endif;

return   uuid;


end-proc f_genUUID;

//=========================================================================
//  Generates a MD5 fingerprint (hash code).
//=========================================================================
//  Parameters:
//   i_pString     - Pointer to a buffer or a variable or a literal
//                   that contains the source string.
//   i_options     - Specifies how to return the MD5.
//                   Default:        cMD5_HEX + cMD5_ONLY
//                   cMD5_HEX      - Returns a hexadecimal 16-byte MD5
//                                   fingerprint (hash code).
//                   cMD5_STRING   - Returns a hexadecimal 32-byte MD5
//                                   fingerprint (hash code).
//                   cMD5_ONLY     - Use this option to pass the
//                                   complete buffer.
//                   cMD5_FIRST    - Use this option to pass the first
//                                   portion of a multi-part buffer.
//                   cMD5_MIDDLE   - Use this option to pass the middle
//                                   portions of a multi-part buffer.
//                   cMD5_FINAL    - Use this option to pass the final
//                                   portion of a multi-part buffer.
//   i_length      - Length of the source string. If a variable or
//                   a string is specified at i_pString, length
//                   can be omitted.
//
//  Returns:
//   md5           - The MD5 of type structure of type md5_t:
//                       md5.value    - the value of the generated MD5
//                       md5.length   - the length of the generated MD5
//=========================================================================

dcl-proc f_genMD5 export;

dcl-pi f_genMD5
       likeds(md5_t   );
i_pString       pointer const  options(*string);
i_options       uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pi;

//  Return value
dcl-ds MD5 likeds(md5_t  ) inz;

//  Parameter positions
dcl-c p_options const(2);
dcl-c p_length const(3);

//  Fields for optional parameters
dcl-s options         like(i_options) inz;
dcl-s length          like(i_length ) inz;

//  Helper fields
dcl-s isOutputString  ind inz(cFalse);
dcl-s hashContext     char(160) static inz(*ALLx'00' );
dcl-s ctrlsSeq        like(controls.sequence) inz;
dcl-ds numOptions qualified;
  sequence        uns(5) inz;
  output          uns(5) inz;
end-ds;
dcl-ds controls likeds(cipherCtrls_t  ) inz;
dcl-ds msg likeds(msg_t          ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get optional parameters ...
// ... options
if %parms >= p_options;
   options = i_options;
else;
   options = cMD5_HEX + cMD5_ONLY;
endif;

// ... length
if %parms >= p_length;
   length = i_length;
else;
   length = strlen(i_pString);
endif;

// Check/get sequence options
numOptions.sequence = 0;
if f_isBitOn(cMD5_ONLY  : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cMD5_ONLY;
   ctrlsSeq = cCIPHER_ONLY;
endif;
if f_isBitOn(cMD5_FIRST : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cMD5_FIRST;
   ctrlsSeq = cCIPHER_FIRST;
endif;
if f_isBitOn(cMD5_MIDDLE: options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cMD5_MIDDLE;
   ctrlsSeq = cCIPHER_MIDDLE;
endif;
if f_isBitOn(cMD5_FINAL : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cMD5_FINAL;
   ctrlsSeq = cCIPHER_FINAL;
endif;

select;
when  numOptions.sequence =  0;
   ctrlsSeq = cCIPHER_ONLY;
when  numOptions.sequence <> 1;
   msg = f_newMsg('CPF9898':
                  'Invalid number of sequence options': cMsg_Escape);
   f_sndPgmMsg(msg);
endsl;

// Check/get output options
numOptions.output = 0;
if f_isBitOn(cMD5_STRING: options);
   numOptions.output = numOptions.output + 1;
   options        = options - cMD5_STRING;
   isOutputString = cTrue;
endif;
if f_isBitOn(cMD5_HEX: options);
   numOptions.output = numOptions.output + 1;
   options        = options - cMD5_HEX;
   isOutputString = cFalse;
endif;

if  numOptions.output <> 1;
   msg = f_newMsg('CPF9898':
                  'Invalid number of output options': cMsg_Escape);
   f_sndPgmMsg(msg);
endif;

if  options <> 0;
   msg = f_newMsg('CPF9898':
                  'Invalid option flags found': cMsg_Escape);
   f_sndPgmMsg(msg);
endif;

// Initialize cipher function
if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FIRST);
   hashContext = *ALLx'00';
endif;

controls.function      = x'0005';
controls.hashAlg       = cCIPHER_MD5;   // Hex 00 = MD5
// Hex 01 = SHA-1
controls.sequence      = ctrlsSeq;      // Hex 00 = Only
// Hex 01 = First
// Hex 02 = Middle
// Hex 03 = Final
controls.dataLength    = length;
controls.output        = cCIPHER_HASH;  // Hex 00 =  Hash
// Hex 01 =  HMAC
controls.reserved_1    = *ALLx'00';
controls.hashContext   = %addr(hashContext);
controls.HMACKey       = *NULL;
controls.HMACKeyLength = 0;
controls.reserved_2    = *ALLx'00';

// Generate MD5 hash code.
cipher(%addr(MD5.value): %addr(controls): i_pString);

if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FINAL);
   if isOutputString;
      // Convert hexadecimal MD5 to string
      MD5.value  = f_cvtBufferToHexString(%addr(MD5.value): 16);
      MD5.length = 32;
   else;
      // Return MD5 as hex value
      MD5.length = 16;
   endif;
else;
   MD5.value  = '';
   MD5.length = 0;
endif;

return   MD5;


end-proc f_genMD5;

//=========================================================================
//  Generates a SHA-1 fingerprint (hash code).
//=========================================================================
//  Parameters:
//   i_pString     - Pointer to a buffer or a variable or a literal
//                   that contains the source string.
//   i_options     - Specifies how to return the SHA-1.
//                   Default:        cSHA1_HEX + cSHA1_ONLY
//                   cSHA1_HEX     - Returns a hexadecimal 20-byte SHA-1
//                                   fingerprint (hash code).
//                   cSHA1_STRING  - Returns a hexadecimal 40-byte SHA-1
//                                   fingerprint (hash code).
//                   cSHA1_ONLY    - Use this option to pass the
//                                   complete buffer.
//                   cSHA1_FIRST   - Use this option to pass the first
//                                   portion of a multi-part buffer.
//                   cSHA1_MIDDLE  - Use this option to pass the middle
//                                   portions of a multi-part buffer.
//                   cSHA1_FINAL   - Use this option to pass the final
//                                   portion of a multi-part buffer.
//   i_length      - Length of the source string. If a variable or
//                   a string is specified at i_pString, length
//                   can be omitted.
//
//  Returns:
//   sha1          - The SHA-1 of type structure of type sha1_t:
//                       sha1.value   - the value of the generated SHA-1
//                       sha1.length  - the length of the generated SHA-1
//=========================================================================

dcl-proc f_genSHA1 export;

dcl-pi f_genSHA1
       likeds(sha1_t  );
i_pString       pointer const  options(*string);
i_options       uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pi;

//  Return value
dcl-ds SHA1 likeds(sha1_t ) inz;

//  Parameter positions
dcl-c p_options const(2);
dcl-c p_length const(3);

//  Fields for optional parameters
dcl-s options         like(i_options) inz;
dcl-s length          like(i_length ) inz;

//  Helper fields
dcl-s isOutputString  ind inz(cFalse);
dcl-s hashContext     char(160) static inz(*ALLx'00' );
dcl-s ctrlsSeq        like(controls.sequence) inz;
dcl-ds numOptions qualified;
  sequence        uns(5) inz;
  output          uns(5) inz;
end-ds;
dcl-ds controls likeds(cipherCtrls_t) inz;
dcl-ds msg likeds(msg_t        ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get optional parameters ...
// ... options
if %parms >= p_options;
   options = i_options;
else;
   options = cSHA1_HEX + cSHA1_ONLY;
endif;

// ... length
if %parms >= p_length;
   length = i_length;
else;
   length = strlen(i_pString);
endif;

// Check/get sequence options
numOptions.sequence = 0;
if f_isBitOn(cSHA1_ONLY  : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cSHA1_ONLY;
   ctrlsSeq = cCIPHER_ONLY;
endif;
if f_isBitOn(cSHA1_FIRST : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cSHA1_FIRST;
   ctrlsSeq = cCIPHER_FIRST;
endif;
if f_isBitOn(cSHA1_MIDDLE: options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cSHA1_MIDDLE;
   ctrlsSeq = cCIPHER_MIDDLE;
endif;
if f_isBitOn(cSHA1_FINAL : options);
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cSHA1_FINAL;
   ctrlsSeq = cCIPHER_FINAL;
endif;

select;
when  numOptions.sequence =  0;
   ctrlsSeq = cCIPHER_ONLY;
when  numOptions.sequence <> 1;
   msg = f_newMsg('CPF9898':
                  'Invalid number of sequence options': cMsg_Escape);
   f_sndPgmMsg(msg);
endsl;

// Check output options
numOptions.output = 0;
if f_isBitOn(cSHA1_STRING: options);
   numOptions.output = numOptions.output + 1;
   options        = options - cSHA1_STRING;
   isOutputString = cTrue;
endif;
if f_isBitOn(cSHA1_HEX: options);
   numOptions.output = numOptions.output + 1;
   options        = options - cSHA1_HEX;
   isOutputString = cFalse;
endif;

if  numOptions.output <> 1;
   msg = f_newMsg('CPF9898':
                  'Invalid number of output options': cMsg_Escape);
   f_sndPgmMsg(msg);
endif;

if  options <> 0;
   msg = f_newMsg('CPF9898':
                  'Invalid option flags found': cMsg_Escape);
   f_sndPgmMsg(msg);
endif;

// Initialize cipher function
if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FIRST);
   hashContext = *ALLx'00';
endif;

controls.function      = x'0005';
controls.hashAlg       = cCIPHER_SHA1;  // Hex 00 = MD5
// Hex 01 = SHA-1
controls.sequence      = ctrlsSeq;      // Hex 00 = Only
// Hex 01 = First
// Hex 02 = Middle
// Hex 03 = Final
controls.dataLength    = length;
controls.output        = cCIPHER_HASH;  // Hex 00 =  Hash
// Hex 01 =  HMAC
controls.reserved_1    = *ALLx'00';
controls.hashContext   = %addr(hashContext);
controls.HMACKey       = *NULL;
controls.HMACKeyLength = 0;
controls.reserved_2    = *ALLx'00';

// Generate SHA-1 hash code.
cipher(%addr(SHA1.value): %addr(controls): i_pString);

if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FINAL);
   if isOutputString;
      // Convert hexadecimal SHA-1 to string
      SHA1.value  = f_cvtBufferToHexString(%addr(SHA1.value): 20);
      SHA1.length = 40;
   else;
      // Return SHA-1 as hex value
      SHA1.length = 20;
   endif;
else;
   SHA1.value  = '';
   SHA1.length = 0;
endif;

return   SHA1;


end-proc f_genSHA1;

//=========================================================================
//  Calculates a CRC32 checksum for a given string buffer.
//=========================================================================
//  Code was taken and converted to RPG from:
//  http://www.vbaccelerator.com/home/VB/Code/Libraries/CRC32/article.asp
//=========================================================================
//  Parameters:
//   i_pString     - Pointer to a buffer or a variable or a literal
//                   that contains the source string.
//   i_options     - Specifies how to return the CRC32.
//                   Default:        cCRC32_ONLY.
//                   cCRC32_ONLY   - Use this option to pass the
//                                   complete buffer.
//                   cCRC32_FIRST  - Use this option to pass the first
//                                   portion of a multi-part buffer.
//                   cCRC32_MIDDLE - Use this option to pass the middle
//                                   portions of a multi-part buffer.
//                   cCRC32_FINAL  - Use this option to pass the final
//                                   portion of a multi-part buffer.
//   i_length      - Length of the source string. If a variable or
//                   a string is specified at i_pString, length
//                   can be omitted.
//
//  Returns:
//   crc32         - The CRC32 of type structure of type crc32_t:
//                       crc32.value  - the value of the generated CRC32
//                       crc32.length - the length of the generated CRC32
//=========================================================================

dcl-proc f_genCRC32 export;

dcl-pi f_genCRC32
       likeds(crc32_t );
i_pString       pointer const  options(*string);
i_options       uns(5) const  options(*nopass);
i_length        uns(10) const  options(*nopass);
end-pi;

//  Return value
dcl-ds CRC32 likeds(crc32_t) inz;

//  Parameter positions
dcl-c p_options const(2);
dcl-c p_length const(3);

//  Fields for optional parameters
dcl-s options         like(i_options) inz;
dcl-s length          like(i_length ) inz;

//  Helper fields
dcl-s ctrlsSeq        int(10) inz;
dcl-s aBufChar        uns(3) based(pABufChar     );
dcl-s i               uns(10) inz;
dcl-s iLookup         uns(10) inz;
dcl-ds numOptions qualified;
  sequence        uns(5) inz;
end-ds;
dcl-ds msg likeds(msg_t        ) inz;

//  Static helper fields
dcl-ds    *n                          static;
/if defined(C_COMPILER)
  crc32Result  uns(10) inz;
/else
  crc32Result  uns(10) inz;
/endif
/if not defined(C_COMPILER)
  crc32Result1_1          char(1) pos(1);
  crc32Result1_3          char(3) pos(1);
  crc32Result2_4          char(4) pos(2);
/endif
end-ds;


/if not defined(C_COMPILER)
dcl-s isInit          ind inz(cFalse)                 static;
dcl-s crc32Table      uns(10) inz static dim(256);
/endif
/if not defined(*V5R3M0)
dcl-s tmpResult       uns(10);
dcl-s hex000000FF     uns(10) inz(x'FF');
/endif
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get optional parameters ...
// ... options
if %parms >= p_options;
   options = i_options;
else;
   options = cCRC32_ONLY;
endif;

// ... length
if %parms >= p_length;
   length = i_length;
else;
   length = strlen(i_pString);
endif;

// Check/get sequence options
numOptions.sequence = 0;
/if defined(*V5R2M0)
if %bitAnd(cCRC32_ONLY  : options) = cCRC32_ONLY;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_ONLY;
   ctrlsSeq = cCIPHER_ONLY;
endif;
if %bitAnd(cCRC32_FIRST : options) = cCRC32_FIRST;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_FIRST;
   ctrlsSeq = cCIPHER_FIRST;
endif;
if %bitAnd(cCRC32_MIDDLE: options) = cCRC32_MIDDLE;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_MIDDLE;
   ctrlsSeq = cCIPHER_MIDDLE;
endif;
if %bitAnd(cCRC32_FINAL : options) = cCRC32_FINAL;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_FINAL;
   ctrlsSeq = cCIPHER_FINAL;
endif;
/else
if lf_bitAnd(cCRC32_ONLY  : options) = cCRC32_ONLY;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_ONLY;
   ctrlsSeq = cCIPHER_ONLY;
endif;
if lf_bitAnd(cCRC32_FIRST : options) = cCRC32_FIRST;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_FIRST;
   ctrlsSeq = cCIPHER_FIRST;
endif;
if lf_bitAnd(cCRC32_MIDDLE: options) = cCRC32_MIDDLE;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_MIDDLE;
   ctrlsSeq = cCIPHER_MIDDLE;
endif;
if lf_bitAnd(cCRC32_FINAL : options) = cCRC32_FINAL;
   numOptions.sequence = numOptions.sequence + 1;
   options  = options - cCRC32_FINAL;
   ctrlsSeq = cCIPHER_FINAL;
endif;
/endif

select;
when  numOptions.sequence =  0;
   ctrlsSeq = cCIPHER_ONLY;
when  numOptions.sequence <> 1;
   msg = f_newMsg('CPF9898':
                  'Invalid number of sequence options': cMsg_Escape);
   f_sndPgmMsg(msg);
endsl;

if  options <> 0;
   msg = f_newMsg('CPF9898':
                  'Invalid option flags found': cMsg_Escape);
   f_sndPgmMsg(msg);
endif;

// Initialize CRC32
if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FIRST);
/if not defined(C_COMPILER)
   crc32Result = x'FFFFFFFF';
   if not isInit;
      lp_crc32Table(crc32Table);
      isInit = cTrue;
   endif;
/else
   crc32Result = x'FFFFFFFF';
/endif
endif;

// Compute CRC32 checksum
/if defined(C_COMPILER)
crc32Result = c_crc32(crc32Result: i_pString: length);
/elseif defined(*V5R2M0)
for i = 0 to length - 1;
   pABufChar = i_pString + i;
   iLookup   = %bitxor(%bitand(crc32Result: x'FF'): aBufChar);
   crc32Result2_4 = crc32Result1_3;                         // nasty shift-right
   crc32Result1_1 = x'00';                                  // 8-bit
   crc32Result = %bitxor(crc32Result: crc32Table(iLookup + 1));
endfor;
/else
for i = 0 to length - 1;
   pABufChar = i_pString + i;
   // iLookup   = %bitxor(%bitand(crc32ResultU: x'FF'): aBufChar);
   iLookup = 0;
   ANDSTR(%addr(tmpResult)  : %addr(crc32Result):
          %addr(hex000000FF): 4);
   XORSTR(%addr(iLookup)+3: %addr(tmpResult)+3:
          %addr(aBufChar): 1);
   crc32Result2_4 = crc32Result1_3;                         // nasty shift-right
   crc32Result1_1 = x'00';                                  // 8-bit
   // crc32Result = %bitxor(crc32Result: crc32Table(iLookup + 1));
   tmpResult = crc32Table(iLookup + 1);
   XORSTR(%addr(crc32Result): %addr(crc32Result):
          %addr(tmpResult  ): 4);
endfor;
/endif

// Set return value
if (ctrlsSeq = cCIPHER_ONLY) or (ctrlsSeq = cCIPHER_FINAL);
/if defined(*V5R2M0)
   crc32Result = %bitnot(crc32Result);
/else
   COMSTR(%addr(crc32Result): %addr(crc32Result): 4);
/endif
   // Convert hexadecimal CRC32 to string
   CRC32.value = f_cvtBufferToHexString(%addr(crc32Result):
                                        %size(crc32Result));
   CRC32.length = 8;
else;
   CRC32.value  = '';
   CRC32.length = 0;
endif;

return   CRC32;


end-proc f_genCRC32;

/if not defined(C_COMPILER)
//=========================================================================
//  *** private ***
//  Initialize crc32Table with official used by CRC32 in PKZip.
//  Often the polynomial is shown reversed (04C11DB7).
//=========================================================================

dcl-proc lp_crc32Table;

dcl-pi lp_crc32Table;
  io_crc32Table   uns(10) dim(256);
end-pi;

//  Helper fields
dcl-s i               int(10) inz;
dcl-s j               int(10) inz;
dcl-s dwCrc           uns(10) inz;
dcl-ds *N;
  dwPolynomial    uns(10);
  dwPolynomialH   char(4) inz(x'EDB88320') pos(1);
end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for i = 0 to 255;
   dwCrc = i;
   for j = 8 downto 1;
/if defined(*V5R2M0)
      if %bitand(dwCrc: x'01') <> 0;
         dwCrc = %bitand(%uns(
                    %bitand(dwCrc: x'FFFFFFFE') / 2): x'7FFFFFFF');
         dwCrc = %bitxor(dwCrc: dwPolynomial);
      else;
         dwCrc = %bitand(%uns(
                    %bitand(dwCrc: x'FFFFFFFE') / 2): x'7FFFFFFF');
      endif;
/else
      if lf_bitand(dwCrc: x'01') <> 0;
         dwCrc = lf_bitand(%uns(
                   lf_bitand(dwCrc: x'FFFFFFFE') / 2): x'7FFFFFFF');
         dwCrc = lf_bitxor(dwCrc: dwPolynomial);
      else;
         dwCrc = lf_bitand(%uns(
                   lf_bitand(dwCrc: x'FFFFFFFE') / 2): x'7FFFFFFF');
      endif;
/endif
   endfor;
   io_crc32Table(i+1) = dwCrc;
endfor;

return;


end-proc lp_crc32Table;

/endif
/if not defined(*V5R2M0)                                                              //
//=========================================================================
//  *** private ***
//  Returns the bit-wise ANDing of the arguments.
//=========================================================================

dcl-proc lf_bitAND;

dcl-pi lf_bitAND
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pi;

//  Return value
dcl-s result          uns(10);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

return result;


end-proc lf_bitAND;

//=========================================================================
//  *** private ***
//  Returns the bit-wise ORing of the arguments.
//=========================================================================

dcl-proc lf_bitOR;

dcl-pi lf_bitOR
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pi;

//  Return value
dcl-s result          uns(10);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

XORSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

return result;


end-proc lf_bitOR;

//=========================================================================
//  *** private ***
//  Returns the bit-wise exclusive ORing of the arguments.
//=========================================================================

dcl-proc lf_bitXOR;

dcl-pi lf_bitXOR
       uns(10);
  i_arg1          uns(10) value;
  i_arg2          uns(10) value;
end-pi;

//  Return value
dcl-s result          uns(10);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

XORSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

return result;


end-proc lf_bitXOR;

//=========================================================================
//  *** private ***
//  Returns the bit-wise inverse of the bits of the argument.
//=========================================================================

dcl-proc lf_bitNOT;

dcl-pi lf_bitNOT
       uns(10);
  i_arg           uns(10) value;
end-pi;

//  Return value
dcl-s result          uns(10);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

COMSTR(%addr(result): %addr(i_arg): %len(result));

return result;


end-proc lf_bitNOT;

/endif
