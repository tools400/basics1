      *===============================================================*
      *    CALL PGM(TEST_R1_02)                                       *
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
     D cFILE_CREATE    C                   const(1)
     D cFILE_REPLACE   C                   const(2)
     D cFILE_APPEND    C                   const(4)
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_R1_02')
      *
     D main...
     D                 PR
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

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
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t     ) inz
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
     D sndInf          DS                  likeds(sndInf_t  ) inz
      *
     D snd             DS                  qualified
     D  pgm                         256A   inz
     D  prc                         256A   inz
      *
     D msgKey          S              4A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create a message with no message ID, only message text
         msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_NONE ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         msg = f_newMsg(cMSG_ID_NONE: 'A message w/o a message ID');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Create a NULL message (which can not be sent)
         msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_NULL ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         msg = f_newMsg(cMSG_ID_NULL);
         monitor;
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         on-error;
            msg = f_newMsg(cMSG_ID_NONE:
                           'Error: A NULL message can not be sent.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endmon;

         // Create a OK message (which can not be sent)
         msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_OK ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         msg = f_newMsg(cMSG_ID_OK);
         monitor;
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         on-error;
            msg = f_newMsg(cMSG_ID_NONE:
                           'Error: A OK message can not be sent.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endmon;

         // Change the application message file to QTCPMSG
         // and send a test message TCP1A0A: &1 ended abnormally.
         msg = f_newMsg(cMSG_ID_NONE: '*** Changing message file ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         p_setAppMsgFile('QTCPMSG': 'QSYS');
         msg = f_newMsg('TCP1A0A': '*TEST_MSG *N  *N        ');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Now send a QCPFMSG
         msg = f_newMsg('CPF9897': 'Hello World! (QCPFMSG)': cMsg_Info:
                        'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Set the application message file back to the default values
         p_setAppMsgFile();

         // Try to use the default message file
         msg = f_newMsg('CPF9897': 'Default message file is QCPFMSG.');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Send a message to the most previous call stack entry
         msg = f_newMsg(cMSG_ID_NONE: '*** Sending & receiving messages ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         msg = f_newMsg(cMSG_ID_NONE: 'Hi, how are you?');
         msgKey = f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);

         rcvm0200 = f_rcvPgmMsg(cMsg_Any: msgKey: cMsg_Act_Same: 0:
                                cMsg_Prv: cMsg_ToMyself);

         sndInf = f_getSndInfOfRcvMsg(rcvm0200: snd.pgm: snd.prc);

         msg = f_newMsg(cMSG_ID_NONE: 'Received: ' + %trimR(rcvm0200.value) +
                                      ' Answer: Thanks''s I am fine.');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Finally remove the message
         p_rmvPgmMsg(cMsg_Rmv_ByKey: msgKey: cMsg_Prv: cMsg_ToMyself);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
