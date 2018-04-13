      /IF NOT DEFINED(rcvm0200_t)
      /DEFINE rcvm0200_t
      *===============================================================*
      *  QMHRCVM API - RCVM0200                                       *
      *===============================================================*
      *
     D rcvm0200_t      DS                  qualified           based(pDummy)
      * Bytes returned
     D  bytRet                       10I 0
      * Bytes available
     D  bytAvl                       10I 0
      * Message Severity
     D  msgSev                       10I 0
      * Message ID
     D  msgID                         7A
      * Message Type
     D  msgType                       2A
      * Message Key
     D  msgKey                        4A
      * Message File
     D  msgF                         10A
      * Message Library Specified
     D  msgLS                        10A
      * Message Library Used
     D  msgLU                        10A
      * Sending Job
     D  sndJob                       10A
      * Sending User Profile
     D  sndUsr                       10A
      * Sending Job Number
     D  sndNbr                        6A
      * Sending Program
     D  sndPgm                       12A
      * Sending program Instr. Nbr.
     D  sndINb                        4A
      * Sending Date
     D  sndDat                        7A
      * Sending Time
     D  sndTim                        6A
      * Receiving program
     D  rcvPgm                       10A
      * Receiving Program Instr. Nbr
     D  rcvINb                        4A
      * Sending Type
     D  sndTyp                        1A
      * Receiving Type
     D  rcvTyp                        1A
      * Reserved 01
     D  reserved_01                   1A
      * Conversion Status ID Text
     D  cStIDTx                      10I 0
      * Conversion Status ID Data
     D  cStIDDt                      10I 0
      * Alert Option
     D  alrOpt                        9A
      * CCSID of msg and help
     D  ccsidMH                      10I 0
      * CCSID of replacement data
     D  ccsidRD                      10I 0
      * Length replacement data ret.
     D  lnRplDtR                     10I 0
      * Length replacement data avl.
     D  lnRplDtA                     10I 0
      * Length message ret.
     D  lnMgR                        10I 0
      * Length message avl.
     D  lnMgA                        10I 0
      * Length message help ret.
     D  lnMgHR                       10I 0
      * Length message help avl.
     D  lnMgHA                       10I 0
      * Value of varying length!
     D  value                      4096A
      *
      /ENDIF
