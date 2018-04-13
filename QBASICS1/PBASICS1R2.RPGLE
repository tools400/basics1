      /IF NOT DEFINED(BASICS1R2)
      /DEFINE BASICS1R2
      *
      *  Reference fields
      /COPY QBASICS1,FDERRCODE
      *
      *  Creates a new API error code.
     D f_newApiErrCode...
     D                 PR                         likeds(errCode_t )
     D                                     extproc('BASICS1R2+
     D                                     _f_newApiErrCode+
     D                                     ')
     D  i_monMsg                       N   const  options(*nopass)
      *
      *  Is API error?
     D f_isApiError...
     D                 PR              N
     D                                     extproc('BASICS1R2+
     D                                     _f_isApiError+
     D                                     ')
     D  i_errCode                          const  likeds(errCode_t )
      *
      *  Converts an API error code to a messsage.
     D f_cvtApiErrCodeToMsg...
     D                 PR                         like(msg_t     )
     D                                     extproc('BASICS1R2+
     D                                     _f_cvtApiErrCodeToMsg+
     D                                     ')
     D  i_errCode                          const  likeds(errCode_t )
      *
      *  Returns the C runtime error number.
     D f_errno...
     D                 PR            10I 0
     D                                     extproc('BASICS1R2+
     D                                     _f_errno+
     D                                     ')
      *
      *  Sets the C runtime error number to ZERO (no error).
     D f_clrErrno...
     D                 PR
     D                                     extproc('BASICS1R2+
     D                                     _f_clrErrno+
     D                                     ')
      *
      *  Sets the C runtime error number to a given error code.
     D f_setErrno...
     D                 PR
     D                                     extproc('BASICS1R2+
     D                                     _f_setErrno+
     D                                     ')
     D  i_errno                      10I 0 const
      *
      *  Returns the message text of a C runtime error number.
     D f_strerror...
     D                 PR           128A          varying
     D                                     extproc('BASICS1R2+
     D                                     _f_strerror+
     D                                     ')
     D  i_errno                      10I 0 const
      *
      *  Converts a C runtime error number to a message.
     D f_cvtErrnoToMsg...
     D                 PR                         like(msg_t     )
     D                                     extproc('BASICS1R2+
     D                                     _f_cvtErrnoToMsg+
     D                                     ')
     D  i_errno                      10I 0 const
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R1                   Messages
      *
      /ENDIF
