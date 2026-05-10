**free
//===============================================================*
//    CALL PGM(TEST_R3_04) PARM('CR+LF')                         *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_04');
  gi_rplStr char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_rplStr char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_rplStr char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_rplStr));
  main(gi_rplStr);
else;
  main('Hello World!');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_rplStr char(32) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  dcl-s msgText varchar(1024) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Retrieve a message and replace &N with i_rplStr.
  msg = f_newMsg('CAE0009');
  msgText = f_rtvMsgHelpText(msg: cMsg_RtnCtrlChar_Yes: *omit);

  msgText = f_replace('&N': %trimR(i_rplStr): msgText);

  // Show the text with the replacements.
  msg = f_newMsg(cMSG_ID_NONE: msgText);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
