      /IF NOT DEFINED(rtvm0300_t)
      /DEFINE rtvm0300_t
      *===============================================================*
      *  QMHRTVM API - RTVM0300                                       *
      *===============================================================*
      *
     D rtvm0300_t      DS                  qualified           based(pDummy)
      *  Bytes returned
     D  bytRet                       10I 0
      *  Bytes available
     D  bytAvl                       10I 0
      *  Message severity
     D  msgSev                       10I 0
      *  Alert index
     D  altIdx                       10I 0
      * Alert Option
     D  altOpt                        9A
      * Log indicator
     D  logInd                        1A
      * Message ID
     D  msgID                         7A
      * Reserved
     D  reserved_01                   3A
      * Nbr. of subst. var. formats
     D  numVarFmt                    10I 0
      * CCSID conv. stat. ind. text
     D  csIndTxt                     10I 0
      * CCSID conv. stat. ind. data
     D  csIndDta                     10I 0
      * CCSID of Text returned
     D  ccsidTxt                     10I 0
      * Offset of default reply
     D  ofsDftR                      10I 0
      * Length of default reply ret.
     D  lenDftRpyR                   10I 0
      * Length of default reply avl.
     D  lenDftRpyA                   10I 0
      * Offset of message
     D  ofsMsg                       10I 0
      * Length of message returned
     D  lenMsgR                      10I 0
      * Length of message available
     D  lenMsgA                      10I 0
      * Offset of message
     D  ofsMsgHlp                    10I 0
      * Length of message help ret.
     D  lenMsgHlpR                   10I 0
      * Length of message help avl.
     D  lenMsgHlpA                   10I 0
      * Ofs. of subst. var. formats
     D  ofsVarFmt                    10I 0
      * Length subst. var. fmt. ret.
     D  lenVarFmtR                   10I 0
      * Length subst. var. fmt. avl.
     D  lenVarFmtA                   10I 0
      * Length subst. var. element
     D  lenVarFmtE                   10I 0
      * Data
     D  data                       4096A
      *                       CHAR(*)  Default reply
      *                       CHAR(*)  Message
      *                       CHAR(*)  Message help
      *                       CHAR(*)  Substitution variable formats
      *
      /ENDIF
