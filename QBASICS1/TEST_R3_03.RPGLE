      *===============================================================*
      *    CALL PGM(TEST_R3_03) PARM('Hello World!')                  *
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
     D                 PR                         extpgm('TEST_R3_03')
     D  gi_text                      32A   const
      *
     D main...
     D                 PR
     D  i_text                       32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_text                      32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_text);

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
     D  i_text                       32A   const
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t      ) inz
     D aString         S            128A   inz varying
     D leftLen         S             10I 0 inz
     D rightLen        S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         aString = f_space(5) + %trim(i_text) + f_space(5);
         msg = f_newMsg('': aString + '<');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         aString = f_space(5: '*') + %trim(i_text) + f_space(5: '*');
         msg = f_newMsg('': aString + '<');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         aString = f_space(5: '%') + %trim(i_text) + f_space(5: '%');
         msg = f_newMsg('': aString + '<');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         aString = f_space(5: '-') + %trim(i_text) + f_space(5: '-');
         leftLen  = %int(%len(aString) / 2);
         rightLen = %len(aString) - leftLen;

         msg = f_newMsg('': f_left(aString: leftLen) + '<');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         msg = f_newMsg('': f_right(aString: rightLen) + '<');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
