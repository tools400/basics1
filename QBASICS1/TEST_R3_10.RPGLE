**free
//===============================================================*
//    CALL PGM(TEST_R3_09)                                       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_09');
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
  dcl-s isEqual ind inz;
  dcl-c text 'A spaceman came travelling on his ship from afar, ''twas +
    light years of time since his mission did start, And over a +
    village he halted his craft, And it hung in the sky like a +
    star, just like a star...';
  dcl-s searchArg varchar(256) inz;
  dcl-s searchText varchar(32) inz;
  dcl-s startPos int(10) inz;
  dcl-s position int(10) inz;

  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg(cMsg_ID_NONE: text);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  startPos  = %len(text);
  searchArg = 'star';
  position  = f_scanR(searchArg: text);
  exsr sndMsg;

  startPos  = 190;
  searchArg = 'star';
  position  = f_scanR(searchArg: text: startPos);
  exsr sndMsg;

  startPos  = 170;
  searchArg = 'star';
  position  = f_scanR(searchArg: text: startPos);
  exsr sndMsg;

  startPos  = 90;
  searchArg = 'star';
  position  = f_scanR(searchArg: text: startPos);
  exsr sndMsg;

  startPos  = %len(text);
  searchArg = text;
  position  = f_scanR(searchArg: text: startPos);
  exsr sndMsg;

  msg = f_newMsg(cMsg_ID_NONE: '- Search argument longer than text: -');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  startPos  = %len(text);
  searchArg = text + ' an extension';
  position  = f_scanR(searchArg: text: startPos);
  exsr sndMsg;

  return;

  begsr sndMsg;

    if %len(searchArg) > 10;
      searchText = %subst(searchArg: 1: 10) + ' ...';
    else;
      searchText = searchArg;
    endif;

    if position = 0;
      msg = f_newMsg(cMsg_ID_NONE: 'Search argument ''' +
                     searchText +
                     ''' was not found before position ' +
                     %char(startPos) + '.');
    else;
      msg = f_newMsg(cMsg_ID_NONE: 'Search argument ''' +
                                   searchText +
                                   ''' found at position ' +
                                   %char(position) + '. ' +
                                   'Start position: ' + %char(startPos));
    endif;

    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  endsr;


end-proc main;
