**free
//===============================================================*
//    CALL PGM(TEST_R1_01) PARM('CPF9897' 'Hello World!' '0')    *
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
//
// ------------------------------------
//  Type Definitions
// ------------------------------------
//
// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------
//
// ------------------------------------
//  Global Constants
// ------------------------------------
//
// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R1_01');
  gi_msgID     char(7) const;
  gi_msgData   char(32) const;
  gi_isMsgHelp char(1) const;
end-pr;

dcl-pr main;
  i_msgID     char(7) const;
  i_msgData   char(32) const;
  i_isMsgHelp ind const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_msgID     char(7) const;
  gi_msgData   char(32) const;
  gi_isMsgHelp char(1) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(gi_msgID: gi_msgData: gi_isMsgHelp);

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_msgID     char(7) const;
    i_msgData   char(32) const;
    i_isMsgHelp ind const;
  end-pi;

  //  Helper fields
  dcl-s msgText varchar(1024) inz;
  dcl-ds rtvMsg likeds(msg_t) inz;
  dcl-ds infoMsg likeds(msg_t) inz;
  dcl-ds errMsg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create message to retrieve the text from
  rtvMsg = f_newMsg(i_msgID: i_msgData);

  // Retrieve message text, Ignore Errors
  infoMsg = f_newMsg('CPF9897': '*** Ignore Errors ***');
  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  msgText = f_rtvMsgText(rtvMsg: *omit);
  if   msgText <> '';
    infoMsg = f_newMsg('': 'MsgText: ' + msgText);
  else;
    infoMsg = f_newMsg(
                 '': 'Error occured on retrieveing message text!');
  endif;

  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  // Retrieve message help text, Ignore Errors
  msgText = f_rtvMsgHelpText(rtvMsg: '*NO': *omit);
  if   msgText <> '';
    infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
  else;
    infoMsg = f_newMsg(
                 '': 'Error occured on retrieveing message help text!');
  endif;

  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  // Retrieve message text, Return error information
  infoMsg = f_newMsg('CPF9897': '*** Return error information ***');
  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  msgText = f_rtvMsgText(rtvMsg: errMsg);
  if   msgText <> '';
    infoMsg = f_newMsg('': 'MsgText: ' + msgText);
  else;
    infoMsg = errMsg;
    infoMsg.type = cMsg_Info;
  endif;

  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  // Retrieve message help text, Return error information
  msgText = f_rtvMsgHelpText(rtvMsg: '*NO': errMsg);
  if   msgText <> '';
    infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
  else;
    infoMsg = errMsg;
    infoMsg.type = cMsg_Info;
  endif;

  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  // Send *ESCAPE message to signal error
  infoMsg = f_newMsg('CPF9897': '*** Send *ESCAPE message ***');
  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  if   not i_isMsgHelp;
    msgText = f_rtvMsgText(rtvMsg);
    infoMsg = f_newMsg('': 'MsgText: ' + msgText);
  else;
    msgText = f_rtvMsgHelpText(rtvMsg: '*NO');
    infoMsg = f_newMsg('': 'MsgHelp: ' + msgText);
  endif;

  f_sndPgmMsg(infoMsg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
