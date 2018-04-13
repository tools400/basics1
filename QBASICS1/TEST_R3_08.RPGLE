      *===============================================================*
      *    CALL PGM(TEST_R3_08)                                       *
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
     D                 PR                         extpgm('TEST_R3_08')
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
     D string          S            128A   inz   varying
      *
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Center a literal into a string
         string = f_space(40);
         string = '>' + f_center('Hello World': %len(string)) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Centered (literal)  : ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Center a given string
         string = 'Hello World' + f_space(29);   // = 40 characters
         string = '>' + f_center(string) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Centered (string)   : ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Center a given string, target too small
         string = f_space(5);
         string = '>' + f_center('Hello World': %len(string)) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Centered (too small): ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Right align a literal into a string
         string = f_space(40);
         string = '>' + f_alignR('Hello World': %len(string)) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (literal)  : ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Right align a given string
         string = 'Hello World' + f_space(29);   // = 40 characters
         string = '>' + f_alignR(string) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (string)   : ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Right align a given string, target too small
         string = f_space(5);
         string = '>' + f_alignR('Hello World': %len(string)) + '<';
         msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (too small): ' + string);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
