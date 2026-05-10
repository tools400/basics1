**free
/if NOT DEFINED(QWCCVTDT)
/define QWCCVTDT

//  Convert Date and Time Format (QWCCVTDT) API
dcl-pr QWCCVTDT extpgm('QWCCVTDT');
  i_iFormat     char(10) const;
  i_iValue      char(65535) options(*varsize) const;
  i_oFormat     char(10) const;
  o_oValue      char(65535) options(*varsize);
  io_errCode    char(65535) options(*varsize);
  i_iTimezone   char(10) options(*nopass) const; // | optGrp 1
  i_oTimezone   char(10) options(*nopass) const; // |
  o_timezone    char(65535) options(*nopass: *varsize); // |
  i_lenTimezone int(10) options(*nopass) const; // |
  i_precInd     char(1) options(*nopass) const; // |
  i_iTimeInd    char(1) options(*nopass) const; // | optGrp 2
end-pr;

//  Time Zone Information Value Structure
dcl-ds QWCCVTDT_timezone_t qualified based(pDummy);
  bytRet        int(10);
  bytAvl        int(10);
  desc          char(10);
  reserved_1    char(1);
  dayLightInd   char(1);
  curOffset     int(10);
  curFullName   char(50);
  curAbbrevName char(10);
  curMsgInd     char(7);
  msgFile       char(10);
  msgFileLib    char(10);
end-ds;

//  This table shows the structure used for the input and output variables when
//  the format is *JOB, *SYSVAL, *YMD, *MDY, *DMY, and *JUL and the precision
//  indicator specifies milliseconds.
dcl-ds QWCCVTDT_dateTime_16_t qualified based(pDummy);
  century char(1);
  date    char(6);
  time    char(6);
  mSecs   char(3);
end-ds;

//  This table shows the structure used for the input and output variables when
//  the format is *YYMD, *MDYY, *DMYY, and *LONGJUL and the precision indicator
//  specifies milliseconds.
dcl-ds QWCCVTDT_dateTime_17_t qualified based(pDummy);
  date  char(8);
  time  char(6);
  mSecs char(3);
end-ds;

//  This table shows the structure used for the input and output variables when
//  the format is *JOB, *SYSVAL, *YMD, *MDY, *DMY, and *JUL and the precision
//  indicator specifies microseconds.
dcl-ds QWCCVTDT_dateTime_19_t qualified based(pDummy);
  century char(1);
  date    char(6);
  time    char(6);
  mSecs   char(6);
end-ds;

//  This table shows the structure used for the input and output variables when
//  the format is *YYMD, *MDYY, *DMYY, and *LONGJUL and the precision indicator
//  specifies microseconds.
dcl-ds QWCCVTDT_dateTime_20_t qualified based(pDummy);
  date  char(8);
  time  char(6);
  mSecs char(6);
end-ds;

/endif