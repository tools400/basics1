      *=====================================================================*
      *  BASICS1RF  - SrvPgm: Basic Routines - System Values                *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  11.04.2010                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RF
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      * -----------------------------------------
      *  Imported Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R1
      /COPY QBASICS1,QWCRSVAL                      Retrieve System Values (QWCRSVAL) API
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Retrieves an alpha-numeric system value.
      *=========================================================================
      *  Parameters:
      *   i_name        - System value name.
      *
      *  Returns:
      *   value         - The value of the specified system value.
      *=========================================================================
     P f_rtvSysVal_char...
     P                 B                   export
      *
     D f_rtvSysVal_char...
     D                 PI          4096A          varying
     D  i_name                       10A   const
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D value           S           4096A   varying inz
      *
      *  Parameter positions
     D p_msg           C                   2
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Helper fields
     D errCode         DS                  likeds(errCode_t ) inz
     D sysVal          DS                  likeds(QWCRSVAL_rtnValue_t    ) inz
     D sysValTbl       DS                  likeds(QWCRSVAL_sysValInfTbl_t)
     D                                     based(pSysValTbl)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg(cMSG_ID_OK);

         // Check system value name
         p_assert(i_name   = 'QABNORMSW'    or   //  Character    1
                  i_name   = 'QACGLVL'      or   //  Character    80
                  i_name   = 'QALWOBJRST'   or   //  Character    150
                  i_name   = 'QALWUSRDMN'   or   //  Character    500
                  i_name   = 'QASTLVL'      or   //  Character    10
                  i_name   = 'QATNPGM'      or   //  Character    20
                  i_name   = 'QAUDCTL'      or   //  Character    50
                  i_name   = 'QAUDENDACN'   or   //  Character    10
                  i_name   = 'QAUDLVL'      or   //  Character    160
                  i_name   = 'QAUTOCFG'     or   //  Character    1
                  i_name   = 'QAUTORMT'     or   //  Character    1
                  i_name   = 'QAUTOSPRPT'   or   //  Character    1
                  i_name   = 'QCENTURY'     or   //  Character    1
                  i_name   = 'QCFGMSGQ'     or   //  Character    20
                  i_name   = 'QCHRID'       or   //  Character    20
                  i_name   = 'QCHRIDCTL'    or   //  Character    10
                  i_name   = 'QCMNARB'      or   //  Character    10
                  i_name   = 'QCMNRCYLMT'   or   //  Character    20
                  i_name   = 'QCNTRYID'     or   //  Character    2
                  i_name   = 'QCONSOLE'     or   //  Character    10
                  i_name   = 'QCRTAUT'      or   //  Character    10
                  i_name   = 'QCRTOBJAUD'   or   //  Character    10
                  i_name   = 'QCTLSBSD'     or   //  Character    20
                  i_name   = 'QCURSYM'      or   //  Character    1
                  i_name   = 'QDATE'        or   //  Character    5 (for Julian dates) or 6
                  i_name   = 'QDATFMT'      or   //  Character    3
                  i_name   = 'QDATSEP'      or   //  Character    1
                  i_name   = 'QDAY'         or   //  Character    2 or 3 (for Julian dates)
                  i_name   = 'QDAYOFWEEK'   or   //  Character    4
                  i_name   = 'QDBFSTCCOL'   or   //  Character    10
                  i_name   = 'QDBRCVYWT'    or   //  Character    1
                  i_name   = 'QDECFMT'      or   //  Character    1
                  i_name   = 'QDEVNAMING'   or   //  Character    10
                  i_name   = 'QDEVRCYACN'   or   //  Character    20
                  i_name   = 'QDSCJOBITV'   or   //  Character    10
                  i_name   = 'QDSPSGNINF'   or   //  Character    1
                  i_name   = 'QDYNPTYADJ'   or   //  Character    1
                  i_name   = 'QDYNPTYSCD'   or   //  Character    1
                  i_name   = 'QFRCCVNRST'   or   //  Character    1
                  i_name   = 'QHOUR'        or   //  Character    2
                  i_name   = 'QIGC'         or   //  Character    1
                  i_name   = 'QIGCCDEFNT'   or   //  Character    20
                  i_name   = 'QINACTITV'    or   //  Character    10
                  i_name   = 'QINACTMSGQ'   or   //  Character    20
                  i_name   = 'QIPLDATTIM'   or   //  Character    20
                  i_name   = 'QIPLSTS'      or   //  Character    1
                  i_name   = 'QIPLTYPE'     or   //  Character    1
                  i_name   = 'QJOBMSGQFL'   or   //  Character    10
                  i_name   = 'QKBDBUF'      or   //  Character    10
                  i_name   = 'QKBDTYPE'     or   //  Character    3
                  i_name   = 'QLANGID'      or   //  Character    3
                  i_name   = 'QLIBLCKLVL'   or   //  Character    1
                  i_name   = 'QLMTDEVSSN'   or   //  Character    1
                  i_name   = 'QLMTSECOFR'   or   //  Character    1
                  i_name   = 'QLOCALE'      or   //  Character    1024
                  i_name   = 'QMAXSGNACN'   or   //  Character    1
                  i_name   = 'QMAXSIGN'     or   //  Character    6
                  i_name   = 'QMINUTE'      or   //  Character    2
                  i_name   = 'QMLTTHDACN'   or   //  Character    1
                  i_name   = 'QMODEL'       or   //  Character    4
                  i_name   = 'QMONTH'       or   //  Character    2
                  i_name   = 'QPASTHRSVR'   or   //  Character    10
                  i_name   = 'QPFRADJ'      or   //  Character    1
                  i_name   = 'QPRBFTR'      or   //  Character    20
                  i_name   = 'QPRCFEAT'     or   //  Character    4
                  i_name   = 'QPRCMLTTSK'   or   //  Character    1
                  i_name   = 'QPRTDEV'      or   //  Character    10
                  i_name   = 'QPRTKEYFMT'   or   //  Character    10
                  i_name   = 'QPRTTXT'      or   //  Character    30
                  i_name   = 'QPWDEXPITV'   or   //  Character    6
                  i_name   = 'QPWDLMTAJC'   or   //  Character    1
                  i_name   = 'QPWDLMTCHR'   or   //  Character    10
                  i_name   = 'QPWDLMTREP'   or   //  Character    1
                  i_name   = 'QPWDPOSDIF'   or   //  Character    1
                  i_name   = 'QPWDRQDDGT'   or   //  Character    1
                  i_name   = 'QPWDRQDDIF'   or   //  Character    1
                  i_name   = 'QPWDVLDPGM'   or   //  Character    20
                  i_name   = 'QPWRRSTIPL'   or   //  Character    1
                  i_name   = 'QQRYDEGREE'   or   //  Character    10
                  i_name   = 'QQRYTIMLMT'   or   //  Character    10
                  i_name   = 'QRCLSPLSTG'   or   //  Character    10
                  i_name   = 'QRETSVRSEC'   or   //  Character    1
                  i_name   = 'QRMTIPL'      or   //  Character    1
                  i_name   = 'QRMTSRVATR'   or   //  Character    1
                  i_name   = 'QRMTSIGN'     or   //  Character    20
                  i_name   = 'QSCPFCONS'    or   //  Character    1
                  i_name   = 'QSECOND'      or   //  Character    2
                  i_name   = 'QSECURITY'    or   //  Character    2
                  i_name   = 'QSETJOBATR'   or   //  Character    160
                  i_name   = 'QSFWERRLOG'   or   //  Character    10
                  i_name   = 'QSHRMEMCTL'   or   //  Character    1
                  i_name   = 'QSPCENV'      or   //  Character    10
                  i_name   = 'QSPLFACN'     or   //  Character    10
                  i_name   = 'QSRLNBR'      or   //  Character    8
                  i_name   = 'QSRTSEQ'      or   //  Character    20
                  i_name   = 'QSRVDMP'      or   //  Character    10
                  i_name   = 'QSTGLOWACN'   or   //  Character    10
                  i_name   = 'QSTRPRTWTR'   or   //  Character    1
                  i_name   = 'QSTRUPPGM'    or   //  Character    20
                  i_name   = 'QSTSMSG'      or   //  Character    10
                  i_name   = 'QSYSLIBL'     or   //  Character    150
                  i_name   = 'QTIME'        or   //  Character    7, 8, or 9
                  i_name   = 'QTIMSEP'      or   //  Character    1
                  i_name   = 'QTSEPOOL'     or   //  Character    10
                  i_name   = 'QUPSDLYTIM'   or   //  Character    20
                  i_name   = 'QUPSMSGQ'     or   //  Character    20
                  i_name   = 'QUSEADPAUT'   or   //  Character    10
                  i_name   = 'QUSRLIBL'     or   //  Character    2750
                  i_name   = 'QUTCOFFSET'   or   //  Character    5
                  i_name   = 'QVFYOBJRST'   or   //  Character    1
                  i_name   = 'QYEAR'        :    //  Character    2                         //RADDAT
                  'Invalid system value name specified: ' + i_name);

         dou '1';

            errCode = f_newApiErrCode(cTrue);
            QWCRSVAL(sysVal: %size(sysVal): 1: i_name: errCode);

            if (f_isApiError(errCode));
               msg = f_cvtApiErrCodeToMsg(errCode);
               leave;
            endif;

            pSysValTbl = %addr(sysVal) + sysVal.ofsSysValTbl(1);

            p_assert(sysValTbl.length <= %len(sysValTbl.data):
                     'Value ' + %char(sysValTbl.length) +
                     ' exceeds maximum length of ' + %char(%size(value)-2));

            value = %subst(sysValTbl.data: 1: sysValTbl.length);
         enddo;

         // Set optional/omissible message parameter
         if (%parms() >= p_msg);
            if (%addr(o_msg) <> *NULL);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return value;

      /END-FREE
      *
     P f_rtvSysVal_char...
     P                 E
      *
      *=========================================================================
      *  Retrieves a numeric system value.
      *=========================================================================
      *  Parameters:
      *   i_name        - System value name.
      *
      *  Returns:
      *   value         - The value of the specified system value.
      *=========================================================================
     P f_rtvSysVal_num...
     P                 B                   export
      *
     D f_rtvSysVal_num...
     D                 PI            15P 5
     D  i_name                       10A   const
     D  o_msg                                     likeds(msg_t )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D value           S             15P 5 inz
      *
      *  Parameter positions
     D p_msg           C                   2
      *
      *  Fields for optional parameters
     D msg             DS                  likeds(msg_t     ) inz
      *
      *  Helper fields
     D errCode         DS                  likeds(errCode_t ) inz
     D sysVal          DS                  likeds(QWCRSVAL_rtnValue_t    ) inz
     D sysValTbl       DS                  likeds(QWCRSVAL_sysValInfTbl_t)
     D                                     based(pSysValTbl)
     D fraction        S             10I 0 inz
     D x               S             10I 0 inz
     D binary4         S             10I 0 based(pBinary4)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg(cMSG_ID_OK);

         // Check system value name
         p_assert(i_name   = 'QACTJOB'      or   //  Decimal      (5 0)
                  i_name   = 'QADLACTJ'     or   //  Decimal      (5 0)
                  i_name   = 'QADLSPLA'     or   //  Decimal      (5 0)
                  i_name   = 'QADLTOTJ'     or   //  Decimal      (5 0)
                  i_name   = 'QAUDFRCLVL'   or   //  Decimal      (5 0)
                  i_name   = 'QAUTOVRT'     or   //  Decimal      (5 0)
                  i_name   = 'QBASACTLVL'   or   //  Zoned        (5 0)
                  i_name   = 'QBASPOOL'     or   //  Zoned        (10 0)
                  i_name   = 'QCCSID'       or   //  Decimal      (5 0)
                  i_name   = 'QHSTLOGSIZ'   or   //  Decimal      (5 0)
                  i_name   = 'QIGCFNTSIZ'   or   //  Decimal      (4 1)
                  i_name   = 'QJOBMSGQMX'   or   //  Decimal      (5 0)
                  i_name   = 'QJOBMSGQSZ'   or   //  Decimal      (5 0)
                  i_name   = 'QJOBMSGQTL'   or   //  Decimal      (5 0)
                  i_name   = 'QJOBSPLA'     or   //  Decimal      (5 0)
                  i_name   = 'QLEAPADJ'     or   //  Decimal      (5 0)
                  i_name   = 'QMAXACTLVL'   or   //  Decimal      (5 0)
                  i_name   = 'QMAXJOB'      or   //  Zoned        (10 0)
                  i_name   = 'QMAXSPLF'     or   //  Zoned        (10 0)
                  i_name   = 'QMCHPOOL'     or   //  Zoned        (10 0)
                  i_name   = 'QPRBHLDITV'   or   //  Decimal      (5 0)
                  i_name   = 'QPWDLVL'      or   //  Decimal      (5 0)
                  i_name   = 'QPWDMAXLEN'   or   //  Decimal      (5 0)
                  i_name   = 'QPWDMINLEN'   or   //  Decimal      (5 0)
                  i_name   = 'QPWRDWNLMT'   or   //  Decimal      (5 0)
                  i_name   = 'QSTGLOWLMT'   or   //  Decimal      (7 4)
                  i_name   = 'QSVRAUTITV'   or   //  Decimal      (6 0)
                  i_name   = 'QTOTJOB'      :    //  Decimal      (5 0)
                  'Invalid system value name specified: ' + i_name);

         dou '1';

            errCode = f_newApiErrCode(cTrue);
            QWCRSVAL(sysVal: %size(sysVal): 1: i_name: errCode);

            if (f_isApiError(errCode));
               msg = f_cvtApiErrCodeToMsg(errCode);
               leave;
            endif;

            pSysValTbl = %addr(sysVal) + sysVal.ofsSysValTbl(1);

            p_assert(sysValTbl.length = 4
                     : 'Size of system value ' + i_name +
                       ' does not match expected integer size of 4');

            select;
            when (sysValTbl.sysVal = 'QIGCFNTSIZ');   //  Decimal      (4 1)
               fraction = 1;
            when (sysValTbl.sysVal = 'QSTGLOWLMT');   //  Decimal      (7 4)
               fraction = 4;
            other;
               fraction = 0;
            endsl;

            pBinary4 = %addr(sysValTbl.data);
            value = binary4;
            for x = 1 to fraction;
               value = value / 10;
            endfor;
         enddo;

         // Set optional/omissible message parameter
         if (%parms() >= p_msg);
            if (%addr(o_msg) <> *NULL);
               o_msg = msg;
            endif;
         else;
            if (msg.ID <> cMSG_ID_OK);
               f_sndPgmMsg(msg: cMsg_Prv);
            endif;
         endif;

         return value;

      /END-FREE
      *
     P f_rtvSysVal_num...
     P                 E
      *
