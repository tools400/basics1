**free
/if NOT DEFINED(BASICS1R3)
/define BASICS1R3

//  Reference fields

//  Konstants: f_wordWrap()
dcl-c cWORDWRAP_PARAGRAPH_NONE 1;
dcl-c cWORDWRAP_PARAGRAPH_MSGD 2;
dcl-c cWORDWRAP_PARAGRAPH_TEXT 4;
dcl-c cWORDWRAP_PARAGRAPH_TRIMR 8;

//  Returns the left portion of a string.
dcl-pr f_left varchar(4096) extproc('BASICS1R3_f_left');
  i_string varchar(4096) const;
  i_length int(10) const;
end-pr;

//  Returns the sub string that starts at a given position.
dcl-pr f_mid varchar(4096) extproc('BASICS1R3_f_mid');
  i_string varchar(4096) options(*varsize) const;
  i_start  int(10) const;
  i_length int(10) options(*nopass: *omit) const;
end-pr;

//  Tests if the specified string starts with the specified prefix.
dcl-pr f_startsWith ind extproc('BASICS1R3_f_startsWith');
  i_prefix varchar(4096) const;
  i_string varchar(4096) const;
end-pr;

//  Tests if the specified string starts with the specified prefix,
//  ignoring case considerations.
dcl-pr f_startsWithIgnoreCase ind extproc('BASICS1R3_f_startsWithIgnoreCase');
  i_prefix varchar(4096) const;
  i_string varchar(4096) const;
end-pr;

//  Returns the right portion of a string.
dcl-pr f_right varchar(4096) extproc('BASICS1R3_f_right');
  i_string varchar(4096) const;
  i_length int(10) const;
end-pr;

//  Tests if the specified string ends with the specified suffix.
dcl-pr f_endsWith ind extproc('BASICS1R3_f_endsWith');
  i_suffix varchar(4096) const;
  i_string varchar(4096) const;
end-pr;

//  Produces an empty string.
dcl-pr f_space varchar(4096) extproc('BASICS1R3_f_space');
  i_length int(10) const;
  i_char   char(1) options(*nopass) const;
end-pr;

//  Converts a given string to lower case.
dcl-pr f_lcase varchar(4096) extproc('BASICS1R3_f_lcase');
  i_string varchar(4096) const;
end-pr;

//  Converts a given string to upper case.
dcl-pr f_ucase varchar(4096) extproc('BASICS1R3_f_ucase');
  i_string varchar(4096) const;
end-pr;

//  Replaces all occurences of a search argument by
//  a replacement string in a given string.
dcl-pr f_replace varchar(4096) extproc('BASICS1R3_f_replace');
  i_searchArg varchar(4096) const;
  i_rplString varchar(4096) const;
  i_string    varchar(4096) const;
  i_startPos  uns(10) options(*nopass) const;
end-pr;

//  Returns the EBCDIC value of a given character.
dcl-pr f_ebcdic uns(3) extproc('BASICS1R3_f_ebcdic');
  i_char char(1) options(*nopass) const;
end-pr;

//  Returns the numeric value of a string.
dcl-pr f_val float(8) extproc('BASICS1R3_f_val');
  i_string   varchar(64) const;
  i_decPoint char(1) options(*nopass) const;
  i_comma    char(1) options(*nopass) const;
  i_currSym  char(1) options(*nopass) const;
end-pr;

//  Performs word wrapping on a given string.
//  Returns the next line of i_string with each call to f_wordWrap().
dcl-pr f_wordWrap varchar(4096) extproc('BASICS1R3_f_wordWrap');
  i_string    varchar(4096) const;
  i_width     uns(10) const;
  io_startPos uns(10);
  i_options   uns(10) options(*nopass) const;
end-pr;

//  Transforms a numeric from its internal format to a
//  character form suitable for displaying.
dcl-pr f_editCode varchar(64) extproc('BASICS1R3_f_editCode');
  i_pBuffer  pointer const;
  i_digits   int(10) const;
  i_decPos   int(10) const;
  i_varClass char(10) const;
  i_editCode char(2) const;
end-pr;

//  Transforms a numeric from its internal format to a
//  character form suitable for displaying.
dcl-pr f_editWord varchar(512) extproc('BASICS1R3_f_editWord');
  i_pBuffer  pointer const;
  i_digits   int(10) const;
  i_varClass char(10) const;
  i_editWord varchar(256) const;
end-pr;

//  Gets the length of a the formatted string of a given edit code.
dcl-pr f_getLengthEditCode uns(5) extproc('BASICS1R3_f_getLengthEditCode');
  i_digits   int(10) const;
  i_decPos   int(10) const;
  i_editCode char(2) const;
end-pr;

//  Gets the length of a the formatted string of a given edit word.
dcl-pr f_getLengthEditWord uns(5) extproc('BASICS1R3_f_getLengthEditWord');
  i_digits   int(10) const;
  i_editWord varchar(256) const;
end-pr;

//  Removes a keyword from a given string.
dcl-pr f_rmvKeyword varchar(4096) extproc('BASICS1R3_f_rmvKeyword');
  i_keyword varchar(128) const;
  i_string  varchar(4096) const;
end-pr;

//  Removes quotes from a given string.
dcl-pr f_rmvQuotes varchar(4096) extproc('BASICS1R3_f_rmvQuotes');
  i_string varchar(4096) const;
  i_quote  char(1) const;
end-pr;

//  Adds quotes to a given string.
dcl-pr f_addQuotes varchar(4096) extproc('BASICS1R3_f_addQuotes');
  i_string varchar(4096) const;
  i_quote  char(1) options(*nopass) const;
end-pr;

//  Centers a string.
dcl-pr f_center varchar(4096) extproc('BASICS1R3_f_center');
  i_string varchar(4096) const;
  i_length uns(10) options(*nopass) const;
end-pr;

//  Right aligns a string.
dcl-pr f_alignR varchar(4096) extproc('BASICS1R3_f_alignR');
  i_string varchar(4096) const;
  i_length uns(10) options(*nopass) const;
end-pr;

//  Compare strings using wildcard characters. (Compare generic)
dcl-pr f_genStrCmp ind extproc('BASICS1R3_f_genStrCmp');
  i_string   varchar(4096) const;
  i_mask     varchar(4096) const;
  i_wildcard char(2) options(*nopass) const;
end-pr;

//  Compare strings using wildcard characters.
dcl-pr f_genStrCmpIgnCase ind extproc('BASICS1R3_f_genStrCmpIgnCase');
  i_string   varchar(4096) const;
  i_mask     varchar(4096) const;
  i_wildcard char(2) options(*nopass) const;
end-pr;

//  Returns the last position of a search argument in the source string.
dcl-pr f_scanR int(5) extproc('BASICS1R3_f_scanR');
  i_searchArg varchar(4096) const;
  i_string    varchar(4096) const;
  i_start     int(5) options(*nopass) const;
end-pr;

//  Converts a given buffer to a character string of hex values.
dcl-pr f_cvtBufferToHexString varchar(4096) extproc('BASICS1R3_f_cvtBufferToHexString');
  i_pBuffer pointer const;
  i_size    uns(5) const;
end-pr;

//  Converts a given pointer to a character string of hex values.
dcl-pr f_cvtPtrToHexString varchar(32) extproc('BASICS1R3_f_cvtPtrToHexString');
  i_pointer pointer value;
end-pr;

//  Converts a given character string of hex values to a buffer.
dcl-pr f_cvtHexStringToBuffer uns(5) opdesc extproc('BASICS1R3_f_cvtHexStringToBuffer');
  i_string  char(4096) options(*varsize) const;
  i_pBuffer pointer const;
  i_size    uns(5) const;
end-pr;

//  Tests, if a given string contains an invalid character
//  at a given position.
dcl-pr f_containsInvalidCharAt ind extproc('BASICS1R3_f_containsInvalidCharAt');
  i_string varchar(4096) options(*varsize) const;
  i_pos    int(10) const;
  i_chars  varchar(256) options(*varsize) const;
end-pr;

//  Tests, if a given string contains a specific string
//  at a given position.
dcl-pr f_containsStringAt ind extproc('BASICS1R3_f_containsStringAt');
  i_string    varchar(4096) options(*varsize) const;
  i_pos       int(10) const;
  i_subString varchar(4096) options(*varsize) const;
end-pr;

//  Returns the string representation of a qualified object name.
dcl-pr f_objName varchar(21) extproc('BASICS1R3_f_objName');
  i_qObj likeds(qObj_t) const;
  i_lib  char(10) options(*nopass) const;
end-pr;

//  Replaces unprintable characters in a given string.
dcl-pr f_rplUnPrtChars varchar(4096) extproc('BASICS1R3_f_rplUnPrtChars');
  i_string  varchar(4096) const;
  i_rplChar varchar(1) options(*nopass) const;
end-pr;

//  Formats a given date according to a given puicture string.
dcl-pr f_formatDate varchar(128) extproc('BASICS1R3_f_formatDate');
  i_date    date const;
  i_picture varchar(128) const;
end-pr;

//  Parses a string representing a date.
dcl-pr f_parseDate date extproc('BASICS1R3_f_parseDate');
  i_string  varchar(128) const;
  i_picture varchar(128) options(*nopass) const;
end-pr;

//  Konstants: f_formatMemSize
dcl-c cMEM_SIZE_BYTE 'B';
dcl-c cMEM_SIZE_KILO_BYTE 'KB';
dcl-c cMEM_SIZE_MEGA_BYTE 'MB';
dcl-c cMEM_SIZE_GIGA_BYTE 'GB';
dcl-c cMEM_SIZE_TERA_BYTE 'TB';
dcl-c cMEM_SIZE_PETA_BYTE 'PB';
dcl-c cMEM_SIZE_EXA_BYTE 'EB';
dcl-c cMEM_SIZE_ZETTA_BYTE 'ZB';

//  Converts a given memory size in bytes to string.
dcl-pr f_formatMemSize varchar(128) extproc('BASICS1R3_f_formatMemSize');
  i_memSize int(20) const;
  io_unit   char(2) options(*nopass: *omit);
  i_decPos  int(3) options(*nopass: *omit) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R2                   API Error Handling
/copy QBASICS1,PBASICS1R4                   Assert/This/Caller
/copy QBASICS1,PBASICS1R7                   Mathematics

/endif