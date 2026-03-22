**FREE
/IF NOT DEFINED(MILIB)
/DEFINE MILIB

//  QSYSINC/MIH.MICOMMON: Requested Authority bitmasks and typedef
//                        The bitmasks are or'd together to give
//                        desired combinations
dcl-c AUTH_OBJ_CTRL const(x'8000');
dcl-c AUTH_OBJ_MGMT const(x'4000');
dcl-c AUTH_POINTER const(x'2000');
dcl-c AUTH_SPACE const(x'1000');
dcl-c AUTH_RETRIEVE const(x'0800');
dcl-c AUTH_INSERT const(x'0400');
dcl-c AUTH_DELETE const(x'0200');
dcl-c AUTH_UPDATE const(x'0100');
dcl-c AUTH_OWNER const(x'0080');
dcl-c AUTH_EXCLUDED const(x'0040');
dcl-c AUTH_LST_MGMT const(x'0020');
dcl-c AUTH_EXECUTE const(x'0010');
dcl-c AUTH_ALTER const(x'0008');
dcl-c AUTH_REF const(x'0004');
dcl-c AUTH_ALL const(x'FF1C');
dcl-c AUTH_NONE const(x'0000');

//  QSYSINC/MIH.MIOBJTYP:  MI Object Type
dcl-c MI_Program const(x'0201');
dcl-c MI_Library const(x'0401');
dcl-c MI_Usrspc const(x'1934');
dcl-c MI_Usrq const(x'0A02');
dcl-c MI_Usridx const(x'0E0A');
dcl-c WLI_ALRTBL const(x'0E09');
dcl-c WLI_AUTL const(x'1B01');
dcl-c WLI_BLKSF const(x'1E05');
dcl-c WLI_BNDDIR const(x'1937');
dcl-c WLI_CFGL const(x'0E0D');
dcl-c WLI_CHTFMT const(x'190D');
dcl-c WLI_CLD const(x'190B');
dcl-c WLI_CLS const(x'1904');
dcl-c WLI_CMD const(x'1905');
dcl-c WLI_CNNL const(x'1701');
dcl-c WLI_COSD const(x'1401');
dcl-c WLI_CRG const(x'192C');
dcl-c WLI_CRQD const(x'0E0F');
dcl-c WLI_CSI const(x'1935');
dcl-c WLI_CSPMAP const(x'1922');
dcl-c WLI_CSPTBL const(x'1923');
dcl-c WLI_CTLD const(x'1201');
dcl-c WLI_DDIR const(x'1F02');
dcl-c WLI_DEVD const(x'1001');
dcl-c WLI_DIR const(x'0C01');
dcl-c WLI_DOC const(x'190E');
dcl-c WLI_DSTMF const(x'1F01');
dcl-c WLI_DTAARA const(x'190A');
dcl-c WLI_DTADCT const(x'1920');
dcl-c WLI_DTAQ const(x'0A01');
dcl-c WLI_EDTD const(x'1908');
dcl-c WLI_EXITRG const(x'1913');
dcl-c WLI_FCT const(x'0E04');
dcl-c WLI_FILE const(x'1901');
dcl-c WLI_FLR const(x'1912');
dcl-c WLI_FNTRSC const(x'1926');
dcl-c WLI_FNTTBL const(x'192B');
dcl-c WLI_FORMDF const(x'1928');
dcl-c WLI_FTR const(x'0E0B');
dcl-c WLI_GSS const(x'190C');
dcl-c WLI_IGCDCT const(x'0E06');
dcl-c WLI_IGCSRT const(x'191A');
dcl-c WLI_IGCTBL const(x'1910');
dcl-c WLI_IPXD const(x'191E');
dcl-c WLI_JOBD const(x'1903');
dcl-c WLI_JOBQ const(x'0E01');
dcl-c WLI_JOBSCD const(x'0E0C');
dcl-c WLI_JRN const(x'0901');
dcl-c WLI_JRNRCV const(x'0701');
dcl-c WLI_LIB const(x'0401');
dcl-c WLI_LIND const(x'1101');
dcl-c WLI_LOCALE const(x'1921');
dcl-c WLI_MEDDFN const(x'191C');
dcl-c WLI_MENU const(x'1916');
dcl-c WLI_MGTCOL const(x'192D');
dcl-c WLI_MODD const(x'1501');
dcl-c WLI_MODULE const(x'0301');
dcl-c WLI_MSGF const(x'0E03');
dcl-c WLI_MSGQ const(x'1902');
dcl-c WLI_M36 const(x'1E04');
dcl-c WLI_M36CFG const(x'1924');
dcl-c WLI_NODL const(x'0E0E');
dcl-c WLI_NTBD const(x'1914');
dcl-c WLI_NWID const(x'1601');
dcl-c WLI_NWSD const(x'1D01');
dcl-c WLI_NODGRP const(x'192A');
dcl-c WLI_OOPOOL const(x'2002');
dcl-c WLI_OUTQ const(x'0E02');
dcl-c WLI_OVL const(x'1929');
dcl-c WLI_PAGDFN const(x'1936');
dcl-c WLI_PAGSEG const(x'1927');
dcl-c WLI_PDG const(x'1930');
dcl-c WLI_PGM const(x'0201');
dcl-c WLI_PNLGRP const(x'1915');
dcl-c WLI_PRDAVL const(x'1933');
dcl-c WLI_PRDDFN const(x'191B');
dcl-c WLI_PRDLOD const(x'191D');
dcl-c WLI_PSFCFG const(x'1925');
dcl-c WLI_QMFORM const(x'1932');
dcl-c WLI_QMQRY const(x'1931');
dcl-c WLI_QRYDFN const(x'1911');
dcl-c WLI_RCT const(x'0E08');
dcl-c WLI_S36 const(x'1919');
dcl-c WLI_SBSD const(x'1909');
dcl-c WLI_SCHIDX const(x'0E07');
dcl-c WLI_SOCKET const(x'1E03');
dcl-c WLI_SOMOBJ const(x'2001');
dcl-c WLI_SPADCT const(x'1C01');
dcl-c WLI_SQLPKG const(x'0202');
dcl-c WLI_SQLUDT const(x'191F');
dcl-c WLI_SRVPGM const(x'0203');
dcl-c WLI_SSND const(x'0E05');
dcl-c WLI_STMF const(x'1E01');
dcl-c WLI_SVRSTG const(x'1917');
dcl-c WLI_SYMLNK const(x'1E02');
dcl-c WLI_TBL const(x'1906');
dcl-c WLI_USRPRF const(x'0801');
dcl-c WLI_USRIDX const(x'0E0A');
dcl-c WLI_USRQ const(x'0A02');
dcl-c WLI_USRSPC const(x'1934');
dcl-c WLI_VLDL const(x'0E10');
dcl-c WLI_WSCST const(x'1938');

//  Activate Bound Program, Returned value: Activation mark
dcl-pr QleActBndPgm    int(10) extproc('QleActBndPgm');
  i_pgmPtr        pointer(*proc) const;
  i_actMark       int(10) const   options(*omit);
  i_actInf        char(32767) const   options(*omit: *varsize);
  i_actInfLen     int(10) const   options(*omit);
  io_errCode      char(32767) options(*omit: *varsize);
end-pr;

//  Type definitions
dcl-ds actInf_t qualified      based(pDummy);
  bytRet          int(10);
  bytAvl          int(10);
  reserved_1      char(8);
  actGrpMark      int(10);
  actMark         int(10);
  reserved_2      char(7);
  flags           char(1);
  reserved_3      char(16);
end-ds;

//  Get Export, Returned value: Exported item - PTR(OPN)
dcl-pr QleGetExp       pointer extproc('QleGetExp');
  i_actMark       int(10) const   options(*omit);
  i_expNum        int(10) const   options(*omit);
  i_expNameLen    int(10) const   options(*omit);
  i_expName       char(32767) const   options(*omit: *varsize);
  o_pExpItem      pointer(*proc) options(*omit);
  o_expItmType    int(10) options(*omit);
  io_errCode      char(32767) options(*omit: *varsize);
end-pr;
/IF NOT DEFINED(TESTPTR)
/DEFINE TESTPTR

//  Test Pointer (TESTPTR)
dcl-pr testptr         int(10) extproc('_TESTPTR');
  i_ptr           pointer value;
  i_test_type     int(10) value;
end-pr;

dcl-c cTESTPTR_TYPE_PROCPTR
      0;
dcl-c cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING
      0;
dcl-c cTESTPTR_OPTIMIZED_PARAMETER_PASSING
      1;

dcl-c cTESTPTR_TYPE_MEMPTR
      1;
dcl-c cTESTPTR_NON_TERASPACE
      0;
dcl-c cTESTPTR_TERASPACE
      1;

dcl-c cTESTPTR_ERROR_NOT_EXIST
      x'2401';
dcl-c cTESTPTR_ERROR_INVALID
      x'2402';
dcl-c cTESTPTR_ERROR_OBJECT_DESTROYED
      x'2202';
/ENDIF

//  Materialize Pointer (MATPTR)
dcl-pr matptr          int(10) extproc('matptr');
  i_MPTR_Template_T
  pointer value;
  i_anyPtr        pointer value;
end-pr;

dcl-ds matptr_TPL_t qualified               based(pDummy);
  bytPrv          int(10);
  bytAvl          int(10);
  type            char(1);
end-ds;

dcl-ds matptr_spacePtr_TPL_t
       qualified               based(pDummy);
  baseInf         likeds(matptr_TPL_t );
ContextID       char(32) pos(10);
ContextType     char(1) pos(10);
ContextSubType
char(1) pos(11);
ContextName     char(30) pos(12);
ObjectID        char(32) pos(42);
ObjectType      char(1) pos(42);
ObjectSubType
char(1) pos(43);
ObjectName      char(30) pos(44);
offSpace        int(10) pos(74);
PtrTragetInf    char(2) pos(78);
reserved_1      char(1) pos(80);
extOffSpace     int(20) pos(81);
end-ds;

//  Resolve System Pointer (RSLVSP)
dcl-pr rslvsp
       pointer(*proc) extproc('rslvsp');
  i_objtype       uns(5) value;
  i_obj           pointer value   options(*string);
  i_lib           pointer value   options(*string);
  i_auth          uns(5) value;
end-pr;

//  Convert Type (QLICVTTP) API
dcl-pr QLICVTTP
       extpgm('QLICVTTP');
  i_conversion    char(10) const;
  io_symObjType   char(10);
  io_hexObjType   uns(5);
  io_errCode      char(32767) options(*varsize);
end-pr;

//  AND String (ANDSTR)
dcl-pr ANDSTR
       extproc('_ANDSTR');
  i_pReceiver     pointer value;
  i_pFirstSrc     pointer value;
  i_pSecondSrc    pointer value;
  i_length        uns(10) value;
end-pr;

//  OR String (ORSTR)
dcl-pr ORSTR
       extproc('_ORSTR');
  i_pReceiver     pointer value;
  i_pFirstSrc     pointer value;
  i_pSecondSrc    pointer value;
  i_length        uns(10) value;
end-pr;

//  XOR (Exclusive Or) String (XORSTR)
dcl-pr XORSTR
       extproc('_XORSTR');
  i_pReceiver     pointer value;
  i_pFirstSrc     pointer value;
  i_pSecondSrc    pointer value;
  i_length        uns(10) value;
end-pr;

//  Complement String (COMSTR)
dcl-pr COMSTR
       extproc('_COMSTR');
  i_pReceiver     pointer value;
  i_pSource       pointer value;
  i_length        uns(10) value;
end-pr;

//  The standard definition for time in the MI library (QSYSINC/MIH.MICOMMON):
dcl-s mi_time_t       char(8) inz;

//  The following values can be OR'd for the Wait Options parameter
//  on the WAITTIME invocation.
dcl-c cWAIT_NORMAL
      0;                                                                 // x'0000'
dcl-c cWAIT_MOD_AS_ENTER
      32768;                                                             // x'8000'
dcl-c cWAIT_MOD_AS_LEAVE
      16384;                                                             // x'4000'
dcl-c cWAIT_MPL_SET
      8192;                                                              // x'2000'
dcl-c cWAIT_SIGNALS
      4096;                                                              // x'1000'

//  Wait On Time (WAITTIME)
dcl-pr waitTime extproc('waittime');
  pmi_time        const  like(mi_time_t);
  option          int(5) value;
end-pr;

//  Use mitime function to form an AS/400 system value for time
dcl-pr mitime          pointer extproc('mitime');
  mi_time         const  like(mi_time_t);
  hour            int(10) value;
  min             int(10) value;
  sec             int(10) value;
  hsec            int(10) value;
end-pr;

/ENDIF
