      *===============================================================*
      *    CALL PGM(TEST_R5_01) PARM('CHKOB' 'QSYS' '*CMD')           *
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
     D                 PR                         extpgm('TEST_R5_01')
     D  gi_obj                       10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
     D  gi_type                      10A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_obj                              const  like(gi_obj    )
     D  i_lib                              const  like(gi_lib    )
     D  i_type                             const  like(gi_type   )
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_obj                       10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
     D  gi_type                      10A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_type));
            main(gi_obj: gi_lib: gi_type);
         else;
            main('QCPFMSG': 'QSYS': '*MSGF');
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
     D  i_obj                              const  like(gi_obj    )
     D  i_lib                              const  like(gi_lib    )
     D  i_type                             const  like(gi_type   )
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if   not f_exist(i_lib: *omit: '*LIB');
            msg = f_newMsg('CPF9898': 'Library ' + %trim(i_lib)
                                      + ' does not exist');
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         else;
            if   not f_exist(i_obj: i_lib: i_type);
               msg = f_newMsg('CPF9898': 'Object ' + %trim(i_lib) + '/'
                                         + %trim(i_obj) + ' (' + %trim(i_type)
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
