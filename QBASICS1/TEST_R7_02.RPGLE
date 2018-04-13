      *===============================================================*
      *    CALL PGM(TEST_R7_02)                                       *
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
     D                 PR                         extpgm('TEST_R7_02')
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
      *
     D rpgLEngth       S              5U 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Compute length of a 1-byte integer field ( 3 I 0)
         rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(1);

         msg = f_newMsg(cMSG_ID_NONE: 'Length of 1-byte integer is: ' +
                        %editc(rpgLength: 'Z'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Compute length of a 2-byte integer field ( 5 I 0)
         rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(2);

         msg = f_newMsg(cMSG_ID_NONE: 'Length of 2-byte integer is: ' +
                        %editc(rpgLength: 'Z'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Compute length of a 4-byte integer field (10 I 0)
         rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(4);

         msg = f_newMsg(cMSG_ID_NONE: 'Length of 4-byte integer is: ' +
                        %editc(rpgLength: 'Z'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Compute length of a 8-byte integer field (20 I 0)
         rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(8);

         msg = f_newMsg(cMSG_ID_NONE: 'Length of 8-byte integer is: ' +
                        %editc(rpgLength: 'Z'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
