**free
//=====================================================================*
//  BASICS1R2  - SrvPgm: Basic Routines - API Error Handling           *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  08.10.2003                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  08.02.2006  Th.Raddatz    Changed BASICS1R2 to be compatible to    *
//                            V5R1M0.                                  *
//                                                                     *
//  08.01.2007  Th.Raddatz    Fixed problem in f_cvtErrnoToMsg().      *
//                            Now errors without corresponding         *
//                            message description in QC2MSGF are       *
//                            returned as CPF9898 message.             *
//                                                                     *
//  12.12.2007  Th.Raddatz    Enhanced f_cvtApiErrCodeToMsg() to       *
//                            receive the original error message from  *
//                            the previous call stack entry, if        *
//                            possible.                                *
//                                                                     *
//  16.07.2011  Th.Raddatz    Added procedure f_setErrno().            *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt bnddir('QC2LE');
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1R2

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Global constants
// -----------------------------------------

//=========================================================================
//  Creates a new API error code.
//=========================================================================
//  Parameters:
//   i_monMsg      - Specifies whether API error conditions
//                   are monitored or not.
//                   Default:        cFalse
//
//  Returns:
//   errCode       - The new API error code.
//=========================================================================
dcl-proc f_newApiErrCode export;
  dcl-pi *n likeds(errCode_t);
    i_monMsg ind options(*nopass) const;
  end-pi;

  //  Return value
  dcl-ds errCode likeds(errCode_t) inz;

  //  Parameter positions
  dcl-c p_monMsg 1;

  //  Optional parameter fields
  dcl-s monMsg like(i_monMsg) inz;
  //-------------------------------------------------------------------*

  // Process optional parameter values ...
  // ... monitor messages
  if   %parms >= p_monMsg;
    monMsg = i_monMsg;
  else;
    monMsg = cFalse;
  endif;

  // Produce API error code ...
  clear   errCode;
  if   monMsg = cTrue;
    errCode.bytPrv = %size(errCode);
  else;
    errCode.bytPrv = 0;
  endif;

  return   errCode;


end-proc;

//=========================================================================
//  Is API error?
//=========================================================================
//  Parameters:
//   i_errCode     - The error code returned from the API call.
//
//  Returns:
//   isError       - Returns cTrue in case of an API error.
//=========================================================================
dcl-proc f_isApiError export;
  dcl-pi *n ind;
    i_errCode likeds(errCode_t) const;
  end-pi;

  //  Return value
  dcl-s isError ind inz;
  //-------------------------------------------------------------------*

  if   i_errCode.bytAvl > 0;
    isError = cTrue;
  else;
    isError = cFalse;
  endif;

  return   isError;


end-proc;

//=========================================================================
//  Converts an API error code to a messsage.
//=========================================================================
//  Parameters:
//   i_errCode     - The error code returned from the API call.
//
//  Returns:
//   msg           - The error message.
//=========================================================================
dcl-proc f_cvtApiErrCodeToMsg export;
  dcl-pi *n like(msg_t);
    i_errCode likeds(errCode_t) const;
  end-pi;

  //  Return value
  dcl-ds msg likeds(msg_t) inz;

  //  Helper fields
  dcl-ds tmpMsg likeds(msg_t) inz;
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
  //-------------------------------------------------------------------*

  if   i_errCode.bytAvl = 0;
    msg = f_newMsg(cMSG_ID_OK);
  else;
    msg = f_newMsg(i_errCode.excID: i_errCode.excDta: cMsg_Escape:
                   'QCPFMSG' : '*LIBL');
    // Try to get the user error message from the previous
    // call stack entry
    rcvm0200 = f_rcvPgmMsg(cMsg_Any: *omit: cMsg_Act_Same: 0: cMsg_Prv);
    tmpMsg = f_cvtRcvMsgToMsg(rcvm0200: cMsg_Escape);
    if (i_errCode.excID = tmpMsg.ID);
      msg = tmpMsg;
    endif;
  endif;

  return   msg;


end-proc;

//=========================================================================
//  Returns the C runtime error number.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   errno         - The C runtime error number.
//=========================================================================
dcl-proc f_errno export;
  dcl-pi *n int(10);
  end-pi;

  //  Return value
  dcl-s errorNo int(10) inz;

  //  Local fields
  dcl-s runTimeError int(10) based(pRunTimeError);
  //-------------------------------------------------------------------*

  pRunTimeError = errno();

  errorNo = runTimeError;

  return   errorNo;


end-proc;

//=========================================================================
//  Sets the C runtime error number to ZERO (no error).
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   void
//=========================================================================
dcl-proc f_clrErrno export;
  dcl-pi *n;
  end-pi;
  //-------------------------------------------------------------------*

  f_setErrno(0);

  return;


end-proc;

//=========================================================================
//  Sets the C runtime error number to a given error code.
//=========================================================================
//  Parameters:
//   i_errno       - A C runtime error number.
//
//  Returns:
//   void
//=========================================================================
dcl-proc f_setErrno export;
  dcl-pi *n;
    i_errno int(10) const;
  end-pi;

  //  Local fields
  dcl-s runTimeError int(10) based(pRunTimeError);
  //-------------------------------------------------------------------*

  pRunTimeError = errno();
  runTimeError = i_errno;

  return;


end-proc;

//=========================================================================
//  Returns the message text of a C runtime error number.
//=========================================================================
//  Parameters:
//   i_errno       - The C runtime error number returned by
//                   the f_errno()-function.
//
//  Returns:
//   errText       - The message text of the error number.
//=========================================================================
dcl-proc f_strerror export;
  dcl-pi *n varchar(128);
    i_errno int(10) const;
  end-pi;

  //  Return value
  dcl-s errText varchar(128) inz;

  //  Local fields
  dcl-s pErrText pointer inz;
  //-------------------------------------------------------------------*

  pErrText = strerror(i_errno);
  if   pErrText = *NULL;
    errText = '';
  else;
    errText = %str(pErrText);
  endif;

  return   errText;


end-proc;

//=========================================================================
//  Converts a C runtime error number to a message.
//=========================================================================
//  Parameters:
//   i_errno       - The C runtime error number returned by
//                   the f_errno()-function.
//
//  Returns:
//   msg           - The error message.
//=========================================================================
dcl-proc f_cvtErrnoToMsg export;
  dcl-pi *n like(msg_t);
    i_errno int(10) const;
  end-pi;

  //  Return value
  dcl-ds msg likeds(msg_t) inz;

  //  Local fields
/if not defined(*V5R3M0)
  dcl-ds msgID qualified;
    prefix char(3);
    nbr    zoned(4);
  end-ds;
/endif

  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-ds msgInf qualified;
    bytRet int(10) inz;
    bytAvl int(10) inz;
  end-ds;
  dcl-ds errCode likeds(errCode_t) inz;
  //-------------------------------------------------------------------*

  if   i_errno = 0;
    msg = f_newMsg(cMSG_ID_OK);
  else;
/if not defined(*V5R3M0)
   msgID.prefix = 'C2M';
   msgID.nbr    = i_errno;
   msg.ID = msgID;
/else
    msg.ID.prefix = 'C2M';
    msg.ID.nbr    = i_errno;
/endif
    qMsgF.name = 'QC2MSGF';
    qMsgF.lib  = '*LIBL';
    errCode = f_newApiErrCode(cTrue);
    QMHRTVM(msgInf: %size(msgInf): 'RTVM0100': msg.ID: qMsgF:
            '': 0: '*NO': '*NO': errCode);
    if not f_isApiError(errCode);
      msg   = f_newMsg(msg.ID
                       : ''
                       : cMsg_Escape: 'QC2MSGF': '*LIBL');
    else;
      msg   = f_newMsg('CPF9898'
                       : %char(i_errno) + ': ' + f_strerror(i_errno)
                       : cMsg_Escape: 'QCPFMSG': '*LIBL');
    endif;
  endif;

  return   msg;


end-proc;