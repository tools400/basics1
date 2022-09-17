      *===============================================================*
      *  CALL PGM(TEST_R5_02) PARM('QRPGSRC' 'QGPL' '*FILE' '*FIRST') *
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
     D                 PR                         extpgm('TEST_R5_02')
     D  gi_file                      10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
     D  gi_mbr                       10A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_file                             const  like(gi_file   )
     D  i_lib                              const  like(gi_lib    )
     D  i_mbr                              const  like(gi_mbr    )
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_file                      10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
     D  gi_mbr                       10A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_mbr));
            main(gi_file: gi_lib: gi_mbr);
         else;
            main('QBASICS1': '*LIBL': 'TEST_R5_02');
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
     D  i_file                             const  like(gi_file   )
     D  i_lib                              const  like(gi_lib    )
     D  i_mbr                              const  like(gi_mbr    )
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (not f_startsWith('*': i_lib) and
             not f_exist(i_lib: *omit: '*LIB'));
            msg = f_newMsg('CPF9898': 'Library ' + %trim(i_lib)
                                      + ' does not exist');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         else;
            if   not f_exist(i_file: i_lib: '*FILE': i_mbr);
               msg = f_newMsg('CPF9898': 'Member ' + %trim(i_lib) + '/'
                                         + %trim(i_file) + ' (' + %trim(i_mbr)
                                         + ') does not exist');
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            else;
               msg = f_newMsg('CPF9897': 'Done');
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            endif;
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
