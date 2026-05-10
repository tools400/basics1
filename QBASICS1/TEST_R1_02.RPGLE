**free
//===============================================================*
//    CALL PGM(TEST_R1_02)                                       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R1_02');
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
  dcl-ds msg likeds(msg_t) inz;
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
  dcl-ds sndInf likeds(sndInf_t) inz;

  dcl-ds snd qualified;
    pgm char(256) inz;
    prc char(256) inz;
  end-ds;

  dcl-s msgKey char(4) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create a message with no message ID, only message text
  msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_NONE ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  msg = f_newMsg(cMSG_ID_NONE: 'A message w/o a message ID');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Create a NULL message (which can not be sent)
  msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_NULL ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  msg = f_newMsg(cMSG_ID_NULL);
  monitor;
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  on-error;
    msg = f_newMsg(cMSG_ID_NONE:
                   'Error: A NULL message can not be sent.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endmon;

  // Create a OK message (which can not be sent)
  msg = f_newMsg(cMSG_ID_NONE: '*** Using cMSG_ID_OK ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  msg = f_newMsg(cMSG_ID_OK);
  monitor;
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  on-error;
    msg = f_newMsg(cMSG_ID_NONE:
                   'Error: A OK message can not be sent.');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  endmon;

  // Change the application message file to QTCPMSG
  // and send a test message TCP1A0A: &1 ended abnormally.
  msg = f_newMsg(cMSG_ID_NONE: '*** Changing message file ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  p_setAppMsgFile('QTCPMSG': 'QSYS');
  msg = f_newMsg('TCP1A0A': '*TEST_MSG *N  *N        ');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Now send a QCPFMSG
  msg = f_newMsg('CPF9897': 'Hello World! (QCPFMSG)': cMsg_Info:
                 'QCPFMSG': '*LIBL');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Set the application message file back to the default values
  p_setAppMsgFile();

  // Try to use the default message file
  msg = f_newMsg('CPF9897': 'Default message file is QCPFMSG.');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Send a message to the most previous call stack entry
  msg = f_newMsg(cMSG_ID_NONE: '*** Sending & receiving messages ***');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  msg = f_newMsg(cMSG_ID_NONE: 'Hi, how are you?');
  msgKey = f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToMyself);

  rcvm0200 = f_rcvPgmMsg(cMsg_Any: msgKey: cMsg_Act_Same: 0:
                         cMsg_Prv: cMsg_ToMyself);

  sndInf = f_getSndInfOfRcvMsg(rcvm0200: snd.pgm: snd.prc);

  msg = f_newMsg(cMSG_ID_NONE: 'Received: ' + %trimR(rcvm0200.value) +
                               ' Answer: Thanks''s I am fine.');
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Finally remove the message
  p_rmvPgmMsg(cMsg_Rmv_ByKey: msgKey: cMsg_Prv: cMsg_ToMyself);

  return;


end-proc main;
