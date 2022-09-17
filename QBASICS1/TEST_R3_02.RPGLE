      *===============================================================*
      *    CALL PGM(TEST_R3_02) PARM(65)                              *
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
     D                 PR                         extpgm('TEST_R3_02')
     D  gi_width                     15P 5 const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_width                      10I 0 const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_width                     15P 5 const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_width));
            main(gi_width);
         else;
            main(60);
         endif;

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
     D  i_width                      10I 0 const
      *
      *  Helper fields
     D theText         S            512A   varying inz('Test wordWrap():&N+
     D                                     ''The quick brown fox -
     D                                     jumps over the lazy dog.'' is a -
     D                                     sentence that includes every letter -
     D                                     of the alphabet.&PThat is why it is -
     D                                     often found as a sample sentence -
     D                                     within font managing software. Of -
     D                                     course I know that the text I am -
     D                                     writing is somewhat silly.&BHowever -
     D                                     the only purpose of the text is to -
     D                                     show how the wordWrap-function -
     D                                     works.')
     D aLine           S             80A   inz
     D startPos        S             10U 0 inz
     D numLine         S              3I 0 inz
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_width >= 1 and i_width <= 80:
                  'i_width is out of range. It must be between 1 and 80');

         // Perform word wrap without respect to end-of-paragraph markers:
         msg = f_newMsg('': '*** No EOP charcater: ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         numLine  = 0;
         startPos = 1;
         dow   startPos > 0;
            numLine = numLine + 1;
            aLine = f_wordWrap(theText: i_width: startPos) + '<';
            msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         enddo;

         // Perform word wrap with respect to end-of-paragraph markers
         // of message descriptions:
         msg = f_newMsg('': '*** EOP charcater of message description: ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         numLine  = 0;
         startPos = 1;
         dow   startPos > 0;
            numLine = numLine + 1;
            aLine = f_wordWrap(theText: i_width: startPos:
                               cWORDWRAP_PARAGRAPH_MSGD) + '<';
            msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         enddo;

         // Perform word wrap with respect to standard text
         // end-of-paragraph markers:
         theText = f_replace('&N': '\n': theText);
         theText = f_replace('&B': '\N': theText);
         theText = f_replace('&P': '\n': theText);

         msg = f_newMsg('': '*** Standard text EOP charcaters: ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         numLine  = 0;
         startPos = 1;
         dow   startPos > 0;
            numLine = numLine + 1;
            aLine = f_wordWrap(theText: i_width: startPos:
                               cWORDWRAP_PARAGRAPH_TEXT) + '<';
            msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         enddo;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
