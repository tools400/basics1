      /IF NOT DEFINED(BASICS1R3)
      /DEFINE BASICS1R3
      *
      *  Reference fields
      *
      *  Konstants: f_wordWrap()
     D cWORDWRAP_PARAGRAPH_NONE...
     D                 C                   const(1)
     D cWORDWRAP_PARAGRAPH_MSGD...
     D                 C                   const(2)
     D cWORDWRAP_PARAGRAPH_TEXT...
     D                 C                   const(4)
     D cWORDWRAP_PARAGRAPH_TRIMR...
     D                 C                   const(8)
      *
      *  Returns the left portion of a string.
     D f_left...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_left+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_length                     10I 0 const
      *
      *  Returns the sub string that starts at a given position.
     D f_mid...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_mid+
     D                                     ')
     D  i_string                   4096A   const   varying
     D                                             options(*varsize)
     D  i_start                      10I 0 const
     D  i_length                     10I 0 const   options(*nopass: *omit)
      *
      *  Tests if the specified string starts with the specified prefix.
     D f_startsWith...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_startsWith+
     D                                     ')
     D  i_prefix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Tests if the specified string starts with the specified prefix,
      *  ignoring case considerations.
     D f_startsWithIgnoreCase...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_startsWithIgnoreCase+
     D                                     ')
     D  i_prefix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Returns the right portion of a string.
     D f_right...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_right+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_length                     10I 0 const
      *
      *  Tests if the specified string ends with the specified suffix.
     D f_endsWith...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_endsWith+
     D                                     ')
     D  i_suffix                   4096A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Produces an empty string.
     D f_space...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_space+
     D                                     ')
     D  i_length                     10I 0 const
     D  i_char                        1A   const   options(*nopass)
      *
      *  Converts a given string to lower case.
     D f_lcase...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_lcase+
     D                                     ')
     D  i_string                   4096A   const   varying
      *
      *  Converts a given string to upper case.
     D f_ucase...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_ucase+
     D                                     ')
     D  i_string                   4096A   const   varying
      *
      *  Replaces all occurences of a search argument by
      *  a replacement string in a given string.
     D f_replace...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_replace+
     D                                     ')
     D  i_searchArg                4096A   const  varying
     D  i_rplString                4096A   const  varying
     D  i_string                   4096A   const  varying
     D  i_startPos                   10U 0 const  options(*nopass)
      *
      *  Returns the EBCDIC value of a given character.
     D f_ebcdic...
     D                 PR             3U 0
     D                                     extproc('BASICS1R3+
     D                                     _f_ebcdic+
     D                                     ')
     D  i_char                        1A   const   options(*nopass)
      *
      *  Returns the numeric value of a string.
     D f_val...
     D                 PR             8F
     D                                     extproc('BASICS1R3+
     D                                     _f_val+
     D                                     ')
     D  i_string                     64A   const  varying
     D  i_decPoint                    1A   const  options(*nopass)
     D  i_comma                       1A   const  options(*nopass)
     D  i_currSym                     1A   const  options(*nopass)
      *
      *  Performs word wrapping on a given string.
      *  Returns the next line of i_string with each call to f_wordWrap().
     D f_wordWrap...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_wordWrap+
     D                                     ')
     D  i_string                   4096A   const  varying
     D  i_width                      10U 0 const
     D  io_startPos                  10U 0
     D  i_options                    10U 0 const  options(*nopass)
      *
      *  Transforms a numeric from its internal format to a
      *  character form suitable for displaying.
     D f_editCode...
     D                 PR            64A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_editCode+
     D                                     ')
     D  i_pBuffer                      *   const
     D  i_digits                     10I 0 const
     D  i_decPos                     10I 0 const
     D  i_varClass                   10A   const
     D  i_editCode                    2A   const
      *
      *  Transforms a numeric from its internal format to a
      *  character form suitable for displaying.
     D f_editWord...
     D                 PR           512A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_editWord+
     D                                     ')
     D  i_pBuffer                      *   const
     D  i_digits                     10I 0 const
     D  i_varClass                   10A   const
     D  i_editWord                  256A   const  varying
      *
      *  Gets the length of a the formatted string of a given edit code.
     D f_getLengthEditCode...
     D                 PR             5U 0
     D                                     extproc('BASICS1R3+
     D                                     _f_getLengthEditCode+
     D                                     ')
     D  i_digits                     10I 0 const
     D  i_decPos                     10I 0 const
     D  i_editCode                    2A   const
      *
      *  Gets the length of a the formatted string of a given edit word.
     D f_getLengthEditWord...
     D                 PR             5U 0
     D                                     extproc('BASICS1R3+
     D                                     _f_getLengthEditWord+
     D                                     ')
     D  i_digits                     10I 0 const
     D  i_editWord                  256A   const  varying
      *
      *  Removes a keyword from a given string.
     D f_rmvKeyword...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_rmvKeyword+
     D                                     ')
     D  i_keyword                   128A   const   varying
     D  i_string                   4096A   const   varying
      *
      *  Removes quotes from a given string.
     D f_rmvQuotes...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_rmvQuotes+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_quote                       1A   const
      *
      *  Adds quotes to a given string.
     D f_addQuotes...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_addQuotes+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_quote                       1A   const   options(*nopass)
      *
      *  Centers a string.
     D f_center...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_center+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_length                     10U 0 const   options(*nopass)
      *
      *  Right aligns a string.
     D f_alignR...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_alignR+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_length                     10U 0 const   options(*nopass)
      *
      *  Compare strings using wildcard characters. (Compare generic)
     D f_genStrCmp...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_genStrCmp+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_mask                     4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      *
      *  Compare strings using wildcard characters.
     D f_genStrCmpIgnCase...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_genStrCmpIgnCase+
     D                                     ')
     D  i_string                   4096A   const   varying
     D  i_mask                     4096A   const   varying
     D  i_wildcard                    2A   const   options(*nopass)
      *
      *  Returns the last position of a search argument in the source string.
     D f_scanR...
     D                 PR             5I 0
     D                                     extproc('BASICS1R3+
     D                                     _f_scanR+
     D                                     ')
     D  i_searchArg                4096A   const   varying
     D  i_string                   4096A   const   varying
     D  i_start                       5I 0 const   options(*nopass)
      *
      *  Converts a given buffer to a character string of hex values.
     D f_cvtBufferToHexString...
     D                 PR          4096A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_cvtBufferToHexString+
     D                                     ')
     D  i_pBuffer                      *   const
     D  i_size                        5U 0 const
      *
      *  Converts a given pointer to a character string of hex values.
     D f_cvtPtrToHexString...
     D                 PR            32A           varying
     D                                     extproc('BASICS1R3+
     D                                     _f_cvtPtrToHexString+
     D                                     ')
     D  i_pointer                      *   value
      *
      *  Converts a given character string of hex values to a buffer.
     D f_cvtHexStringToBuffer...
     D                 PR             5U 0 opdesc
     D                                     extproc('BASICS1R3+
     D                                     _f_cvtHexStringToBuffer+
     D                                     ')
     D  i_string                   4096A   const   options(*varsize)
     D  i_pBuffer                      *   const
     D  i_size                        5U 0 const
      *
      *  Tests, if a given string contains an invalid character
      *  at a given position.
     D f_containsInvalidCharAt...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_containsInvalidCharAt+
     D                                     ')
     D  i_string                   4096A   const  varying options(*varsize)
     D  i_pos                        10I 0 const
     D  i_chars                     256A   const  varying options(*varsize)
      *
      *  Tests, if a given string contains a specific string
      *  at a given position.
     D f_containsStringAt...
     D                 PR              N
     D                                     extproc('BASICS1R3+
     D                                     _f_containsStringAt+
     D                                     ')
     D  i_string                   4096A   const  varying options(*varsize)
     D  i_pos                        10I 0 const
     D  i_subString                4096A   const  varying options(*varsize)
      *
      *  Returns the string representation of a qualified object name.
     D f_objName...
     D                 PR            21A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_objName+
     D                                     ')
     D  i_qObj                             const  likeds(qObj_t   )
     D  i_lib                        10A   const  options(*nopass)
      *
      *  Replaces unprintable characters in a given string.
     D f_rplUnPrtChars...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_rplUnPrtChars+
     D                                     ')
     D  i_string                   4096A   const  varying
     D  i_rplChar                     1A   const  varying options(*nopass)
      *
      *  Formats a given date according to a given puicture string.
     D f_formatDate...
     D                 PR           128A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_formatDate+
     D                                     ')
     D  i_date                         D   const
     D  i_picture                   128A   const  varying
      *
      *  Parses a string representing a date.
     D f_parseDate...
     D                 PR              D
     D                                     extproc('BASICS1R3+
     D                                     _f_parseDate+
     D                                     ')
     D  i_string                    128A   const  varying
     D  i_picture                   128A   const  varying options(*nopass)
      *
      *  Konstants: f_formatMemSize
     D cMEM_SIZE_BYTE...
     D                 C                   'B'
     D cMEM_SIZE_KILO_BYTE...
     D                 C                   'KB'
     D cMEM_SIZE_MEGA_BYTE...
     D                 C                   'MB'
     D cMEM_SIZE_GIGA_BYTE...
     D                 C                   'GB'
     D cMEM_SIZE_TERA_BYTE...
     D                 C                   'TB'
     D cMEM_SIZE_PETA_BYTE...
     D                 C                   'PB'
     D cMEM_SIZE_EXA_BYTE...
     D                 C                   'EB'
     D cMEM_SIZE_ZETTA_BYTE...
     D                 C                   'ZB'
      *
      *  Converts a given memory size in bytes to string.
     D f_formatMemSize...
     D                 PR           128A          varying
     D                                     extproc('BASICS1R3+
     D                                     _f_formatMemSize+
     D                                     ')
     D  i_memSize                    20I 0 const
     D  io_unit                       2A          options(*nopass: *omit)
     D  i_decPos                      3I 0 const  options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      /COPY QBASICS1,PBASICS1R4                   Assert/This/Caller
      /COPY QBASICS1,PBASICS1R7                   Mathematics
      *
      /ENDIF
