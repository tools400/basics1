**FREE
/IF NOT DEFINED(BASICR0)
/DEFINE BASICR0

// -----------------------------------------
//  Constants
// -----------------------------------------
/IF NOT DEFINED(cTrue)
/DEFINE cTrue
dcl-c cTrue const(*on );
/ENDIF

/IF NOT DEFINED(cFalse)
/DEFINE cFalse
dcl-c cFalse const(*off);
/ENDIF

// -----------------------------------------
//  Reference fields
// -----------------------------------------

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/COPY QBASICS1,CLIB
/COPY QBASICS1,CEELIB

//  Retrieve Message (QMHRTVM) API
dcl-pr QMHRTVM        extpgm('QMHRTVM');
  o_msgInf        char(32767) options(*varsize );
  i_length        int(10) const;
  i_format        char(8) const;
  i_msgID         char(7) const;
  i_qMsgF         char(20) const;
  i_rplData       char(32767) const  options(*varsize );
  i_rpldataLen    int(10) const;
  i_rplVars       char(10) const;
  i_rtnCtrlChrs   char(10) const;
  io_ErrCode      char(32767) options(*varsize );
end-pr;

//  Send Program Message (QMHSNDPM) API
dcl-pr QMHSNDPM        extpgm('QMHSNDPM');
  i_msgID         char(7) const;
  i_qMsgF         char(20) const;
  i_msgData       char(32767) const  options(*varsize );
  i_length        int(10) const;
  i_msgType       char(10) const;
  i_callStkE      char(32767) const  options(*varsize );
  i_callStkC      int(10) const;
  o_msgKey        char(4);
  io_ErrCode      char(32767) options(*varsize );
  i_lenStkE       int(10) const  options(*nopass  );                     // | optGrp 1
  i_callStkEQ     char(20) const  options(*nopass  );                    // |
  i_wait          int(10) const  options(*nopass  );                     // |
  i_callStkEDT    char(10) const  options(*nopass  );                    // | optGrp 2
  i_ccsid         int(10) const  options(*nopass  );                     // |
end-pr;

//  Receive Program Message (QMHRCVPM) API
dcl-pr QMHRCVPM        extpgm('QMHRCVPM');
  o_rcvVar        char(32767) options(*varsize );
  i_length        int(10) const;
  i_format        char(8) const;
  i_callStkE      char(10) const;
  i_callStkC      int(10) const;
  i_msgType       char(10) const;
  i_msgKey        char(4) const;
  i_wait          int(10) const;
  i_action        char(10) const;
  io_ErrCode      char(32767) options(*varsize );
  i_lenStkE       int(10) const  options(*nopass  );                     // | optGrp 1
  i_callStkEQ     char(20) const  options(*nopass  );                    // |
  i_callStkEDT    char(10) const  options(*nopass  );                    // | optGrp 2
  i_ccsid         int(10) const  options(*nopass  );                     // |
end-pr;

//  Remove Program Messages (QMHRMVPM) API
dcl-pr QMHRMVPM        extpgm('QMHRMVPM');
  i_callStkE      char(10) const;
  i_callStkC      int(10) const;
  i_msgKey        char(4) const;
  i_msgToRemove   char(10) const;
  io_ErrCode      char(32767) options(*varsize );
  i_lenStkE       int(10) const  options(*nopass  );                     // | optGrp 1
  i_callStkEQ     char(20) const  options(*nopass  );                    // |
  i_rmvUnhExcp    char(10) const  options(*nopass  );                    // |
end-pr;

//  Process Commands (QCAPCMD) API
dcl-pr QCAPCMD
       extpgm('QCAPCMD');
  i_cmd
  char(32702) const  options(*varsize);
  i_cmdLength
  int(10) const;
  i_optCtrlBlk
  char(32767) const  options(*varsize);
  i_optCtrlBlkLength
  int(10) const;
  i_optCtrlBlkFormat
  char(8) const;
  o_chgCmd
  char(32702) options(*varsize);
  i_chgCmdLength
  int(10) const;
  o_chgCmdLengthAvl
  int(10);
  io_errorCode
  char(32767) options(*varsize);
end-pr;

//  Retrieve Object Description (QUSROBJD) API
dcl-pr QUSROBJD        extpgm('QUSROBJD');
  i_rcvVar        char(32767) options(*varsize);
  i_length        int(10) const;
  i_format        char(8) const;
  i_qObj          char(20) const;
  i_objType       char(10) const;
  io_ErrCode      char(32767) options(*nopass: *varsize);                // | optGrp
end-pr;

//  Retrieve Member Description (QUSRMBRD) API
dcl-pr QUSRMBRD        extpgm('QUSRMBRD');
  i_rcvVar        char(32767) options(*varsize);
  i_length        int(10) const;
  i_format        char(8) const;
  i_qFile         char(20) const;
  i_mbr           char(10) const;
  i_prcOverride   char(1) const;
  io_ErrCode      char(32767) options(*nopass: *varsize);                // | optGrp 1
end-pr;

//  Convert Case (QLGCNVCS, QlgConvertCase) API
dcl-pr QlgConvertCase        extproc('QlgConvertCase');
  i_reqCtrlBlk    char(32767) const  options(*varsize);
  i_inData        char(32767) const  options(*varsize);
  o_outData       char(32767) options(*varsize);
  i_length        int(10) const;
  io_ErrCode      char(32767) options(*nopass: *varsize);
end-pr;

dcl-c cCVTCASE_TYPE_ccsid
      const(1);

dcl-c cCVTCASE_TYPE_table
      const(2);

dcl-c cCVTCASE_TYPE_userDef
      const(3);

dcl-c cCVTCASE_toUpper
      const(0);

dcl-c cCVTCASE_toLower
      const(1);

dcl-c cCVTCASE_CCSID_Job
      const(0);

dcl-ds reqCtrlBlk_t qualified           based(pDummy);
  type            int(10);
  CCSID           int(10);
  case            int(10);
  reserved        char(10);
end-ds;

//  Convert Edit Code (QECCVTEC) API
dcl-pr QECCVTEC
       extpgm('QECCVTEC');
  o_editMask      char(256);
  o_editMaskLen   int(10);
  o_rcvVarLen     int(10);
  o_zeroFilChar   char(1);
  i_editCode      char(2) const;
  i_floatInd      char(1) const;
  i_precision     int(10) const;
  i_decPos        int(10) const;
  io_ErrCode      char(32767) options(*varsize);
end-pr;

//  Convert Edit Word (QECCVTEW) API
dcl-pr QECCVTEW
       extpgm('QECCVTEW');
  o_editMask      char(256);
  o_editMaskLen   int(10);
  o_rcvVarLen     int(10);
  i_editWord      char(32767) const options(*varsize);
  i_editWordLen   int(10) const;
  io_ErrCode      char(32767) options(*varsize);
end-pr;

//  Edit (QECEDT) API
dcl-pr QECEDT
       extpgm('QECEDT');
  o_rcvVar        char(32767) options(*varsize);
  i_rcvVarLen     int(10) const;
  i_srcVar        char(32767) const options(*varsize);
  i_srcVarClass   char(10) const;
  i_srcVarPrec    int(10) const;
  i_editMask      char(32767) const options(*varsize);
  i_editMaskLen   int(10) const;
  i_zeroFilChar   char(1) const;
  io_ErrCode      char(32767) options(*varsize);
end-pr;

/ENDIF
