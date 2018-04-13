      *===============================================================*
      *    CALL PGM(TEST_R3_14)                                       *
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
     D                 PR                         extpgm('TEST_R3_14')
      *
     D main...
     D                 PR
      *
     D displayMemSize...
     D                 PR
     D  i_memSize                    20I 0 value
     D  i_unit                        2A   value  options(*nopass)
     D  i_decPos                     10I 0 value  options(*nopass)
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
      *  Display result.
      *===============================================================*
     P displayMemSize...
     P                 B
      *
     D displayMemSize...
     D                 PI
     D  i_memSize                    20I 0 value
     D  i_unit                        2A   value  options(*nopass)
     D  i_decPos                     10I 0 value  options(*nopass)
      *
      *  Helper fields
     D memSize         S                   like(i_memSize) inz
     D unit            S                   like(i_unit   ) inz
     D decPos          S                   like(i_decPos ) inz
     D msgText         S            128A   varying inz
     D formatted       S             64A   varying inz
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= 2);
            unit = i_unit;
         else;
            unit = '';
         endif;

         if (%parms() >= 3);
            decPos = i_decPos;
         else;
            decPos = 7;
         endif;

         if (%rem(i_memSize: 1024) <> 0);
            memSize = i_memSize * 1.3;
         else;
            memSize = i_memSize;
         endif;

         msgText = %editc(memSize: 'Z') + ' Bytes = ' +
                   f_formatMemSize(memSize: unit: decPos) + ' ' + unit;

         msg = f_newMsg(cMsg_ID_NONE: msgText);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P displayMemSize...
     P                 E
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
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         displayMemSize(1024);
         displayMemSize((1024**1) + 1);

         displayMemSize(1024**2);
         displayMemSize((1024**2) + 1);

         displayMemSize(600: '': 7);
         displayMemSize(600: cMEM_SIZE_KILO_BYTE: 7);

         displayMemSize(60000000: '': 7);
         displayMemSize(60000000: cMEM_SIZE_KILO_BYTE: 7);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
