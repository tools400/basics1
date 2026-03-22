**FREE
/IF NOT DEFINED(PBASICSR1)
/DEFINE PBASICSR1

//  Reference fields
/COPY QBASICS1,FDMSG
/COPY QBASICS1,FDRCVM0200
/COPY QBASICS1,FDRCVM0300
/COPY QBASICS1,FDRTVM0100
/COPY QBASICS1,FDRTVM0300
/COPY QBASICS1,FDRTVM0400

//  Constants

//  Message ID special values:
dcl-c cMSG_ID_OK const('*OK');
dcl-c cMSG_ID_NONE const('');
dcl-c cMSG_ID_NULL const('*NULL');

//  Parameter: Stack Counter
dcl-c cMsg_AllInact const(-4);                                           //  - / - /rmv
dcl-c cMsg_Ext const(-1);                                                // snd/rcv/rmv
dcl-c cMsg_Prv const(-2);                                                // snd/rcv/rmv
dcl-c cMsg_Same const(-3);                                               // snd/rcv/rmv

//  Parameter: Procedure
dcl-c cMsg_ToMyself const('*');                                          // snd/rcv/rmv
dcl-c cMsg_ToPgmBdy const('*PGMBDY');                                    // snd/ - / -
dcl-c cMsg_ToCtlBdy const('*CTLBDY');                                    // snd/ - / -
dcl-c cMsg_ToPgm const('*PGMNAME');                                      // snd/ - / -

//  Parameter: Message Type
dcl-c cMsg_Any const('*ANY');                                            //  - /rcv/ -
dcl-c cMsg_Comp const('*COMP');                                          // snd/rcv/ -
dcl-c cMsg_Copy const('*COPY');                                          //  - /rcv/ -
dcl-c cMsg_Diag const('*DIAG');                                          // snd/rcv/ -
dcl-c cMsg_Escape const('*ESCAPE');                                      // snd/rcv/ -
dcl-c cMsg_Escp const('*EXCP');                                          //  - /rcv/ -
dcl-c cMsg_First const('*FIRST');                                        //  - /rcv/ -
dcl-c cMsg_Info const('*INFO');                                          // snd/rcv/ -
dcl-c cMsg_Inq const('*INQ');                                            // snd/ - / -
dcl-c cMsg_Last const('*LAST');                                          //  --/rcv/ -
dcl-c cMsg_Next const('*NEXT');                                          //  --/rcv/ -
dcl-c cMsg_Notify const('*NOTIFY');                                      // snd/rcv/ -
dcl-c cMsg_Previous const('*PRV');                                       //  --/rcv/ -
dcl-c cMsg_Rpy const('*RPY');                                            //  --/rcv/ -
dcl-c cMsg_Rqs const('*RQS');                                            // snd/rcv/ -
dcl-c cMsg_Status const('*STATUS');                                      // snd/ - / -

//  Parameter: Action
dcl-c cMsg_Act_Old const('*OLD');                                        //  - /rcv/ -
dcl-c cMsg_Act_Rmv const('*REMOVE');                                     //  - /rcv/ -
dcl-c cMsg_Act_Same const('*SAME');                                      //  - /rcv/ -

//  Parameter: Message to remove
dcl-c cMsg_Rmv_All const('*ALL');                                        //  - / - /rmv
dcl-c cMsg_Rmv_ByKey const('*BYKEY');                                    //  - / - /rmv
dcl-c cMsg_Rmv_New const('*NEW');                                        //  - / - /rmv
dcl-c cMsg_Rmv_Old const('*OLD');                                        //  - / - /rmv
dcl-c cMsg_Rmv_Scope const('*SCOPE');                                    //  - / - /rmv

//  Retrieve message help text
dcl-c cMsg_RtnCtrlChar_Yes
      const('*YES');
dcl-c cMsg_RtnCtrlChar_No
      const('*NO');

//  Sets the application message file.
dcl-pr p_setAppMsgFile
       extproc('BASICS1R1+
       _p_setAppMsgFile+
       ');
  i_file          char(10) const  options(*nopass);
  i_lib           char(10) const  options(*nopass);
end-pr;

//  Creates a new message.
dcl-pr f_newMsg
       likeds(msg_t     )
extproc('BASICS1R1+
_f_newMsg+
');
i_ID            const  like(msg_t.id    )
     options(*omit: *nopass);
i_data          varchar(512) const
     options(*omit: *nopass);
i_type          const  like(msg_t.type  )
     options(*omit: *nopass);
i_file          const  like(msg_t.file  )
     options(*omit: *nopass);
i_lib           const  like(msg_t.lib   )
     options(*omit: *nopass);
end-pr;

//  Sends a program message.
dcl-pr f_sndPgmMsg
       char(4)
       extproc('BASICS1R1+
       _f_sndPgmMsg+
       ');
  i_msg           const  likeds(msg_t   );
i_toStkC        int(10) const  options(*nopass: *omit);
i_toProc        char(256) const  options(*nopass: *omit);
i_toMod         char(10) const  options(*nopass: *omit);
i_toPgm         char(10) const  options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Receives a program message.
dcl-pr f_rcvPgmMsg
       likeds(rcvm0200_t)
extproc('BASICS1R1+
_f_rcvPgmMsg+
');
i_msgType       char(10) const;
i_msgKey        char(4) const  options(*nopass: *omit);
i_action        char(10) const  options(*nopass: *omit);
i_wait          int(10) const  options(*nopass: *omit);
i_fromStkC      int(10) const  options(*nopass: *omit);
i_fromProc      char(256) const  options(*nopass: *omit);
i_fromMod       char(10) const  options(*nopass: *omit);
i_fromPgm       char(10) const  options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Removes a program message.
dcl-pr p_rmvPgmMsg
       extproc('BASICS1R1+
       _p_rmvPgmMsg+
       ');
  i_msgToRemove   char(10) const;
  i_msgKey        char(4) const  options(*nopass: *omit);
  i_fromStkC      int(10) const  options(*nopass: *omit);
  i_fromProc      char(256) const  options(*nopass: *omit);
  i_fromMod       char(10) const  options(*nopass: *omit);
  i_fromPgm       char(10) const  options(*nopass: *omit);
  o_msg           likeds(msg_t    )
options(*nopass: *omit);
end-pr;

//  Retrieves the message text of a given message.
//  Replaces substitution variables with message data.
dcl-pr f_rtvMsgText
       varchar(4096)
       extproc('BASICS1R1+
       _f_rtvMsgText+
       ');
  i_msg           const  likeds(msg_t    );
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Retrieves the message help text of a given message.
//  Replaces substitution variables with message data.
dcl-pr f_rtvMsgHelpText
       varchar(4096)
       extproc('BASICS1R1+
       _f_rtvMsgHelpText+
       ');
  i_msg           const  likeds(msg_t    );
i_rtnCtrlChr    char(10) const  options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Retrieves the message text of a given message.
//  Does not replace substitution variables with message data.
dcl-pr f_rtvMsgTextRaw
       varchar(4096)
       extproc('BASICS1R1+
       _f_rtvMsgTextRaw+
       ');
  i_msg           const  likeds(msg_t    );
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Retrieves the message help text of a given message.
//  Does not replace substitution variables with message data.
dcl-pr f_rtvMsgHelpTextRaw
       varchar(4096)
       extproc('BASICS1R1+
       _f_rtvMsgHelpTextRaw+
       ');
  i_msg           const  likeds(msg_t    );
i_rtnCtrlChr    char(10) const  options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Converts a received message of format RCVM0200 to a message.
dcl-pr f_cvtRcvMsgToMsg
       likeds(msg_t     )
extproc('BASICS1R1+
_f_cvtRcvMsgToMsg+
');
i_rcvm0200      const  likeds(rcvm0200_t);
i_type          const  like(msg_t.type  )
     options(*omit: *nopass);
end-pr;

//  Receives a program message and returns a message structure.
dcl-pr f_rcvPgmMsgObj
       likeds(msg_t )
extproc('BASICS1R1+
_f_rcvPgmMsgObj+
');
i_msgType       char(10) const;
i_msgKey        char(4) const  options(*nopass: *omit);
i_action        char(10) const  options(*nopass: *omit);
i_wait          int(10) const  options(*nopass: *omit);
i_fromStkC      int(10) const  options(*nopass: *omit);
i_fromProc      char(256) const  options(*nopass: *omit);
i_fromMod       char(10) const  options(*nopass: *omit);
i_fromPgm       char(10) const  options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

//  Returns the sender information of a receives program message.
dcl-pr f_getSndInfOfRcvMsg
       likeds(sndInf_t  )
extproc('BASICS1R1+
_f_getSndInfOfRcvMsg+
');
i_rcvm0200      const  likeds(rcvm0200_t);
o_longSndPgm    char(256) options(*nopass: *omit);
o_longSndPrc    char(256) options(*nopass: *omit);
o_msg           likeds(msg_t    )
     options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R2                   API Error Handling
/COPY QBASICS1,PBASICS1R4                   Assert/THIS
/COPY QBASICS1,PBASICS1R5                   Objects

/ENDIF
