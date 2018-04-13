      /IF NOT DEFINED(QWCRSVAL)
      /DEFINE QWCRSVAL
      *
      *  Retrieve System Values (QWCRSVAL) API
     D QWCRSVAL...
     D                 PR                         extpgm('QWCRSVAL')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_numSysVal                  10I 0 const
     D  i_arySysVal                  10A   const  options(*varsize) dim(128)
     D  io_errCode                65535A          options(*varsize)
      *
      *  Return value
     D QWCRSVAL_rtnValue_t...
     D                 DS          4096    qualified               based(pDummy)
     D  numSysValRtn                 10I 0
     D  ofsSysValTbl                 10I 0 dim(128)
      *
     D QWCRSVAL_sysValInfTbl_t...
     D                 DS                  qualified   based(pSysValTbl)
     D  sysVal                       10A
     D  type                          1A
     D  infStatus                     1A
     D  length                       10I 0
     D  data                       4096A
      *
      * --------------------------------------------------
      *  Pre-defined structures for complex system values
      * --------------------------------------------------
      *
      *  QACGLVL:         Accounting level
     D QWCRSVAL_acgLvl_t...
     D                 DS                  qualified
     D  option                       10A   dim(8)
      *
      *  QALWOBJRST:      Allow object restore options
     D QWCRSVAL_alwObjRst_t...
     D                 DS                  qualified
     D  option                       10A   dim(15)
      *
      *  QALWUSRDMN:      Allow user domain
     D QWCRSVAL_alwUsrDmn_t...
     D                 DS                  qualified
     D  lib                          10A   dim(50)
      *
      *  QATNPGM:        Attention program
     D QWCRSVAL_atnPgm_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QAUDCTL:         Auditing control
     D QWCRSVAL_audCtl_t...
     D                 DS                  qualified
     D  option                       10A   dim(5)
      *
      *  QAUDLVL:         Auditing level
     D QWCRSVAL_audLvl_t...
     D                 DS                  qualified
     D  option                       10A   dim(16)
      *
      *  QAUDLVL2:        Auditing level extension
     D QWCRSVAL_audLvl2_t...
     D                 DS                  qualified
     D  option                       10A   dim(99)
      *
      *  QBOOKPATH:      Book and bookshelf search path
     D QWCRSVAL_bookPath_t...
     D                 DS                  qualified
     D  path                         63A   dim(5)
      *
      *  QCFGMSGQ:       Configuration message queue
     D QWCRSVAL_cfgMsgQ_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QCHRID:         Character set and code page
     D QWCRSVAL_chrID_t...
     D                 DS                  qualified
     D  ccsid                        10A
     D  codePage                     10A
      *
      *  QCMNRCYLMT:     Communications recovery limit
     D QWCRSVAL_cmnRcyLmt_t...
     D                 DS                  qualified
     D  count                        10A
     D  interval                     10A
      *
      *  QCTLSBSD:       Controlling subsystem
     D QWCRSVAL_ctlSbsD_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QDATETIME:      System date and time       (YYYYMMDDHHNNSSXXXXXX)
     D QWCRSVAL_dateTime_t...
     D                 DS                  qualified
     D  date                          8A
     D  time                          6A
     D  mSecs                         6A
      *
      *  QIGCCDEFNT:     Double-byte coded font name
     D QWCRSVAL_igcCdeFnt_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QINACTMSGQ:   Inactive message queue
     D QWCRSVAL_inActMsgQ_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QIPLDATTIM:   Automatic IPL date and time  (value = CYYMMDDHHMMSS)
     D QWCRSVAL_iplDatTim_t...
     D                 DS                  qualified
     D  spcVal                 1     10A
     D  value                  1     13A
      *
      *  QPRBFTR:      Problem filter
     D QWCRSVAL_prbFtr_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QPWDVLDPGM:   Password validation program
     D QWCRSVAL_pwdVldPgm_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QRMTSIGN:     Remote sign-on
     D QWCRSVAL_rmtSign_t...
     D                 DS                  qualified
     D  spcVal                       10A
     D  pgm                          10A   overlay(spcVal)
     D  lib                          10A
      *
      *  QSCANFS:      Scan file systems
     D QWCRSVAL_scanFS_t...
     D                 DS                  qualified
     D  option                       10A   dim(20)
      *
      *  QSCANFSCTL:   Scan file systems control
     D QWCRSVAL_scanFSCtl_t...
     D                 DS                  qualified
     D  option                       10A   dim(20)
      *
      *  QSETJOBATR:   Set job attributes from locale
     D QWCRSVAL_setJobAtr_t...
     D                 DS                  qualified
     D  attr                         10A   dim(16)
      *
      *  QSRTSEQ:      Sort sequence table
     D QWCRSVAL_srtSeq_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QSTRUPPGM:    Startup program name
     D QWCRSVAL_strUpPgm_t...
     D                 DS                  qualified
     D  name                         10A
     D  lib                          10A
      *
      *  QSYSLIBL:     System library list
     D QWCRSVAL_sysLibl_t...
     D                 DS                  qualified
     D  lib                          10A   dim(15)
      *
      *  QUSRLIBL:     User library list
     D QWCRSVAL_usrLibl_t...
     D                 DS                  qualified
     D  lib                          10A   dim(25)
      *
      *  QUTCOFFSET:   Coordinated universal time offset
     D QWCRSVAL_utcOffset_t...
     D                 DS                  qualified
     D  timeZoneID                    1A
     D  hours                         2A
     D  minutes                       2A
      *
      /ENDIF
