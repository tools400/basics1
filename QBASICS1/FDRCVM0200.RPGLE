**FREE
/IF NOT DEFINED(rcvm0200_t)
/DEFINE rcvm0200_t
//===============================================================*
//  QMHRCVM API - RCVM0200                                       *
//===============================================================*

dcl-ds rcvm0200_t qualified           based(pDummy);
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
  // Sending Job
  sndJob          char(10);
  // Sending User Profile
  sndUsr          char(10);
  // Sending Job Number
  sndNbr          char(6);
  // Sending Program
  sndPgm          char(12);
  // Sending program Instr. Nbr.
  sndINb          char(4);
  // Sending Date
  sndDat          char(7);
  // Sending Time
  sndTim          char(6);
  // Receiving program
  rcvPgm          char(10);
  // Receiving Program Instr. Nbr
  rcvINb          char(4);
  // Sending Type
  sndTyp          char(1);
  // Receiving Type
  rcvTyp          char(1);
  // Reserved 01
  reserved_01     char(1);
  // Conversion Status ID Text
  cStIDTx         int(10);
  // Conversion Status ID Data
  cStIDDt         int(10);
  // Alert Option
  alrOpt          char(9);
  // CCSID of msg and help
  ccsidMH         int(10);
  // CCSID of replacement data
  ccsidRD         int(10);
  // Length replacement data ret.
  lnRplDtR        int(10);
  // Length replacement data avl.
  lnRplDtA        int(10);
  // Length message ret.
  lnMgR           int(10);
  // Length message avl.
  lnMgA           int(10);
  // Length message help ret.
  lnMgHR          int(10);
  // Length message help avl.
  lnMgHA          int(10);
  // Value of varying length!
  value           char(4096);
end-ds;

/ENDIF
