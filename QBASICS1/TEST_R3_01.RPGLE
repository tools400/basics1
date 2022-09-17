      *===============================================================*
      *    CALL PGM(TEST_R3_01) PARM('-123.456,789')                  *
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
     D                 PR                         extpgm('TEST_R3_01')
     D  gi_strVal                    32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_strVal                     32A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_strVal                    32A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_strVal));
            main(gi_strVal);
         else;
            main('');
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
     D  i_strVal                     32A   const
      *
      *  Helper fields
     D numVal          S              8F                      inz
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         numVal = f_val('  $   1.605,25  ');
         msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         numVal = f_val('-123,5');
         msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         numVal = f_val('123,5-');
         msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         if (i_strVal <> '');
            numVal = f_val(i_strVal);
            msg = f_newMsg('': %editc(%dec(numVal: 30: 9): 'N'));
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
