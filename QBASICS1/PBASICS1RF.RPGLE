**FREE
/IF NOT DEFINED(BASICS1RF)
/DEFINE BASICS1RF

//  Retrieves an alpha-numeric system value.
dcl-pr f_rtvSysVal_char
       varchar(4096)
       extproc('BASICS1RF+
       _f_rtvSysVal_char+
       ');
  i_name          char(10) const;
  o_msg           likeds(msg_t )
options(*nopass: *omit);
end-pr;

//  Retrieves a numeric system value.
dcl-pr f_rtvSysVal_num
       packed(15:5)
       extproc('BASICS1RF+
       _f_rtvSysVal_num+
       ');
  i_name          char(10) const;
  o_msg           likeds(msg_t )
options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/ENDIF
