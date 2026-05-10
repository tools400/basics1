**free
//===============================================================*
//    CALL PGM(TEST_R3_01) PARM('-123.456,789')                  *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_01');
  gi_strVal char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_strVal char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_strVal char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_strVal));
  main(gi_strVal);
else;
  main('');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_strVal char(32) const;
  end-pi;

  //  Helper fields
  dcl-s numVal float(8) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  numVal = f_val('  $   1.605,25  ');
  msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  numVal = f_val('-123,5');
  msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  numVal = f_val('123,5-');
  msg = f_newMsg('': %editc(%dec(numVal: 20: 5): 'N'));
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  if (i_strVal <> '');
    numVal = f_val(i_strVal);
    msg = f_newMsg('': %editc(%dec(numVal: 30: 9): 'N'));
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  return;


end-proc main;
