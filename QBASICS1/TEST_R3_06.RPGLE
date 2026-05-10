**free
//===============================================================*
//    CALL PGM(TEST_R3_06)                                       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_06');
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
  dcl-s digits uns(5) inz;
  dcl-s fraction uns(5) inz;
  dcl-s length uns(5) inz;
  dcl-s editCode char(1) inz;
  dcl-s editWord varchar(32) inz;
  dcl-s fmtString varchar(64) inz;
  dcl-s num64 zoned(6: 4) inz(*loval);
  dcl-s num74 zoned(7: 4) inz(*loval);
  dcl-s num84 zoned(8: 4) inz(*loval);
  dcl-s num94 zoned(9: 4) inz(*hival);
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Test a numeric 6,4 variable with edit code 'B'
  digits    = %len(num64);
  fraction  = %decpos(num64);
  editCode  = 'B';
  length    = f_getLengthEditCode(digits: fraction: editCode);
  fmtString = %editc(num64: 'B');

  p_assert(length = %len(fmtString));

  msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                 ''' is: ' + %editc(length: 'Z') +
                 ' (' + fmtString + ')');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Test a numeric 7,4 variable with edit code 'L'
  digits    = %len(num74);
  fraction  = %decpos(num74);
  editCode  = 'L';
  length    = f_getLengthEditCode(digits: fraction: editCode);
  fmtString = %editc(num74: 'L');

  p_assert(length = %len(fmtString));

  msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                 ''' is: ' + %editc(length: 'Z') +
                 ' (' + fmtString + ')');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Test a numeric 8,4 variable with edit code 'X' (negative value)
  digits    = %len(num84);
  fraction  = %decpos(num84);
  editCode  = 'X';
  length    = f_getLengthEditCode(digits: fraction: editCode);
  fmtString = %editc(num84: 'X');

  p_assert(length = %len(fmtString));

  msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                 ''' is: ' + %editc(length: 'Z') +
                 ' (' + fmtString + ')');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Test a numeric 9,4 variable with edit code 'X' (positive value)
  digits    = %len(num94);
  fraction  = %decpos(num94);
  editCode  = 'X';
  length    = f_getLengthEditCode(digits: fraction: editCode);
  fmtString = %editc(num94: 'X');

  p_assert(length = %len(fmtString));

  msg = f_newMsg(cMSG_ID_NONE: 'Length of edit code ''' + editCode +
                 ''' is: ' + %editc(length: 'Z') +
                 ' (' + fmtString + ')');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Test a numeric 7,4 variable with edit word ' -  /    '
  digits    = %len(num74);
  fraction  = 0;
  editWord  = ' -  /    ';
  length    = f_getLengthEditWord(digits: editWord);
  fmtString = %editw(num74: ' -  /    ');

  p_assert(length = %len(fmtString));

  msg = f_newMsg(cMSG_ID_NONE: 'Length of edit word ''' + editWord +
                 ''' is: ' + %editc(length: 'Z') +
                 ' (' + fmtString + ')');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
