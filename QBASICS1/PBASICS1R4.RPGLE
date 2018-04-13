      /IF NOT DEFINED(BASICS1R4)
      /DEFINE BASICS1R4
      *
      *  RPG equivalent of the C Assert macro.
     D p_assert...
     D                 PR
     D                                     extproc('BASICS1R4+
     D                                     _p_assert+
     D                                     ')
     D  i_condition                    N   const
     D  i_msgText                   128A   const  options(*nopass)
      *
      *  Returns the procedure, module and program name
      *  of the current procedure.
     D f_this...
     D                 PR           256A          varying
     D                                     extproc('BASICS1R4+
     D                                     _f_this+
     D                                     ')
     D  o_module                     10A          options(*nopass: *omit)
     D  o_program                    10A          options(*nopass: *omit)
     D  o_stmtID                     10A          options(*nopass: *omit)
      *
      *  Returns the procedure, module and program name
      *  that called the current procedure.
     D f_caller...
     D                 PR           256A          varying
     D                                     extproc('BASICS1R4+
     D                                     _f_caller+
     D                                     ')
     D  o_module                     10A          options(*nopass: *omit)
     D  o_program                    10A          options(*nopass: *omit)
     D  o_stmtID                     10A          options(*nopass: *omit)
     D  i_offset                      3I 0 const  options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      /COPY QBASICS1,PBASICS1R5                   Objects
      *
      /ENDIF
