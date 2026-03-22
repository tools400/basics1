**FREE
/IF NOT DEFINED(rtvm0100_t)
/DEFINE rtvm0100_t
//===============================================================*
//  QMHRTVM API - RTVM0100                                       *
//===============================================================*

dcl-ds rtvm0100_t qualified           based(pDummy);
  //  Bytes returned
  BYTRET          bindec(9);
  //  Bytes available
  BYTAVL          bindec(9);
  //  Length of message returned
  LENMSGRET       bindec(9);
  //  Length of message available
  LENMSGAVL       bindec(9);
  //  Length of msg help returned
  LENHLPRET       bindec(9);
  //  Length of msg help available
  LENHLPAVL       bindec(9);
  //  Msg text and data of varying length!
  DATA            char(2048);
end-ds;

/ENDIF
