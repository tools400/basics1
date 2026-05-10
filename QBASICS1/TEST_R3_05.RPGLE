**free
//===============================================================*
//    CALL PGM(TEST_R3_05) PARM('Hello World! ')           *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_05');
  gi_string char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_string char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_string char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_string));
  main(gi_string);
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
    i_string char(32) const;
  end-pi;

  //  Helper fields
  dcl-s string varchar(32) inz;
  dcl-ds msg likeds(msg_t) inz;
  dcl-s msgText varchar(1024) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Convert i_string to lower case.
  msg = f_newMsg('CPF9897': 'Lower string is: ' + f_lcase(i_string));

  // Show converted string
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Convert i_string to upper case.
  msg = f_newMsg('CPF9897': 'Upper string is: ' + f_ucase(i_string));

  // Show converted string
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
