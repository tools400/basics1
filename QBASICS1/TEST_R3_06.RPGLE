      *===============================================================*
      *    CALL PGM(TEST_R3_06)                                       *
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
     D                 PR                         extpgm('TEST_R3_06')
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
     D digits          S              5U 0 inz
     D fraction        S              5U 0 inz
     D length          S              5U 0 inz
     D editCode        S              1A   inz
     D editWord        S             32A   inz varying
     D fmtString       S             64A   inz varying
     D num64           S              6S 4 inz(*LOVAL)
     D num74           S              7S 4 inz(*LOVAL)
     D num84           S              8S 4 inz(*LOVAL)
     D num94           S              9S 4 inz(*HIVAL)
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Test a numeric 6,4 variable with edit code 'B'
         digits    = %len(num64);
         fraction  = %decpos(num64);
         editCode  = 'B';
         length    = f_getLengthEditCode(digits: fraction: editCode);
         fmtString = %editc(num64: 'B');

         p_assert(length = %len(fmtString));

         msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                        ''' is: ' + %editc(length: 'Z') +
                        ' (' + fmtString + ')');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Test a numeric 7,4 variable with edit code 'L'
         digits    = %len(num74);
         fraction  = %decpos(num74);
         editCode  = 'L';
         length    = f_getLengthEditCode(digits: fraction: editCode);
         fmtString = %editc(num74: 'L');

         p_assert(length = %len(fmtString));

         msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                        ''' is: ' + %editc(length: 'Z') +
                        ' (' + fmtString + ')');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Test a numeric 8,4 variable with edit code 'X' (negative value)
         digits    = %len(num84);
         fraction  = %decpos(num84);
         editCode  = 'X';
         length    = f_getLengthEditCode(digits: fraction: editCode);
         fmtString = %editc(num84: 'X');

         p_assert(length = %len(fmtString));

         msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                        ''' is: ' + %editc(length: 'Z') +
                        ' (' + fmtString + ')');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Test a numeric 9,4 variable with edit code 'X' (positive value)
         digits    = %len(num94);
         fraction  = %decpos(num94);
         editCode  = 'X';
         length    = f_getLengthEditCode(digits: fraction: editCode);
         fmtString = %editc(num94: 'X');

         p_assert(length = %len(fmtString));

         msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                        ''' is: ' + %editc(length: 'Z') +
                        ' (' + fmtString + ')');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Test a numeric 7,4 variable with edit word ' -  /    '
         digits    = %len(num74);
         fraction  = 0;
         editWord  = ' -  /    ';
         length    = f_getLengthEditWord(digits: editWord);
         fmtString = %editw(num74: ' -  /    ');

         p_assert(length = %len(fmtString));

         msg = f_newMsg(cMSG_ID_NONE: 'Length of edit word ''' + editWord +
                        ''' is: ' + %editc(length: 'Z') +
                        ' (' + fmtString + ')');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
