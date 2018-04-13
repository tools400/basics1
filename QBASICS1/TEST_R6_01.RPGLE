      *===============================================================*
      *    CALL PGM(TEST_R6_01) PARM('CHKOBJ QSY *LIB')               *
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
     D                 PR                         extpgm('TEST_R6_01')
     D  gi_cmd                       32A   const
      *
     D main...
     D                 PR
     D  i_cmd                        32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_cmd                       32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(gi_cmd);

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
     D  i_cmd                        32A   const
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Ignore Errors
         msg = f_newMsg('CPF9897': '*** Ignore Errors ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         if   not f_execute(i_cmd: *omit: *omit);
            msg = f_newMsg('CPF9898': 'Error on: ' + %trim(i_cmd));
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Return error information
         msg = f_newMsg('CPF9897': '*** Return error information ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         if   not f_execute(i_cmd: *omit: msg);
            // Do not let the program crash here
            msg.type = cMsg_Diag;
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Send *ESCAPE message to signal error
         msg = f_newMsg('CPF9897': '*** Send *ESCAPE message ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         f_execute(i_cmd: *omit);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
