      *===============================================================*
      *    CALL PGM(TEST_R3_13)                                       *
      *         PARM('2009-01-23' 'YYYY-MM-DD' 'ZD Mmmmmmmmmz YYYY')  *
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
     D                 PR                         extpgm('TEST_R3_13')
     D  gi_date_str                  32A   const  options(*nopass)
     D  gi_pic_str                   32A   const  options(*nopass)
     D  gi_fmt_str                   32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_date_str                   32A   const  varying
     D  i_pic_str                    32A   const  varying
     D  i_fmt_str                    32A   const  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_date_str                  32A   const  options(*nopass)
     D  gi_pic_str                   32A   const  options(*nopass)
     D  gi_fmt_str                   32A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= 3);
            main(%trim(gi_date_str): %trim(gi_pic_str): %trim(gi_fmt_str));
         else;
            main(%char(%date(): *ISO): 'YYYY-MM-DD': 'ZD. Mmmmmmmmmz YYYY');
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
     D  i_date_str                   32A   const  varying
     D  i_pic_str                    32A   const  varying
     D  i_fmt_str                    32A   const  varying
      *
      *  Helper fields
     D date            S               D   inz
     D date_str        S             64A   inz varying
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         date = f_parseDate(i_date_str: i_pic_str);

         date_str = f_formatDate(date: i_fmt_str);

         msg = f_newMsg(cMsg_ID_NONE: 'Converted ' + f_addQuotes(i_date_str) +
                        ' to date ' + %char(date: *EUR) + ' and string: ' +
                        date_str);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
