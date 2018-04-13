      *===============================================================*
      *    CALL PGM(TEST_R1_03)                                       *
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
     D                 PR                         extpgm('TEST_R1_03')
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
     D lib             S             10A   inz
     D msg             DS                  likeds(msg_t     ) inz
     D msgRcv          DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         lib = f_getObjLib('QCPFMSG': '*LIBL': '*MSGF');

         // Create a message, send it to myself and then receive it
         msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
                        : cMsg_Info: 'QCPFMSG': lib);
         f_sndPgmMsg(msg: cMsg_Same: cMsg_ToMyself);
         msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                                 : cMsg_Same: cMsg_ToMyself);
         p_assert(msg.ID = msgRcv.ID
                  : 'msgRcv.ID und msg.ID dürfen nicht voneinander abweichen');
         p_assert(msg.data = msgRcv.data
                  : 'msgRcv.data und msg.data dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.type = msgRcv.type
                  : 'msgRcv.type und msg.type dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.file = msgRcv.file
                  : 'msgRcv.file und msg.file dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.lib = msgRcv.lib
                  : 'msgRcv.lib und msg.lib dürfen +
                     nicht voneinander abweichen');

         // Create a message, send it to 'previous' and then receive it
         msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
                        : cMsg_Info: 'QCPFMSG': lib);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
         msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                                 : cMsg_Prv: cMsg_ToMyself);
         p_assert(msg.ID = msgRcv.ID
                  : 'msgRcv.ID und msg.ID dürfen nicht voneinander abweichen');
         p_assert(msg.data = msgRcv.data
                  : 'msgRcv.data und msg.data dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.type = msgRcv.type
                  : 'msgRcv.type und msg.type dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.file = msgRcv.file
                  : 'msgRcv.file und msg.file dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.lib = msgRcv.lib
                  : 'msgRcv.lib und msg.lib dürfen +
                     nicht voneinander abweichen');

         // Create a message, send it to 'extern' and then receive it
         msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
                        : cMsg_Info: 'QCPFMSG': lib);
         f_sndPgmMsg(msg: cMsg_Ext);
         msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                                 : cMsg_Ext);
         p_assert(msg.ID = msgRcv.ID
                  : 'msgRcv.ID und msg.ID dürfen nicht voneinander abweichen');
         p_assert(msg.data = msgRcv.data
                  : 'msgRcv.data und msg.data dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.type = msgRcv.type
                  : 'msgRcv.type und msg.type dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.file = msgRcv.file
                  : 'msgRcv.file und msg.file dürfen +
                     nicht voneinander abweichen');
         p_assert(msg.lib = msgRcv.lib
                  : 'msgRcv.lib und msg.lib dürfen +
                     nicht voneinander abweichen');

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
