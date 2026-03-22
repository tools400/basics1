**FREE
//===============================================================*
//    CALL PGM(TEST_R1_03)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt DEBUG OPTION(*SRCSTMT : *NODEBUGIO);
ctl-opt DECEDIT('0,') DATEDIT(*DMY.);
ctl-opt DATFMT(*ISO )  TIMFMT(*ISO );
ctl-opt EXPROPTS(*RESDECPOS);
ctl-opt EXTBININT(*YES);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_R1_03');
end-pr;

dcl-pr main;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
end-pi;

//  Helper fields
dcl-s lib             char(10) inz;
dcl-ds msg likeds(msg_t     ) inz;
dcl-ds msgRcv likeds(msg_t     ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

lib = f_getObjLib('QCPFMSG': '*LIBL': '*MSGF');

// Create a message, send it to myself and then receive it
msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
               : cMsg_Info: 'QCPFMSG': lib);
f_sndPgmMsg(msg: cMsg_Same: cMsg_ToMyself);
msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                        : cMsg_Same: cMsg_ToMyself);
p_assert(msg.ID = msgRcv.ID
         : 'msgRcv.ID und msg.ID drfen nicht voneinander abweichen');
p_assert(msg.data = msgRcv.data
         : 'msgRcv.data und msg.data drfen +
            nicht voneinander abweichen');
p_assert(msg.type = msgRcv.type
         : 'msgRcv.type und msg.type drfen +
            nicht voneinander abweichen');
p_assert(msg.file = msgRcv.file
         : 'msgRcv.file und msg.file drfen +
            nicht voneinander abweichen');
p_assert(msg.lib = msgRcv.lib
         : 'msgRcv.lib und msg.lib drfen +
            nicht voneinander abweichen');

// Create a message, send it to 'previous' and then receive it
msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
               : cMsg_Info: 'QCPFMSG': lib);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);
msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                        : cMsg_Prv: cMsg_ToMyself);
p_assert(msg.ID = msgRcv.ID
         : 'msgRcv.ID und msg.ID drfen nicht voneinander abweichen');
p_assert(msg.data = msgRcv.data
         : 'msgRcv.data und msg.data drfen +
            nicht voneinander abweichen');
p_assert(msg.type = msgRcv.type
         : 'msgRcv.type und msg.type drfen +
            nicht voneinander abweichen');
p_assert(msg.file = msgRcv.file
         : 'msgRcv.file und msg.file drfen +
            nicht voneinander abweichen');
p_assert(msg.lib = msgRcv.lib
         : 'msgRcv.lib und msg.lib drfen +
            nicht voneinander abweichen');

// Create a message, send it to 'extern' and then receive it
msg = f_newMsg('CPF9897': 'Hello World: ' + %char(%timestamp())
               : cMsg_Info: 'QCPFMSG': lib);
f_sndPgmMsg(msg: cMsg_Ext);
msgRcv = f_rcvPgmMsgObj(cMsg_Last: *omit: cMsg_Act_Same: 0
                        : cMsg_Ext);
p_assert(msg.ID = msgRcv.ID
         : 'msgRcv.ID und msg.ID drfen nicht voneinander abweichen');
p_assert(msg.data = msgRcv.data
         : 'msgRcv.data und msg.data drfen +
            nicht voneinander abweichen');
p_assert(msg.type = msgRcv.type
         : 'msgRcv.type und msg.type drfen +
            nicht voneinander abweichen');
p_assert(msg.file = msgRcv.file
         : 'msgRcv.file und msg.file drfen +
            nicht voneinander abweichen');
p_assert(msg.lib = msgRcv.lib
         : 'msgRcv.lib und msg.lib drfen +
            nicht voneinander abweichen');

return;


end-proc main;

