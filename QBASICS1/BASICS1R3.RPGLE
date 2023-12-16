      *=====================================================================*
      *  BASICS1R3  - SrvPgm: Basic Routines - Strings                      *
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
      *  26.01.2005  Th.Raddatz    Changed f_val to use self-written code   *
      *                            instead of MI function cvtefnd().        *
      *                            cvtefnd() crashes when it encounters an  *
      *                            invalid character.                       *
      *                                                                     *
      *  10.02.2005  Th.Raddatz    Added f_center() to center a string.     *
      *                                                                     *
      *  10.02.2005  Th.Raddatz    Added f_alignR() to right align a        *
      *                            given string.                            *
      *                                                                     *
      *  10.02.2005  Th.Raddatz    Changed f_space() to accept a 0 length.  *
      *                                                                     *
      *  15.02.2005  Th.Raddatz    Fixed problem in f_addQuotes() that      *
      *                            added to many leading and trailing       *
      *                            quotes.                                  *
      *                            Changed f_rmvQuotes() to removes quotes  *
      *                            only in case it is a quoted string.      *
      *                            String must have a leading *and* a       *
      *                            trailing quote.                          *
      *                                                                     *
      *  15.02.2005  Th.Raddatz    Added f_genStrCmp() and                  *
      *                            f_genStrCmpIgncase() to compare strings  *
      *                            using wildcard characters.               *
      *                                                                     *
      *  17.02.2005  Th.Raddatz    Added f_scanR() to a string for the      *
      *                            latest occurrence of a search argument.  *
      *                                                                     *
      *  24.02.2005  Th.Raddatz    Added f_cvtBufferToHexString() to        *
      *                            convert a buffer to a hex string.        *
      *                                                                     *
      *  25.02.2005  Th.Raddatz    Added f_cvtHexStringToBuffer() to        *
      *                            convert a hex string to a buffer.        *
      *                                                                     *
      *  28.02.2005  Th.Raddatz    Changed parameter i_string of            *
      *                            f_wordWrap() to VARYING. Enhanced        *
      *                            f_wordWrap() tp support end-of-paragraph *
      *                            marker.                                  *
      *                                                                     *
      *  17.06.2005  Th.Raddatz    Added f_startsWith().                    *
      *                                                                     *
      *  28.06.2006  Th.Raddatz    Fixed problem in f_wordwrap() that       *
      *                            EOL-character was not found when it was  *
      *                            the last character in the string.        *
      *                                                                     *
      *  20.11.2007  Th.Raddatz    Added f_endsWith().                      *
      *                                                                     *
      *  21.12.2007  Th.Raddatz    Added f_containsInvalidCharAt() and      *
      *                            f_containsStringAt().                    *
      *                                                                     *
      *  17.12.2008  Th.Raddatz    Added f_objName().                       *
      *                                                                     *
      *  15.01.2009  Th.Raddatz    Added f_rplUnPrtChars().                 *
      *                                                                     *
      *  15.01.2009  Th.Raddatz    Added f_rplUnPrtChars().                 *
      *                                                                     *
      *  23.01.2009  Th.Raddatz    Added f_formatDate() and f_parseDate().  *
      *                            Changed parameter i_quote of             *
      *                            f_addQuotes() from 'required' to         *
      *                            'optional'.                              *
      *                            Added f_formatMemSize().                 *
      *                                                                     *
      *  02.02.2009  Th.Raddatz    Fixed problem in f_wordwrap() that       *
      *                            caused a runtime error in case that the  *
      *                            last character of the input string is an *
      *                            EOP escape character.                    *
      *                                                                     *
      *  24.06.2009  Th.Raddatz    Fixed problem in f_genStrCmp() that      *
      *                            does not properly compare strings        *
      *                            that contain multiple dots.              *
      *                                                                     *
      *  03.04.2010  Th.Raddatz    Added f_cvtPtrToHexString().             *
      *                                                                     *
      *  22.01.2010  Th.Raddatz    Added f_startsWithIgnoreCase().          *
      *                                                                     *
      *  07.04.2015  Th.Raddatz    Replaced f_genStrCmp() with a more       *
      *                            reliable approach.                       *
      *                                                                     *
      *  17.09.2022  Th.Raddatz    Fixed handling optional parameter        *
      *                            i_wildcard in f_genStrCmp().             *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
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
      /COPY QBASICS1,PBASICS1R3
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,CEELIB
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Converts a RPG variable type to a variable class of the edit APIs.
     D lf_cvtRpgVarTypeToEdtAPIVarClass...
     D                 PR            10A
     D                                     extproc(
     D                                     'lf_cvtRpgVarTypeToEdtAPIVarClass')
     D  i_varType                     1A   const
      *
      *  Performs word wrapping on a given string without respect to
      *  end-of-paragraph markers.
     D lf_wordWrap...
     D                 PR          4096A          varying
     D                                     extproc('lf_wordWrap')
     D  i_string                   4096A   const  varying
     D  i_width                      10U 0 const
     D  io_startPos                  10U 0
      *
      *  Compare strings using wildcard characters. (Compare generic)
     D lf_genStrCmpInternal...
     D                 PR              N
     D                                     extproc('lf_genStrCmpInternal')
     D  i_string                   4096A   const   varying
     D  i_pattern                  4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cOPEN_PARENTHESIS...
     D                 C                   const('(')
     D cCLOSE_PARENTHESIS...
     D                 C                   const(')')
     D cSINGLE_QUOTE...
     D                 C                   const('''')
      *
     D cEQUAL_TRUE     C                   const('1')
     D cEQUAL_FALSE    C                   const('0')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Returns the left portion of a string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to return the left portion of.
      *   i_length      - The length of the left portion to return.
      *
      *  Returns:
      *   string        - The left portion if the string.
      *=========================================================================
      *
     P f_left...
     P                 B                   export
      *
     D f_left...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_length                     10I 0 const
      *
      *  Return value
     D leftString      S           4096A   varying  inz
      *
      *  Local fields
     D length          S                   like(i_length  )  inz
     D start           S                   like(i_length  )  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   i_length <= %len(i_string);
            length = i_length;
         else;
            length = %len(i_string);
         endif;

         start = 1;

         leftString = %subst(i_string: start: length);

         return   leftString;

      /END-FREE
      *
     P f_left...
     P                 E
      *
      *=========================================================================
      *  Returns the sub string that starts at a given position.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to return the left portion of.
      *   i_start       - Start position of the sub string.
      *   i_length      - The length of the sub string to return.
      *
      *  Returns:
      *   string        - The sub string.
      *=========================================================================
     P f_mid...
     P                 B                   export
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D                                             options(*varsize)
     D  i_start                      10I 0 const
     D  i_length                     10I 0 const   options(*nopass: *omit)
      *
      *  Definieren Funktionswert
     D rtnString       S           4096A   varying  inz
      *
      *  Parameterpositionen
     D p_length        c                   3
      *
      *  Definieren Arbeitsfelder
     D maxLength       s             10i 0 inz
     D length          s                   like(i_length) inz
     D msgText         s            256A   varying inz
     D msg             ds                  likeds(msg_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /free

         if (%parms() >= p_length and %addr(i_length) <> *NULL);
            length = i_length;
         else;
            length = *HIVAL;
         endif;

         if (i_start > %len(i_string) + 1 or i_start < 1);
            msgText = 'Start position is out of range: ' + %char(i_start);
            f_sndPgmMsg(f_newMsg(
                  'CPF9898': msgText: cMsg_Escape: 'QCPFMSG'): cMsg_Prv);
         endif;

         if (i_start + length - 1 > %len(i_string));
            length = %len(i_string) - i_start + 1;
         endif;

         if (length < 0);
            msgText = 'Length is out of range: ' + %char(i_length);
            f_sndPgmMsg(f_newMsg(
                  'CPF9898': msgText: cMsg_Escape: 'QCPFMSG'): cMsg_Prv);
         endif;

         if (length = 0);
            return '';
         endif;

         rtnString = %subst(i_string: i_start: length);

         return rtnString;

      /end-free
     P                 E
      *
      *=========================================================================
      *  Tests if the specified string starts with the specified prefix.
      *=========================================================================
      *  Parameters:
      *   i_prefix      - The prefix.
      *   i_string      - The string that is tested.
      *
      *  Returns:
      *   startsWith    - Returns TRUE if the string starts with the prefix,
      *                   else FALSE.
      *=========================================================================
      *
     P f_startsWith...
     P                 B                   export
      *
     D f_startsWith...
     D                 PI              N
     D  i_prefix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D startsWith      S               N   inz(cFalse)
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%len(i_string) = 0  or
             %len(i_prefix) = 0  or
             %len(i_string) < %len(i_prefix));
            return cFalse;
         endif;

         if (%subst(i_string: 1: %len(i_prefix)) <> i_prefix);
            return cFalse;
         endif;

         return cTrue;

      /END-FREE
      *
     P f_startsWith...
     P                 E
      *
      *=========================================================================
      *  Tests if the specified string starts with the specified prefix,
      *  ignoring case considerations.
      *=========================================================================
      *  Parameters:
      *   i_prefix      - The prefix.
      *   i_string      - The string that is tested.
      *
      *  Returns:
      *   startsWith    - Returns TRUE if the string starts with the prefix,
      *                   else FALSE.
      *=========================================================================
      *
     P f_startsWithIgnoreCase...
     P                 B                   export
      *
     D f_startsWithIgnoreCase...
     D                 PI              N
     D  i_prefix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D startsWith      S               N   inz(cFalse)
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%len(i_string) = 0  or
             %len(i_prefix) = 0  or
             %len(i_string) < %len(i_prefix));
            return cFalse;
         endif;

         if (f_lcase(%subst(i_string: 1: %len(i_prefix))) <> f_lcase(i_prefix));
            return cFalse;
         endif;

         return cTrue;

      /END-FREE
      *
     P f_startsWithIgnoreCase...
     P                 E
      *
      *=========================================================================
      *  Returns the right portion of a string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to return the right portion of.
      *   i_length      - The length of the right portion to return.
      *
      *  Returns:
      *   string        - The right portion if the string.
      *=========================================================================
      *
     P f_right...
     P                 B                   export
      *
     D f_right...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_length                     10I 0 const
      *
      *  Return value
     D rightString     S           4096A   varying   inz
      *
      *  Local fields
     D length          S                   like(i_length  )  inz
     D start           S                   like(i_length  )  inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   i_length <= %len(i_string);
            length = i_length;
         else;
            length = %len(i_string);
         endif;

         start = %len(i_string) - length + 1;

         rightString = %subst(i_string: start: length);

         return   rightString;

      /END-FREE
      *
     P f_right...
     P                 E
      *
      *=========================================================================
      *  Tests if the specified string ends with the specified suffix.
      *=========================================================================
      *  Parameters:
      *   i_suffix      - The suffix.
      *   i_string      - The string that is tested.
      *
      *  Returns:
      *   endsWith      - Returns TRUE if the string ends with the suffix,
      *                   else FALSE.
      *=========================================================================
      *
     P f_endsWith...
     P                 B                   export
      *
     D f_endsWith...
     D                 PI              N
     D  i_suffix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D endsWith        S               N   inz(cFalse)
      *
      *  Local fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if %len(i_string) = 0  or
            %len(i_suffix) = 0  or
            %len(i_string) < %len(i_suffix);
            return endsWith;
         endif;

         if %subst(i_string
                   : %len(i_string) - %len(i_suffix) + 1) = i_suffix;
            endsWith = cTrue;
         endif;

         return   endsWith;

      /END-FREE
      *
     P f_endsWith...
     P                 E
      *
      *=========================================================================
      *  Produces an empty string.
      *=========================================================================
      *  Parameters:
      *   i_length      - The length of the string to produce.
      *   i_char        - The fill char of the string.
      *                   Default:        *BLANKS
      *
      *  Returns:
      *   string        - The new string initialized with i_char.
      *=========================================================================
      *
     P f_space...
     P                 B                   export
      *
     D f_space...
     D                 PI          4096A           varying
     D  i_length                     10I 0 const
     D  i_char                        1A   const   options(*nopass)
      *
      *  Return value
     D spaceString     S           4096A   varying   inz
      *
      *  Parameter positions
     D p_char          C                   const(2)
      *
      *  Local fields
     D tmpStr          S           4096A                     inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_length >= 0:
                  'i_length is out of range. It must be less than ' +
                  %editc(%size(tmpStr): 'N'));

         if i_length = 0;
            spaceString = '';
         else;
            if   %parms >= p_char;
               memset(%addr(tmpStr): f_ebcdic(i_char): i_length);
            else;
               memset(%addr(tmpStr): f_ebcdic(' ')   : i_length);
            endif;

            spaceString = %subst(tmpStr: 1: i_length);
         endif;

         return   spaceString;

      /END-FREE
      *
     P f_space...
     P                 E
      *
      *=========================================================================
      *  Converts a given string to lower case.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to convert to lower case.
      *
      *  Returns:
      *   string        - The string converted to lower case.
      *=========================================================================
      *
     P f_lcase...
     P                 B                   export
      *
     D f_lcase...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D string          S           4096A   varying   inz
      *
      *  Fields for QlgConvertCase API
     D stringBuf       S           4096A             inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
     D reqCtrlBlk      DS                  qualified
     D  type                         10I 0
     D  CCSID                        10I 0
     D  case                         10I 0
     D  reserved                     10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE


         if   i_string <> '';
            reqCtrlBlk.type     = cCVTCASE_TYPE_ccsid;
            reqCtrlBlk.CCSID    = cCVTCASE_CCSID_Job;
            reqCtrlBlk.case     = cCVTCASE_toLower;
            reqCtrlBlk.reserved = *ALLx'00';
            errCode = f_newApiErrCode(cFalse);
            QlgConvertCase(reqCtrlBlk:
                           i_string: stringBuf: %len(i_string): errCode);
            string = %subst(stringBuf: 1: %len(i_string));
         else;
            string = i_string;
         endif;

         return   string;

      /END-FREE
      *
     P f_lcase...
     P                 E
      *
      *=========================================================================
      *  Converts a given string to upper case.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to convert to upper case.
      *
      *  Returns:
      *   string        - The string converted to upper case.
      *=========================================================================
      *
     P f_ucase...
     P                 B                   export
      *
     D f_ucase...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D string          S           4096A   varying   inz
      *
      *  Fields for QlgConvertCase API
     D stringBuf       S           4096A             inz
     D errCode         DS                  likeds(errCode_t ) inz
      *
     D reqCtrlBlk      DS                  qualified
     D  type                         10I 0
     D  CCSID                        10I 0
     D  case                         10I 0
     D  reserved                     10A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE


         if   i_string <> '';
            reqCtrlBlk.type     = cCVTCASE_TYPE_ccsid;
            reqCtrlBlk.CCSID    = cCVTCASE_CCSID_Job;
            reqCtrlBlk.case     = cCVTCASE_toUpper;
            reqCtrlBlk.reserved = *ALLx'00';
            errCode = f_newApiErrCode(cFalse);
            QlgConvertCase(reqCtrlBlk:
                           i_string: stringBuf: %len(i_string): errCode);
            string = %subst(stringBuf: 1: %len(i_string));
         else;
            string = i_string;
         endif;

         return   string;

      /END-FREE
      *
     P f_ucase...
     P                 E
      *
      *=========================================================================
      *  Replaces all occurences of a search argument by
      *  a replacement string in a given string.
      *=========================================================================
      *  Parameters:
      *   i_searchArg   - The argument that is replaced by the replacement
      *                   string.
      *   i_rplString   - The replacement string that replaces the search
      *                   argument.
      *   i_string      - The string that contains the search argument.
      *   i_startPos    - The position where to start from.
      *
      *  Returns:
      *   string        - The string having the search argument replaced with
      *                   the replacement string.
      *=========================================================================
      *
     P f_replace...
     P                 B                   export
      *
     D f_replace...
     D                 PI          4096A          varying
     D  i_searchArg                4096A   const  varying
     D  i_rplString                4096A   const  varying
     D  i_string                   4096A   const  varying
     D  i_startPos                   10U 0 const  options(*nopass)
      *
      *  Return value
     D string          S           4096A   varying   inz
      *
      *  Parameter positions
     D p_startPos      C                   const(4)
      *
      *  Standardwerte für nicht übergebene Parameter
     D startPos        S                   like(i_startPos) inz
      *
      *  Local fields
     D X               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   %parms >= p_startPos;
            startPos = i_startPos;
         else;
            startPos = 1;
         endif;

         string = i_string;

         x = %scan(i_searchArg: string: startPos);
         dow   x > 0;
            string = %replace(i_rplString: string: x: %len(i_searchArg));
            x = x + %len(i_rplString);
            if   x <= %len(string);
               x = %scan(i_searchArg: string: x);
            else;
               leave;
            endif;
         enddo;

         return   string;

      /END-FREE
      *
     P f_replace...
     P                 E
      *
      *=========================================================================
      *  Returns the EBCDIC value of a given character.
      *=========================================================================
      *  Parameters:
      *   i_char        - The fill char to return the EBCDIC value of.
      *
      *  Returns:
      *   ebcdic        - The EBCDIC value of i_char.
      *=========================================================================
      *
     P f_ebcdic...
     P                 B                   export
      *
     D f_ebcdic...
     D                 PI             3U 0
     D  i_char                        1A   const   options(*nopass)
      *
      *  Return value
     D ebcdic          DS                  qualified
     D  char                   1      1A
     D  integer                1      1U 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         ebcdic.char = i_char;

         return   ebcdic.integer;

      /END-FREE
      *
     P f_ebcdic...
     P                 E
      *
      *=========================================================================
      *  Returns the numeric value of a string.
      *=========================================================================
      *  Parameters:
      *   i_string      - A string representing a numeric value.
      *   i_decPoint    - The decimal point symbol.
      *   i_comma       - The comma symbol.
      *   i_curSym      - The currency symbol.
      *
      *  Returns:
      *   value         - The numeric value of i_string.
      *=========================================================================
      *
     P f_val...
     P                 B                   export
      *
     D f_val...
     D                 PI             8F
     D  i_string                     64A   const  varying
     D  i_decPoint                    1A   const  options(*nopass)
     D  i_comma                       1A   const  options(*nopass)
     D  i_curSym                      1A   const  options(*nopass)
      *
      *  Return value
     D value           S              8F   inz
      *
      *  Parameter positions
     D p_decPoint      C                   const(2)
     D p_comma         C                   const(3)
     D p_curSym        C                   const(4)
      *
      *  Optional parameter fields
     D mask            DS                  qualified
     d  curSym                        1A   inz
     D  comma                         1A   inz
     D  decPoint                      1A   inz
      *
      *  Helper fields to determine the decimal point and comma
     D refVal          C                   const(1000,5)
     D refStr          S              7A   inz      static
     D dft_comma       S              1A   inz      static
     D dft_decPoint    S              1A   inz      static
     D dft_curSym      S              1A   inz      static
      *
      *  Helper fields:
      *  Result data structure
     D                 ds
     D result                        30s 9 inz(0)
     D resultAsString                30a   overlay(result)
      *
      *  The parts of the result
     D digits          s             30a   varying inz('')
     D fraction        s             30a   varying inz('')
     D isFraction      S               N   inz(cFalse)
      *
      *  Helper fields
     D is1NumDigit     S               N   inz(cFalse)
     D stringLen       S             10I 0 inz
     D x               S             10I 0 inz
     D c1              S              1A   inz
     D c2              S              2A   inz
     D sign            S              1A   inz
     D digit1Pos       S             10I 0 inz
     D fract1Pos       S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Determine comma and decimal point
         if   refStr = '';
            refStr = %editc(refVal: '1');
            dft_comma    = %subst(refStr: 2: 1) ;
            dft_decPoint = %subst(refStr: 6: 1) ;
            dft_curSym   = '$';
         endif;

         // Process optional parameter values ...
         // ... decimal point
         if  %parms >= p_decPoint;
            mask.decPoint = i_decPoint;
         else;
            mask.decPoint = dft_decPoint;
         endif;

         // ... comma
         if  %parms >= p_comma;
            mask.comma = i_comma;
         else;
            mask.comma = dft_comma;
         endif;

         // ... currency symbol
         if  %parms >= p_curSym;
            mask.curSym = i_curSym;
         else;
            mask.curSym = dft_curSym;
         endif;


         // Initialize
         is1NumDigit = cFalse;
         isFraction  = cFalse;
         digits      = '';
         fraction    = '';
         stringLen   = %len(%trimr(i_string));

         // Spin through input data
         for x = 1 to stringLen;

            // get character of current position
            c1 = %subst(i_string: x: 1);

            // get possible CR sign
            if   x < stringLen;
               c2 = %subst(i_string: x: 2);
               c2 = %xlate('cr':'CR': c2);
            else;
               c2 = '';
            endif;

            select;
            // Ignore BLANKS and currency symbol
            when   (c1 = '') or (c1 = mask.curSym);
               // if we did not yet got a numeric character
               if   not is1NumDigit;
                  // ... then ignore BLANKS and currency symbol
                  iter;
               else;
                  // ... else cancel processing
                  leave;
               endif;

            // Ignore decimal point
            when   (c1 = mask.decPoint);
               is1NumDigit = cTrue;
               iter;

            // Switch do decimal positions
            when   (c1 = mask.comma);
               // If we did not yet got decimal positions, ...
               if   not isFraction;
                  // ... then switch to decimal positions
                  isFraction  = cTrue;
                  is1NumDigit = cTrue;
                  iter;
               else;
                  // cancel processing
                  leave;
               endif;

            // Remember sign '+'/'-', leading or trailing
            when   (c1 = '+')  or (c1 = '-');
               // if we did not yet hit the sign
               if   sign = '';
                  // ... then remember the sign
                  sign        = c1;
                  is1NumDigit = cTrue;
                  iter;
               else;
                  // ... else cancel processing
                  leave;
               endif;

            // Remember sign 'CR', always trailing
            when   c2 = 'CR';
               // if we did not yet hit the sign and if
               // we already got a numeric digit
               if   (sign = '') and is1NumDigit;
                  // ... then remember the sign
                  sign      = '-';
                  x         = x + 1;
                  iter;
               else;
                  // ... else cancel processing
                  leave;
               endif;

            // Process digits
            when   (c1 >= '0') and (c1 <= '9');
               // If we did switched to decimal positions, ...
               if   isFraction;
                  // ... then add digit to decimal portion
                  fraction = fraction + c1;
               else;
                  // ... else add digit to integer portion
                  if   (digits = ' ') and (c1 = '0');
                     // ignore '0'
                  else;
                     digits = digits + c1;
                  endif;
               endif;

               is1NumDigit = cTrue;
               iter;

            // invalid characters
            other;
               // cancel processing
               leave;
            endsl;

         endfor;

         // Strip trailling *BLANKS and '0' of decimal portion
         %len(fraction) = %checkr('0 ': fraction);

         // Make sure that the fraction does not exceed the limit
         p_assert(%decpos(result) >= %len(fraction):
                  'Numeric value contains too many fraction digits');

         // Make sure that we did not get to many digits
         p_assert((%len(result) - %decpos(result)) >= %len(digits):
                  'Number of significant digits allowed exceeded');

         // Put the result together
         fract1Pos = %len(result) - %decpos(result) + 1;
         digit1Pos = fract1Pos - %len(digits);

         %subst(resultAsString: digit1Pos: %len(digits  )) = digits;
         %subst(resultAsString: fract1Pos: %len(fraction)) = fraction;

         // Finally set the sign accordingly
         if   sign = '-';
            value = result * -1;
         else;
            value = result;
         endif;

         return   value;

      /END-FREE
      *
     P f_val...
     P                 E
      *
      *=========================================================================
      *  Performs word wrapping on a given string.
      *  Returns the next line of i_string with each call to f_wordWrap().
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to be word wrapped.
      *   i_width       - Line length.
      *   io_startPos   - The position to start from.
      *                   (Should not be changed between calls.)
      *   i_option      - Options to set.
      *                   Default:        cWORDWRAP_PARAGRAPH_NONE +
      *                                   cWORDWRAP_PARAGRAPH_TRIMR
      *                   cWORDWRAP_PARAGRAPH_NONE   Do not respect
      *                                              end-of-paragraph markers.
      *                   cWORDWRAP_PARAGRAPH_MSGD   Respect end-of-paragraph
      *                                              markers of message descriptions:
      *                                              &N, &B and &P.
      *                   cWORDWRAP_PARAGRAPH_TEXT   Respect standard text
      *                                              end-of-paragraph markers: \n
      *                   cWORDWRAP_PARAGRAPH_TRIMR  Remove trailing blanks from
      *                                              result string.
      *
      *  Returns:
      *   text          - The next line of i_string.
      *=========================================================================
      *
     P f_wordWrap...
     P                 B                   export
      *
     D f_wordWrap...
     D                 PI          4096A          varying
     D  i_string                   4096A   const  varying
     D  i_width                      10U 0 const
     D  io_startPos                  10U 0
     D  i_options                    10U 0 const  options(*nopass)
      *
      *  Return value
     D text            S           4096A   inz    varying
      *
      *  Parameter positions
     D p_options       C                   const(4)
      *
      *  Optional parameter fields
     D options         S                   like(i_options) inz
      *
      *  Local fields
     D theEOP          DS                  qualified
     D  isFound                        N   inz(cFalse)
     D  position                     10I 0
     D  string                        2A   varying
     D x               S             10I 0                     inz
     D tmpEOP          S              2A   varying             inz
     D numEOP          S             10I 0                     inz
     D EOP             S                   like(tmpEOP) dim(3) inz
     D ESC             S              1A
     D startPos        S                   like(io_startPos  ) inz
     D string          S                   like(i_string     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_width >= 1:
                  'i_width is out of range. It must be greater than 0');

         p_assert(io_startPos >= 1 and io_startPos <= %len(i_string):
                  'io_startPos is out of range. It must be greater than 0 -
                   and less than the length of i_string');

         // Process optional parameter values ...
         // ... options
         if %parms >= p_options;
            options = i_options;
         else;
            options = cWORDWRAP_PARAGRAPH_NONE +
                      cWORDWRAP_PARAGRAPH_TRIMR;
         endif;

         // TRIM trailing blanks
         string = %trimR(i_string);

         // Determine how to treat end-of-paragraph markers:
         select;
         // ... do not respect end-of-paragraph marker
         when f_isBitOn(cWORDWRAP_PARAGRAPH_NONE: options);
            clear EOP;
            clear ESC;
            numEOP = 0;
         // ... respect end-of-paragraph marker of message descriptions: &N, &P, &B
         when f_isBitOn(cWORDWRAP_PARAGRAPH_MSGD: options);
            clear EOP;
            EOP(1) = '&N';
            EOP(2) = '&P';
            EOP(3) = '&B';
            ESC    = '&';
            numEOP = 3;
         // ... respect end-of-paragraph marker of text: \n
         when f_isBitOn(cWORDWRAP_PARAGRAPH_TEXT: options);
            clear EOP;
            EOP(1) = '\N';
            ESC    = '\';
            numEOP = 1;
         endsl;

         // ---------------------------------------------------
         //  Perform word-wrap with no respect to
         //  end-of-paragraph markers.
         // ---------------------------------------------------
         if numEOP = 0;
            text = lf_wordWrap(string: i_width: io_startPos);
         else;
         // ---------------------------------------------------
         //  Perform word-wrap with respect to
         //  end-of-paragraph markers.
         // ---------------------------------------------------

            // Find next end-of-paragraph marker
            reset theEOP;
            theEOP.isFound = cFalse;
            theEOP.position = %scan(ESC: string: io_startPos);
            dow not theEOP.isFound and theEOP.position > 0;
               // If there is an escape character, ...
               if %subst(string: theEOP.position: 1) = ESC;
                  // ... then check it against the list of EOP marker
                  for x = 1 to numEOP;
                     // If there is enough space for a EOP after the escape character
                     // and if it is a known EOP, ...
                     if theEOP.position <= %len(string) - %len(EOP(x)) + 1;
                        tmpEOP = %subst(string: theEOP.position: %len(EOP(x)));
                        if f_ucase(tmpEOP) = f_ucase(EOP(x));
                           // ... then set flag "EOP found"
                           theEOP.string  = EOP(x);
                           theEOP.isFound = cTrue;
                           leave;
                        endif;
                     endif;
                  endfor;
               endif;

               if (not theEOP.isFound);
                  if (theEOP.position < %len(string));
                     theEOP.position = %scan(ESC: string: theEOP.position + 1);
                  else;
                     theEOP.position = 0;
                  endif;
               endif;
            enddo;

            // If no end-of-paragraph marker is found, ...
            if not theEOP.isFound;
               // ... then perform standard word wrap with no respect to EOP
               text = lf_wordWrap(string: i_width: io_startPos);
            else;
               // ... else perform word wrap for text portion
               //     before end-of-paragraph marker
               if (theEOP.position - io_startPos) > 0;
                  string   = %subst(string: io_startPos:
                                    theEOP.position - io_startPos);
                  startPos = 1;
                  text = lf_wordWrap(string: i_width: startPos);
               else;
                  text = '';
               endif;

               // If all we got is a EOP, ...
               if (%len(text)    = %len(theEOP.string)   ) and
                  (f_ucase(text) = f_ucase(theEOP.string));
                  // ... then delete it
                  text = '';
               endif;
               // Set new start position. Skip EOP if EOP
               // caused new line.
               io_startPos = io_startPos + %len(text);
               if theEOP.position = io_startPos;
                  io_startPos = io_startPos + %len(theEOP.string);
               endif;
               // Set start position to 0 if new start position
               // exceeds maximum length of text.
               if io_startPos > %len(i_string);
                  io_startPos = 0;
               endif;
            endif;

         endif;

         // If the user requested to remove BLANKS, ...
         if f_isBitOn(cWORDWRAP_PARAGRAPH_TRIMR: options);
            // ... then remove BLANKS.
            text = %trimR(text);
         endif;

         return   text;

      /END-FREE
      *
     P f_wordWrap...
     P                 E
      *
      *=========================================================================
      *  Performs word wrapping on a given string without respect to
      *  end-of-paragraph markers.
      *=========================================================================
      *
     P lf_wordWrap...
     P                 B
      *
     D lf_wordWrap...
     D                 PI          4096A          varying
     D  i_string                   4096A   const  varying
     D  i_width                      10U 0 const
     D  io_startPos                  10U 0
      *
      *  Return value
     D text            S           4096A   inz    varying
      *
      *  Local fields
     D sPos            S             10I 0 inz
     D ePos            S             10I 0 inz
     D ePosConst       S             10I 0 inz
     D length          S             10I 0 inz
     D char            S              1A   inz
     D x               S             10I 0 inz
      *
      *  Valid separater characters
     D cDELIMITER      C                   const(' -/\.:')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialise helper fields
         text   = '';
         sPos   = io_startPos;
         ePos   = 0;
         length = 0;

         // Set range
         ePos      = sPos + i_width;
         ePosConst = ePos;

         // If the end position is out of range ...
         if   ePos > %len(i_string);
         // ... then
         //     assume the last character to be the delimiter
            ePos = %len(i_string);
         else;
         // ... else
         //     look backwards for a deliniter.
            dow   ePos >= sPos;
               char = %subst(i_string: ePos: 1);
               // At position width + 1 ...
               if   ePos = ePosConst;
               // ... only BLANKS are allowed
                  x = %check(' ': char);
               else;
               // ... else every delimiter is allowed
                  x = %check(cDELIMITER: char);
               endif;
               // If there is a delimiter, ...
               if   x = 0;
               // ... then stop searching
                  leave;
               endif;

               ePos = ePos - 1;
            enddo;
         endif;

         // If there is no delimiter, ...
         if   ePos < sPos;
         // ... then assume the last character to be the delimiter.
            ePos = sPos + i_width - 1;
         endif;

         // Retrieve text (incl. delimiter) ...
         length = ePos - sPos + 1;
         text = %subst(i_string: sPos: length);

         // ... and set new start position.
         sPos = sPos + length;
         if sPos <= %len(i_string);
            io_startPos = %check(' ': i_string: sPos);
         else;
            io_startPos = 0;
         endif;

         return   text;

      /END-FREE
      *
     P lf_wordWrap...
     P                 E
      *
      *=========================================================================
      *  Transforms a numeric from its internal format to a
      *  character form suitable for displaying.
      *=========================================================================
      *  Parameters:
      *   i_pBuffer     - Address of the internal form of the numeric value.
      *   i_digits      - Number of digits of the numeric value.
      *   i_decPos      - Number of decimal positions of the numeric value.
      *   i_varType     - Type of the numeric value.
      *   i_editCode    - Edit code used for translating the numeric value
      *                   to a character string.
      *
      *  Returns:
      *   fmtString     - Formatted string.
      *=========================================================================
      *
     P f_editCode...
     P                 B                   export
      *
     D f_editCode...
     D                 PI            64A          varying
     D  i_pBuffer                      *   const
     D  i_digits                     10I 0 const
     D  i_decPos                     10I 0 const
     D  i_varType                    10A   const
     D  i_editCode                    2A   const
      *
      *  Return value
     D fmtString       S             64A   varying  inz
      *
      *  Local fields
     D editCode        S                   like(i_editCode)   inz
     D isEditCode_X    S               N   inz(cFalse)
     D buffer          S             64A   based(i_pBuffer)
     D editMask        S            256A   inz
     D editMaskLen     S             10I 0 inz
     D rcvVar          S             64A   inz
     D rcvVarLen       S             10I 0 inz
     D zeroBalanceFillChar...
     D                 S              1A   inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------
      /FREE

         editCode = i_editCode;

         // Check whether edit code 'X' was specified or not.
         if %subst(editCode: 1: 1) = 'X';
            isEditCode_X = cTrue;
            %subst(editCode: 1: 1) = 'Z';
         else;
            isEditCode_X = cFalse;
         endif;

         // Produce edit mask for the given edit code
         errCode = f_newApiErrCode(cFalse);

         QECCVTEC(editMask               :
                  editMaskLen            :
                  rcvVarLen              :
                  zeroBalanceFillChar    :
                  %subst(editCode: 1: 1) :
                  %subst(editCode: 2: 1) :
                  i_digits               :
                  i_decPos               :
                  errCode                );

         // Translate the numeric value to a character string
         QECEDT(rcvVar                                      :
                rcvVarLen                                   :
                buffer                                      :
                lf_cvtRpgVarTypeToEdtAPIVarClass(i_varType) :
                i_digits                                    :
                editMask                                    :
                editMaskLen                                 :
                zeroBalanceFillChar                         :
                errCode                                     );

         // Set return value
         fmtString = %subst(rcvVar: 1: rcvVarLen);

         // Replace blanks with '0' if edit code 'X' was requested
         if isEditCode_X;
            fmtString = %xlate(' ': '0': fmtString);
         endif;

         return fmtString;

      /END-FREE
      *
     P f_editCode...
     P                 E
      *
      *=========================================================================
      *  Transforms a numeric from its internal format to a
      *  character form suitable for displaying.
      *=========================================================================
      *  Parameters:
      *   i_pBuffer     - Address of the internal form of the numeric value.
      *   i_digits      - Number of digits of the numeric value.
      *   i_varType     - Type of the numeric value.
      *   i_editWord    - Edit word used for translating the numeric value
      *                   to a character string.
      *
      *  Returns:
      *   fmtString     - Formatted string.
      *=========================================================================
      *
     P f_editWord...
     P                 B                   export
      *
     D f_editWord...
     D                 PI           512A          varying
     D  i_pBuffer                      *   const
     D  i_digits                     10I 0 const
     D  i_varType                    10A   const
     D  i_editWord                  256A   const  varying
      *
      *  Return value
     D fmtString       S            512A   varying  inz
      *
      *  Local fields
     D buffer          S             64A   based(i_pBuffer)
     D editMask        S            256A   inz
     D editMaskLen     S             10I 0 inz
     D rcvVar          S            512A   inz
     D rcvVarLen       S             10I 0 inz
     D zeroBalanceFillChar...
     D                 S              1A   inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------
      /FREE

         errCode = f_newApiErrCode(cFalse);

         // Produce edit mask for the given edit mask
         QECCVTEW(editMask         :
                  editMaskLen      :
                  rcvVarLen        :
                  i_editWord       :
                  %len(i_editWord) :
                  errCode          );

         // Translate the numeric value to a character string
         QECEDT(rcvVar                                      :
                rcvVarLen                                   :
                buffer                                      :
                lf_cvtRpgVarTypeToEdtAPIVarClass(i_varType) :
                i_digits                                    :
                editMask                                    :
                editMaskLen                                 :
                X'00'                                       :
                errCode                                     );

         // Set return value
         fmtString = %subst(rcvVar: 1: rcvVarLen);

         return fmtString;

      /END-FREE
      *
     P f_editWord...
     P                 E
      *
      *=========================================================================
      *  Gets the length of a the formatted string of a given edit code.
      *=========================================================================
      *  Parameters:
      *   i_digits      - Number of digits of the numeric value.
      *   i_decPos      - Number of decimal positions of the numeric value.
      *   i_editCode    - Edit code used for translating the numeric value
      *                   to a character string.
      *
      *  Returns:
      *   length        - Length of the formatted string.
      *=========================================================================
      *
     P f_getLengthEditCode...
     P                 B                   export
      *
     D f_getLengthEditCode...
     D                 PI             5U 0
     D  i_digits                     10I 0 const
     D  i_decPos                     10I 0 const
     D  i_editCode                    2A   const
      *
      *  Return value
     D length          S              5U 0 inz
      *
      *  Local fields
     D buffZoned       S            128A   inz(*ALLx'F0')
     D fmtString       S             64A   inz    varying
      *-------------------------------------------------------------------
      /FREE

         fmtString = f_editCode(%addr(buffZoned):
                                i_digits: i_decpos: 'S': i_editCode);

         length = %len(fmtString);

         return length;

      /END-FREE
      *
     P f_getLengthEditCode...
     P                 E
      *
      *=========================================================================
      *  Gets the length of a the formatted string of a given edit word.
      *=========================================================================
      *  Parameters:
      *   i_digits      - Number of digits of the numeric value.
      *   i_editWord    - Edit word used for translating the numeric value
      *                   to a character string.
      *
      *  Returns:
      *   length        - Length of the formatted string.
      *=========================================================================
      *
     P f_getLengthEditWord...
     P                 B                   export
      *
     D f_getLengthEditWord...
     D                 PI             5U 0
     D  i_digits                     10I 0 const
     D  i_editWord                  256A   const  varying
      *
      *  Return value
     D length          S              5U 0 inz
      *
      *  Local fields
     D buffZoned       S            128A   inz(*ALLx'F0')
     D fmtString       S            512A   inz    varying
      *-------------------------------------------------------------------
      /FREE

         fmtString = f_editWord(%addr(buffZoned): i_digits: 'S': i_editWord);

         length = %len(fmtString);

         return length;

      /END-FREE
      *
     P f_getLengthEditWord...
     P                 E
      *
      *=========================================================================
      *  Removes a keyword from a given string.
      *=========================================================================
      *  Parameters:
      *   i_keyword     - The keyword to remove from the string.
      *   i_string      - The given string.
      *
      *  Returns:
      *   string        - The string without the keyword.
      *
      *  Comment:
      *   i_string must start with the keyword with no leading spaces.
      *   Otherwise the keyword is not removed from i_string.
      *=========================================================================
      *
     P f_rmvKeyword...
     P                 B                   export
      *
     D f_rmvKeyword...
     D                 PI          4096A           varying
     D  i_keyword                   128A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Return value
     D string          S           4096A   varying  inz
      *
      *  Local fields
      *-------------------------------------------------------------------
      /FREE

         // If the keyword is there ...
         if f_left(i_string: %len(i_keyword)) = i_keyword;

            // If the string is longer than the keyword ...
            if %len(i_string) > %len(i_keyword) + %len(cOPEN_PARENTHESIS )
 B02                                            + %len(cCLOSE_PARENTHESIS);

               // ... strip the keyword from the string
               string = %subst(i_string: %len(i_keyword) + 1);

               // remove opening parenthesis
               if f_left(string: 1) = cOPEN_PARENTHESIS;
                  string = %subst(string: %len(cOPEN_PARENTHESIS) + 1);
               endif;

               // remove closing parenthesis
               if f_right(string: 1) = cCLOSE_PARENTHESIS;
                  string = f_left(string: %len(string) -
                                          %len(cCLOSE_PARENTHESIS));
               endif;
            else;

               // ... clear the string
               string = '';
            endif;

         else;
            // ... return the string unchanged
            string = i_string;
         endif;

         return string;

      /END-FREE
      *
     P f_rmvKeyword...
     P                 E
      *
      *=========================================================================
      *  Removes quotes from a given string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The given string.
      *   i_quote       - The quote to be removed from the string.
      *
      *  Returns:
      *   string        - The string without quotes.
      *=========================================================================
      *
     P f_rmvQuotes...
     P                 B                   export
      *
     D f_rmvQuotes...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_quote                       1A   const
      *
      *  Return value
     D string          S           4096A   varying  inz
      *
      *  Local fields
      *-------------------------------------------------------------------
      /FREE

         string = i_string;

         if %len(string) >= 2;

            // If it is a quoted string ...
            if (f_left(string:  1) = i_quote) and
               (f_right(string: 1) = i_quote);

               if %len(string) = 2;
                  string = '';
               else;
                  // ... remove leading quote
                  string = %subst(string: 2);

                  // ... remove trailing quote
                  string = f_left(string: %len(string) - 1);

                  // ... turn 2 immediately following quotes into a quote
                  string = f_replace(i_quote + i_quote: i_quote: string);
               endif;

            endif;

         endif;

         return string;

      /END-FREE
      *
     P f_rmvQuotes...
     P                 E
      *
      *=========================================================================
      *  Adds quotes to a given string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The given string.
      *   i_quote       - The quote to be added to the string.
      *
      *  Returns:
      *   string        - The string with quotes.
      *=========================================================================
      *
     P f_addQuotes...
     P                 B                   export
      *
     D f_addQuotes...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_quote                       1A   const   options(*nopass)
      *
      *  Return value
     D string          S           4096A   varying  inz
      *
      *  Parameter positions
     D p_quote         C                   const(2)
      *
      *  Optional parameter fields
     D quote           S                   like(i_quote) inz
      *
      *  Local fields
      *-------------------------------------------------------------------
      /FREE

         if (%parms() >= p_quote);
            quote = i_quote;
         else;
            quote = cSINGLE_QUOTE;
         endif;

         string = i_string;

         // double single quotes
         string = f_replace(quote: quote + quote: string);

         // add leading quote
         string = quote + string;

         // add trailing quote
         string = string + quote;

         return string;

      /END-FREE
      *
     P f_addQuotes...
     P                 E
      *
      *=========================================================================
    R *  *** PRIVATE ***
      *  Converts a RPG variable type to a variable class of the edit APIs.
      *=========================================================================
      *
     P lf_cvtRpgVarTypeToEdtAPIVarClass...
     P                 B
      *
     D lf_cvtRpgVarTypeToEdtAPIVarClass...
     D                 PI            10A
     D  i_varType                     1A   const
      *
      *  Return value
     D varClass        S             10A   inz
      *
      *  Local constants
     D cZONED          C                   const('*ZONED')
     D cPACKED         C                   const('*PACKED')
     D cBINARY         C                   const('*BINARY')
     D cINTEGER        C                   const('*BINARY')
      *-------------------------------------------------------------------
      /FREE

         // Convert RPG type ...
         select;
         // ... zoned
         when i_varType = 'S';
            varClass = cZONED;
         // ... packed
         when i_varType = 'P';
            varClass = cPACKED;
         // ... binary
         when i_varType = 'B';
            varClass = cBINARY;
         // ... integer
         when i_varType = 'I';
            varClass = cINTEGER;
         endsl;

         return varClass;

      /END-FREE
      *
     P lf_cvtRpgVarTypeToEdtAPIVarClass...
     P                 E
      *
      *=========================================================================
      *  Centers a string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to be centered.
      *   i_length      - The length of the target field.
      *
      *  Returns:
      *   string        - The centered string.
      *=========================================================================
      *
     P f_center...
     P                 B                   export
      *
     D f_center...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_length                     10U 0 const   options(*nopass)
      *
      *  Return value
     D centeredString  S           4096A   varying   inz
      *
      *  Parameter positions
     D p_length        C                   const(2)
      *
      *  Fields for not passed parameters
     D length          S                   like(i_length  ) inz
      *
      *  Local fields
     D spaces          S             10I 0 inz
     D string          S           4096A   varying   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   %parms >= p_length;
            length = i_length;
         else;
            length = %len(i_string);
         endif;

         string = %trim(i_string);
         spaces = %int((length - %len(string)) / 2);

         if spaces < 0;
            centeredString = f_left(string: length);
         else;
            %len(centeredString) = length;
            centeredString = %replace(string: centeredString:
                                      spaces + 1: %len(string));
         endif;

         return   centeredString;

      /END-FREE
      *
     P f_center...
     P                 E
      *
      *=========================================================================
      *  Right aligns a string.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to be right aligned.
      *   i_length      - The length of the target field.
      *
      *  Returns:
      *   string        - The right aligned string.
      *=========================================================================
      *
     P f_alignR...
     P                 B                   export
      *
     D f_alignR...
     D                 PI          4096A           varying
     D  i_string                   4096A   const   varying
     D  i_length                     10U 0 const   options(*nopass)
      *
      *  Return value
     D alignedString   S           4096A   varying   inz
      *
      *  Parameter positions
     D p_length        C                   const(2)
      *
      *  Fields for not passed parameters
     D length          S                   like(i_length  ) inz
      *
      *  Local fields
     D spaces          S             10I 0 inz
     D string          S           4096A   varying   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   %parms >= p_length;
            length = i_length;
         else;
            length = %len(i_string);
         endif;

         string = %trim(i_string);
         spaces = length - %len(%trim(i_string));

         if spaces < 0;
            alignedString = f_right(%trimR(i_string): length);
         else;
            %len(alignedString) = length;
            alignedString = %replace(string: alignedString:
                                     spaces + 1: %len(string));
         endif;

         return   alignedString;

      /END-FREE
      *
     P f_alignR...
     P                 E
      *
      *=========================================================================
      *  Compare strings using wildcard characters. (Compare generic)
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to be compared with i_mask.
      *   i_pattern     - Mask. Optionally containing wildcard characters.
      *   i_wildcard    - Wildcard characters:
      *                   Position 1-1: Ignore group of characters. Default: *
      *                   Position 2-2: Ignore single character.    Default: ?
      *
      *  Returns:
      *   isEqual       - Returns cTrue when the strings are equal.
      *=========================================================================
     P f_genStrCmp...
     P                 B                   export
     D                 PI              N
     D  i_string                   4096A   const   varying
     D  i_pattern                  4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%len(i_pattern) = 0);
            return cEQUAL_TRUE;
         endif;

         // Call generic string compare procedure
         if (%parms() >= %parmNum(i_wildcard));
            return lf_genStrCmpInternal(i_string: i_pattern: i_wildcard);
         else;
            return lf_genStrCmpInternal(i_string: i_pattern);
         endif;

      /END-FREE
      *
     P f_genStrCmp...
     P                 E
      *
      *=========================================================================
      *  Compare strings using wildcard characters. (Compare generic)
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to be compared with i_mask.
      *   i_mask        - Mask. Optionally containing wildcard characters.
      *   i_wildcard    - Wildcard characters:
      *                   Position 1-1: Ignore group of characters. Default: *
      *                   Position 2-2: Ignore single character.    Default: ?
      *
      *  Returns:
      *   isEqual       - Returns cTrue when the strings are equal.
      *=========================================================================
     P f_genStrCmpIgnCase...
     P                 B                   export
     D                 PI              N
     D  i_string                   4096A   const   varying
     D  i_mask                     4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      *
      *  Return value
     D isEqual         S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_wildcard      C                   const(3)
      *
      *  Fields for optional parameters
      *
      *  Local fields
     D string          S                   like(i_string) inz
     D mask            S                   like(i_mask  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Convert everything to lower case
         mask   = f_lcase(i_mask);
         string = f_lcase(i_string);

         // Call generic string compare procedure
         if (%parms() >= %parmNum(i_wildcard));
            isEqual = f_genStrCmp(string: mask: i_wildcard);
         else;
            isEqual = f_genStrCmp(string: mask);
         endif;

         return isEqual;

      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Compare strings using wildcard characters. (Compare generic)
      *=========================================================================
     P lf_genStrCmpInternal...
     P                 B
     D                 PI              N
     D  i_string                   4096A   const   varying
     D  i_pattern                  4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      *
      *  Parameter positions
     D p_wildcard      C                   const(3)
      *
      *  Fields for optional parameters
     D wildcard        DS                  qualified
     D  group                         1A   inz
     D  single                        1A   inz
      *
      *  Local fields
     D string          S                   like(i_string)
     D pattern         S                   like(i_pattern)
      *
     D genStrCmp       S              1A   inz
     D strPos          S             10U 0 inz
     D maskPos         S             10U 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Process optional parameter values ...
         // ... wildcard
         if (%parms() >= p_wildcard and %addr(i_wildcard) <> *NULL);
            wildcard = i_wildcard;
         else;
            wildcard.group  = '*';   // Ignore group of characters
            wildcard.single = '?';   // Ignore single character
         endif;

         string = i_string;
         pattern = i_pattern;

         if (%len(pattern) = %len(string) and pattern = string);
            return cEQUAL_TRUE;
         elseif (%len(string) = 0);
            if (%check(wildcard.group: pattern) = 0);
               return cEQUAL_TRUE;
            else;
               return cEQUAL_FALSE;
            endif;
         elseif (%len(pattern) = 0);
            if (%len(string) = 0);
               return cEQUAL_TRUE;
            else;
               return cEQUAL_FALSE;
            endif;
         elseif (pattern = wildcard.group);
            return cEQUAL_TRUE;
         elseif (f_startsWith(wildcard.single: pattern)); // ?
            return lf_genStrCmpInternal(f_mid(string: 2)
                                        : f_mid(pattern: 2)
                                        : wildcard);
         elseif (f_endsWith(wildcard.single: pattern));   // ?
            return lf_genStrCmpInternal(%subst(string: 1: %len(string) - 1)
                                        : %subst(pattern: 1: %len(pattern) - 1)
                                        : wildcard);
         elseif (f_startsWith(wildcard.group: pattern));  // *
            if (lf_genStrCmpInternal(string
                                     : f_mid(pattern: 2)
                                     : wildcard));
               return cEQUAL_TRUE;
            else;
               return lf_genStrCmpInternal(f_mid(string: 2)
                                           : pattern
                                           : wildcard);
            endif;
         elseif (f_endsWith(wildcard.group: pattern));    // *
            if (lf_genStrCmpInternal(string
                                     : %subst(pattern: 1: %len(pattern) - 1)
                                     : wildcard));
               return cEQUAL_TRUE;
            else;
               return lf_genStrCmpInternal(%subst(string: 1: %len(string) - 1)
                                  : pattern
                                  : wildcard);
            endif;
         elseif (%subst(pattern: 1: 1) = %subst(string: 1: 1));
               return lf_genStrCmpInternal(f_mid(string: 2)
                                           : f_mid(pattern: 2)
                                           : wildcard);
         endif;

         return cEQUAL_FALSE;

      /END-FREE
     P                 E
      *
      *=========================================================================
      *  Returns the last position of a search argument in the source string.
      *=========================================================================
      *  Parameters:
      *   i_searchArg   - The search argument that is searched in for.
      *   i_string      - The source string.
      *   i_start       - Start position.
      *
      *  Returns:
      *   position      - Returns the start position of the search argument in
      *                   source string on success, else 0.
      *=========================================================================
      *
     P f_scanR...
     P                 B                   export
      *
     D f_scanR...
     D                 PI             5I 0
     D  i_searchArg                4096A   const   varying
     D  i_string                   4096A   const   varying
     D  i_start                       5I 0 const   options(*nopass)
      *
      *  Return value
     D position        S              5I 0 inz
      *
      *  Parameter positions
     D p_start         C                   const(3)
      *
      *  Fields for optional parameters
     D start           S                   like(i_start ) inz
      *
      *  Local fields
     D x               S                   like(i_start ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   %parms >= p_start;
            start = i_start;
         else;
            start = %len(i_string);
         endif;

         if %len(i_searchArg) > start;
            position = 0;
         else;
            x = start - %len(i_searchArg) + 1;
            dou (position > 0) or (x = 0);
               if %subst(i_string: x: %len(i_searchArg)) = i_searchArg;
                  position = x;
               endif;
               x = x - 1;
            enddo;
         endif;

         return   position;

      /END-FREE
      *
     P f_scanR...
     P                 E
      *
      *=========================================================================
      *  Converts a given buffer to a character string of hex values.
      *=========================================================================
      *  Parameters:
      *   i_pBuffer     - Pointer to a buffer containing bytes.
      *   i_size        - Size of buffer.
      *
      *  Returns:
      *   string        - Returns the character string of hex values
      *                   of i_buffer.
      *
      *  Sample:
      *     When i_pBuffer points to a variable that contains 'Hello World',
      *     then string is set to 'C88593939640E696999384'.
      *=========================================================================
      *
     P f_cvtBufferToHexString...
     P                 B                   export
      *
     D f_cvtBufferToHexString...
     D                 PI          4096A           varying
     D  i_pBuffer                      *   const
     D  i_size                        5U 0 const
      *
      *  Return value (as varying field)
     D                 DS
     D string                      4096    varying
     D  str_length                    5U 0 overlay(string)
     D  str_data                   4096A   overlay(string: *next)
      *
      *  Reference field
     D string_t        S           4096A   varying based(pDummy)
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert((i_size * 2) <= %size(str_data):
                  'Length of i_buffer exceeded maximum length allowed.');

         p_assert(%size(string) = %size(string_t):
                  'Incorrect definition of structure ''string''.');

         cvthc(%addr(str_data): i_pBuffer: i_size * 2);
         str_length = i_size * 2;

         return   string;

      /END-FREE
      *
     P f_cvtBufferToHexString...
     P                 E
      *
      *=========================================================================
      *  Converts a given pointer to a character string of hex values.
      *=========================================================================
      *  Parameters:
      *   i_pointer     - Pointer that is converted to its string representation.
      *
      *  Returns:
      *   string        - Returns the character string of hex values
      *                   of i_pointer.
      *=========================================================================
      *
     P f_cvtPtrToHexString...
     P                 B                   export
      *
     D f_cvtPtrToHexString...
     D                 PI            32A           varying
     D  i_pointer                      *   value
      *
      *  Return value
     D string          S             32A   varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = f_cvtBufferToHexString(%addr(i_pointer): %size(i_pointer));

         return string;

      /END-FREE
      *
     P f_cvtPtrToHexString...
     P                 E
      *
      *=========================================================================
      *  Converts a given character string of hex values to a buffer.
      *=========================================================================
      *  Parameters:
      *   i_string      - Character string of hex values.
      *
      *  Returns:
      *   size          - Returns the size of the bytes sequence
      *                   represented by i_string.
      *
      *  Sample:
      *     When i_string contains 'C88593939640E696999384', then buffer
      *     is set to 'Hello World'.
      *=========================================================================
      *
     P f_cvtHexStringToBuffer...
     P                 B                   export
      *
     D f_cvtHexStringToBuffer...
     D                 PI             5U 0 opdesc
     D  i_string                   4096A   const   options(*varsize)
     D  i_pBuffer                      *   const
     D  i_size                        5U 0 const
      *
      *  Return value
     D size            S              5U 0 inz
      *
      *  Parameter positions
     D p_string        C                   const(1)
      *
      *  Local fields
     D string          S                   like(i_string    ) inz
     D strInf          DS                  likeds(strInf_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         CEEGSI(p_string: strInf.datatype: strInf.curlen: strInf.maxlen: *omit);

         p_assert((strInf.curlen / 2) <= i_size:
                  'Length of i_buffer exceeded maximum length allowed.');

         string = %subst(i_string: 1: strInf.curlen);
         cvtch(i_pBuffer: %addr(string): strInf.curlen);
         size   = strInf.curlen / 2;

         if size < i_size;
            memset(i_pBuffer + size: x'00': i_size - size);
         endif;

         return   size;

      /END-FREE
      *
     P f_cvtHexStringToBuffer...
     P                 E
      *
      *=========================================================================
      *  Tests, if a given string contains an invalid character
      *  at a given position.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to test.
      *   i_pos         - The position that specifies the character
      *                   to be tested.
      *   i_chars       - List of valid characters.
      *
      *  Returns:
      *   isValid       - Returns cTrue, if the character at the specified
      *                   position is valid, else cFalse.
      *=========================================================================
     P f_containsInvalidCharAt...
     P                 B                   export
      *
     D f_containsInvalidCharAt...
     D                 PI              N
     D  i_string                   4096A   const  varying options(*varsize)
     D  i_pos                        10I 0 const
     D  i_chars                     256A   const  varying options(*varsize)
      *
      *  Return value
     D isInvalid       S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_pos <= %len(i_string):
                  'i_pos is out of range. It must be less than or equal to ' +
                  %editc(%len(i_string): 'N'));

         if %check(%subst(i_chars: 1: %len(i_chars))
                   : %subst(i_string: i_pos: 1)) <> 0;
            isInvalid = cTrue;
         else;
            isInvalid = cFalse;
         endif;

         return isInvalid;

      /END-FREE
      *
     P f_containsInvalidCharAt...
     P                 E
      *
      *=========================================================================
      *  Tests, if a given string contains a specific string
      *  at a given position.
      *=========================================================================
      *  Parameters:
      *   i_string      - The string to test.
      *   i_pos         - The position that specifies the start position
      *                   of the embedded sub string.
      *   i_subString   - The sub string.
      *
      *  Returns:
      *   isAvailable   - Returns cTrue, if the sub string is found at the
      *                   specified position, else cFalse.
      *=========================================================================
     P f_containsStringAt...
     P                 B                   export
      *
     D f_containsStringAt...
     D                 PI              N
     D  i_string                   4096A   const  varying options(*varsize)
     D  i_pos                        10I 0 const
     D  i_subString                4096A   const  varying options(*varsize)
      *
      *  Return value
     D isAvailable     S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_pos + %len(i_subString)) <= %len(i_string);
            if %subst(i_string: i_pos: %len(i_subString)) =
                  %subst(i_subString: 1: %len(i_subString));
               isAvailable = cTrue;
            else;
               isAvailable = cFalse;
            endif;
         else;
            isAvailable = cFalse;
         endif;

         return isAvailable;

      /END-FREE
      *
     P f_containsStringAt...
     P                 E
      *
      *=========================================================================
      *  Returns the string representation of a qualified object name.
      *=========================================================================
      *  Parameters:
      *   i_qObj        - Qualified object name.
      *   i_lib         - Name of the library that contains the object
      *                   specified at i_qObj. If i_lib is used i_qObj
      *                   behaves like a 10 byte name field that contains
      *                   the name of the object only.
      *
      *  Returns:
      *   strObjName    - The string represenation of the qualified object name.
      *=========================================================================
     P f_objName...
     P                 B                   export
      *
     D f_objName...
     D                 PI            21A          varying
     D  i_qObj                             const  likeds(qObj_t   )
     D  i_lib                        10A   const  options(*nopass)
      *
      *  Return value
     D strObjName      S             21A   varying inz
      *
      *  Parameter positions
     D p_lib           C                   const(2)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_lib);
            strObjName = %trimR(i_lib) + '/' + %trimR(i_qObj);
         else;
            strObjName = %trimR(i_qObj.lib) + '/' + %trimR(i_qObj.name);
         endif;

         return strObjName;

      /END-FREE
      *
     P f_objName...
     P                 E
      *
      *=========================================================================
      *  Replaces unprintable characters in a given string.
      *=========================================================================
      *  Parameters:
      *   i_string      - String that may contain unprintable characters.
      *   i_rplChar     - Substitution character that replaces the
      *                   unprintable characters.
      *
      *  Returns:
      *   string        - String without any unprintable characters.
      *=========================================================================
     P f_rplUnPrtChars...
     P                 B                   export
      *
     D f_rplUnPrtChars...
     D                 PI          4096A          varying
     D  i_string                   4096A   const  varying
     D  i_rplChar                     1A   const  varying options(*nopass)
      *
      *  Return value
     D string          S           4096A   varying inz
      *
      *  Parameter positions
     D p_rplChar       C                   const(2)
      *
      *  Optional parameter fields
     D rplChar         S                   like(i_rplChar ) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_rplChar);
            rplChar = i_rplChar;
         else;
            rplChar = ' ';
         endif;

         string = '';

         for x = 1 to %len(i_string);
            if (%subst(i_string: x: 1) < x'40' or
                %subst(i_string: x: 1) = x'FF');
               if (%len(rplChar) > 0);
                  string = string + rplChar;
               endif;
            else;
               string = string + %subst(i_string: x: 1);
            endif;
         endfor;

         return string;

      /END-FREE
      *
     P f_rplUnPrtChars...
     P                 E
      *
      *=========================================================================
      *  Formats a given date according to a given picture string.
      *=========================================================================
      *  Parameters:
      *   i_date        - Date to be formatted.
      *   i_pic_str     - Picture string representing the desired format.
      *
      *  Returns:
      *   string        - Formatted date string.
      *=========================================================================
     P f_formatDate...
     P                 B                   export
      *
     D f_formatDate...
     D                 PI           128A          varying
     D  i_date                         D   const
     D  i_pic_str                   128A   const  varying
      *
      *  Return value
     D string          S            128A   inz
      *
      *  Local constants
     D cDATE_ISO       C                   'YYYYMMDD'
      *
      *  Helper fields
     D tmpDate         S             10A   inz
     D tmpLilianDate   S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         tmpDate = %char(i_date: *ISO0);
         CEEDAYS(tmpDate: cDATE_ISO: tmpLilianDate: *omit);
         CEEDATE(tmpLilianDate: i_pic_str: string: *omit);

         return %trimR(string);

      /END-FREE
      *
     P f_formatDate...
     P                 E
      *
      *=========================================================================
      *  Parses a string representing a date.
      *=========================================================================
      *  Parameters:
      *   i_string      - String representing a date.
      *   i_pic_str     - Picture string describing the date string.
      *
      *  Returns:
      *   date          - Date.
      *=========================================================================
     P f_parseDate...
     P                 B                   export
      *
     D f_parseDate...
     D                 PI              D
     D  i_string                    128A   const  varying
     D  i_pic_str                   128A   const  varying options(*nopass)
      *
      *  Return value
     D date            S               D   inz
      *
      *  Local constants
     D cDATE_ISO       C                   'YYYYMMDD'
      *
      *  Helper fields
     D tmpDate         S             10A   inz
     D tmpLilianDate   S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         CEEDAYS(i_string: i_pic_str: tmpLilianDate: *omit);
         CEEDATE(tmpLilianDate: cDATE_ISO: tmpDate: *omit);
         date = %date(tmpDate: *ISO0);

         return date;

      /END-FREE
      *
     P f_parseDate...
     P                 E
      *
      *=========================================================================
      *  Converts a given memory size in bytes to string.
      *=========================================================================
      *  Parameters:
      *   i_memSize     - Memory size in bytes that is converted to string.
      *   io_unit       - Input:  Desired unit of the formatted memory size.
      *                   Output: Unit of the formatted memory size.
      *                   Default (input ): best fit = ''
      *                   cMEM_SIZE_BYTE
      *                   cMEM_SIZE_KILO_BYTE
      *                   cMEM_SIZE_MEGA_BYTE
      *                   cMEM_SIZE_GIGA_BYTE
      *                   cMEM_SIZE_TERA_BYTE
      *                   cMEM_SIZE_PETA_BYTE
      *                   cMEM_SIZE_EXA_BYTE
      *                   cMEM_SIZE_TETTA_BYTE
      *   i_decPos      - Number of decimal positions.
      *                   Default: 2
      *
      *  Returns:
      *   string        - Formatted memory size string.
      *=========================================================================
     P f_formatMemSize...
     P                 B                   export
      *
     D f_formatMemSize...
     D                 PI           128A          varying
     D  i_memSize                    20I 0 const
     D  io_unit                       2A          options(*nopass: *omit)
     D  i_decPos                      3I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D string          S            128A   varying inz
      *
      *  Parameter positions
     D p_unit          C                   2
     D p_decPos        C                   3
      *
      *  Optional parameter fields
     D unit            S                   like(io_unit ) inz
     D decPos          S                   like(i_decPos) inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D x               S             10I 0 inz
     D i               S             10I 0 inz
     D p               S             10I 0 inz
      *
     D                 DS
     D memSize                 1     29S 7 inz
     D memSize6                1     28S 6
     D memSize5                1     27S 5
     D memSize4                1     26S 4
     D memSize3                1     25S 3
     D memSize2                1     24S 2
     D memSize1                1     23S 1
      *
      *  Static status fields
     D isInit          S               N   inz(cFalse)
     D isUnit          S               N   inz(cFalse)
     D units           S              2A   varying dim(8)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not isInit);
            units(1) = cMEM_SIZE_BYTE;        //                                   1 Byte
            units(2) = cMEM_SIZE_KILO_BYTE;   //                               1.000 Byte
            units(3) = cMEM_SIZE_MEGA_BYTE;   //                           1.000.000 Byte
            units(4) = cMEM_SIZE_GIGA_BYTE;   //                       1.000.000.000 Byte
            units(5) = cMEM_SIZE_TERA_BYTE;   //                   1.000.000.000.000 Byte
            units(6) = cMEM_SIZE_PETA_BYTE;   //               1.000.000.000.000.000 Byte
            units(7) = cMEM_SIZE_EXA_BYTE;    //           1.000.000.000.000.000.000 Byte
            units(8) = cMEM_SIZE_ZETTA_BYTE;  //       1.000.000.000.000.000.000.000 Byte
            isInit = cTrue;
         endif;

         // Get values of optional parameters
         // ... unit
         if (%parms() >= p_unit);
            CEETSTA(isPresent: p_unit: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            unit = %trim(io_unit);
            isUnit = cTrue;
         else;
            unit = '';
            isUnit = cFalse;
         endif;

         // ... decPos
         if (%parms() >= p_decPos);
            CEETSTA(isPresent: p_decPos: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            decPos = i_decPos;
         else;
            decPos = 2;
         endif;

         p_assert(decPos >= 0 and decPos <= %decPos(memSize)
                  : 'Number of decimal positions out of range 1 to ' +
                     %char(decPos));

         // Determine index of desired unit
         x = %lookup(f_ucase(unit): units);

         // Divide memory size down to smallest possible value (unit)
         i = 1;
         memSize = i_memSize;
         dow (memSize >= 1024 and (x <> i or x = 0));
            i = i + 1;
            eval(H) memSize = memSize / 1024;
         enddo;

         // Divide memory size down to requested unit
         // (number of bytes is less than 1024)
         dow (i < x);
            i = i + 1;
            eval(H) memSize = memSize / 1024;
         enddo;

         select;
         when (decPos = 1);
            eval(H) memSize1 = memSize;
         when (decPos = 2);
            eval(H) memSize2 = memSize;
         when (decPos = 3);
            eval(H) memSize3 = memSize;
         when (decPos = 4);
            eval(H) memSize4 = memSize;
         when (decPos = 5);
            eval(H) memSize5 = memSize;
         when (decPos = 6);
            eval(H) memSize6 = memSize;
         endsl;

         string = %editc(memSize: 'N');
         string = f_left(string: %len(string) - %decPos(memSize) + decPos);

         if (isUnit);
            io_unit = units(i);
         endif;

         return string;

      /END-FREE
      *
     P f_formatMemSize...
     P                 E
      *
