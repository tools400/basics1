 DEF  /IF NOT DEFINED(MILIB)
 DEF  /DEFINE MILIB
      *
      *  QSYSINC/MIH.MICOMMON: Requested Authority bitmasks and typedef
      *                        The bitmasks are or'd together to give
      *                        desired combinations
     D AUTH_OBJ_CTRL   C                   const(x'8000')
     D AUTH_OBJ_MGMT   C                   const(x'4000')
     D AUTH_POINTER    C                   const(x'2000')
     D AUTH_SPACE      C                   const(x'1000')
     D AUTH_RETRIEVE   C                   const(x'0800')
     D AUTH_INSERT     C                   const(x'0400')
     D AUTH_DELETE     C                   const(x'0200')
     D AUTH_UPDATE     C                   const(x'0100')
     D AUTH_OWNER      C                   const(x'0080')
     D AUTH_EXCLUDED   C                   const(x'0040')
     D AUTH_LST_MGMT   C                   const(x'0020')
     D AUTH_EXECUTE    C                   const(x'0010')
     D AUTH_ALTER      C                   const(x'0008')
     D AUTH_REF        C                   const(x'0004')
     D AUTH_ALL        C                   const(x'FF1C')
     D AUTH_NONE       C                   const(x'0000')
      *
      *  QSYSINC/MIH.MIOBJTYP:  MI Object Type
     D MI_Program      C                   const(x'0201')
     D MI_Library      C                   const(x'0401')
     D MI_Usrspc       C                   const(x'1934')
     D MI_Usrq         C                   const(x'0A02')
     D MI_Usridx       C                   const(x'0E0A')
     D WLI_ALRTBL      C                   const(x'0E09')
     D WLI_AUTL        C                   const(x'1B01')
     D WLI_BLKSF       C                   const(x'1E05')
     D WLI_BNDDIR      C                   const(x'1937')
     D WLI_CFGL        C                   const(x'0E0D')
     D WLI_CHTFMT      C                   const(x'190D')
     D WLI_CLD         C                   const(x'190B')
     D WLI_CLS         C                   const(x'1904')
     D WLI_CMD         C                   const(x'1905')
     D WLI_CNNL        C                   const(x'1701')
     D WLI_COSD        C                   const(x'1401')
     D WLI_CRG         C                   const(x'192C')
     D WLI_CRQD        C                   const(x'0E0F')
     D WLI_CSI         C                   const(x'1935')
     D WLI_CSPMAP      C                   const(x'1922')
     D WLI_CSPTBL      C                   const(x'1923')
     D WLI_CTLD        C                   const(x'1201')
     D WLI_DDIR        C                   const(x'1F02')
     D WLI_DEVD        C                   const(x'1001')
     D WLI_DIR         C                   const(x'0C01')
     D WLI_DOC         C                   const(x'190E')
     D WLI_DSTMF       C                   const(x'1F01')
     D WLI_DTAARA      C                   const(x'190A')
     D WLI_DTADCT      C                   const(x'1920')
     D WLI_DTAQ        C                   const(x'0A01')
     D WLI_EDTD        C                   const(x'1908')
     D WLI_EXITRG      C                   const(x'1913')
     D WLI_FCT         C                   const(x'0E04')
     D WLI_FILE        C                   const(x'1901')
     D WLI_FLR         C                   const(x'1912')
     D WLI_FNTRSC      C                   const(x'1926')
     D WLI_FNTTBL      C                   const(x'192B')
     D WLI_FORMDF      C                   const(x'1928')
     D WLI_FTR         C                   const(x'0E0B')
     D WLI_GSS         C                   const(x'190C')
     D WLI_IGCDCT      C                   const(x'0E06')
     D WLI_IGCSRT      C                   const(x'191A')
     D WLI_IGCTBL      C                   const(x'1910')
     D WLI_IPXD        C                   const(x'191E')
     D WLI_JOBD        C                   const(x'1903')
     D WLI_JOBQ        C                   const(x'0E01')
     D WLI_JOBSCD      C                   const(x'0E0C')
     D WLI_JRN         C                   const(x'0901')
     D WLI_JRNRCV      C                   const(x'0701')
     D WLI_LIB         C                   const(x'0401')
     D WLI_LIND        C                   const(x'1101')
     D WLI_LOCALE      C                   const(x'1921')
     D WLI_MEDDFN      C                   const(x'191C')
     D WLI_MENU        C                   const(x'1916')
     D WLI_MGTCOL      C                   const(x'192D')
     D WLI_MODD        C                   const(x'1501')
     D WLI_MODULE      C                   const(x'0301')
     D WLI_MSGF        C                   const(x'0E03')
     D WLI_MSGQ        C                   const(x'1902')
     D WLI_M36         C                   const(x'1E04')
     D WLI_M36CFG      C                   const(x'1924')
     D WLI_NODL        C                   const(x'0E0E')
     D WLI_NTBD        C                   const(x'1914')
     D WLI_NWID        C                   const(x'1601')
     D WLI_NWSD        C                   const(x'1D01')
     D WLI_NODGRP      C                   const(x'192A')
     D WLI_OOPOOL      C                   const(x'2002')
     D WLI_OUTQ        C                   const(x'0E02')
     D WLI_OVL         C                   const(x'1929')
     D WLI_PAGDFN      C                   const(x'1936')
     D WLI_PAGSEG      C                   const(x'1927')
     D WLI_PDG         C                   const(x'1930')
     D WLI_PGM         C                   const(x'0201')
     D WLI_PNLGRP      C                   const(x'1915')
     D WLI_PRDAVL      C                   const(x'1933')
     D WLI_PRDDFN      C                   const(x'191B')
     D WLI_PRDLOD      C                   const(x'191D')
     D WLI_PSFCFG      C                   const(x'1925')
     D WLI_QMFORM      C                   const(x'1932')
     D WLI_QMQRY       C                   const(x'1931')
     D WLI_QRYDFN      C                   const(x'1911')
     D WLI_RCT         C                   const(x'0E08')
     D WLI_S36         C                   const(x'1919')
     D WLI_SBSD        C                   const(x'1909')
     D WLI_SCHIDX      C                   const(x'0E07')
     D WLI_SOCKET      C                   const(x'1E03')
     D WLI_SOMOBJ      C                   const(x'2001')
     D WLI_SPADCT      C                   const(x'1C01')
     D WLI_SQLPKG      C                   const(x'0202')
     D WLI_SQLUDT      C                   const(x'191F')
     D WLI_SRVPGM      C                   const(x'0203')
     D WLI_SSND        C                   const(x'0E05')
     D WLI_STMF        C                   const(x'1E01')
     D WLI_SVRSTG      C                   const(x'1917')
     D WLI_SYMLNK      C                   const(x'1E02')
     D WLI_TBL         C                   const(x'1906')
     D WLI_USRPRF      C                   const(x'0801')
     D WLI_USRIDX      C                   const(x'0E0A')
     D WLI_USRQ        C                   const(x'0A02')
     D WLI_USRSPC      C                   const(x'1934')
     D WLI_VLDL        C                   const(x'0E10')
     D WLI_WSCST       C                   const(x'1938')
      *
      *  Activate Bound Program, Returned value: Activation mark
     D QleActBndPgm    PR            10I 0 extproc('QleActBndPgm')
     D  i_pgmPtr                       *   const   procptr
     D  i_actMark                    10I 0 const   options(*omit)
     D  i_actInf                  32767A   const   options(*omit: *varsize)
     D  i_actInfLen                  10I 0 const   options(*omit)
     D  io_errCode                32767A           options(*omit: *varsize)
      *
      *  Type definitions
     D actInf_t        DS                  qualified      based(pDummy)
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  reserved_1             9     16A
     D  actGrpMark            17     20I 0
     D  actMark               21     24I 0
     D  reserved_2            25     31A
     D  flags                 32     32A
     D  reserved_3            33     48A
      *
      *  Get Export, Returned value: Exported item - PTR(OPN)
     D QleGetExp       PR              *   extproc('QleGetExp')
     D  i_actMark                    10I 0 const   options(*omit)
     D  i_expNum                     10I 0 const   options(*omit)
     D  i_expNameLen                 10I 0 const   options(*omit)
     D  i_expName                 32767A   const   options(*omit: *varsize)
     D  o_pExpItem                     *           options(*omit) procptr
     D  o_expItmType                 10I 0         options(*omit)
     D  io_errCode                32767A           options(*omit: *varsize)
      /IF NOT DEFINED(TESTPTR)
      /DEFINE TESTPTR
      *
      *  Test Pointer (TESTPTR)
     D testptr         PR            10I 0 extproc('_TESTPTR')
     D  i_ptr                          *   value
     D  i_test_type                  10I 0 value
      *
     D cTESTPTR_TYPE_PROCPTR...
     D                 C                   0
     D cTESTPTR_NO_OPTIMIZED_PARAMETER_PASSING...
     D                 C                   0
     D cTESTPTR_OPTIMIZED_PARAMETER_PASSING...
     D                 C                   1
      *
     D cTESTPTR_TYPE_MEMPTR...
     D                 C                   1
     D cTESTPTR_NON_TERASPACE...
     D                 C                   0
     D cTESTPTR_TERASPACE...
     D                 C                   1
      *
     D cTESTPTR_ERROR_NOT_EXIST...
     D                 C                   x'2401'
     D cTESTPTR_ERROR_INVALID...
     D                 C                   x'2402'
     D cTESTPTR_ERROR_OBJECT_DESTROYED...
     D                 C                   x'2202'
      /ENDIF
      *
      *  Materialize Pointer (MATPTR)
     D matptr          PR            10I 0 extproc('matptr')
     D  i_MPTR_Template_T...
     D                                 *   value
     D  i_anyPtr                       *   value
      *
     D matptr_TPL_t    DS                  qualified               based(pDummy)
     D  bytPrv                 1      4I 0
     D  bytAvl                 5      8I 0
     D  type                   9      9A
      *
     D matptr_spacePtr_TPL_t...
     D                 DS                  qualified               based(pDummy)
     D  baseInf                            likeds(matptr_TPL_t )
     D  ContextID             10     41A
     D   ContextType          10     10A
     D   ContextSubType...
     D                        11     11A
     D   ContextName          12     41A
     D  ObjectID              42     73A
     D   ObjectType           42     42A
     D   ObjectSubType...
     D                        43     43A
     D   ObjectName           44     73A
     D  offSpace              74     77I 0
     D  PtrTragetInf          78     79A
     D  reserved_1            80     80A
     D  extOffSpace           81     88I 0
      *
      *  Resolve System Pointer (RSLVSP)
     D rslvsp...
     D                 PR              *   extproc('rslvsp') procptr
     D  i_objtype                     5U 0 value
     D  i_obj                          *   value   options(*string)
     D  i_lib                          *   value   options(*string)
     D  i_auth                        5U 0 value
      *
      *  Convert Type (QLICVTTP) API
     D QLICVTTP...
     D                 PR                  extpgm('QLICVTTP')
     D  i_conversion                 10A   const
     D  io_symObjType                10A
     D  io_hexObjType                 5U 0
     D  io_errCode                32767A          options(*varsize)
      *
      *  AND String (ANDSTR)
     D ANDSTR...
     D                 PR                  extproc('_ANDSTR')
     D  i_pReceiver                    *   value
     D  i_pFirstSrc                    *   value
     D  i_pSecondSrc                   *   value
     D  i_length                     10U 0 value
      *
      *  OR String (ORSTR)
     D ORSTR...
     D                 PR                  extproc('_ORSTR')
     D  i_pReceiver                    *   value
     D  i_pFirstSrc                    *   value
     D  i_pSecondSrc                   *   value
     D  i_length                     10U 0 value
      *
      *  XOR (Exclusive Or) String (XORSTR)
     D XORSTR...
     D                 PR                  extproc('_XORSTR')
     D  i_pReceiver                    *   value
     D  i_pFirstSrc                    *   value
     D  i_pSecondSrc                   *   value
     D  i_length                     10U 0 value
      *
      *  Complement String (COMSTR)
     D COMSTR...
     D                 PR                  extproc('_COMSTR')
     D  i_pReceiver                    *   value
     D  i_pSource                      *   value
     D  i_length                     10U 0 value
      *
      *  The standard definition for time in the MI library (QSYSINC/MIH.MICOMMON):
     D mi_time_t       S              8A   inz
      *
      *  The following values can be OR'd for the Wait Options parameter
      *  on the WAITTIME invocation.
     D cWAIT_NORMAL...
     D                 C                   0                                    x'0000'
     D cWAIT_MOD_AS_ENTER...
     D                 C                   32768                                x'8000'
     D cWAIT_MOD_AS_LEAVE...
     D                 C                   16384                                x'4000'
     D cWAIT_MPL_SET...
     D                 C                   8192                                 x'2000'
     D cWAIT_SIGNALS...
     D                 C                   4096                                 x'1000'
      *
      *  Wait On Time (WAITTIME)
     D waitTime        PR                  extproc('waittime')
     D  pmi_time                           const  like(mi_time_t)
     D  option                        5I 0 value
      *
      *  Use mitime function to form an AS/400 system value for time
     D mitime          PR              *   extproc('mitime')
     D  mi_time                            const  like(mi_time_t)
     D  hour                         10I 0 value
     D  min                          10I 0 value
     D  sec                          10I 0 value
     D  hsec                         10I 0 value
      *
 DEF  /ENDIF
