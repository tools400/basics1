**free
/if NOT DEFINED(MILIB)
/define MILIB

//  QSYSINC/MIH.MICOMMON: Requested Authority bitmasks and typedef
//                        The bitmasks are or'd together to give
//                        desired combinations
dcl-c AUTH_OBJ_CTRL x'8000';
dcl-c AUTH_OBJ_MGMT x'4000';
dcl-c AUTH_POINTER x'2000';
dcl-c AUTH_SPACE x'1000';
dcl-c AUTH_RETRIEVE x'0800';
dcl-c AUTH_INSERT x'0400';
dcl-c AUTH_DELETE x'0200';
dcl-c AUTH_UPDATE x'0100';
dcl-c AUTH_OWNER x'0080';
dcl-c AUTH_EXCLUDED x'0040';
dcl-c AUTH_LST_MGMT x'0020';
dcl-c AUTH_EXECUTE x'0010';
dcl-c AUTH_ALTER x'0008';
dcl-c AUTH_REF x'0004';
dcl-c AUTH_ALL x'FF1C';
dcl-c AUTH_NONE x'0000';

//  QSYSINC/MIH.MIOBJTYP:  MI Object Type
dcl-c MI_Program x'0201';
dcl-c MI_Library x'0401';
dcl-c MI_Usrspc x'1934';
dcl-c MI_Usrq x'0A02';
dcl-c MI_Usridx x'0E0A';
dcl-c WLI_ALRTBL x'0E09';
dcl-c WLI_AUTL x'1B01';
dcl-c WLI_BLKSF x'1E05';
dcl-c WLI_BNDDIR x'1937';
dcl-c WLI_CFGL x'0E0D';
dcl-c WLI_CHTFMT x'190D';
dcl-c WLI_CLD x'190B';
dcl-c WLI_CLS x'1904';
dcl-c WLI_CMD x'1905';
dcl-c WLI_CNNL x'1701';
dcl-c WLI_COSD x'1401';
dcl-c WLI_CRG x'192C';
dcl-c WLI_CRQD x'0E0F';
dcl-c WLI_CSI x'1935';
dcl-c WLI_CSPMAP x'1922';
dcl-c WLI_CSPTBL x'1923';
dcl-c WLI_CTLD x'1201';
dcl-c WLI_DDIR x'1F02';
dcl-c WLI_DEVD x'1001';
dcl-c WLI_DIR x'0C01';
dcl-c WLI_DOC x'190E';
dcl-c WLI_DSTMF x'1F01';
dcl-c WLI_DTAARA x'190A';
dcl-c WLI_DTADCT x'1920';
dcl-c WLI_DTAQ x'0A01';
dcl-c WLI_EDTD x'1908';
dcl-c WLI_EXITRG x'1913';
dcl-c WLI_FCT x'0E04';
dcl-c WLI_FILE x'1901';
dcl-c WLI_FLR x'1912';
dcl-c WLI_FNTRSC x'1926';
dcl-c WLI_FNTTBL x'192B';
dcl-c WLI_FORMDF x'1928';
dcl-c WLI_FTR x'0E0B';
dcl-c WLI_GSS x'190C';
dcl-c WLI_IGCDCT x'0E06';
dcl-c WLI_IGCSRT x'191A';
dcl-c WLI_IGCTBL x'1910';
dcl-c WLI_IPXD x'191E';
dcl-c WLI_JOBD x'1903';
dcl-c WLI_JOBQ x'0E01';
dcl-c WLI_JOBSCD x'0E0C';
dcl-c WLI_JRN x'0901';
dcl-c WLI_JRNRCV x'0701';
dcl-c WLI_LIB x'0401';
dcl-c WLI_LIND x'1101';
dcl-c WLI_LOCALE x'1921';
dcl-c WLI_MEDDFN x'191C';
dcl-c WLI_MENU x'1916';
dcl-c WLI_MGTCOL x'192D';
dcl-c WLI_MODD x'1501';
dcl-c WLI_MODULE x'0301';
dcl-c WLI_MSGF x'0E03';
dcl-c WLI_MSGQ x'1902';
dcl-c WLI_M36 x'1E04';
dcl-c WLI_M36CFG x'1924';
dcl-c WLI_NODL x'0E0E';
dcl-c WLI_NTBD x'1914';
dcl-c WLI_NWID x'1601';
dcl-c WLI_NWSD x'1D01';
dcl-c WLI_NODGRP x'192A';
dcl-c WLI_OOPOOL x'2002';
dcl-c WLI_OUTQ x'0E02';
dcl-c WLI_OVL x'1929';
dcl-c WLI_PAGDFN x'1936';
dcl-c WLI_PAGSEG x'1927';
dcl-c WLI_PDG x'1930';
dcl-c WLI_PGM x'0201';
dcl-c WLI_PNLGRP x'1915';
dcl-c WLI_PRDAVL x'1933';
dcl-c WLI_PRDDFN x'191B';
dcl-c WLI_PRDLOD x'191D';
dcl-c WLI_PSFCFG x'1925';
dcl-c WLI_QMFORM x'1932';
dcl-c WLI_QMQRY x'1931';
dcl-c WLI_QRYDFN x'1911';
dcl-c WLI_RCT x'0E08';
dcl-c WLI_S36 x'1919';
dcl-c WLI_SBSD x'1909';
dcl-c WLI_SCHIDX x'0E07';
dcl-c WLI_SOCKET x'1E03';
dcl-c WLI_SOMOBJ x'2001';
dcl-c WLI_SPADCT x'1C01';
dcl-c WLI_SQLPKG x'0202';
dcl-c WLI_SQLUDT x'191F';
dcl-c WLI_SRVPGM x'0203';
dcl-c WLI_SSND x'0E05';
dcl-c WLI_STMF x'1E01';
dcl-c WLI_SVRSTG x'1917';
dcl-c WLI_SYMLNK x'1E02';
dcl-c WLI_TBL x'1906';
dcl-c WLI_USRPRF x'0801';
dcl-c WLI_USRIDX x'0E0A';
dcl-c WLI_USRQ x'0A02';
dcl-c WLI_USRSPC x'1934';
dcl-c WLI_VLDL x'0E10';
dcl-c WLI_WSCST x'1938';

//  Activate Bound Program, Returned value: Activation mark
dcl-pr QleActBndPgm int(10) extproc('QleActBndPgm');
  i_pgmPtr    pointer(*proc) const;
  i_actMark   int(10) options(*omit) const;
  i_actInf    char(32767) options(*omit: *varsize) const;
  i_actInfLen int(10) options(*omit) const;
  io_errCode  char(32767) options(*omit: *varsize);
end-pr;

//  Type definitions
dcl-ds actInf_t qualified based(pDummy);
  bytRet     int(10);
  bytAvl     int(10);
  reserved_1 char(8);
  actGrpMark int(10);
  actMark    int(10);
  reserved_2 char(7);
  flags      char(1);
  reserved_3 char(16);
end-ds;

//  Get Export, Returned value: Exported item - PTR(OPN)
dcl-pr QleGetExp pointer extproc('QleGetExp');
  i_actMark    int(10) options(*omit) const;
  i_expNum     int(10) options(*omit) const;
  i_expNameLen int(10) options(*omit) const;
  i_expName    char(32767) options(*omit: *varsize) const;
  o_pExpItem   pointer(*proc) options(*omit);
  o_expItmType int(10) options(*omit);
  io_errCode   char(32767) options(*omit: *varsize);
end-pr;
/if NOT DEFINED(TESTPTR)
/define TESTPTR

//  Test Pointer (TESTPTR)
dcl-pr testptr int(10) extproc('_TESTPTR');
  i_ptr       pointer value;
  i_test_type int(10) value;
end-pr;

dcl-c cTESTPTR_TYPE_PROCPTR 0;
dcl-c cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING 0;
dcl-c cTESTPTR_OPTIMIZED_PARAMETER_PASSING 1;

dcl-c cTESTPTR_TYPE_MEMPTR 1;
dcl-c cTESTPTR_NON_TERASPACE 0;
dcl-c cTESTPTR_TERASPACE 1;

dcl-c cTESTPTR_ERROR_NOT_EXIST x'2401';
dcl-c cTESTPTR_ERROR_INVALID x'2402';
dcl-c cTESTPTR_ERROR_OBJECT_DESTROYED x'2202';
/endif

//  Materialize Pointer (MATPTR)
dcl-pr matptr int(10) extproc('matptr');
  i_MPTR_Template_T pointer value;
  i_anyPtr          pointer value;
end-pr;

dcl-ds matptr_TPL_t qualified based(pDummy);
  bytPrv int(10);
  bytAvl int(10);
  type   char(1);
end-ds;

dcl-ds matptr_spacePtr_TPL_t qualified based(pDummy);
  baseInf        likeds(matptr_TPL_t);
  ContextID      char(32) pos(10);
  ContextType    char(1) pos(10);
  ContextSubType char(1) pos(11);
  ContextName    char(30) pos(12);
  ObjectID       char(32) pos(42);
  ObjectType     char(1) pos(42);
  ObjectSubType  char(1) pos(43);
  ObjectName     char(30) pos(44);
  offSpace       int(10) pos(74);
  PtrTragetInf   char(2) pos(78);
  reserved_1     char(1) pos(80);
  extOffSpace    int(20) pos(81);
end-ds;

//  Resolve System Pointer (RSLVSP)
dcl-pr rslvsp pointer(*proc) extproc('rslvsp');
  i_objtype uns(5) value;
  i_obj     pointer options(*string) value;
  i_lib     pointer options(*string) value;
  i_auth    uns(5) value;
end-pr;

//  Convert Type (QLICVTTP) API
dcl-pr QLICVTTP extpgm('QLICVTTP');
  i_conversion  char(10) const;
  io_symObjType char(10);
  io_hexObjType uns(5);
  io_errCode    char(32767) options(*varsize);
end-pr;

//  AND String (ANDSTR)
dcl-pr ANDSTR extproc('_ANDSTR');
  i_pReceiver  pointer value;
  i_pFirstSrc  pointer value;
  i_pSecondSrc pointer value;
  i_length     uns(10) value;
end-pr;

//  OR String (ORSTR)
dcl-pr ORSTR extproc('_ORSTR');
  i_pReceiver  pointer value;
  i_pFirstSrc  pointer value;
  i_pSecondSrc pointer value;
  i_length     uns(10) value;
end-pr;

//  XOR (Exclusive Or) String (XORSTR)
dcl-pr XORSTR extproc('_XORSTR');
  i_pReceiver  pointer value;
  i_pFirstSrc  pointer value;
  i_pSecondSrc pointer value;
  i_length     uns(10) value;
end-pr;

//  Complement String (COMSTR)
dcl-pr COMSTR extproc('_COMSTR');
  i_pReceiver pointer value;
  i_pSource   pointer value;
  i_length    uns(10) value;
end-pr;

//  The standard definition for time in the MI library (QSYSINC/MIH.MICOMMON):
dcl-s mi_time_t char(8) inz;

//  The following values can be OR'd for the Wait Options parameter
//  on the WAITTIME invocation.
dcl-c cWAIT_NORMAL 0; // x'0000'
dcl-c cWAIT_MOD_AS_ENTER 32768; // x'8000'
dcl-c cWAIT_MOD_AS_LEAVE 16384; // x'4000'
dcl-c cWAIT_MPL_SET 8192; // x'2000'
dcl-c cWAIT_SIGNALS 4096; // x'1000'

//  Wait On Time (WAITTIME)
dcl-pr waitTime extproc('waittime');
  pmi_time like(mi_time_t) const;
  option   int(5) value;
end-pr;

//  Use mitime function to form an AS/400 system value for time
dcl-pr mitime pointer extproc('mitime');
  mi_time like(mi_time_t) const;
  hour    int(10) value;
  min     int(10) value;
  sec     int(10) value;
  hsec    int(10) value;
end-pr;

/endif