**FREE
/IF NOT DEFINED(BASICS1R4)
/DEFINE BASICS1R4

//  RPG equivalent of the C Assert macro.
dcl-pr p_assert
       extproc('BASICS1R4+
       _p_assert+
       ');
  i_condition     ind const;
  i_msgText       char(128) const  options(*nopass);
end-pr;

//  Returns the procedure, module and program name
//  of the current procedure.
dcl-pr f_this
       varchar(256)
       extproc('BASICS1R4+
       _f_this+
       ');
  o_module        char(10) options(*nopass: *omit);
  o_program       char(10) options(*nopass: *omit);
  o_stmtID        char(10) options(*nopass: *omit);
end-pr;

//  Returns the procedure, module and program name
//  that called the current procedure.
dcl-pr f_caller
       varchar(256)
       extproc('BASICS1R4+
       _f_caller+
       ');
  o_module        char(10) options(*nopass: *omit);
  o_program       char(10) options(*nopass: *omit);
  o_stmtID        char(10) options(*nopass: *omit);
  i_offset        int(3) const  options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R2                   API Error Handling
/COPY QBASICS1,PBASICS1R5                   Objects

/ENDIF
