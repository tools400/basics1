      /IF NOT DEFINED(BASICS1C7)
      /DEFINE BASICS1C7
      *
      *  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
     D get_crc_table...
     D                 PR              *
     D                                     extproc('get_crc_table')
      *
      *  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
     D crc32...
     D                 PR                         like(uLong_t)
     D                                     extproc('crc32')
     D  i_crc                              value  like(uLong_t)
     D  i_pBuffer                      *   value
     D  i_length                           value  like(uInt_t )
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,CLIB                         C-Library
      *
      /ENDIF
