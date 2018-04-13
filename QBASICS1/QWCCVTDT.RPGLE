      /IF NOT DEFINED(QWCCVTDT)
      /DEFINE QWCCVTDT
      *
      *  Convert Date and Time Format (QWCCVTDT) API
     D QWCCVTDT...
     D                 PR                         extpgm('QWCCVTDT')
     D  i_iFormat                    10A   const
     D  i_iValue                  65535A   const options(*varsize)
     D  i_oFormat                    10A   const
     D  o_oValue                  65535A          options(*varsize)
     D  io_errCode                65535A          options(*varsize)
     D  i_iTimezone                  10A   const  options(*nopass)              | optGrp 1
     D  i_oTimezone                  10A   const  options(*nopass)              |
     D  o_timezone                65535A          options(*nopass: *varsize)    |
     D  i_lenTimezone                10I 0 const  options(*nopass)              |
     D  i_precInd                     1A   const  options(*nopass)              |
     D  i_iTimeInd                    1A   const  options(*nopass)              | optGrp 2
      *
      *  Time Zone Information Value Structure
     D QWCCVTDT_timezone_t...
     D                 DS                  qualified               based(pDummy)
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  desc                   9     18A
     D  reserved_1            19     19A
     D  dayLightInd           20     20A
     D  curOffset             21     24I 0
     D  curFullName           25     74A
     D  curAbbrevName         75     84A
     D  curMsgInd             85     91A
     D  msgFile               92    101A
     D  msgFileLib           102    111A
      *
      *  This table shows the structure used for the input and output variables when
      *  the format is *JOB, *SYSVAL, *YMD, *MDY, *DMY, and *JUL and the precision
      *  indicator specifies milliseconds.
     D QWCCVTDT_dateTime_16_t...
     D                 DS                  qualified               based(pDummy)
     D  century                1      1A
     D  date                   2      7A
     D  time                   8     13A
     D  mSecs                 14     16A
      *
      *  This table shows the structure used for the input and output variables when
      *  the format is *YYMD, *MDYY, *DMYY, and *LONGJUL and the precision indicator
      *  specifies milliseconds.
     D QWCCVTDT_dateTime_17_t...
     D                 DS                  qualified               based(pDummy)
     D  date                   1      8A
     D  time                   9     14A
     D  mSecs                 15     17A
      *
      *  This table shows the structure used for the input and output variables when
      *  the format is *JOB, *SYSVAL, *YMD, *MDY, *DMY, and *JUL and the precision
      *  indicator specifies microseconds.
     D QWCCVTDT_dateTime_19_t...
     D                 DS                  qualified               based(pDummy)
     D  century                1      1A
     D  date                   2      7A
     D  time                   8     13A
     D  mSecs                 14     19A
      *
      *  This table shows the structure used for the input and output variables when
      *  the format is *YYMD, *MDYY, *DMYY, and *LONGJUL and the precision indicator
      *  specifies microseconds.
     D QWCCVTDT_dateTime_20_t...
     D                 DS                  qualified               based(pDummy)
     D  date                   1      8A
     D  time                   9     14A
     D  mSecs                 15     20A
      *
      /ENDIF
