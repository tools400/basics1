      *===============================================================*
      *    CALL PGM(TEST_R7_01)                                       *
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
     D                 PR                         extpgm('TEST_R7_01')
      *
     D main...
     D                 PR
      *
     D lf_openFile...
     D                 PR
     D  i_openFlags                  10U 0 const
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
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create file and replace data
         msg = f_newMsg(cMSG_ID_NONE: '*** CREATE + REPLACE ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         lf_openFile(cFILE_CREATE + cFILE_REPLACE);

         // Append data
         msg = f_newMsg(cMSG_ID_NONE: '*** APPEND ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         lf_openFile(cFILE_APPEND);

         // Append and replace data
         msg = f_newMsg(cMSG_ID_NONE: '*** APPEND + REPLACE ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         lf_openFile(cFILE_APPEND + cFILE_REPLACE);

         // Bits are zero. ==> Error
         msg = f_newMsg(cMSG_ID_NONE: '*** Bits are zero ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         monitor;
            f_isBitOn(0: 5);
         on-error;
            msg = f_newMsg(cMSG_ID_NONE: 'Error monitored.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endmon;

         // End message
         msg = f_newMsg(cMSG_ID_NONE: '*** END OF TEST ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
      *===============================================================*
      *  Dummy: Open a file.
      *===============================================================*
     P lf_openFile...
     P                 B
      *
     D lf_openFile...
     D                 PI
     D  i_openFlags                  10U 0 const
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Check CREATE flag
         if   f_isBitOn(cFILE_CREATE: i_openFlags);
            msg = f_newMsg(cMSG_ID_NONE: 'If the file being opened does not +
                                          exist, it is created.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Check APPEND + REPLACE flag
         if   f_isBitOn(cFILE_APPEND + cFILE_REPLACE: i_openFlags);
            msg = f_newMsg(cMSG_ID_NONE: 'APPEND + REPLACE must not be +
                                          specified together.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            return;
         endif;

         // Check REPLACE flag
         if   f_isBitOn(cFILE_REPLACE: i_openFlags);
            msg = f_newMsg(cMSG_ID_NONE: 'Replace existing data +
                                          if the file exists.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         // Check APPEND flag
         if   f_isBitOn(cFILE_APPEND: i_openFlags);
            msg = f_newMsg(cMSG_ID_NONE: 'Append new data to the end of the +
                                          file.');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P lf_openFile...
     P                 E
      *
