**FREE
//===============================================================*
//    CALL PGM(TEST_R3_08)                                       *
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
       extpgm('TEST_R3_08');
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
dcl-s string          varchar(128) inz;

dcl-ds msg likeds(msg_t      ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Center a literal into a string
string = f_space(40);
string = '>' + f_center('Hello World': %len(string)) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Centered (literal)  : ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Center a given string
string = 'Hello World' + f_space(29);   // = 40 characters
string = '>' + f_center(string) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Centered (string)   : ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Center a given string, target too small
string = f_space(5);
string = '>' + f_center('Hello World': %len(string)) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Centered (too small): ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Right align a literal into a string
string = f_space(40);
string = '>' + f_alignR('Hello World': %len(string)) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (literal)  : ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Right align a given string
string = 'Hello World' + f_space(29);   // = 40 characters
string = '>' + f_alignR(string) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (string)   : ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Right align a given string, target too small
string = f_space(5);
string = '>' + f_alignR('Hello World': %len(string)) + '<';
msg = f_newMsg(cMSG_ID_NONE: 'Aligned  (too small): ' + string);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

