      *=====================================================================*
      *  BASICS1R1  - SrvPgm: Basic Routines - Messages                     *
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
      *  26.01.2005  Th.Raddatz    Removed Parameter i_rtnCtrlChr from      *
      *                            f_rtvMsgText().                          *
      *                                                                     *
      *  09.02.2005  Th.Raddatz    Added f_rtvMsgTextRaw() and              *
      *                            f_rtvMsgHelpTextRaw().                   *
      *                                                                     *
      *  22.03.2007  Th.Raddatz    Added f_cvtRcvMsgToMsg().                *
      *                                                                     *
      *  12.12.2007  Th.Raddatz    Fixed problem f_cvtRcvMsgToMsg().        *
      *                            returned msg ID was blanks when          *
      *                            i_rcvm0200 was empty. Now msg ID is      *
      *                            set to cMSG_ID_NONE.                     *
      *                                                                     *
      *  17.12.2008  Th.Raddatz    Added f_rcvPgmMsgObj().                  *
      *                                                                     *
      *  17.12.2008  Th.Raddatz    Changed f_cvtRcvMsgToMsg() to get the    *
      *                            message type from the rcvm0200 format    *
      *                            if the message type has not been passed. *
      *                                                                     *
      *  17.09.2022  Th.Raddatz    Changed module to use:  xalloc()         *
      *                                                    xrealloc()       *
      *                                                    xdealloc()       *
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
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R1
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /DEFINE INCLUDE_INTERNAL_PROCDURES
      /COPY QBASICS1,PBASICS1R8
      /UNDEFINE INCLUDE_INTERNAL_PROCDURES
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Get application message file name
     D lf_getAppMsgFileName...
     D                 PR            10A
      *
      *  Get application message file library name
     D lf_getAppMsgFileLibrary...
     D                 PR            10A
      *
      *  Set application message file name
     D lp_setAppMsgFileName...
     D                 PR
     D  i_file                       10A   const
      *
      *  Set application message file library name
     D lp_setAppMsgFileLibrary...
     D                 PR
     D  i_lib                        10A   const
      *
      *  Retrieve message description
     D lf_rtvMsgD...
     D                 PR              *
     D  i_format                      8A   const
     D  i_msgID                       7A   const
     D  i_rplData                  4096A   const  varying
     D  i_qMsgF                            const  likeds(qObj_t    )
     D  o_msg                                     likeds(msg_t     )
     D  i_rplVars                    10A   const  options(*nopass)
     D  i_rtnCtrlChr                 10A   const  options(*nopass)
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_qAppMsgFile   DS                  likeds(qObj_t    ) inz
      *
      *=========================================================================
      *  Sets the application message file.
      *=========================================================================
      *  Parameters:
      *   i_file        - The name of the message file.
      *                   Default:        QCPFMSG
      *   i_lib         - The name of the message file library.
      *                   Default:        *LIBL
      *
      *  Returns:
      *   void
      *=========================================================================
     P p_setAppMsgFile...
     P                 B                   export
      *
     D p_setAppMsgFile...
     D                 PI
     D  i_file                       10A   const  options(*nopass)
     D  i_lib                        10A   const  options(*nopass)
      *
      *  Parameter positions
     D p_file          C                   const(1)
     D p_lib           C                   const(2)
      *
      *  Optional parameter fields
     D file            S                   like(i_file    ) inz
     D lib             S                   like(i_lib     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... file
         if   %parms >= p_file;
            CEETSTA(isPresent: p_file: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            file = i_file;
         else;
            file = 'QCPFMSG';
         endif;

         // ... library
         if   %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // Set the message file ...
         lp_setAppMsgFileName(file);
         lp_setAppMsgFileLibrary(lib);

         return;

      /END-FREE
      *
     P p_setAppMsgFile...
     P                 E
      *
      *=========================================================================
      *  Creates a new message.
      *=========================================================================
      *  Parameters:
      *   i_ID          - The message ID.
      *                   Default:        cMSG_ID_NONE (if omitted)
      *                                   cMSG_ID_NULL (if not passed)
      *                   cMsg_ID_OK    - An OK message which actually is
      *                                   a blank message structure.
      *                   cMsg_ID_NONE  - A message with no message ID,
      *                                   just message text.
      *                   cMsg_ID_NULL  - A NULL message.
      *   i_data        - The message data of the replacement variables.
      *                   Default:        *BLANKS
      *   i_type        - The message type.
      *                   Default:        cMsg_Info
      *                   Please refer to PBASICS1R1 for a list of valid
      *                   message types.
      *   i_file        - The message file that contains the message ID.
      *                   Default:        The application message file.
      *   i_lib         - The message file library.
      *                   Default:        The application message file
      *                                   library.
      *
      *  Returns:
      *   void
      *=========================================================================
     P f_newMsg...
     P                 B                   export
      *
     D f_newMsg...
     D                 PI                         likeds(msg_t     )
     D  i_ID                               const  like(msg_t.id    )
     D                                            options(*omit: *nopass)
     D  i_data                      512A   const  varying
     D                                            options(*omit: *nopass)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
     D  i_file                             const  like(msg_t.file  )
     D                                            options(*omit: *nopass)
     D  i_lib                              const  like(msg_t.lib   )
     D                                            options(*omit: *nopass)
      *
      *  Return value
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Parameter positions
     D p_ID            C                   const(1)
     D p_data          C                   const(2)
     D p_type          C                   const(3)
     D p_file          C                   const(4)
     D p_lib           C                   const(5)
      *
      *  Optional parameter fields
     D ID              S                   like(i_ID      ) inz
     D data            S                   like(i_data    ) inz
     D type            S                   like(i_type    ) inz
     D file            S                   like(i_file    ) inz
     D lib             S                   like(i_lib     ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      * ---------------------------------------------------------
      /FREE

         // Process optional parameter values ...
         // ... ID
         if  %parms >= p_ID;
            CEETSTA(isPresent: p_ID: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            ID = i_ID;
         else;
            if  %parms >= p_ID;
               ID = cMSG_ID_NONE;
            else;
               ID = cMSG_ID_NULL;
            endif;
         endif;

         // ... Data
         if  %parms >= p_data;
            CEETSTA(isPresent: p_data: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            data = i_data;
         else;
            data = '';
         endif;

         // ... Type
         if  %parms >= p_type;
            CEETSTA(isPresent: p_type: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            type = i_type;
         else;
            if   (ID <> cMsg_ID_OK  ) and
                 (ID <> cMsg_ID_NULL);
               type = cMsg_Info;
            else;
               type = '';
            endif;
         endif;

         // ... File
         if  %parms >= p_file;
            CEETSTA(isPresent: p_file: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            file = i_file;
         else;
            file = lf_getAppMsgFileName();
         endif;

         // ... Library
         if  %parms >= p_lib;
            CEETSTA(isPresent: p_lib: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            lib = i_lib;
         else;
            lib = lf_getAppMsgFileLibrary();
         endif;

         // Check dependencies ...
         if   (ID = cMSG_ID_NONE) and (data = '');
            p_assert(cFalse:
                     'Message data must not be *BLANKS in case that -
                      message ID is specified as cMsg_ID_NONE.'           );
         endif;

         // Produce message ...
         clear   msg;

         msg.ID   = ID;
         if   msg.ID <> cMSG_ID_NULL;
            msg.data = data;
            msg.type = type;
            msg.file = file;
            msg.lib  = lib;
         endif;

         return   msg;

      /END-FREE
      *
     P f_newMsg...
     P                 E
      *
      *=========================================================================
      *  Sends a program message.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The message to send.
      *   i_toStkC      - The stack entry to send the message to.
      *                   Default:        cMsg_Same
      *                   cMsg_Ext      - The external message queue.
      *                   cMsg_Prv      - The procedure that is before
      *                                   the procdure that is specified
      *                                   at i_toProc.
      *                   cMsg_Same     - The procedure that is specified
      *                                   at i_toProc.
      *   i_toProc      - The procedure to send the message to.
      *                   Default:        cMsg_ToMyself
      *                   cMsg_ToMyself - The procedure that calls
      *                                   f_sndPgmMsg().
      *                   cMsg_ToPgmBdy - The program boundary.
      *                   cMsg_ToCtlBdy - The control boundary.
      *                   cMsg_ToPgm    - The program specified
      *                                   at i_toPgm.
      *   i_toMod       - The module that contains the procedure.
      *                   Default:        *NONE
      *   i_toPgm       - The program that contains the module.
      *                   Default:        *NONE
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msgKey        - The message key of the message sent.
      *=========================================================================
     P f_sndPgmMsg...
     P                 B                   export
      *
     D f_sndPgmMsg...
     D                 PI             4A
     D  i_msg                              const  likeds(msg_t   )
     D  i_toStkC                     10I 0 const  options(*nopass: *omit)
     D  i_toProc                    256A   const  options(*nopass: *omit)
     D  i_toMod                      10A   const  options(*nopass: *omit)
     D  i_toPgm                      10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msgKey          S              4A   inz
      *
      *  Parameter positions
     D p_toStkC        C                   const(2)
     D p_toProc        C                   const(3)
     D p_toMod         C                   const(4)
     D p_toPgm         C                   const(5)
     D p_msg           C                   const(6)
      *
      *  Optional parameter fields
     D toStkC          S                   like(i_toStkC  ) inz
     D toProc          S                   like(i_toProc  ) inz
     D toMod           S                   like(i_toMod   ) inz
     D toPgm           S                   like(i_toPgm   ) inz
     D msg             DS                  likeds(o_msg   ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QMHSNDPM
     D qMsgF           DS                  likeds(qObj_t    ) inz
     D callStkE        S                   like(i_toProc)     inz
     D callStkCtr      S             10I 0                    inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... stack counter
         if  %parms >= p_toStkC;
            CEETSTA(isPresent: p_toStkC: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            toStkC = i_toStkC;
         else;
            toStkC = cMsg_Same;
         endif;

         // ... to procedure
         if  %parms >= p_toProc;
            CEETSTA(isPresent: p_toProc: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            toProc = i_toProc;
         else;
            toProc = cMsg_toMySelf;
         endif;

         // ... to module
         if  %parms >= p_toMod;
            CEETSTA(isPresent: p_toMod: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            toMod  = i_toMod;
         else;
            toMod  = '*NONE';
         endif;

         // ... to program
         if  %parms >= p_toPgm;
            CEETSTA(isPresent: p_toPgm: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            toPgm  = i_toPgm;
         else;
            toPgm  = '*NONE';
         endif;

         // Check dependencies ...
         p_assert(i_msg.ID <> cMSG_ID_OK     and
                  i_msg.ID <> cMSG_ID_NULL         :
                  'Message ID must not be ''' + i_msg.ID + '''.'   );

         // Set values to call QMHSNDPM API:
         // Call stack counter ...
         select;
         // ... *EXT
         when   toStkC = cMsg_Ext;
            callStkCtr = 0;
            toProc     = '*EXT';
         // ... *PERVIOUS
         when   toStkC = cMsg_Prv;
            callStkCtr = 1;
         // ... *SAME
         when   toStkC = cMsg_Same;
            callStkCtr = 0;
         // ... others
         other;
            callStkCtr = toStkC;
         endsl;

         // To procedure ...
         select;
         // ... *
         when   toProc = cMsg_ToMyself;
            callStkE   = '*';
            // ... add 1 to skip f_sndPgmMsg() stack entry
            callStkCtr = callStkCtr + 1;
            // ... *PGMBDY
         when   toProc = cMsg_ToPgmBdy;
            callStkE   = '*PGMBDY';
            // ... *CTLBDY
         when   toProc = cMsg_ToCtlBdy;
            callStkE   = '*CTLBDY';
            // ... *PGMNAME
         when   toProc = cMsg_ToPgm;
            callStkE   = '*PGMNAME';
            // ... *EXT
         when   toProc = '*EXT';
            callStkE   = '*EXT';
            // ... named procedure
         other;
            callStkE   = toProc;
         endsl;

         // To module ...
         callStkEQ.module  = toMod;

         // To program ...
         callStkEQ.program = toPgm;

         // Set message file name and library ...
         qMsgF.name = i_msg.file;
         qMsgF.lib  = i_msg.lib;

         // Initialize message key ...
         msgKey  = '';

         // Initialize error code ...
         errCode = f_newApiErrCode(cFalse);

         // Finally send the message ...
         QMHSNDPM(i_msg.ID: qMsgF: i_msg.data: %len(%trimR(i_msg.data)):
                  i_msg.type: callStkE: callStkCtr: msgKey: errCode:
                  %len(%trimR(callStkE)): callStkEQ: -1);

         // Check API error code
         if  f_isApiError(errCode);
            msgKey = '';
            msg    = f_cvtApiErrCodeToMsg(errCode);
         else;
            msg    = f_newMsg(cMsg_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   msgKey;

      /END-FREE
      *
     P f_sndPgmMsg...
     P                 E
      *
      *=========================================================================
      *  Receives a program message.
      *=========================================================================
      *  Parameters:
      *   i_msgType     - The type of the message to receive.
      *                   Please refer to PBASICS1R1 for a list of valid
      *                   message types.
      *   i_msgKey      - The key of the message to receive.
      *                   Default:        *BLANKS
      *   i_action      - The action to take after the message
      *                   is received.
      *                   Default:        cMsg_Act_Same
      *                   cMsg_Act_Old  - Keep message, mark as old.
      *                   cMsg_Act_Rmv  - Remove message.
      *                   cMsg_Act_Same - Keep message.
      *   i_wait        - The time to wait for the message.
      *                   Default:        0
      *                   0             - Do not wait.
      *                   -1            - Wait forever.
      *                   n             - Wait n seconds.
      *   i_fromStkC    - The stack entry to send the message to.
      *                   Default:        cMsg_Same
      *                   cMsg_Ext      - The external message queue.
      *                   cMsg_Prv      - The procedure that is before
      *                                   the procdure that is specified
      *                                   at i_toProc.
      *                   cMsg_Same     - The procedure that is specified
      *                                   at i_toProc.
      *   i_fromProc    - The procedure to send the message to.
      *                   Default:        cMsg_ToMyself
      *                   cMsg_ToMyself - The procedure that calls
      *                                   f_rcvPgmMsg().
      *   i_fromMod     - The module that contains the procedure.
      *                   Default:        *NONE
      *   i_fromPgm     - The program that contains the module.
      *                   Default:        *NONE
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   rcvm0200_t    - Format RCVM0200 of the received message.
      *=========================================================================
     P f_rcvPgmMsg...
     P                 B                   export
      *
     D f_rcvPgmMsg...
     D                 PI                         likeds(rcvm0200_t)
     D  i_msgType                    10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_action                     10A   const  options(*nopass: *omit)
     D  i_wait                       10I 0 const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Parameter positions
     D p_msgKey        C                   const(2)
     D p_action        C                   const(3)
     D p_wait          C                   const(4)
     D p_fromStkC      C                   const(5)
     D p_fromProc      C                   const(6)
     D p_fromMod       C                   const(7)
     D p_fromPgm       C                   const(8)
     D p_msg           C                   const(9)
      *
      *  Optional parameter fields
     D msgKey          S                   like(i_msgKey  ) inz
     D action          S                   like(i_action  ) inz
     D wait            S                   like(i_wait    ) inz
     D fromStkC        S                   like(i_fromStkC) inz
     D fromProc        S                   like(i_fromProc) inz
     D fromMod         S                   like(i_fromMod ) inz
     D fromPgm         S                   like(i_fromPgm ) inz
     D msg             DS                  likeds(o_msg   ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QMHSNDPM
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
     D callStkE        S                   like(i_fromProc  ) inz
     D callStkCtr      S             10I 0                    inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... message key
         if  %parms >= p_msgKey;
            CEETSTA(isPresent: p_msgKey: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            msgKey = i_msgKey;
         else;
            msgKey = '';
         endif;

         // ... action
         if  %parms >= p_action;
            CEETSTA(isPresent: p_action: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            action = i_action;
         else;
            action = cMsg_Act_Same;
         endif;

         // ... wait
         if  %parms >= p_wait;
            CEETSTA(isPresent: p_wait: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            wait = i_wait;
         else;
            wait = 0;            //  Do not wait for the message.
         endif;

         // ... stack counter
         if  %parms >= p_fromStkC;
            CEETSTA(isPresent: p_fromStkC: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromStkC = i_fromStkC;
         else;
            fromStkC = cMsg_Same;
         endif;

         // ... from procedure
         if  %parms >= p_fromProc;
            CEETSTA(isPresent: p_fromProc: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromProc = i_fromProc;
         else;
            fromProc = cMsg_toMySelf;
         endif;

         // ... from module
         if  %parms >= p_fromMod;
            CEETSTA(isPresent: p_fromMod: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromMod  = i_fromMod;
         else;
            fromMod  = '*NONE';
         endif;

         // ... from program
         if  %parms >= p_fromPgm;
            CEETSTA(isPresent: p_fromPgm: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromPgm  = i_fromPgm;
         else;
            fromPgm  = '*NONE';
         endif;

         // Set values to call QMHSNDPM API:
         // Call stack counter ...
         select;
         // ... *EXT
         when   fromStkC = cMsg_Ext;
            callStkCtr = 0;
            fromProc   = '*EXT';
         // ... *PERVIOUS
         when   fromStkC = cMsg_Prv;
            callStkCtr = 1;
         // ... *SAME
         when   fromStkC = cMsg_Same;
            callStkCtr = 0;
         // ... sonst
         other;
            callStkCtr = fromStkC;
         endsl;

         // From procedure ...
         select;
         // ... *
         when   fromProc = cMsg_ToMyself;
            callStkE   = '*';
            // ... add 1 to skip f_rcvPgmMsg() stack entry
            callStkCtr = callStkCtr + 1;
         // ... *EXT
         when   fromProc = '*EXT';
            callStkE   = '*EXT';
         // ... named procedure
         other;
            callStkE   = fromProc;
         endsl;

         // From module ...
         callStkEQ.module  = fromMod;

         // From program ...
         callStkEQ.program = fromPgm;

         // Initialize error code ...
         errCode = f_newApiErrCode(cFalse);

         // Finally receive the message ...
         QMHRCVPM(rcvm0200: %size(rcvm0200): 'RCVM0200': callStkE: callStkCtr:
                  i_msgType: msgKey: wait: action: errCode:
                  %len(%trimR(callStkE)): callStkEQ);

         // Check API error code
         if  f_isApiError(errCode);
            clear   rcvm0200;
            msg = f_cvtApiErrCodeToMsg(errCode);
         else;
            p_assert(%size(rcvm0200) >= rcvm0200.bytAvl :                                   //RADDAT
                     'RCVM0200 too small to hold result');
            msg = f_newMsg(cMsg_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   rcvm0200;

      /END-FREE
      *
     P f_rcvPgmMsg...
     P                 E
      *
      *=========================================================================
      *  Receives a program message and returns a message structure.
      *=========================================================================
      *  Parameters:
      *   i_msgType     - The type of the message to receive.
      *                   Please refer to PBASICS1R1 for a list of valid
      *                   message types.
      *   i_msgKey      - The key of the message to receive.
      *                   Default:        *BLANKS
      *   i_action      - The action to take after the message
      *                   is received.
      *                   Default:        cMsg_Act_Same
      *                   cMsg_Act_Old  - Keep message, mark as old.
      *                   cMsg_Act_Rmv  - Remove message.
      *                   cMsg_Act_Same - Keep message.
      *   i_wait        - The time to wait for the message.
      *                   Default:        0
      *                   0             - Do not wait.
      *                   -1            - Wait forever.
      *                   n             - Wait n seconds.
      *   i_fromStkC    - The stack entry to send the message to.
      *                   Default:        cMsg_Same
      *                   cMsg_Ext      - The external message queue.
      *                   cMsg_Prv      - The procedure that is before
      *                                   the procdure that is specified
      *                                   at i_toProc.
      *                   cMsg_Same     - The procedure that is specified
      *                                   at i_toProc.
      *   i_fromProc    - The procedure to send the message to.
      *                   Default:        cMsg_ToMyself
      *                   cMsg_ToMyself - The procedure that calls
      *                                   f_rcvPgmMsg().
      *   i_fromMod     - The module that contains the procedure.
      *                   Default:        *NONE
      *   i_fromPgm     - The program that contains the module.
      *                   Default:        *NONE
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msg           - Received message.
      *=========================================================================
     P f_rcvPgmMsgObj...
     P                 B                   export
      *
     D f_rcvPgmMsgObj...
     D                 PI                         likeds(msg_t )
     D  i_msgType                    10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_action                     10A   const  options(*nopass: *omit)
     D  i_wait                       10I 0 const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rtnMsg          DS                  likeds(msg_t ) inz
      *
      *  Parameter positions
     D p_msgKey        C                   const(2)
     D p_action        C                   const(3)
     D p_wait          C                   const(4)
     D p_fromStkC      C                   const(5)
     D p_fromProc      C                   const(6)
     D p_fromMod       C                   const(7)
     D p_fromPgm       C                   const(8)
     D p_msg           C                   const(9)
      *
      *  Optional parameter fields
     D fromStkC        S                   like(i_fromStkC) inz
     D msg             DS                  likeds(o_msg   ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *
      *  Helper fields
     D callStkCtr      S             10I 0 inz
     D rcvm0200        DS                  likeds(rcvm0200_t ) inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... stack counter
         if (%parms() >= p_fromStkC);
            CEETSTA(isPresent: p_fromStkC: *omit);
         else;
            isPresent = 0;
         endif;

         if (isPresent = 1);
            fromStkC = i_fromStkC;
         else;
            fromStkC = cMsg_Same;
         endif;

         // Adjust stack counter
         select;
         when (fromStkC = cMsg_Ext);
            callStkCtr = fromStkC;
         // ... *PERVIOUS
         when (fromStkC = cMsg_Prv);
            callStkCtr = 1 + 1;  // let f_rcvPgmMsg() skip f_rcvPgmMsgObj()
         // ... *SAME
         when (fromStkC = cMsg_Same);
            callStkCtr = 0 + 1;  // let f_rcvPgmMsg() skip f_rcvPgmMsgObj()
         // ... everything else
         other;
            callStkCtr = fromStkC + 1;  // let f_rcvPgmMsg() skip f_rcvPgmMsgObj()
         endsl;

         // Receive the message
         select;
         when (%parms() < p_msgKey);    //   1 parameter passed
            rcvm0200 = f_rcvPgmMsg(i_msgType: *omit: *omit: *omit: callStkCtr
                                   : *omit: *omit: *omit: msg);

         when (%parms() = p_msgKey);    //   2 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey: *omit: *omit: callStkCtr
                                   : *omit: *omit: *omit: msg);

         when (%parms() = p_action);    //   3 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action: *omit: callStkCtr
                                   : *omit: *omit: *omit: msg);

         when (%parms() = p_wait);      //   4 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action
                                   : i_wait: callStkCtr
                                   : *omit: *omit: *omit: msg);

         when (%parms() = p_fromStkC);  //   5 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action
                                   : i_wait
                                   : callStkCtr
                                   : *omit: *omit: *omit: msg);

         when (%parms() = p_fromProc);  //   6 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action
                                   : i_wait
                                   : callStkCtr
                                   : i_fromProc
                                   : *omit: *omit: msg);

         when (%parms() = p_fromMod);   //   7 parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action
                                   : i_wait
                                   : callStkCtr
                                   : i_fromProc
                                   : i_fromMod
                                   : *omit: msg);

         other;                         //   8 or more parameters passed
            rcvm0200 = f_rcvPgmMsg(i_msgType
                                   : i_msgKey
                                   : i_action
                                   : i_wait
                                   : callStkCtr
                                   : i_fromProc
                                   : i_fromMod
                                   : i_fromPgm
                                   : msg);
         endsl;

         if (msg.ID = cMSG_ID_OK);
            rtnMsg = f_cvtRcvMsgToMsg(rcvm0200);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return rtnMsg;

      /END-FREE
      *
     P f_rcvPgmMsgObj...
     P                 E
      *
      *=========================================================================
      *  Removes a program message.
      *=========================================================================
      *  Parameters:
      *   i_msgToRemove - The type of the message to receive.
      *                   cMsg_Rmv_All  - Remove all messages.
      *                   cMsg_Rmv_ByKey- Remove message that is specified
      *                                   by i_msgKey.
      *                   cMsg_Rmv_New  - Remove new messages.
      *                   cMsg_Rmv_Old  - Remove old messages.
      *                   cMsg_Rmv_Scope- Remove the scope message in the
      *                                   message key parameter.
      *   i_msgKey      - The key of the message to remove.
      *                   Default:        *BLANKS
      *   i_toStkC      - The stack entry to send the message to.
      *                   Default:        cMsg_Same
      *                   cMsg_AllInact - All inactive call stack entries.
      *                                   i_msgToRemove must be cMsg_Rmv_All.
      *                   cMsg_Ext      - The external message queue.
      *                   cMsg_Prv      - The procedure that is before
      *                                   the procdure that is specified
      *                                   at i_toProc.
      *                   cMsg_Same     - The procedure that is specified
      *                                   at i_toProc.
      *   i_toProc      - The procedure to send the message to.
      *                   Default:        cMsg_toMySelf
      *                   cMsg_ToMyself - The procedure that calls
      *                                   f_rcvPgmMsg().
      *   i_toMod       - The module that contains the procedure.
      *                   Default:        *NONE
      *   i_toPgm       - The program that contains the module.
      *                   Default:        *NONE
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   void
      *=========================================================================
     P p_rmvPgmMsg...
     P                 B                   export
      *
     D p_rmvPgmMsg...
     D                 PI
     D  i_msgToRemove                10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Parameter positions
     D p_msgKey        C                   const(2)
     D p_fromStkC      C                   const(3)
     D p_fromProc      C                   const(4)
     D p_fromMod       C                   const(5)
     D p_fromPgm       C                   const(6)
     D p_msg           C                   const(7)
      *
      *  Optional parameter fields
     D msgKey          S                   like(i_msgKey  ) inz
     D fromStkC        S                   like(i_fromStkC) inz
     D fromProc        S                   like(i_fromProc) inz
     D fromMod         S                   like(i_fromMod ) inz
     D fromPgm         S                   like(i_fromPgm ) inz
     D msg             DS                  likeds(o_msg   ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0                  inz
      *
      *  Helper fields QMHSNDPM
     D callStkE        S                   like(i_fromProc  ) inz
     D callStkCtr      S             10I 0                    inz
     D callStkEQ       DS                  qualified
     D  module                 1     10A                      inz
     D  program               11     20A                      inz
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... message key
         if  %parms >= p_msgKey;
            CEETSTA(isPresent: p_msgKey: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            msgKey = i_msgKey;
         else;
            msgKey = '';
         endif;

         // ... stack counter
         if  %parms >= p_fromStkC;
            CEETSTA(isPresent: p_fromStkC: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromStkC = i_fromStkC;
         else;
            fromStkC = cMsg_Same;
         endif;

         // ... from procedure
         if  %parms >= p_fromProc;
            CEETSTA(isPresent: p_fromProc: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromProc = i_fromProc;
         else;
            fromProc = cMsg_toMySelf;
         endif;

         // ... from module
         if  %parms >= p_fromMod;
            CEETSTA(isPresent: p_fromMod: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromMod  = i_fromMod;
         else;
            fromMod  = '*NONE';
         endif;

         // ... from program
         if  %parms >= p_fromPgm;
            CEETSTA(isPresent: p_fromPgm: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            fromPgm  = i_fromPgm;
         else;
            fromPgm  = '*NONE';
         endif;

         // Set values to call QMHRMVPM API:
         // Call stack counter ...
         select;
         // ... *ALLINACT
         when   fromStkC = cMsg_AllInact;
            callStkCtr = 0;
            fromProc   = '*ALLINACT';
         // ... *EXT
         when   fromStkC = cMsg_Ext;
            callStkCtr = 0;
            fromProc   = '*EXT';
         // ... *PERVIOUS
         when   fromStkC = cMsg_Prv;
            callStkCtr = 1;
         // ... *SAME
         when   fromStkC = cMsg_Same;
            callStkCtr = 0;
         // ... sonst
         other;
            callStkCtr = fromStkC;
         endsl;

         // From procedure ...
         select;
         // ... *
         when   fromProc = cMsg_ToMyself;
            callStkE   = '*';
            // ... add 1 to skip f_rcvPgmMsg() stack entry
            callStkCtr = callStkCtr + 1;
         // ... *EXT
         when   fromProc = '*EXT';
            callStkE   = '*EXT';
         // ... *ALLINACT
         when   fromProc = '*ALLINACT';
            callStkE   = '*ALLINACT';
         // ... named procedure
         other;
            callStkE   = fromProc;
         endsl;

         // From module ...
         callStkEQ.module  = fromMod;

         // From program ...
         callStkEQ.program = fromPgm;

         // Initialize error code ...
         errCode = f_newApiErrCode(cFalse);

         // Finally remove the message ...
         QMHRMVPM(callStkE: callStkCtr: msgKey: i_msgToRemove: errCode:
                  %len(%trimR(callStkE)): callStkEQ: '*NO');

         // Check API error code
         if  f_isApiError(errCode);
            msg = f_cvtApiErrCodeToMsg(errCode);
         else;
            msg = f_newMsg(cMsg_ID_OK);
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return;

      /END-FREE
      *
     P p_rmvPgmMsg...
     P                 E
      *
      *=========================================================================
      *  Retrieves the message text of a given message.
      *  Replaces substitution variables with message data.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The message to retrieve the text from.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msgText       - The message text that was retrieved from
      *                   the given message.
      *=========================================================================
     P f_rtvMsgText...
     P                 B                   export
      *
     D f_rtvMsgText...
     D                 PI          4096A          varying
     D  i_msg                              const  likeds(msg_t    )
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msgText         S           4096A   varying inz
      *
      *  Parameter positions
     D p_msg           C                   const(2)
      *
      *  Optional parameter fields
     D msg             DS                  likeds(o_msg       ) inz
      *
      *  Local fields
     D rtvm0100        DS                  likeds(rtvm0100_t  ) based(pRtvm0100)
     D qMsgF           DS                  likeds(qObj_t      ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *-------------------------------------------------------------------*
      *
      /FREE

         // Retrieve message information
         qMsgF.name = i_msg.file;
         qMsgF.lib  = i_msg.lib;
         pRtvm0100  = lf_rtvMsgD('RTVM0100':
                                 i_msg.ID: %trimR(i_msg.data): qMsgF: msg:
                                 '*YES': '*NO');

         // Retrieve message text from message information
         if   pRtvm0100 <> *NULL;
            if   rtvm0100.lenMsgRet > 0;
               msgText = %subst(rtvm0100: 25: rtvm0100.lenMsgRet);
               xdealloc(pRtvm0100);
            else;
               msgText = '';
            endif;
         else;
            msgText = '';
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   msgText;

      /END-FREE
      *
     P f_rtvMsgText...
     P                 E
      *
      *=========================================================================
      *  Retrieves the message help text of a given message.
      *  Replaces substitution variables with message data.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The message to retrieve the help text from.
      *   i_rtnCtrlChr  - Specifies whether the control characters are
      *                   returned or not.
      *                   cMsg_RtnCtrlChar_Yes - Return control characters
      *                   cMsg_RtnCtrlChar_No  - Do not return control characters
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msgText       - The message help text that was retrieved from
      *                   the given message.
      *=========================================================================
     P f_rtvMsgHelpText...
     P                 B                   export
      *
     D f_rtvMsgHelpText...
     D                 PI          4096A          varying
     D  i_msg                              const  likeds(msg_t    )
     D  i_rtnCtrlChr                 10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msgHelpText     S           4096A   varying inz
      *
      *  Parameter positions
     D p_rtnCtrlChr    C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D rtnCtrlChr      S                   like(i_rtnCtrlChr  ) inz
     D msg             DS                  likeds(o_msg       ) inz
      *
      *  Local fields
     D qMsgF           DS                  likeds(qObj_t      ) inz
     D rtvm0100        DS                  likeds(rtvm0100_t  ) based(pRtvm0100)
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *-------------------------------------------------------------------*
      *
      /FREE

         // Process optional parameter values ...
         // ... rtnCtrlChr
         if   %parms >= p_rtnCtrlChr;
            CEETSTA(isPresent: p_rtnCtrlChr: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            rtnCtrlChr = i_rtnCtrlChr;
         else;
            rtnCtrlChr = '*NO';
         endif;

         // Retrieve message information
         qMsgF.name = i_msg.file;
         qMsgF.lib  = i_msg.lib;
         pRtvm0100  = lf_rtvMsgD('RTVM0100':
                                 i_msg.ID: %trimR(i_msg.data): qMsgF: msg:
                                 '*YES': rtnCtrlChr);

         // Retrieve message help text from message information
         if   pRtvm0100 <> *NULL;
            if   rtvm0100.lenHlpRet > 0;
               msgHelpText = %subst(rtvm0100: 25 + rtvm0100.lenMsgRet:
                                    rtvm0100.lenHlpRet);
               xdealloc(pRtvm0100);
            else;
               msgHelpText = '';
            endif;
         else;
            msgHelpText = '';
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   msgHelpText;

      /END-FREE
      *
     P f_rtvMsgHelpText...
     P                 E
      *
      *=========================================================================
      *  Retrieves the message text of a given message.
      *  Does not replaces substitution variables with message data.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The message to retrieve the text from.
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msgText       - The message text that was retrieved from
      *                   the given message.
      *=========================================================================
     P f_rtvMsgTextRaw...
     P                 B                   export
      *
     D f_rtvMsgTextRaw...
     D                 PI          4096A          varying
     D  i_msg                              const  likeds(msg_t    )
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msgText         S           4096A   varying inz
      *
      *  Parameter positions
     D p_msg           C                   const(2)
      *
      *  Optional parameter fields
     D msg             DS                  likeds(o_msg       ) inz
      *
      *  Local fields
     D rtvm0100        DS                  likeds(rtvm0100_t  ) based(pRtvm0100)
     D qMsgF           DS                  likeds(qObj_t      ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *-------------------------------------------------------------------*
      *
      /FREE

         // Retrieve message information
         qMsgF.name = i_msg.file;
         qMsgF.lib  = i_msg.lib;
         pRtvm0100  = lf_rtvMsgD('RTVM0100':
                                 i_msg.ID: %trimR(i_msg.data): qMsgF: msg:
                                 '*NO': '*NO');

         // Retrieve message text from message information
         if   pRtvm0100 <> *NULL;
            if   rtvm0100.lenMsgRet > 0;
               msgText = %subst(rtvm0100: 25: rtvm0100.lenMsgRet);
               xdealloc(pRtvm0100);
            else;
               msgText = '';
            endif;
         else;
            msgText = '';
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   msgText;

      /END-FREE
      *
     P f_rtvMsgTextRaw...
     P                 E
      *
      *=========================================================================
      *  Retrieves the message help text of a given message.
      *  Does not replaces substitution variables with message data.
      *=========================================================================
      *  Parameters:
      *   i_msg         - The message to retrieve the help text from.
      *   i_rtnCtrlChr  - Specifies whether the control characters are
      *                   returned or not.
      *                   cMsg_RtnCtrlChar_Yes - Return control characters
      *                   cMsg_RtnCtrlChar_No  - Do not return control characters
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   msgText       - The message help text that was retrieved from
      *                   the given message.
      *=========================================================================
     P f_rtvMsgHelpTextRaw...
     P                 B                   export
      *
     D f_rtvMsgHelpTextRaw...
     D                 PI          4096A          varying
     D  i_msg                              const  likeds(msg_t    )
     D  i_rtnCtrlChr                 10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msgHelpText     S           4096A   varying inz
      *
      *  Parameter positions
     D p_rtnCtrlChr    C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D rtnCtrlChr      S                   like(i_rtnCtrlChr  ) inz
     D msg             DS                  likeds(o_msg       ) inz
      *
      *  Local fields
     D qMsgF           DS                  likeds(qObj_t      ) inz
     D rtvm0100        DS                  likeds(rtvm0100_t  ) based(pRtvm0100)
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *-------------------------------------------------------------------*
      *
      /FREE

         // Process optional parameter values ...
         // ... rtnCtrlChr
         if   %parms >= p_rtnCtrlChr;
            CEETSTA(isPresent: p_rtnCtrlChr: *omit);
         else;
            isPresent = 0;
         endif;

         if   isPresent = 1;
            rtnCtrlChr = i_rtnCtrlChr;
         else;
            rtnCtrlChr = '*NO';
         endif;

         // Retrieve message information
         qMsgF.name = i_msg.file;
         qMsgF.lib  = i_msg.lib;
         pRtvm0100  = lf_rtvMsgD('RTVM0100':
                                 i_msg.ID: %trimR(i_msg.data): qMsgF: msg:
                                 '*NO': rtnCtrlChr);

         // Retrieve message help text from message information
         if   pRtvm0100 <> *NULL;
            if   rtvm0100.lenHlpRet > 0;
               msgHelpText = %subst(rtvm0100: 25 + rtvm0100.lenMsgRet:
                                    rtvm0100.lenHlpRet);
               xdealloc(pRtvm0100);
            else;
               msgHelpText = '';
            endif;
         else;
            msgHelpText = '';
         endif;

         // Process optional/omissible message parameter
         if   %parms >= p_msg;
            CEETSTA(isPresent: p_msg: *omit);
            if   isPresent = 1;
               o_msg = msg;
            endif;
         else;
            if   msg.ID <> cMSG_ID_OK;
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return   msgHelpText;

      /END-FREE
      *
     P f_rtvMsgHelpTextRaw...
     P                 E
      *
      *=========================================================================
      *  Converts a received message of format RCVM0200 to a message.
      *=========================================================================
      *  Parameters:
      *   i_rcvm0200    - Format RCVM0200 of the received message.
      *   i_type        - The message type.
      *                   Default:        cMsg_Info
      *
      *  Returns:
      *   msg           - Message as message structure
      *=========================================================================
     P f_cvtRcvMsgToMsg...
     P                 B                   export
      *
     D f_cvtRcvMsgToMsg...
     D                 PI                         likeds(msg_t     )
     D  i_rcvm0200                         const  likeds(rcvm0200_t)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
      *
      *  Return value
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Parameter positions
     D p_type          C                   const(2)
      *
      *  Optional parameter fields
     D type            S                   like(i_type      ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *
      *  Helper fields
     D msgID           S                   like(msg_t.ID    ) inz
     D msgData         S                   like(msg_t.data  ) inz
      *-------------------------------------------------------------------*
      /FREE

         // Process optional parameter values ...
         // ... Type
         if  %parms >= p_type;
            CEETSTA(isPresent: p_type: *omit);
         else;
            isPresent = 0;
         endif;

         if  isPresent = 1;
            type = i_type;
         else;
            select;
            when (i_rcvm0200.msgType = '01');   // Completion
               type = cMsg_Comp;
            when (i_rcvm0200.msgType = '02');   // Diagnostic
               type = cMsg_Diag;
            when (i_rcvm0200.msgType = '04');   // Informational
               type = cMsg_Info;
            when (i_rcvm0200.msgType = '05');   // Inquery
               type = cMsg_Inq;
            when (i_rcvm0200.msgType = '06');   // Sender's copy
               type = cMsg_Copy;
            when (i_rcvm0200.msgType = '08');   // Request
               type = cMsg_Rqs;
            when (i_rcvm0200.msgType = '10');   // Request with prompting
               type = cMsg_Rqs;
            when (i_rcvm0200.msgType = '14');   // Notify
               type = cMsg_Notify;
            when (i_rcvm0200.msgType = '15');   // Escape
               type = cMsg_Escape;
            when (i_rcvm0200.msgType = '16');   // Notify, exception not handled when API is c
               type = cMsg_Notify;
            when (i_rcvm0200.msgType = '17');   // Escape, exception not handled when API is c
               type = cMsg_Escape;
            when (i_rcvm0200.msgType = '21');   // Reply, not validity checked
               type = cMsg_Rpy;
            when (i_rcvm0200.msgType = '22');   // Reply, validity checked
               type = cMsg_Rpy;
            when (i_rcvm0200.msgType = '23');   // Reply, message default used
               type = cMsg_Rpy;
            when (i_rcvm0200.msgType = '24');   // Reply, system default used
               type = cMsg_Rpy;
            when (i_rcvm0200.msgType = '25');   // Reply, from system reply list
               type = cMsg_Rpy;
            when (i_rcvm0200.msgType = '26');   // Reply, from exit program
               type = cMsg_Rpy;
            other;
               type = cMsg_Info;
            endsl;
         endif;

         if i_rcvm0200.lnRplDtR = 0;
            msgData = '';
         else;
            msgData = %subst(i_rcvm0200.value: 1: i_rcvm0200.lnRplDtR);
         endif;

         if i_rcvm0200.msgID = '';
            msgID = cMSG_ID_NULL;
         else;
            msgID = i_rcvm0200.msgID;
         endif;

         msg = f_newMsg(msgID: msgData: type
                        : i_rcvm0200.msgF: i_rcvm0200.msgLU);

         return   msg;

      /END-FREE
      *
     P f_cvtRcvMsgToMsg...
     P                 E
      *
      *=========================================================================
      *  Returns the sender information of a receives program message.
      *=========================================================================
      *  Parameters:
      *   i_rcvm0200    - Format RCVM0200 of the received message.
      *
      *  Returns:
      *   sndInf        - Sender information of the received message.
      *=========================================================================
     P f_getSndInfOfRcvMsg...
     P                 B                   export
      *
     D f_getSndInfOfRcvMsg...
     D                 PI                         likeds(sndInf_t  )
     D  i_rcvm0200                         const  likeds(rcvm0200_t)
     D  o_longSndPgm                256A          options(*nopass: *omit)
     D  o_longSndPrc                256A          options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D sndInf          DS                  likeds(sndInf_t  ) inz
      *
      *  Parameter positions
     D p_longSndPgm    C                   const(2)
     D p_longSndPrc    C                   const(3)
     D p_msg           C                   const(4)
      *
      *  Optional parameter fields
     D longSndPgm      S                   like(o_longSndPgm) inz
     D longSndPrc      S                   like(o_longSndPrc) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields
     D memSize         S             10I 0 inz
     D rcvm0300        DS                  likeds(rcvm0300_t) based(pRcvm0300 )
     D tmpSndInf       DS                  likeds(sndInf_t  )
     D                                     based(pTmpSndInf)
     D tmpLongSndPgm   S                   like(o_longSndPgm)
     D                                     based(pTmpLongSndPgm)
     D tmpLongSndPrc   S                   like(o_longSndPrc)
     D                                     based(pTmpLongSndPrc)
     D errCode         DS                  likeds(errCode_t ) inz
      *-------------------------------------------------------------------*
      /FREE

         memSize   = %size(rcvm0300) + 1024;
         pRcvm0300 = xalloc(memSize);
         errCode   = f_newApiErrCode(cFalse);

         dou (rcvm0300.bytRet >= rcvm0300.bytAvl or f_isApiError(errCode));
            QMHRCVPM(rcvm0300: memSize: 'RCVM0300': '*': 0:
                     cMsg_Any: i_rcvm0200.msgKey: 0: cMsg_Act_Same: errCode);
            if (rcvm0300.bytRet < rcvm0300.bytAvl);
               memSize   = rcvm0300.bytAvl;
               pRcvm0300 = xrealloc(pRcvm0300: memSize);
            endif;
         enddo;

         // Check API error code
         if  f_isApiError(errCode);
            msg = f_cvtApiErrCodeToMsg(errCode);
            clear sndInf;
            clear longSndPgm;
            clear longSndPrc;
         else;
            msg = f_newMsg(cMsg_ID_OK);
            pTmpSndInf = %addr(rcvm0300) +
                         %size(rcvm0300) +
                         rcvm0300.lenRplDataR +
                         rcvm0300.lenMsgR +
                         rcvm0300.lenMsgHlpR;
            pTmpLongSndPgm = pTmpSndInf + tmpSndInf.ofsSndPgmLName;
            pTmpLongSndPrc = pTmpSndInf + tmpSndInf.ofsSndPrcLName;
            sndInf     = tmpSndInf;
            longSndPgm = %subst(tmpLongSndPgm: 1: tmpSndInf.lenSndPgmLName);
            longSndPrc = %subst(tmpLongSndPrc: 1: tmpSndInf.lenSndPrcLName);
         endif;

         xdealloc(pRcvm0300);

         // Set optional output parameters
         if (%parms() >= p_longSndPgm and %addr(o_longSndPgm) <> *NULL);
            o_longSndPgm = longSndPgm;
         endif;

         if (%parms() >= p_longSndPrc and %addr(o_longSndPrc) <> *NULL);
            o_longSndPrc = longSndPrc;
         endif;

         // Process optional/omissible message parameter
         if (%parms() >= p_msg);
            if (%addr(o_msg) <> *NULL);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return sndInf;

      /END-FREE
      *
     P f_getSndInfOfRcvMsg...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Get application message file name
      *=========================================================================
     P lf_getAppMsgFileName...
     P                 B
      *
     D lf_getAppMsgFileName...
     D                 PI            10A
      *
      *  Return value
     D appMsgFileName  S             10A   inz
      *-------------------------------------------------------------------*
      *
      /FREE

         if  g_qAppMsgFile.name = '';
            appMsgFileName = 'QCPFMSG';
            else;
            appMsgFileName = g_qAppMsgFile.name;
         endif;

         return   appMsgFileName;

      /END-FREE
      *
     P lf_getAppMsgFileName...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Get application message file library name
      *=========================================================================
     P lf_getAppMsgFileLibrary...
     P                 B
      *
     D lf_getAppMsgFileLibrary...
     D                 PI            10A
      *
      *  Return value
     D appMsgFileLib   S             10A   inz
      *-------------------------------------------------------------------*
      *
      /FREE

         if  g_qAppMsgFile.name = '';
            appMsgFileLib = '*LIBL';
            else;
            appMsgFileLib = g_qAppMsgFile.lib;
         endif;

         return   appMsgFileLib;

      /END-FREE
      *
     P lf_getAppMsgFileLibrary...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Set application message file name
      *=========================================================================
     P lp_setAppMsgFileName...
     P                 B
      *
     D lp_setAppMsgFileName...
     D                 PI
     D  i_file                       10A   const
      *-------------------------------------------------------------------*
      *
      /FREE

         g_qAppMsgFile.name = i_file;

         return;

      /END-FREE
      *
     P lp_setAppMsgFileName...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Set application message file library name
      *=========================================================================
     P lp_setAppMsgFileLibrary...
     P                 B
      *
     D lp_setAppMsgFileLibrary...
     D                 PI
     D  i_lib                        10A   const
      *-------------------------------------------------------------------*
      *
      /FREE

         g_qAppMsgFile.lib = i_lib;

         return;

      /END-FREE
      *
     P lp_setAppMsgFileLibrary...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Retrieve message description
      *=========================================================================
     P lf_rtvMsgD...
     P                 B
      *
     D lf_rtvMsgD...
     D                 PI              *
     D  i_format                      8A   const
     D  i_msgID                       7A   const
     D  i_rplData                  4096A   const  varying
     D  i_qMsgF                            const  likeds(qObj_t    )
     D  o_msg                                     likeds(msg_t     )
     D  i_rplVars                    10A   const  options(*nopass)
     D  i_rtnCtrlChr                 10A   const  options(*nopass)
      *
      *  Return value
     D pMsgInf         S               *   inz
      *
      *  Parameter positions
     D p_rplVars       C                   const(6)
     D p_rtnCtrlChr    C                   const(7)
      *
      *  Optional parameter fields
     D rplVars         S                   like(i_rplVars   ) inz
     D rtnCtrlChr      S                   like(i_rtnCtrlChr) inz
      *
      *  Local fields
     D msgInf          DS                  based(pMsgInf) qualified
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D errCode         DS                  likeds(errCode_t ) inz
      *
     D memSize         S             10I 0 inz
      *-------------------------------------------------------------------*
      *
      /FREE

         // Process optional parameter values ...
         // ... rplvars
         if   %parms >= p_rplvars;
            rplvars = i_rplvars;
         else;
            rplvars = '*YES';
         endif;

         // ... rtnCtrlChr
         if   %parms >= p_rtnCtrlChr;
            rtnCtrlChr = i_rtnCtrlChr;
         else;
            rtnCtrlChr = '*NO';
         endif;

         // Allocate memory and set initial parameter values
         memSize = 8;
         pMsgInf = xalloc(memSize);
         errCode = f_newApiErrCode(cTrue);

         // Loop until complete message information is received ...
         dou   msgInf.bytRet >= msgInf.bytAvl;
            // ... call the API
            QMHRTVM(msgInf: memSize: i_format: i_msgID: i_qMsgF:
                    i_rplData: %len(i_rplData): rplVars: rtnCtrlChr: errCode);

            // ... check for errors
            if  f_isApiError(errCode);
               xdealloc(pMsgInf);
               o_msg = f_cvtApiErrCodeToMsg(errCode);
               leave;
            else;
               // ... get more memory
               if   memSize < msgInf.bytAvl;
                  memSize = msgInf.bytAvl;
                  pMsgInf = xrealloc(pMsgInf: memSize);
               else;
                  o_msg = f_newMsg(cMsg_ID_OK);
               endif;
            endif;

         enddo;

         return   pMsgInf;

      /END-FREE
      *
     P lf_rtvMsgD...
     P                 E
      *
