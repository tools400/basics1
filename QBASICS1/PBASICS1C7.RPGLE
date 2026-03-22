**FREE
/IF NOT DEFINED(BASICS1C7)
/DEFINE BASICS1C7

//  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
dcl-pr get_crc_table
       pointer
       extproc('get_crc_table');
end-pr;

//  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
dcl-pr crc32
       like(uLong_t)
       extproc('crc32');
  i_crc           value  like(uLong_t);
  i_pBuffer       pointer value;
  i_length        value  like(uInt_t );
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,CLIB                         C-Library

/ENDIF
