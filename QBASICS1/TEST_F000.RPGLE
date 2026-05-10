**free
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_F000');
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
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


  return;


end-proc main;
