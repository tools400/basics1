      /IF NOT DEFINED(BASICS1RF)
      /DEFINE BASICS1RF
      *
      *  Retrieves an alpha-numeric system value.
     D f_rtvSysVal_char...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1RF+
     D                                     _f_rtvSysVal_char+
     D                                     ')
     D  i_name                       10A   const
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves a numeric system value.
     D f_rtvSysVal_num...
     D                 PR            15P 5
     D                                     extproc('BASICS1RF+
     D                                     _f_rtvSysVal_num+
     D                                     ')
     D  i_name                       10A   const
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      /ENDIF
