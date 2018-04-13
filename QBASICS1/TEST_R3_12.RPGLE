      *===============================================================*
      *    CALL PGM(TEST_R3_12) PARM('SYSPROCS' 'QSYS2')              *
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
     D                 PR                         extpgm('TEST_R3_12')
     D  gi_name                      10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_name                       10A   const
     D  i_lib                        10A   const
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_name                      10A   const  options(*nopass)
     D  gi_lib                       10A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= 2);
            main(gi_name: gi_lib);
         else;
            main('SYSPROCS': 'QSYS2');
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
     D  i_name                       10A   const
     D  i_lib                        10A   const
      *
      *  Helper fields
     D objName         S             21A   inz
     D qObj            DS                  likeds(qObj_t) inz
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qObj.name = i_name;
         qObj.lib  = i_lib;
         objName = f_objname(qObj);

         p_assert(objName = %trimR(i_lib) + '/' + %trimR(i_name)
                  : 'Fehler in Funktion f_objName()');

         msg = f_newMsg(cMsg_ID_NONE: 'Qualified object name 1 is: ' + objName);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         objName = f_objname(i_name: i_lib);

         p_assert(objName = %trimR(i_lib) + '/' + %trimR(i_name)
                  : 'Fehler in Funktion f_objName()');

         msg = f_newMsg(cMsg_ID_NONE: 'Qualified object name 2 is: ' + objName);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
