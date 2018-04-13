      /IF NOT DEFINED(BASICR0)
      /DEFINE BASICR0
      *
      * -----------------------------------------
      *  Constants
      * -----------------------------------------
      /IF NOT DEFINED(cTrue)
      /DEFINE cTrue
     D cTrue           C                   const(*on )
      /ENDIF
      *
      /IF NOT DEFINED(cFalse)
      /DEFINE cFalse
     D cFalse          C                   const(*off)
      /ENDIF
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,CLIB
      /COPY QBASICS1,CEELIB
      *
      *  Retrieve Message (QMHRTVM) API
     D QMHRTVM         PR                         extpgm('QMHRTVM')
     D  o_msgInf                  32767A          options(*varsize )
     D  i_length                     10I 0 const
     D  i_format                      8A   const
     D  i_msgID                       7A   const
     D  i_qMsgF                      20A   const
     D  i_rplData                 32767A   const  options(*varsize )
     D  i_rpldataLen                 10I 0 const
     D  i_rplVars                    10A   const
     D  i_rtnCtrlChrs                10A   const
     D  io_ErrCode                32767A          options(*varsize )
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D  i_msgID                       7A   const
     D  i_qMsgF                      20A   const
     D  i_msgData                 32767A   const  options(*varsize )
     D  i_length                     10I 0 const
     D  i_msgType                    10A   const
     D  i_callStkE                32767A   const  options(*varsize )
     D  i_callStkC                   10I 0 const
     D  o_msgKey                      4A
     D  io_ErrCode                32767A          options(*varsize )
     D  i_lenStkE                    10I 0 const  options(*nopass  )            | optGrp 1
     D  i_callStkEQ                  20A   const  options(*nopass  )            |
     D  i_wait                       10I 0 const  options(*nopass  )            |
     D  i_callStkEDT                 10A   const  options(*nopass  )            | optGrp 2
     D  i_ccsid                      10I 0 const  options(*nopass  )            |
      *
      *  Receive Program Message (QMHRCVPM) API
     D QMHRCVPM        PR                         extpgm('QMHRCVPM')
     D  o_rcvVar                  32767A          options(*varsize )
     D  i_length                     10I 0 const
     D  i_format                      8A   const
     D  i_callStkE                   10A   const
     D  i_callStkC                   10I 0 const
     D  i_msgType                    10A   const
     D  i_msgKey                      4A   const
     D  i_wait                       10I 0 const
     D  i_action                     10A   const
     D  io_ErrCode                32767A          options(*varsize )
     D  i_lenStkE                    10I 0 const  options(*nopass  )            | optGrp 1
     D  i_callStkEQ                  20A   const  options(*nopass  )            |
     D  i_callStkEDT                 10A   const  options(*nopass  )            | optGrp 2
     D  i_ccsid                      10I 0 const  options(*nopass  )            |
      *
      *  Remove Program Messages (QMHRMVPM) API
     D QMHRMVPM        PR                         extpgm('QMHRMVPM')
     D  i_callStkE                   10A   const
     D  i_callStkC                   10I 0 const
     D  i_msgKey                      4A   const
     D  i_msgToRemove                10A   const
     D  io_ErrCode                32767A          options(*varsize )
     D  i_lenStkE                    10I 0 const  options(*nopass  )            | optGrp 1
     D  i_callStkEQ                  20A   const  options(*nopass  )            |
     D  i_rmvUnhExcp                 10A   const  options(*nopass  )            |
      *
      *  Process Commands (QCAPCMD) API
     D QCAPCMD...
     D                 PR                         extpgm('QCAPCMD')
     D  i_cmd...
     D                            32702A   const  options(*varsize)
     D  i_cmdLength...
     D                               10I 0 const
     D  i_optCtrlBlk...
     D                            32767A   const  options(*varsize)
     D  i_optCtrlBlkLength...
     D                               10I 0 const
     D  i_optCtrlBlkFormat...
     D                                8A   const
     D  o_chgCmd...
     D                            32702A          options(*varsize)
     D  i_chgCmdLength...
     D                               10I 0 const
     D  o_chgCmdLengthAvl...
     D                               10I 0
     D  io_errorCode...
     D                            32767A          options(*varsize)
      *
      *  Retrieve Object Description (QUSROBJD) API
     D QUSROBJD        PR                         extpgm('QUSROBJD')
     D  i_rcvVar                  32767A          options(*varsize)
     D  i_length                     10I 0 const
     D  i_format                      8A   const
     D  i_qObj                       20A   const
     D  i_objType                    10A   const
     D  io_ErrCode                32767A          options(*nopass: *varsize)    | optGrp
      *
      *  Retrieve Member Description (QUSRMBRD) API
     D QUSRMBRD        PR                         extpgm('QUSRMBRD')
     D  i_rcvVar                  32767A          options(*varsize)
     D  i_length                     10I 0 const
     D  i_format                      8A   const
     D  i_qFile                      20A   const
     D  i_mbr                        10A   const
     D  i_prcOverride                 1A   const
     D  io_ErrCode                32767A          options(*nopass: *varsize)    | optGrp 1
      *
      *  Convert Case (QLGCNVCS, QlgConvertCase) API
     D QlgConvertCase  PR                         extproc('QlgConvertCase')
     D  i_reqCtrlBlk              32767A   const  options(*varsize)
     D  i_inData                  32767A   const  options(*varsize)
     D  o_outData                 32767A          options(*varsize)
     D  i_length                     10I 0 const
     D  io_ErrCode                32767A          options(*nopass: *varsize)
      *
     D cCVTCASE_TYPE_ccsid...
     D                 C                   const(1)
      *
     D cCVTCASE_TYPE_table...
     D                 C                   const(2)
      *
     D cCVTCASE_TYPE_userDef...
     D                 C                   const(3)
      *
     D cCVTCASE_toUpper...
     D                 C                   const(0)
      *
     D cCVTCASE_toLower...
     D                 C                   const(1)
      *
     D cCVTCASE_CCSID_Job...
     D                 C                   const(0)
      *
     D reqCtrlBlk_t    DS                  qualified           based(pDummy)
     D  type                         10I 0
     D  CCSID                        10I 0
     D  case                         10I 0
     D  reserved                     10A
      *
      *  Convert Edit Code (QECCVTEC) API
     D QECCVTEC...
     D                 PR                  extpgm('QECCVTEC')
     D  o_editMask                  256A
     D  o_editMaskLen                10I 0
     D  o_rcvVarLen                  10I 0
     D  o_zeroFilChar                 1A
     D  i_editCode                    2A   const
     D  i_floatInd                    1A   const
     D  i_precision                  10I 0 const
     D  i_decPos                     10I 0 const
     D  io_ErrCode                32767A          options(*varsize)
      *
      *  Convert Edit Word (QECCVTEW) API
     D QECCVTEW...
     D                 PR                  extpgm('QECCVTEW')
     D  o_editMask                  256A
     D  o_editMaskLen                10I 0
     D  o_rcvVarLen                  10I 0
     D  i_editWord                32767A   const options(*varsize)
     D  i_editWordLen                10I 0 const
     D  io_ErrCode                32767A         options(*varsize)
      *
      *  Edit (QECEDT) API
     D QECEDT...
     D                 PR                  extpgm('QECEDT')
     D  o_rcvVar                  32767A         options(*varsize)
     D  i_rcvVarLen                  10I 0 const
     D  i_srcVar                  32767A   const options(*varsize)
     D  i_srcVarClass                10A   const
     D  i_srcVarPrec                 10I 0 const
     D  i_editMask                32767A   const options(*varsize)
     D  i_editMaskLen                10I 0 const
     D  i_zeroFilChar                 1A   const
     D  io_ErrCode                32767A         options(*varsize)
      *
      /ENDIF
