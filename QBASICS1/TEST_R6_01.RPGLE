**free
//===============================================================*
//    CALL PGM(TEST_R6_01) PARM('CHKOBJ QSY *LIB')               *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R6_01');
  gi_cmd char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_cmd char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_cmd char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_cmd));
  main(gi_cmd);
else;
  main('DLYJOB DLY(1)');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_cmd char(32) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Ignore Errors
  msg = f_newMsg('CPF9897': '*** Ignore Errors ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  if   not f_execute(i_cmd: *omit: *omit);
    msg = f_newMsg('CPF9898': 'Error on: ' + %trim(i_cmd));
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  // Return error information
  msg = f_newMsg('CPF9897': '*** Return error information ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  if   not f_execute(i_cmd: *omit: msg);
    // Do not let the program crash here
    msg.type = cMsg_Diag;
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  // Send *ESCAPE message to signal error
  msg = f_newMsg('CPF9897': '*** Send *ESCAPE message ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  f_execute(i_cmd: *omit);

  return;


end-proc main;
