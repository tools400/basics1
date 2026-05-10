**free
//===============================================================*
//    CALL PGM(TEST_R3_02) PARM(65)                              *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_02');
  gi_width packed(15: 5) options(*nopass) const;
end-pr;

dcl-pr main;
  i_width int(10) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_width packed(15: 5) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_width));
  main(gi_width);
else;
  main(60);
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_width int(10) const;
  end-pi;

  //  Helper fields
  dcl-s theText varchar(512)
    inz('Test wordWrap():&N''The quick brown fox jumps over the +
    lazy dog.'' is a sentence that includes every letter of the +
    alphabet.&PThat is why it is often found as a sample +
    sentence within font managing software. Of course I know +
    that the text I am writing is somewhat silly.&BHowever the +
    only purpose of the text is to show how the +
    wordWrap-function works.');
  dcl-s aLine char(80) inz;
  dcl-s startPos uns(10) inz;
  dcl-s numLine int(3) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(i_width >= 1 and i_width <= 80:
           'i_width is out of range. It must be between 1 and 80');

  // Perform word wrap without respect to end-of-paragraph markers:
  msg = f_newMsg('': '*** No EOP charcater: ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  numLine  = 0;
  startPos = 1;
  dow   startPos > 0;
    numLine = numLine + 1;
    aLine = f_wordWrap(theText: i_width: startPos) + '<';
    msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  enddo;

  // Perform word wrap with respect to end-of-paragraph markers
  // of message descriptions:
  msg = f_newMsg('': '*** EOP charcater of message description: ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  numLine  = 0;
  startPos = 1;
  dow   startPos > 0;
    numLine = numLine + 1;
    aLine = f_wordWrap(theText: i_width: startPos:
                       cWORDWRAP_PARAGRAPH_MSGD) + '<';
    msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  enddo;

  // Perform word wrap with respect to standard text
  // end-of-paragraph markers:
  theText = f_replace('&N': '\n': theText);
  theText = f_replace('&B': '\N': theText);
  theText = f_replace('&P': '\n': theText);

  msg = f_newMsg('': '*** Standard text EOP charcaters: ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  numLine  = 0;
  startPos = 1;
  dow   startPos > 0;
    numLine = numLine + 1;
    aLine = f_wordWrap(theText: i_width: startPos:
                       cWORDWRAP_PARAGRAPH_TEXT) + '<';
    msg = f_newMsg('': 'Line ' + %char(numLine) + ': ' + aLine);
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  enddo;

  return;


end-proc main;
