      *===============================================================*
      *    CALL PGM(TEST_R4_01) PARM('1')                             *
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
     D                 PR                         extpgm('TEST_R4_01')
     D  gi_boolean                    1A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_boolean                      N   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_boolean                    1A   const  options(*nopass)
      *
      *  Local helper fields
     D msg             DS                  likeds(msg_t     ) inz
     D procedure       S            256A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         procedure = f_this();
         msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                            + '*N' + '.'
                                            + %trimR(procedure));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         if (%parms() >= %parmNum(gi_boolean));
            main(gi_boolean);
         else;
            main(*on);
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
     D  i_boolean                      N   const
      *
      *  Local helper fields
     D msg             DS                  likeds(msg_t     ) inz
     D procedure       S            256A   inz
     D module          S             10A   inz
     D program         S             10A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         procedure = f_this();
         msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                            + '*N' + '.'
                                            + %trimR(procedure));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         procedure = f_this(module);
         msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                            + %trimR(module) + '.'
                                            + %trimR(procedure));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         procedure = f_this(module: program);
         msg = f_newMsg(cMSG_ID_NONE: '=> ' + %trimR(program) + '/'
                                            + %trimR(module) + '.'
                                            + %trimR(procedure));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         procedure = f_caller(module: program);
         msg = f_newMsg(cMSG_ID_NONE: '=> ' + %trimR(program) + '/'
                                            + %trimR(module) + '.'
                                            + %trimR(procedure));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         p_assert(i_boolean                        :                                        //RADDAT
                  'Error detected by p_assert()'   );

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
