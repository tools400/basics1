      *===============================================================*
      *    CALL PGM(TEST_R3_09)                                       *
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
     D                 PR                         extpgm('TEST_R3_09')
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
     D isEqual         S               N   inz
     D text            C                   const('+
     D                                     A spaceman came travelling on his +
     D                                     ship from afar, +
     D                                     ''twas light years of time since +
     D                                     his mission did start, +
     D                                     And over a village he halted his +
     D                                     craft, +
     D                                     And it hung in the sky like a +
     D                                     star, just like a star...')
     D searchArg       S            256A   inz   varying
     D searchText      S             32A   inz   varying
     D startPos        S             10I 0 inz
     D position        S             10I 0 inz
      *
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg(cMsg_ID_NONE: text);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         startPos  = %len(text);
         searchArg = 'star';
         position  = f_scanR(searchArg: text);
         exsr sndMsg;

         startPos  = 190;
         searchArg = 'star';
         position  = f_scanR(searchArg: text: startPos);
         exsr sndMsg;

         startPos  = 170;
         searchArg = 'star';
         position  = f_scanR(searchArg: text: startPos);
         exsr sndMsg;

         startPos  = 90;
         searchArg = 'star';
         position  = f_scanR(searchArg: text: startPos);
         exsr sndMsg;

         startPos  = %len(text);
         searchArg = text;
         position  = f_scanR(searchArg: text: startPos);
         exsr sndMsg;

         msg = f_newMsg(cMsg_ID_NONE: '- Search argument longer than text: -');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         startPos  = %len(text);
         searchArg = text + ' an extension';
         position  = f_scanR(searchArg: text: startPos);
         exsr sndMsg;

         return;

         begsr sndMsg;

         if %len(searchArg) > 10;
            searchText = %subst(searchArg: 1: 10) + ' ...';
         else;
            searchText = searchArg;
         endif;

         if position = 0;
            msg = f_newMsg(cMsg_ID_NONE: 'Search argument ''' +
                           searchText +
                           ''' was not found before position ' +
                           %char(startPos) + '.');
         else;
            msg = f_newMsg(cMsg_ID_NONE: 'Search argument ''' +
                                         searchText +
                                         ''' found at position ' +
                                         %char(position) + '. ' +
                                         'Start position: ' + %char(startPos));
         endif;

         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         endsr;

      /END-FREE
      *
     P main...
     P                 E
      *
