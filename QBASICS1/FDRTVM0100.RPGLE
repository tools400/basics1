      /IF NOT DEFINED(rtvm0100_t)
      /DEFINE rtvm0100_t
      *===============================================================*
      *  QMHRTVM API - RTVM0100                                       *
      *===============================================================*
      *
     D rtvm0100_t      DS                  qualified           based(pDummy)
      *  Bytes returned
     D  BYTRET                        9B 0
      *  Bytes available
     D  BYTAVL                        9B 0
      *  Length of message returned
     D  LENMSGRET                     9B 0
      *  Length of message available
     D  LENMSGAVL                     9B 0
      *  Length of msg help returned
     D  LENHLPRET                     9B 0
      *  Length of msg help available
     D  LENHLPAVL                     9B 0
      *  Msg text and data of varying length!
     D  DATA                       2048A
      *
      /ENDIF
