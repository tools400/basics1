      *=====================================================================*
      *  BASICS1R7  - SrvPgm: Basic Routines - Mathematics                  *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  08.10.2003                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *   4.02.2005  Th.Raddatz    Added f_genUUID() to generate a          *
      *                            Universal Unique Identifier (UUID).      *
      *   8.03.2005  Th.Raddatz    Added f_genMD5() to generate a           *
      *                            MD5 fingerprint (hash code).             *
      *   8.03.2005  Th.Raddatz    Added f_genSHA1() to generate a          *
      *                            SHA-1 fingerprint (hash code).           *
      *   8.03.2005  Th.Raddatz    Added f_genSHA1() to generate a          *
      *                            SHA-1 fingerprint (hash code).           *
      *  28.12.2005  Th.Raddatz    Added f_genCRC32() to generate a         *
      *                            CRC-32 check sum.                        *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/BASICS1R7) +                *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< OPTIMIZE(*FULL );                                    *
      *       >>PARM<< TGTRLS(V6R1M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
     H BNDDIR('QC2LE')
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R7
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      /if not defined(*V5R3M0)                                                              //
      /COPY QBASICS1,MILIB
      /endif
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      /if defined(C_COMPILER)
     D c_crc32...
     D                 PR            10U 0        extproc('crc32')
     D  crc                          10U 0 value
     D  buf                            *   value
     D  len                          10U 0 value
      *
      /else
     D lp_crc32Table...
     D                 PR
     D  io_crc32Table                10U 0        dim(256)
      *
      /endif
      /if not defined(*V5R2M0)                                                              //
      *  Returns the bit-wise ANDing of the arguments.
     D lf_bitAND...
     D                 PR            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Returns the bit-wise ORing of the arguments.
     D lf_bitOR...
     D                 PR            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Returns the bit-wise exclusive ORing of the arguments.
     D lf_bitXOR...
     D                 PR            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Returns the bit-wise inverse of the bits of the argument.
     D lf_bitNOT...
     D                 PR            10U 0
     D  i_arg                        10U 0 value
      *
      /endif
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Tests for one or more bits.
      *=========================================================================
      *  Parameters:
      *   i_testBit     - The bits that are tested.
      *   i_value       - The numeric value that is tested for the bits.
      *
      *  Returns:
      *   isOn          - Returns cTrue when the bits specified at i_testBit
      *                   are set.
      *=========================================================================
      *
     P f_isBitOn...
     P                 B                   export
      *
     D f_isBitOn...
     D                 PI              N
     D  i_testBit                    10U 0 value
     D  i_value                      10U 0 value
      *
      *  Return value
     D isOn            S               N   inz(cTrue)
      *
      *  Helper fields
     D x               S              3I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_isBitOn...
     P                 E
      *
      *=========================================================================
      *  Computes the logarithm base 10 of a given value.
      *=========================================================================
      *  Parameters:
      *   i_value       - The numeric value.
      *
      *  Returns:
      *   log           - The logarithm value of i_value.
      *=========================================================================
      *
     P f_log10...
     P                 B                   export
      *
     D f_log10...
     D                 PI             8F
     D  i_value                       8F   value
      *
      *  Return value
     D log             S              8F   inz
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         CEESDLG1(i_value: log);

         return   log;

      /END-FREE
      *
     P f_log10...
     P                 E
      *
      *=========================================================================
      *  Computes the length of a RPG integer field from its buffer length
      *=========================================================================
      *  Parameters:
      *   i_value       - The numeric value.
      *
      *  Returns:
      *   log           - The logarithm value of i_value.
      *=========================================================================
      *
     P f_clcLengthOfRPGIntFieldFromBufSize...
     P                 B                   export
      *
     D f_clcLengthOfRPGIntFieldFromBufSize...
     D                 PI             5U 0
     D  i_buffSize                    5U 0 value
      *
      *  Return value
     D tempResult      S              8F   inz
     D rpgLength       S              5U 0 inz
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         tempResult = f_log10(2 ** (8 * i_buffSize));

         // Always round up to the next unsigned integer
         rpgLength  = %unsh(((tempResult * 10) + 5) / 10);

         return   rpgLength;

      /END-FREE
      *
     P f_clcLengthOfRPGIntFieldFromBufSize...
     P                 E
      *
      *=========================================================================
      *  Generates a Universal Unique Identifier (UUID).
      *=========================================================================
      *  The UUID is unique as an identifier across all time and space and is
      *  consistent with the Open Systems Foundation (OSF) Distributed Computing
      *  Environments (DCE) version 1 UUID specification described in the DCE's
      *  "Architecture Environment Specification/Distributed Computing: for
      *  Remote Procedure Calls", Appendix A.
      *  http://publib.boulder.ibm.com/infocenter/iseries/v5r3/ic2924/index.htm
      *=========================================================================
      *  Parameters:
      *   i_option      - Specifies how to return the UUID.
      *                   Default:        *HEX
      *                   cUUID_HEX     - Returns a hexadecimal UUID with
      *                                   a length of 16 byte.
      *                   cUUID_STRING  - Returns the string representation
      *                                   of a UUID with a length of 32 bytes.
      *
      *  Returns:
      *   uuid          - The UUID of type structure of type uuid_t:
      *                       uuid.value   - the value of the generated UUID
      *                       uuid.length  - the length of the generated UUID
      *=========================================================================
      *
     P f_genUUID...
     P                 B                   export
      *
     D f_genUUID...
     D                 PI                         likeds(uuid_t  )
     D  i_option                      5U 0 value  options(*nopass)
      *
      *  Return value
     D uuid            DS                  likeds(uuid_t) inz
      *
      *  Parameter positions
     D p_option        C                   const(1)
      *
      *  Fields for optional parameters
     D option          S                   like(i_option) inz
      *
      *  Helper fields
     D uuidHex         S             16A   inz
     D uuidString      S             32A   inz
     D uuidTemplate    DS                  likeds(uuid_template_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_genUUID...
     P                 E
      *
      *=========================================================================
      *  Generates a MD5 fingerprint (hash code).
      *=========================================================================
      *  Parameters:
      *   i_pString     - Pointer to a buffer or a variable or a literal
      *                   that contains the source string.
      *   i_options     - Specifies how to return the MD5.
      *                   Default:        cMD5_HEX + cMD5_ONLY
      *                   cMD5_HEX      - Returns a hexadecimal 16-byte MD5
      *                                   fingerprint (hash code).
      *                   cMD5_STRING   - Returns a hexadecimal 32-byte MD5
      *                                   fingerprint (hash code).
      *                   cMD5_ONLY     - Use this option to pass the
      *                                   complete buffer.
      *                   cMD5_FIRST    - Use this option to pass the first
      *                                   portion of a multi-part buffer.
      *                   cMD5_MIDDLE   - Use this option to pass the middle
      *                                   portions of a multi-part buffer.
      *                   cMD5_FINAL    - Use this option to pass the final
      *                                   portion of a multi-part buffer.
      *   i_length      - Length of the source string. If a variable or
      *                   a string is specified at i_pString, length
      *                   can be omitted.
      *
      *  Returns:
      *   md5           - The MD5 of type structure of type md5_t:
      *                       md5.value    - the value of the generated MD5
      *                       md5.length   - the length of the generated MD5
      *=========================================================================
      *
     P f_genMD5...
     P                 B                   export
      *
     D f_genMD5...
     D                 PI                         likeds(md5_t   )
     D  i_pString                      *   const  options(*string)
     D  i_options                     5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      *  Return value
     D MD5             DS                  likeds(md5_t  ) inz
      *
      *  Parameter positions
     D p_options       C                   const(2)
     D p_length        C                   const(3)
      *
      *  Fields for optional parameters
     D options         S                   like(i_options) inz
     D length          S                   like(i_length ) inz
      *
      *  Helper fields
     D isOutputString  S               N   inz(cFalse)
     D hashContext     S            160A   static   inz(*ALLx'00' )
     D ctrlsSeq        S                   like(controls.sequence) inz
     D numOptions      DS                  qualified
     D  sequence                      5U 0 inz
     D  output                        5U 0 inz
     D controls        DS                  likeds(cipherCtrls_t  ) inz
     D msg             DS                  likeds(msg_t          ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_genMD5...
     P                 E
      *
      *=========================================================================
      *  Generates a SHA-1 fingerprint (hash code).
      *=========================================================================
      *  Parameters:
      *   i_pString     - Pointer to a buffer or a variable or a literal
      *                   that contains the source string.
      *   i_options     - Specifies how to return the SHA-1.
      *                   Default:        cSHA1_HEX + cSHA1_ONLY
      *                   cSHA1_HEX     - Returns a hexadecimal 20-byte SHA-1
      *                                   fingerprint (hash code).
      *                   cSHA1_STRING  - Returns a hexadecimal 40-byte SHA-1
      *                                   fingerprint (hash code).
      *                   cSHA1_ONLY    - Use this option to pass the
      *                                   complete buffer.
      *                   cSHA1_FIRST   - Use this option to pass the first
      *                                   portion of a multi-part buffer.
      *                   cSHA1_MIDDLE  - Use this option to pass the middle
      *                                   portions of a multi-part buffer.
      *                   cSHA1_FINAL   - Use this option to pass the final
      *                                   portion of a multi-part buffer.
      *   i_length      - Length of the source string. If a variable or
      *                   a string is specified at i_pString, length
      *                   can be omitted.
      *
      *  Returns:
      *   sha1          - The SHA-1 of type structure of type sha1_t:
      *                       sha1.value   - the value of the generated SHA-1
      *                       sha1.length  - the length of the generated SHA-1
      *=========================================================================
      *
     P f_genSHA1...
     P                 B                   export
      *
     D f_genSHA1...
     D                 PI                         likeds(sha1_t  )
     D  i_pString                      *   const  options(*string)
     D  i_options                     5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      *  Return value
     D SHA1            DS                  likeds(sha1_t ) inz
      *
      *  Parameter positions
     D p_options       C                   const(2)
     D p_length        C                   const(3)
      *
      *  Fields for optional parameters
     D options         S                   like(i_options) inz
     D length          S                   like(i_length ) inz
      *
      *  Helper fields
     D isOutputString  S               N   inz(cFalse)
     D hashContext     S            160A   static   inz(*ALLx'00' )
     D ctrlsSeq        S                   like(controls.sequence) inz
     D numOptions      DS                  qualified
     D  sequence                      5U 0 inz
     D  output                        5U 0 inz
     D controls        DS                  likeds(cipherCtrls_t) inz
     D msg             DS                  likeds(msg_t        ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_genSHA1...
     P                 E
      *
      *=========================================================================
      *  Calculates a CRC32 checksum for a given string buffer.
      *=========================================================================
      *  Code was taken and converted to RPG from:
      *  http://www.vbaccelerator.com/home/VB/Code/Libraries/CRC32/article.asp
      *=========================================================================
      *  Parameters:
      *   i_pString     - Pointer to a buffer or a variable or a literal
      *                   that contains the source string.
      *   i_options     - Specifies how to return the CRC32.
      *                   Default:        cCRC32_ONLY.
      *                   cCRC32_ONLY   - Use this option to pass the
      *                                   complete buffer.
      *                   cCRC32_FIRST  - Use this option to pass the first
      *                                   portion of a multi-part buffer.
      *                   cCRC32_MIDDLE - Use this option to pass the middle
      *                                   portions of a multi-part buffer.
      *                   cCRC32_FINAL  - Use this option to pass the final
      *                                   portion of a multi-part buffer.
      *   i_length      - Length of the source string. If a variable or
      *                   a string is specified at i_pString, length
      *                   can be omitted.
      *
      *  Returns:
      *   crc32         - The CRC32 of type structure of type crc32_t:
      *                       crc32.value  - the value of the generated CRC32
      *                       crc32.length - the length of the generated CRC32
      *=========================================================================
      *
     P f_genCRC32...
     P                 B                   export
      *
     D f_genCRC32...
     D                 PI                         likeds(crc32_t )
     D  i_pString                      *   const  options(*string)
     D  i_options                     5U 0 const  options(*nopass)
     D  i_length                     10U 0 const  options(*nopass)
      *
      *  Return value
     D CRC32           DS                  likeds(crc32_t) inz
      *
      *  Parameter positions
     D p_options       C                   const(2)
     D p_length        C                   const(3)
      *
      *  Fields for optional parameters
     D options         S                   like(i_options) inz
     D length          S                   like(i_length ) inz
      *
      *  Helper fields
     D ctrlsSeq        S             10I 0                       inz
     D aBufChar        S              3U 0 based(pABufChar     )
     D i               S             10U 0 inz
     D iLookup         S             10U 0 inz
     D numOptions      DS                  qualified
     D  sequence                      5U 0                       inz
     D msg             DS                  likeds(msg_t        ) inz
      *
      *  Static helper fields
     D                 DS                                              static
      /if defined(C_COMPILER)
     D  crc32Result                  10U 0 inz
      /else
     D  crc32Result                  10U 0 inz
      /endif
      /if not defined(C_COMPILER)
     D crc32Result1_1          1      1A
     D crc32Result1_3          1      3A
     D crc32Result2_4          2      4A
      *
     D isInit          S               N   inz(cFalse)                 static
     D crc32Table      S             10U 0 inz                         static
     D                                     dim(256)
      /endif
      /if not defined(*V5R3M0)
     D tmpResult       S             10U 0
     D hex000000FF     S             10U 0 inz(x'FF')
      /endif
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_genCRC32...
     P                 E
      *
      /if not defined(C_COMPILER)
      *=========================================================================
    R *  *** private ***
      *  Initialize crc32Table with official used by CRC32 in PKZip.
      *  Often the polynomial is shown reversed (04C11DB7).
      *=========================================================================
      *
     P lp_crc32Table...
     P                 B
      *
     D lp_crc32Table...
     D                 PI
     D  io_crc32Table                10U 0        dim(256)
      *
      *  Helper fields
     D i               S             10I 0 inz
     D j               S             10I 0 inz
     D dwCrc           S             10U 0 inz
     D                 DS
     D dwPolynomial                  10U 0
     D dwPolynomialH           1      4    inz(x'EDB88320')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P lp_crc32Table...
     P                 E
      *
      /endif
      /if not defined(*V5R2M0)                                                              //
      *=========================================================================
    R *  *** private ***
      *  Returns the bit-wise ANDing of the arguments.
      *=========================================================================
      *
     P lf_bitAND...
     P                 B
      *
     D lf_bitAND...
     D                 PI            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Return value
     D result          S             10U 0
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         ANDSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

         return result;

      /END-FREE
      *
     P lf_bitAND...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns the bit-wise ORing of the arguments.
      *=========================================================================
      *
     P lf_bitOR...
     P                 B
      *
     D lf_bitOR...
     D                 PI            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Return value
     D result          S             10U 0
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         XORSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

         return result;

      /END-FREE
      *
     P lf_bitOR...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns the bit-wise exclusive ORing of the arguments.
      *=========================================================================
      *
     P lf_bitXOR...
     P                 B
      *
     D lf_bitXOR...
     D                 PI            10U 0
     D  i_arg1                       10U 0 value
     D  i_arg2                       10U 0 value
      *
      *  Return value
     D result          S             10U 0
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         XORSTR(%addr(result): %addr(i_arg1): %addr(i_arg2): %len(result));

         return result;

      /END-FREE
      *
     P lf_bitXOR...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns the bit-wise inverse of the bits of the argument.
      *=========================================================================
      *
     P lf_bitNOT...
     P                 B
      *
     D lf_bitNOT...
     D                 PI            10U 0
     D  i_arg                        10U 0 value
      *
      *  Return value
     D result          S             10U 0
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         COMSTR(%addr(result): %addr(i_arg): %len(result));

         return result;

      /END-FREE
      *
     P lf_bitNOT...
     P                 E
      *
      /endif
