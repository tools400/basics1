**free
/if NOT DEFINED(BASICS1R2)
/define BASICS1R2

//  Reference fields
/copy QBASICS1,FDERRCODE

//  Creates a new API error code.
dcl-pr f_newApiErrCode likeds(errCode_t) extproc('BASICS1R2_f_newApiErrCode');
  i_monMsg ind options(*nopass) const;
end-pr;

//  Is API error?
dcl-pr f_isApiError ind extproc('BASICS1R2_f_isApiError');
  i_errCode likeds(errCode_t) const;
end-pr;

//  Converts an API error code to a messsage.
dcl-pr f_cvtApiErrCodeToMsg like(msg_t) extproc('BASICS1R2_f_cvtApiErrCodeToMsg');
  i_errCode likeds(errCode_t) const;
end-pr;

//  Returns the C runtime error number.
dcl-pr f_errno int(10) extproc('BASICS1R2_f_errno');
end-pr;

//  Sets the C runtime error number to ZERO (no error).
dcl-pr f_clrErrno extproc('BASICS1R2_f_clrErrno');
end-pr;

//  Sets the C runtime error number to a given error code.
dcl-pr f_setErrno extproc('BASICS1R2_f_setErrno');
  i_errno int(10) const;
end-pr;

//  Returns the message text of a C runtime error number.
dcl-pr f_strerror varchar(128) extproc('BASICS1R2_f_strerror');
  i_errno int(10) const;
end-pr;

//  Converts a C runtime error number to a message.
dcl-pr f_cvtErrnoToMsg like(msg_t) extproc('BASICS1R2_f_cvtErrnoToMsg');
  i_errno int(10) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R1                   Messages

/endif