      /IF NOT DEFINED(rcvm0300_t)
      /DEFINE rcvm0300_t
      *===============================================================*
      *  QMHRCVM API - RCVM0300                                       *
      *===============================================================*
      *
     D rcvm0300_t      DS                  qualified           based(pDummy)
      * Bytes returned
     D  bytRet                 1      4I 0
      * Bytes available
     D  bytAvl                 5      8I 0
      * Message Severity
     D  msgSev                 9     12I 0
      * Message ID
     D  msgID                 13     19A
      * Message Type
     D  msgType               20     21A
      * Message Key
     D  msgKey                22     25A
      * Message File
     D  msgF                  26     35A
      * Message Library Specified
     D  msgLS                 36     45A
      * Message Library Used
     D  msgLU                 46     55A
      * Alert option
     D  alertOpt              56     64A
      * CCSID conversion status indicator of message and message help
     D  ccsidConvStatMsg...
     D                        65     68I 0
      * CCSID conversion status indicator of message data or text
     D  ccsidConvStatMsgData...
     D                        69     72I 0
      * CCSID of replacement data or impromptu message text
     D  ccsidRplData...
     D                        73     76I 0
      * CCSID of replacement data and message help
     D  ccsidMsgHlp...
     D                        77     80I 0
      * Length of replacement data or impromptu message text returned
     D  lenRplDataR...
     D                        81     84I 0
      * Length of replacement data or impromptu message text available
     D  lenRplDataA...
     D                        85     88I 0
      * Length of message returned
     D  lenMsgR...
     D                        89     92I 0
      * Length of message available
     D  lenMsgA...
     D                        93     96I 0
      * Length of message help returned
     D  lenMsgHlpR...
     D                        97    100I 0
      * Length of message help available
     D  lenMsgHlpA...
     D                       101    104I 0
      * Length of sender information returned
     D  lenSndInfR...
     D                       105    108I 0
      * Length of sender information available
     D  lenSndInfA...
     D                       109    112I 0
      *
      * The offsets to       CHAR(*)      Replacement data or impromptu message text
      * these fields         CHAR(*)      Message
      * equal the offset     CHAR(*)      Message help
      * to the last          CHAR(*)      Sender information
      * fixed-length
      * field plus the
      * length of the
      * previous variable
      * length fields.
      *
      /ENDIF
      *
      /IF NOT DEFINED(sndInf_t)
      /DEFINE sndInf_t
      *===============================================================*
      *  QMHRCVM API - Sender Information Format                      *
      *===============================================================*
      *
     D sndInf_t        DS                  based(pDummy) qualified
      * Sending job
     D  job...
     D                         1     10A
      * Sending user profile
     D  user...
     D                        11     20A
      * Sending job's number
     D  jobNbr...
     D                        21     26A
      * Date sent
     D  date...
     D                        27     33A
      * Time sent
     D  time...
     D                        34     39A
      * Sending type
     D  sndType...
     D                        40     40A
      * Receiving type
     D  rcvType...
     D                        41     41A
      * Sending program name
     D  sndPgm...
     D                        42     53A
      * Sending module name
     D  sndModule...
     D                        54     63A
      * Sending procedure name
     D  sndProc...
     D                        64    319A
      * Reserved
     D  reserved_01...
     D                       320    320A
      * Number of statement numbers or instruction numbers
      * available for the sending program or procedure
     D  sndPgmNumStmtNbrs...
     D                       321    324A
      * Sending program's statement numbers or
      * instruction numbers
     D  sndPgmStmtNbrs...
     D                       325    354A
     D   sndPgmStmtNbr...
     D                               10A   dim(3) overlay(sndPgmStmtNbrs)
      * Receiving program name
     D  rcvPgm...
     D                       355    364A
      * Receiving module name
     D  rcvModule...
     D                       365    374A
      * Receiving procedure name
     D  rcvProc...
     D                       375    630A
      * Reserved
     D  reserved_02...
     D                       631    640A
      * Number of statement numbers or instruction numbers
      * available for the receiving program or procedure.
     D  rcvPgmNumStmtNbrs...
     D                       641    644I 0
      * Receiving program's statement number or
      * instruction number
     D  rcvPgmStmtNbrs...
     D                       645    674A
     D   rcvPgmStmtNbr...
     D                               10A   dim(3) overlay(rcvPgmStmtNbrs)
      * Reserved
     D  reserved_03...
     D                       675    676A
      * Displacement to long sending program name
     D  ofsSndPgmLName...
     D                       677    680I 0
      * Length of long sending program name
     D  lenSndPgmLName...
     D                       681    684I 0
      * Displacement to long sending procedure name
     D  ofsSndPrcLName...
     D                       685    688I 0
      * Length of long sending procedure name
     D  lenSndPrcLName...
     D                       689    692I 0
      * Displacement to long receiving procedure name
     D  ofsRcvPrcLName...
     D                       693    696I 0
      * Length of long receiving procedure name
     D  lenRcvPrcLName...
     D                       697    700I 0
      *
      * The                  CHAR(*)      Reserved
      * offsets              CHAR(*)      Long sending program name
      * to these             CHAR(*)      Long sending procedure name
      * fields               CHAR(*)      Long receiving procedure name
      * are found
      * in the
      * displacemet
      * fields
      * identified
      * in this
      * table.
      *
      /ENDIF
