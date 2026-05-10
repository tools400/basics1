**free
/if NOT DEFINED(BASICS1C7)
/define BASICS1C7

//  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
dcl-pr get_crc_table pointer extproc('get_crc_table');
end-pr;

//  Returns a table of CRC-32's of all single-byte values (made by make_crc_table)
dcl-pr crc32 like(uLong_t) extproc('crc32');
  i_crc     like(uLong_t) value;
  i_pBuffer pointer value;
  i_length  like(uInt_t) value;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,CLIB                         C-Library

/endif