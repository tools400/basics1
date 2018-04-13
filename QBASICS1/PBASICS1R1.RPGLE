      /IF NOT DEFINED(PBASICSR1)
      /DEFINE PBASICSR1
      *
      *  Reference fields
      /COPY QBASICS1,FDMSG
      /COPY QBASICS1,FDRCVM0200
      /COPY QBASICS1,FDRCVM0300
      /COPY QBASICS1,FDRTVM0100
      /COPY QBASICS1,FDRTVM0300
      /COPY QBASICS1,FDRTVM0400
      *
      *  Constants
      *
      *  Message ID special values:
     D cMSG_ID_OK      C                   const('*OK')
     D cMSG_ID_NONE    C                   const('')
     D cMSG_ID_NULL    C                   const('*NULL')
      *
      *  Parameter: Stack Counter
     D cMsg_AllInact   C                   const(-4)                             - / - /rmv
     D cMsg_Ext        C                   const(-1)                            snd/rcv/rmv
     D cMsg_Prv        C                   const(-2)                            snd/rcv/rmv
     D cMsg_Same       C                   const(-3)                            snd/rcv/rmv
      *
      *  Parameter: Procedure
     D cMsg_ToMyself   C                   const('*')                           snd/rcv/rmv
     D cMsg_ToPgmBdy   C                   const('*PGMBDY')                     snd/ - / -
     D cMsg_ToCtlBdy   C                   const('*CTLBDY')                     snd/ - / -
     D cMsg_ToPgm      C                   const('*PGMNAME')                    snd/ - / -
      *
      *  Parameter: Message Type
     D cMsg_Any        C                   const('*ANY')                         - /rcv/ -
     D cMsg_Comp       C                   const('*COMP')                       snd/rcv/ -
     D cMsg_Copy       C                   const('*COPY')                        - /rcv/ -
     D cMsg_Diag       C                   const('*DIAG')                       snd/rcv/ -
     D cMsg_Escape     C                   const('*ESCAPE')                     snd/rcv/ -
     D cMsg_Escp       C                   const('*EXCP')                        - /rcv/ -
     D cMsg_First      C                   const('*FIRST')                       - /rcv/ -
     D cMsg_Info       C                   const('*INFO')                       snd/rcv/ -
     D cMsg_Inq        C                   const('*INQ')                        snd/ - / -
     D cMsg_Last       C                   const('*LAST')                        --/rcv/ -
     D cMsg_Next       C                   const('*NEXT')                        --/rcv/ -
     D cMsg_Notify     C                   const('*NOTIFY')                     snd/rcv/ -
     D cMsg_Previous   C                   const('*PRV')                         --/rcv/ -
     D cMsg_Rpy        C                   const('*RPY')                         --/rcv/ -
     D cMsg_Rqs        C                   const('*RQS')                        snd/rcv/ -
     D cMsg_Status     C                   const('*STATUS')                     snd/ - / -
      *
      *  Parameter: Action
     D cMsg_Act_Old    C                   const('*OLD')                         - /rcv/ -
     D cMsg_Act_Rmv    C                   const('*REMOVE')                      - /rcv/ -
     D cMsg_Act_Same   C                   const('*SAME')                        - /rcv/ -
      *
      *  Parameter: Message to remove
     D cMsg_Rmv_All    C                   const('*ALL')                         - / - /rmv
     D cMsg_Rmv_ByKey  C                   const('*BYKEY')                       - / - /rmv
     D cMsg_Rmv_New    C                   const('*NEW')                         - / - /rmv
     D cMsg_Rmv_Old    C                   const('*OLD')                         - / - /rmv
     D cMsg_Rmv_Scope  C                   const('*SCOPE')                       - / - /rmv
      *
      *  Retrieve message help text
     D cMsg_RtnCtrlChar_Yes...
     D                 C                   const('*YES')
     D cMsg_RtnCtrlChar_No...
     D                 C                   const('*NO')
      *
      *  Sets the application message file.
     D p_setAppMsgFile...
     D                 PR
     D                                     extproc('BASICS1R1+
     D                                     _p_setAppMsgFile+
     D                                     ')
     D  i_file                       10A   const  options(*nopass)
     D  i_lib                        10A   const  options(*nopass)
      *
      *  Creates a new message.
     D f_newMsg...
     D                 PR                         likeds(msg_t     )
     D                                     extproc('BASICS1R1+
     D                                     _f_newMsg+
     D                                     ')
     D  i_ID                               const  like(msg_t.id    )
     D                                            options(*omit: *nopass)
     D  i_data                      512A   const  varying
     D                                            options(*omit: *nopass)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
     D  i_file                             const  like(msg_t.file  )
     D                                            options(*omit: *nopass)
     D  i_lib                              const  like(msg_t.lib   )
     D                                            options(*omit: *nopass)
      *
      *  Sends a program message.
     D f_sndPgmMsg...
     D                 PR             4A
     D                                     extproc('BASICS1R1+
     D                                     _f_sndPgmMsg+
     D                                     ')
     D  i_msg                              const  likeds(msg_t   )
     D  i_toStkC                     10I 0 const  options(*nopass: *omit)
     D  i_toProc                    256A   const  options(*nopass: *omit)
     D  i_toMod                      10A   const  options(*nopass: *omit)
     D  i_toPgm                      10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Receives a program message.
     D f_rcvPgmMsg...
     D                 PR                         likeds(rcvm0200_t)
     D                                     extproc('BASICS1R1+
     D                                     _f_rcvPgmMsg+
     D                                     ')
     D  i_msgType                    10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_action                     10A   const  options(*nopass: *omit)
     D  i_wait                       10I 0 const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Removes a program message.
     D p_rmvPgmMsg...
     D                 PR
     D                                     extproc('BASICS1R1+
     D                                     _p_rmvPgmMsg+
     D                                     ')
     D  i_msgToRemove                10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves the message text of a given message.
      *  Replaces substitution variables with message data.
     D f_rtvMsgText...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R1+
     D                                     _f_rtvMsgText+
     D                                     ')
     D  i_msg                              const  likeds(msg_t    )
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves the message help text of a given message.
      *  Replaces substitution variables with message data.
     D f_rtvMsgHelpText...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R1+
     D                                     _f_rtvMsgHelpText+
     D                                     ')
     D  i_msg                              const  likeds(msg_t    )
     D  i_rtnCtrlChr                 10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves the message text of a given message.
      *  Does not replace substitution variables with message data.
     D f_rtvMsgTextRaw...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R1+
     D                                     _f_rtvMsgTextRaw+
     D                                     ')
     D  i_msg                              const  likeds(msg_t    )
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves the message help text of a given message.
      *  Does not replace substitution variables with message data.
     D f_rtvMsgHelpTextRaw...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1R1+
     D                                     _f_rtvMsgHelpTextRaw+
     D                                     ')
     D  i_msg                              const  likeds(msg_t    )
     D  i_rtnCtrlChr                 10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Converts a received message of format RCVM0200 to a message.
     D f_cvtRcvMsgToMsg...
     D                 PR                         likeds(msg_t     )
     D                                     extproc('BASICS1R1+
     D                                     _f_cvtRcvMsgToMsg+
     D                                     ')
     D  i_rcvm0200                         const  likeds(rcvm0200_t)
     D  i_type                             const  like(msg_t.type  )
     D                                            options(*omit: *nopass)
      *
      *  Receives a program message and returns a message structure.
     D f_rcvPgmMsgObj...
     D                 PR                         likeds(msg_t )
     D                                     extproc('BASICS1R1+
     D                                     _f_rcvPgmMsgObj+
     D                                     ')
     D  i_msgType                    10A   const
     D  i_msgKey                      4A   const  options(*nopass: *omit)
     D  i_action                     10A   const  options(*nopass: *omit)
     D  i_wait                       10I 0 const  options(*nopass: *omit)
     D  i_fromStkC                   10I 0 const  options(*nopass: *omit)
     D  i_fromProc                  256A   const  options(*nopass: *omit)
     D  i_fromMod                    10A   const  options(*nopass: *omit)
     D  i_fromPgm                    10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Returns the sender information of a receives program message.
     D f_getSndInfOfRcvMsg...
     D                 PR                         likeds(sndInf_t  )
     D                                     extproc('BASICS1R1+
     D                                     _f_getSndInfOfRcvMsg+
     D                                     ')
     D  i_rcvm0200                         const  likeds(rcvm0200_t)
     D  o_longSndPgm                256A          options(*nopass: *omit)
     D  o_longSndPrc                256A          options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      /COPY QBASICS1,PBASICS1R4                   Assert/THIS
      /COPY QBASICS1,PBASICS1R5                   Objects
      *
      /ENDIF
