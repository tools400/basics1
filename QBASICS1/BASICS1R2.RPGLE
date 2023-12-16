      *=====================================================================*
      *  BASICS1R2  - SrvPgm: Basic Routines - API Error Handling           *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  08.10.2003                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  08.02.2006  Th.Raddatz    Changed BASICS1R2 to be compatible to    *
      *                            V5R1M0.                                  *
      *                                                                     *
      *  08.01.2007  Th.Raddatz    Fixed problem in f_cvtErrnoToMsg().      *
      *                            Now errors without corresponding         *
      *                            message description in QC2MSGF are       *
      *                            returned as CPF9898 message.             *
      *                                                                     *
      *  12.12.2007  Th.Raddatz    Enhanced f_cvtApiErrCodeToMsg() to       *
      *                            receive the original error message from  *
      *                            the previous call stack entry, if        *
      *                            possible.                                *
      *                                                                     *
      *  16.07.2011  Th.Raddatz    Added procedure f_setErrno().            *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
     H BNDDIR('QC2LE')
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R2
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new API error code.
      *=========================================================================
      *  Parameters:
      *   i_monMsg      - Specifies whether API error conditions
      *                   are monitored or not.
      *                   Default:        cFalse
      *
      *  Returns:
      *   errCode       - The new API error code.
      *=========================================================================
     P f_newApiErrCode...
     P                 B                   export
      *
     D f_newApiErrCode...
     D                 PI                         likeds(errCode_t )
     D  i_monMsg                       N   const  options(*nopass)
      *
      *  Return value
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Parameter positions
     D p_monMsg        C                   const(1)
      *
      *  Optional parameter fields
     D monMsg          S                   like(i_monMsg    ) inz
      *-------------------------------------------------------------------*
      /FREE

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

      /END-FREE
      *
     P f_newApiErrCode...
     P                 E
      *
      *=========================================================================
      *  Is API error?
      *=========================================================================
      *  Parameters:
      *   i_errCode     - The error code returned from the API call.
      *
      *  Returns:
      *   isError       - Returns cTrue in case of an API error.
      *=========================================================================
     P f_isApiError...
     P                 B                   export
      *
     D f_isApiError...
     D                 PI              N
     D  i_errCode                      N   const  likeds(errCode_t )
      *
      *  Return value
     D isError         S               N   inz
      *-------------------------------------------------------------------*
      /FREE

         if   i_errCode.bytAvl > 0;
            isError = cTrue;
         else;
            isError = cFalse;
         endif;

         return   isError;

      /END-FREE
      *
     P f_isApiError...
     P                 E
      *
      *=========================================================================
      *  Converts an API error code to a messsage.
      *=========================================================================
      *  Parameters:
      *   i_errCode     - The error code returned from the API call.
      *
      *  Returns:
      *   msg           - The error message.
      *=========================================================================
     P f_cvtApiErrCodeToMsg...
     P                 B                   export
      *
     D f_cvtApiErrCodeToMsg...
     D                 PI                         like(msg_t     )
     D  i_errCode                      N   const  likeds(errCode_t )
      *
      *  Return value
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Helper fields
     D tmpMsg          DS                  likeds(msg_t     ) inz
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
      *-------------------------------------------------------------------*
      /FREE

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

      /END-FREE
      *
     P f_cvtApiErrCodeToMsg...
     P                 E
      *
      *=========================================================================
      *  Returns the C runtime error number.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   errno         - The C runtime error number.
      *=========================================================================
     P f_errno...
     P                 B                   export
      *
     D f_errno...
     D                 PI            10I 0
      *
      *  Return value
     D errorNo         S             10I 0 inz
      *
      *  Local fields
     D runTimeError    S             10I 0 based(pRunTimeError)
      *-------------------------------------------------------------------*
      /FREE

         pRunTimeError = errno();

         errorNo = runTimeError;

         return   errorNo;

      /END-FREE
      *
     P f_errno...
     P                 E
      *
      *=========================================================================
      *  Sets the C runtime error number to ZERO (no error).
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   void
      *=========================================================================
     P f_clrErrno...
     P                 B                   export
      *
     D f_clrErrno...
     D                 PI
      *-------------------------------------------------------------------*
      /FREE

         f_setErrno(0);

         return;

      /END-FREE
      *
     P f_clrErrno...
     P                 E
      *
      *=========================================================================
      *  Sets the C runtime error number to a given error code.
      *=========================================================================
      *  Parameters:
      *   i_errno       - A C runtime error number.
      *
      *  Returns:
      *   void
      *=========================================================================
     P f_setErrno...
     P                 B                   export
      *
     D f_setErrno...
     D                 PI
     D  i_errno                      10I 0 const
      *
      *  Local fields
     D runTimeError    S             10I 0 based(pRunTimeError)
      *-------------------------------------------------------------------*
      /FREE

         pRunTimeError = errno();
         runTimeError = i_errno;

         return;

      /END-FREE
      *
     P f_setErrno...
     P                 E
      *
      *=========================================================================
      *  Returns the message text of a C runtime error number.
      *=========================================================================
      *  Parameters:
      *   i_errno       - The C runtime error number returned by
      *                   the f_errno()-function.
      *
      *  Returns:
      *   errText       - The message text of the error number.
      *=========================================================================
     P f_strerror...
     P                 B                   export
      *
     D f_strerror...
     D                 PI           128A          varying
     D  i_errno                      10I 0 const
      *
      *  Return value
     D errText         S            128A   inz  varying
      *
      *  Local fields
     D pErrText        S               *   inz
      *-------------------------------------------------------------------*
      /FREE

         pErrText = strerror(i_errno);
         if   pErrText = *NULL;
            errText = '';
         else;
            errText = %str(pErrText);
         endif;

         return   errText;

      /END-FREE
      *
     P f_strerror...
     P                 E
      *
      *=========================================================================
      *  Converts a C runtime error number to a message.
      *=========================================================================
      *  Parameters:
      *   i_errno       - The C runtime error number returned by
      *                   the f_errno()-function.
      *
      *  Returns:
      *   msg           - The error message.
      *=========================================================================
     P f_cvtErrnoToMsg...
     P                 B                   export
      *
     D f_cvtErrnoToMsg...
     D                 PI                         like(msg_t     )
     D  i_errno                      10I 0 const
      *
      *  Return value
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Local fields
      /if not defined(*V5R3M0)
     D msgID           DS                  qualified
     D  prefix                        3A
     D  nbr                           4S 0
      /endif
      *
     D qMsgF           DS                  likeds(qObj_t    ) inz
     D msgInf          DS                  qualified
     D  bytRet                       10I 0 inz
     D  bytAvl                       10I 0 inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------*
      /FREE

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

      /END-FREE
      *
     P f_cvtErrnoToMsg...
     P                 E
      *
