**FREE
/IF NOT DEFINED(rcvm0300_t)
/DEFINE rcvm0300_t
//===============================================================*
//  QMHRCVM API - RCVM0300                                       *
//===============================================================*

dcl-ds rcvm0300_t qualified           based(pDummy);
  // Bytes returned
  bytRet          int(10);
  // Bytes available
  bytAvl          int(10);
  // Message Severity
  msgSev          int(10);
  // Message ID
  msgID           char(7);
  // Message Type
  msgType         char(2);
  // Message Key
  msgKey          char(4);
  // Message File
  msgF            char(10);
  // Message Library Specified
  msgLS           char(10);
  // Message Library Used
  msgLU           char(10);
  // Alert option
  alertOpt        char(9);
  // CCSID conversion status indicator of message and message help
  ccsidConvStatMsg
  int(10) pos(65);
  // CCSID conversion status indicator of message data or text
  ccsidConvStatMsgData
  int(10) pos(69);
  // CCSID of replacement data or impromptu message text
  ccsidRplData
  int(10) pos(73);
  // CCSID of replacement data and message help
  ccsidMsgHlp
  int(10) pos(77);
  // Length of replacement data or impromptu message text returned
  lenRplDataR
  int(10) pos(81);
  // Length of replacement data or impromptu message text available
  lenRplDataA
  int(10) pos(85);
  // Length of message returned
  lenMsgR
  int(10) pos(89);
  // Length of message available
  lenMsgA
  int(10) pos(93);
  // Length of message help returned
  lenMsgHlpR
  int(10) pos(97);
  // Length of message help available
  lenMsgHlpA
  int(10) pos(101);
  // Length of sender information returned
  lenSndInfR
  int(10) pos(105);
  // Length of sender information available
  lenSndInfA
  int(10) pos(109);
end-ds;

// The offsets to       CHAR(*)      Replacement data or impromptu message text
// these fields         CHAR(*)      Message
// equal the offset     CHAR(*)      Message help
// to the last          CHAR(*)      Sender information
// fixed-length
// field plus the
// length of the
// previous variable
// length fields.

/ENDIF

/IF NOT DEFINED(sndInf_t)
/DEFINE sndInf_t
//===============================================================*
//  QMHRCVM API - Sender Information Format                      *
//===============================================================*

dcl-ds sndInf_t based(pDummy) qualified;
  // Sending job
  job
  char(10) pos(1);
  // Sending user profile
  user
  char(10) pos(11);
  // Sending job's number
  jobNbr
  char(6) pos(21);
  // Date sent
  date
  char(7) pos(27);
  // Time sent
  time
  char(6) pos(34);
  // Sending type
  sndType
  char(1) pos(40);
  // Receiving type
  rcvType
  char(1) pos(41);
  // Sending program name
  sndPgm
  char(12) pos(42);
  // Sending module name
  sndModule
  char(10) pos(54);
  // Sending procedure name
  sndProc
  char(256) pos(64);
  // Reserved
  reserved_01
  char(1) pos(320);
  // Number of statement numbers or instruction numbers
  // available for the sending program or procedure
  sndPgmNumStmtNbrs
  char(4) pos(321);
  // Sending program's statement numbers or
  // instruction numbers
  sndPgmStmtNbrs
  char(30) pos(325);
  sndPgmStmtNbr
  char(10) dim(3) overlay(sndPgmStmtNbrs);
  // Receiving program name
  rcvPgm
  char(10) pos(355);
  // Receiving module name
  rcvModule
  char(10) pos(365);
  // Receiving procedure name
  rcvProc
  char(256) pos(375);
  // Reserved
  reserved_02
  char(10) pos(631);
  // Number of statement numbers or instruction numbers
  // available for the receiving program or procedure.
  rcvPgmNumStmtNbrs
  int(10) pos(641);
  // Receiving program's statement number or
  // instruction number
  rcvPgmStmtNbrs
  char(30) pos(645);
  rcvPgmStmtNbr
  char(10) dim(3) overlay(rcvPgmStmtNbrs);
  // Reserved
  reserved_03
  char(2) pos(675);
  // Displacement to long sending program name
  ofsSndPgmLName
  int(10) pos(677);
  // Length of long sending program name
  lenSndPgmLName
  int(10) pos(681);
  // Displacement to long sending procedure name
  ofsSndPrcLName
  int(10) pos(685);
  // Length of long sending procedure name
  lenSndPrcLName
  int(10) pos(689);
  // Displacement to long receiving procedure name
  ofsRcvPrcLName
  int(10) pos(693);
  // Length of long receiving procedure name
  lenRcvPrcLName
  int(10) pos(697);
end-ds;

// The                  CHAR(*)      Reserved
// offsets              CHAR(*)      Long sending program name
// to these             CHAR(*)      Long sending procedure name
// fields               CHAR(*)      Long receiving procedure name
// are found
// in the
// displacemet
// fields
// identified
// in this
// table.

/ENDIF
