**free
/if NOT DEFINED(PBASICSR1)
/define PBASICSR1

//  Reference fields
/copy QBASICS1,FDMSG
/copy QBASICS1,FDRCVM0200
/copy QBASICS1,FDRCVM0300
/copy QBASICS1,FDRTVM0100
/copy QBASICS1,FDRTVM0300
/copy QBASICS1,FDRTVM0400

//  Constants

//  Message ID special values:
dcl-c cMSG_ID_OK '*OK';
dcl-c cMSG_ID_NONE '';
dcl-c cMSG_ID_NULL '*NULL';

//  Parameter: Stack Counter
dcl-c cMsg_AllInact -4; //  - / - /rmv
dcl-c cMsg_Ext -1; // snd/rcv/rmv
dcl-c cMsg_Prv -2; // snd/rcv/rmv
dcl-c cMsg_Same -3; // snd/rcv/rmv

//  Parameter: Procedure
dcl-c cMsg_ToMyself '*'; // snd/rcv/rmv
dcl-c cMsg_ToPgmBdy '*PGMBDY'; // snd/ - / -
dcl-c cMsg_ToCtlBdy '*CTLBDY'; // snd/ - / -
dcl-c cMsg_ToPgm '*PGMNAME'; // snd/ - / -

//  Parameter: Message Type
dcl-c cMsg_Any '*ANY'; //  - /rcv/ -
dcl-c cMsg_Comp '*COMP'; // snd/rcv/ -
dcl-c cMsg_Copy '*COPY'; //  - /rcv/ -
dcl-c cMsg_Diag '*DIAG'; // snd/rcv/ -
dcl-c cMsg_Escape '*ESCAPE'; // snd/rcv/ -
dcl-c cMsg_Escp '*EXCP'; //  - /rcv/ -
dcl-c cMsg_First '*FIRST'; //  - /rcv/ -
dcl-c cMsg_Info '*INFO'; // snd/rcv/ -
dcl-c cMsg_Inq '*INQ'; // snd/ - / -
dcl-c cMsg_Last '*LAST'; //  --/rcv/ -
dcl-c cMsg_Next '*NEXT'; //  --/rcv/ -
dcl-c cMsg_Notify '*NOTIFY'; // snd/rcv/ -
dcl-c cMsg_Previous '*PRV'; //  --/rcv/ -
dcl-c cMsg_Rpy '*RPY'; //  --/rcv/ -
dcl-c cMsg_Rqs '*RQS'; // snd/rcv/ -
dcl-c cMsg_Status '*STATUS'; // snd/ - / -

//  Parameter: Action
dcl-c cMsg_Act_Old '*OLD'; //  - /rcv/ -
dcl-c cMsg_Act_Rmv '*REMOVE'; //  - /rcv/ -
dcl-c cMsg_Act_Same '*SAME'; //  - /rcv/ -

//  Parameter: Message to remove
dcl-c cMsg_Rmv_All '*ALL'; //  - / - /rmv
dcl-c cMsg_Rmv_ByKey '*BYKEY'; //  - / - /rmv
dcl-c cMsg_Rmv_New '*NEW'; //  - / - /rmv
dcl-c cMsg_Rmv_Old '*OLD'; //  - / - /rmv
dcl-c cMsg_Rmv_Scope '*SCOPE'; //  - / - /rmv

//  Retrieve message help text
dcl-c cMsg_RtnCtrlChar_Yes '*YES';
dcl-c cMsg_RtnCtrlChar_No '*NO';

//  Sets the application message file.
dcl-pr p_setAppMsgFile extproc('BASICS1R1_p_setAppMsgFile');
  i_file char(10) options(*nopass) const;
  i_lib  char(10) options(*nopass) const;
end-pr;

//  Creates a new message.
dcl-pr f_newMsg likeds(msg_t) extproc('BASICS1R1_f_newMsg');
  i_ID   like(msg_t.id) options(*omit: *nopass) const;
  i_data varchar(512) options(*omit: *nopass) const;
  i_type like(msg_t.type) options(*omit: *nopass) const;
  i_file like(msg_t.file) options(*omit: *nopass) const;
  i_lib  like(msg_t.lib) options(*omit: *nopass) const;
end-pr;

//  Sends a program message.
dcl-pr f_sndPgmMsg char(4) extproc('BASICS1R1_f_sndPgmMsg');
  i_msg    likeds(msg_t) const;
  i_toStkC int(10) options(*nopass: *omit) const;
  i_toProc char(256) options(*nopass: *omit) const;
  i_toMod  char(10) options(*nopass: *omit) const;
  i_toPgm  char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Receives a program message.
dcl-pr f_rcvPgmMsg likeds(rcvm0200_t) extproc('BASICS1R1_f_rcvPgmMsg');
  i_msgType  char(10) const;
  i_msgKey   char(4) options(*nopass: *omit) const;
  i_action   char(10) options(*nopass: *omit) const;
  i_wait     int(10) options(*nopass: *omit) const;
  i_fromStkC int(10) options(*nopass: *omit) const;
  i_fromProc char(256) options(*nopass: *omit) const;
  i_fromMod  char(10) options(*nopass: *omit) const;
  i_fromPgm  char(10) options(*nopass: *omit) const;
  o_msg      likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Removes a program message.
dcl-pr p_rmvPgmMsg extproc('BASICS1R1_p_rmvPgmMsg');
  i_msgToRemove char(10) const;
  i_msgKey      char(4) options(*nopass: *omit) const;
  i_fromStkC    int(10) options(*nopass: *omit) const;
  i_fromProc    char(256) options(*nopass: *omit) const;
  i_fromMod     char(10) options(*nopass: *omit) const;
  i_fromPgm     char(10) options(*nopass: *omit) const;
  o_msg         likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieves the message text of a given message.
//  Replaces substitution variables with message data.
dcl-pr f_rtvMsgText varchar(4096) extproc('BASICS1R1_f_rtvMsgText');
  i_msg likeds(msg_t) const;
  o_msg likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieves the message help text of a given message.
//  Replaces substitution variables with message data.
dcl-pr f_rtvMsgHelpText varchar(4096) extproc('BASICS1R1_f_rtvMsgHelpText');
  i_msg        likeds(msg_t) const;
  i_rtnCtrlChr char(10) options(*nopass: *omit) const;
  o_msg        likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieves the message text of a given message.
//  Does not replace substitution variables with message data.
dcl-pr f_rtvMsgTextRaw varchar(4096) extproc('BASICS1R1_f_rtvMsgTextRaw');
  i_msg likeds(msg_t) const;
  o_msg likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieves the message help text of a given message.
//  Does not replace substitution variables with message data.
dcl-pr f_rtvMsgHelpTextRaw varchar(4096) extproc('BASICS1R1_f_rtvMsgHelpTextRaw');
  i_msg        likeds(msg_t) const;
  i_rtnCtrlChr char(10) options(*nopass: *omit) const;
  o_msg        likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Converts a received message of format RCVM0200 to a message.
dcl-pr f_cvtRcvMsgToMsg likeds(msg_t) extproc('BASICS1R1_f_cvtRcvMsgToMsg');
  i_rcvm0200 likeds(rcvm0200_t) const;
  i_type     like(msg_t.type) options(*omit: *nopass) const;
end-pr;

//  Receives a program message and returns a message structure.
dcl-pr f_rcvPgmMsgObj likeds(msg_t) extproc('BASICS1R1_f_rcvPgmMsgObj');
  i_msgType  char(10) const;
  i_msgKey   char(4) options(*nopass: *omit) const;
  i_action   char(10) options(*nopass: *omit) const;
  i_wait     int(10) options(*nopass: *omit) const;
  i_fromStkC int(10) options(*nopass: *omit) const;
  i_fromProc char(256) options(*nopass: *omit) const;
  i_fromMod  char(10) options(*nopass: *omit) const;
  i_fromPgm  char(10) options(*nopass: *omit) const;
  o_msg      likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Returns the sender information of a receives program message.
dcl-pr f_getSndInfOfRcvMsg likeds(sndInf_t) extproc('BASICS1R1_f_getSndInfOfRcvMsg');
  i_rcvm0200   likeds(rcvm0200_t) const;
  o_longSndPgm char(256) options(*nopass: *omit);
  o_longSndPrc char(256) options(*nopass: *omit);
  o_msg        likeds(msg_t) options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R2                   API Error Handling
/copy QBASICS1,PBASICS1R4                   Assert/THIS
/copy QBASICS1,PBASICS1R5                   Objects

/endif