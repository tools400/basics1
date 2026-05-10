**free
//===============================================================*
//    CALL PGM(TEST_R3_07)                                       *
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

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_07');
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
  dcl-s string varchar(128) inz;
  dcl-s kwdValue varchar(128) inz;
  dcl-c cCMD 'PGM(*LIBL/QCMDEXC';
  dcl-c cKEYWORD_PGM 'PGM';

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  string   = cCMD;
  kwdValue = f_rmvKeyword(cKEYWORD_PGM: string);

  msg = f_newMsg(cMSG_ID_NONE: 'The value of ' + cKEYWORD_PGM +
                 ' is: ' + kwdValue);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
