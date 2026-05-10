**free
//===============================================================*
//    CALL PGM(TEST_R7_02)                                       *
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
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------
dcl-c cFILE_CREATE 1;
dcl-c cFILE_REPLACE 2;
dcl-c cFILE_APPEND 4;

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R7_02');
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
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;

  dcl-s rpgLEngth uns(5) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Compute length of a 1-byte integer field ( 3 I 0)
  rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(1);

  msg = f_newMsg(cMSG_ID_NONE: 'Length of 1-byte integer is: ' +
                 %editc(rpgLength: 'Z'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Compute length of a 2-byte integer field ( 5 I 0)
  rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(2);

  msg = f_newMsg(cMSG_ID_NONE: 'Length of 2-byte integer is: ' +
                 %editc(rpgLength: 'Z'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Compute length of a 4-byte integer field (10 I 0)
  rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(4);

  msg = f_newMsg(cMSG_ID_NONE: 'Length of 4-byte integer is: ' +
                 %editc(rpgLength: 'Z'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Compute length of a 8-byte integer field (20 I 0)
  rpgLength = f_clcLengthOfRPGIntFieldFromBufSize(8);

  msg = f_newMsg(cMSG_ID_NONE: 'Length of 8-byte integer is: ' +
                 %editc(rpgLength: 'Z'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
