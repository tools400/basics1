      *===============================================================*
      *    CALL PGM(TEST_R1_01) PARM('CPF9897' 'Hello World!' '0')    *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/BASICS1) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_R1_01')
     D  gi_msgID                      7A   const
     D  gi_msgData                   32A   const
     D  gi_isMsgHelp                  1A   const
      *
     D main...
     D                 PR
     D  i_msgID                       7A   const
     D  i_msgData                    32A   const
     D  i_isMsgHelp                    N   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_msgID                      7A   const
     D  gi_msgData                   32A   const
     D  gi_isMsgHelp                  1A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_msgID: gi_msgData: gi_isMsgHelp);

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_msgID                       7A   const
     D  i_msgData                    32A   const
     D  i_isMsgHelp                    N   const
      *
      *  Helper fields
     D msgText         S           1024A   varying            inz
     D rtvMsg          DS                  likeds(msg_t     ) inz
     D infoMsg         DS                  likeds(msg_t     ) inz
     D errMsg          DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create message to retrieve the text from
         rtvMsg = f_newMsg(i_msgID: i_msgData);

         // Retrieve message text, Ignore Errors
         infoMsg = f_newMsg('CPF9897': '*** Ignore Errors ***');
         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         msgText = f_rtvMsgText(rtvMsg: *omit);
         if   msgText <> '';
            infoMsg = f_newMsg('': 'MsgText: ' + msgText);
         else;
            infoMsg = f_newMsg(
                         '': 'Error occured on retrieveing message text!');
         endif;

         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         // Retrieve message help text, Ignore Errors
         msgText = f_rtvMsgHelpText(rtvMsg: '*NO': *omit);
         if   msgText <> '';
            infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
         else;
            infoMsg = f_newMsg(
                         '': 'Error occured on retrieveing message help text!');
         endif;

         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         // Retrieve message text, Return error information
         infoMsg = f_newMsg('CPF9897': '*** Return error information ***');
         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         msgText = f_rtvMsgText(rtvMsg: errMsg);
         if   msgText <> '';
            infoMsg = f_newMsg('': 'MsgText: ' + msgText);
         else;
            infoMsg = errMsg;
            infoMsg.type = cMsg_Info;
         endif;

         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         // Retrieve message help text, Return error information
         msgText = f_rtvMsgHelpText(rtvMsg: '*NO': errMsg);
         if   msgText <> '';
            infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
         else;
            infoMsg = errMsg;
            infoMsg.type = cMsg_Info;
         endif;

         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         // Send *ESCAPE message to signal error
         infoMsg = f_newMsg('CPF9897': '*** Send *ESCAPE message ***');
         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         if   not i_isMsgHelp;
            msgText = f_rtvMsgText(rtvMsg);
            infoMsg = f_newMsg('': 'MsgText: ' + msgText);
         else;
            msgText = f_rtvMsgHelpText(rtvMsg: '*NO');
            infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
         endif;

         f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
