**FREE
//===============================================================*
//    CALL PGM(TEST_R3_14)                                       *
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
       extpgm('TEST_R3_14');
end-pr;

dcl-pr main;
end-pr;

dcl-pr displayMemSize;
  i_memSize       int(20) value;
  i_unit          char(2) value  options(*nopass);
  i_decPos        int(10) value  options(*nopass);
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
//  Display result.
//===============================================================*
dcl-proc displayMemSize;

dcl-pi displayMemSize;
  i_memSize       int(20) value;
  i_unit          char(2) value  options(*nopass);
  i_decPos        int(10) value  options(*nopass);
end-pi;

//  Helper fields
dcl-s memSize         like(i_memSize) inz;
dcl-s unit            like(i_unit   ) inz;
dcl-s decPos          like(i_decPos ) inz;
dcl-s msgText         varchar(128) inz;
dcl-s formatted       varchar(64) inz;
dcl-ds msg likeds(msg_t ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 2);
   unit = i_unit;
else;
   unit = '';
endif;

if (%parms() >= 3);
   decPos = i_decPos;
else;
   decPos = 7;
endif;

if (%rem(i_memSize: 1024) <> 0);
   memSize = i_memSize * 1.3;
else;
   memSize = i_memSize;
endif;

msgText = %editc(memSize: 'Z') + ' Bytes = ' +
          f_formatMemSize(memSize: unit: decPos) + ' ' + unit;

msg = f_newMsg(cMsg_ID_NONE: msgText);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc displayMemSize;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
end-pi;

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

displayMemSize(1024);
displayMemSize((1024**1) + 1);

displayMemSize(1024**2);
displayMemSize((1024**2) + 1);

displayMemSize(600: '': 7);
displayMemSize(600: cMEM_SIZE_KILO_BYTE: 7);

displayMemSize(60000000: '': 7);
displayMemSize(60000000: cMEM_SIZE_KILO_BYTE: 7);

return;


end-proc main;

