      *===============================================================*
      *    CALL PGM(TEST_R3_11) PARM(x'C88593939640E696999384')       *
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
     D                 PR                         extpgm('TEST_R3_11')
     D  gi_buffer                    32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_buffer                     32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_buffer                    32A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_buffer));
            main(gi_buffer);
         else;
            main('Hello World!');
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
     D  i_buffer                     32A   const
      *
      *  Helper fields
     D size            S              5I 0                inz
     D buffer          S                   like(i_buffer) inz
     D string          S             64A   varying        inz
     D msgText         S            128A                  inz
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Convert a buffer to a hex string.
         buffer = i_buffer;
         size   = %len(%trimR(buffer));
         string = f_cvtBufferToHexString(%addr(buffer): size);

         msgText = 'Buffer: ''' + %trimR(buffer) + '''' +
                   ' ==> Hex-String: ''' + string + '''';
         msg = f_newMsg(cMsg_ID_NONE: msgText);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Convert a string of hex values to a buffer
         string = 'C140A297818385948195408381948540A39981A5859393899587';
         size = f_cvtHexStringToBuffer(string: %addr(buffer): %size(buffer));

         msgText = 'Hex-String: ''' + string + '''' +
                   ' ==> Buffer: ''' + %subst(buffer: 1: size) + '''';
         msg = f_newMsg(cMsg_ID_NONE: msgText);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
