**free
//===============================================================*
//    CALL PGM(TEST_R7_01)                                       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R7_01');
end-pr;

dcl-pr main;
end-pr;

dcl-pr lf_openFile;
  i_openFlags uns(10) const;
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

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create file and replace data
  msg = f_newMsg(cMSG_ID_NONE: '*** CREATE + REPLACE ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  lf_openFile(cFILE_CREATE + cFILE_REPLACE);

  // Append data
  msg = f_newMsg(cMSG_ID_NONE: '*** APPEND ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  lf_openFile(cFILE_APPEND);

  // Append and replace data
  msg = f_newMsg(cMSG_ID_NONE: '*** APPEND + REPLACE ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  lf_openFile(cFILE_APPEND + cFILE_REPLACE);

  // Bits are zero. ==> Error
  msg = f_newMsg(cMSG_ID_NONE: '*** Bits are zero ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  monitor;
    f_isBitOn(0: 5);
  on-error;
    msg = f_newMsg(cMSG_ID_NONE: 'Error monitored.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endmon;

  // End message
  msg = f_newMsg(cMSG_ID_NONE: '*** END OF TEST ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;

//===============================================================*
//  Dummy: Open a file.
//===============================================================*
dcl-proc lf_openFile;
  dcl-pi *n;
    i_openFlags uns(10) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Check CREATE flag
  if   f_isBitOn(cFILE_CREATE: i_openFlags);
    msg = f_newMsg(cMSG_ID_NONE: 'If the file being opened does not +
                                  exist, it is created.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  // Check APPEND + REPLACE flag
  if   f_isBitOn(cFILE_APPEND + cFILE_REPLACE: i_openFlags);
    msg = f_newMsg(cMSG_ID_NONE: 'APPEND + REPLACE must not be +
                                  specified together.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    return;
  endif;

  // Check REPLACE flag
  if   f_isBitOn(cFILE_REPLACE: i_openFlags);
    msg = f_newMsg(cMSG_ID_NONE: 'Replace existing data +
                                  if the file exists.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  // Check APPEND flag
  if   f_isBitOn(cFILE_APPEND: i_openFlags);
    msg = f_newMsg(cMSG_ID_NONE: 'Append new data to the end of the +
                                  file.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endif;

  return;


end-proc;
