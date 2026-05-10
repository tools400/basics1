**free
//===============================================================*
//    CALL PGM(TEST_R3_03) PARM('Hello World!')                  *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_03');
  gi_text char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_text char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_text char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_text));
  main(gi_text);
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
    i_text char(32) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  dcl-s aString varchar(128) inz;
  dcl-s leftLen int(10) inz;
  dcl-s rightLen int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  aString = f_space(5) + %trim(i_text) + f_space(5);
  msg = f_newMsg('': aString + '<');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  aString = f_space(5: '*') + %trim(i_text) + f_space(5: '*');
  msg = f_newMsg('': aString + '<');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  aString = f_space(5: '%') + %trim(i_text) + f_space(5: '%');
  msg = f_newMsg('': aString + '<');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  aString = f_space(5: '-') + %trim(i_text) + f_space(5: '-');
  leftLen  = %int(%len(aString) / 2);
  rightLen = %len(aString) - leftLen;

  msg = f_newMsg('': f_left(aString: leftLen) + '<');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  msg = f_newMsg('': f_right(aString: rightLen) + '<');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
