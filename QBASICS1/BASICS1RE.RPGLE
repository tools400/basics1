**FREE
// -------------------------------------------------------------------
//  BASICS1RC  - SrvPgm: Basic Routines - Date and Time
// -------------------------------------------------------------------
//  Author  :  Thomas Raddatz
//  Date    :  19.02.2009
//  E-mail  :  thomas.raddatz@Tools400.de
//  Homepage:  www.tools400.de
// -------------------------------------------------------------------
//
//  This software is free software, you can redistribute it and/or
//  modify it under the terms of the GNU General Public License (GPL)
//  as published by the Free Software Foundation.
//
//  See GNU General Public License for details.
//          http://www.opensource.org
//          http://www.opensource.org/licenses/gpl-license.html
//
// -------------------------------------------------------------------
//  History:
//
//  Datum       Name          Änderung
//  ----------  ------------  ---------------------------------------
//
// -------------------------------------------------------------------
//   >>PRE-COMPILER<<
//
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +
//                              SRCFILE(&SL/&SF) +
//                              SRCMBR(&SM);
//
//     >>COMPILE<<
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);
//       >>PARM<< DBGVIEW(*LIST);
//       >>PARM<< TGTRLS(V7R3M0);
//     >>END-COMPILE<<
//
//     >>EXECUTE<<
//
//   >>END-PRE-COMPILER<<
// -------------------------------------------------------------------
ctl-opt NOMAIN;
//  Standard H-Specs
/COPY QBASICS1,H_SPEC
/COPY QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/COPY QBASICS1,PBASICS1RE

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/COPY QBASICS1,BASICS1R0

// -----------------------------------------
//  Imported Prototypes
// -----------------------------------------
/COPY QBASICS1,QWCCVTDT                      Convert Date and Time Format (QWCCVTDT) API
/COPY QBASICS1,PBASICS1R2                    API Error Handling

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Global constants
// -----------------------------------------

dcl-s EPOCHSTART      timestamp inz(z'1970-01-01-00.00.00.000000');

// -----------------------------------------
//  Global fields
// -----------------------------------------

// -----------------------------------------------------------------------
//  Produces a date from a given year, month and day.
// -----------------------------------------------------------------------
//  Parameters:
//   i_year        - Year of the date. Range: 1-9999
//   i_month       - Day of the date. Any numeric value.
//   i_day         - Day of the date. Any numeric value.
//
//  Returns:
//   date          - Date.
// -----------------------------------------------------------------------
dcl-proc f_dateSerial export;
dcl-pi *N              date;
  i_year          int(10) const;
  i_month         int(10) const;
  i_day           int(10) const;
end-pi;

//  Return value
dcl-s date            date inz;

//  Helper fields
dcl-s tmpDate         char(10) inz;

tmpDate = %editc(%dec(i_year: 4: 0): 'X') + '-' + '01' + '-' + '01';
date = %date(tmpDate: *ISO);
date = date + %months(i_month-1);
date = date + %days(i_day-1);

return date;

end-proc;

// -----------------------------------------------------------------------
//  Converts an epoch date to a RPG timestamp.
// -----------------------------------------------------------------------
//  Parameters:
//
//   i_epochSecs   - The UNIX timestamp, in UNIX epoch format (number of
//                   seconds since midnight, Jan 1, 1970).
//   i_adjustUTC   - Determine whether the time should be adjusted by the
//                   UTC offset.
//                   true  - adjust for UTC offset
//                   false - do not adjust for UTC offset
//
//  Returns:
//   timestamp     - RPG timestamp value
// -----------------------------------------------------------------------
dcl-proc f_cvtEpochTS export;
dcl-pi *N              timestamp;
  i_epochSecs     int(10) const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pi;

// Return value
dcl-s timestamp       timestamp inz;

// Parameter position
dcl-c p_adjustUTC 2;

// Optional parameters
dcl-s adjustUTC       like(i_adjustUTC);

// Variables.
dcl-ds utc likeds(cee_utco_t) inz;

if (%parms() >= p_adjustUTC and %addr(i_adjustUTC) <> *null);
   adjustUTC = i_adjustUTC;
else;
   adjustUTC = cTrue;
endif;

timestamp = EPOCHSTART + %seconds(i_epochSecs);
if (adjustUTC);
   CEEUTCO(utc.offHours: utc.offMins: utc.offSecs);
   timestamp = timestamp + %seconds(%int(utc.offSecs));
endif;

return timestamp;

end-proc;

// -----------------------------------------------------------------------
//  Converts a RPG timestamp to an epoch value.
// -----------------------------------------------------------------------
//  Parameters:
//
//   i_timestamp   - The OS/400 timestamp value.
//   i_adjustUTC   - Determine whether the time should be adjusted by the
//                   UTC offset.
//                   true  - adjust for UTC offset
//                   false - do not adjust for UTC offset
//
//  Returns:
//   epoch         - Epoch value
// -----------------------------------------------------------------------
dcl-proc f_cvtTSEpoch export;
dcl-pi *N              int(10);
  i_timestamp     timestamp const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pi;

// Return value
dcl-s epochSecs       int(10) inz;

// Parameter position
dcl-c p_adjustUTC 2;

// Optional parameters
dcl-s adjustUTC       like(i_adjustUTC);

// Constants.
dcl-c PIC_TIMESTAMP 'YYYY-MM-DD-HH.MI.SS.999999';

// Variables.
dcl-ds utc likeds(cee_utco_t) inz;
dcl-s tsSecs          float(8) inz;
dcl-s epochStartSecs  float(8) inz;

if (%parms() >= p_adjustUTC and %addr(i_adjustUTC) <> *null);
   adjustUTC = i_adjustUTC;
else;
   adjustUTC = cTrue;
endif;

CEESECS(%char(i_timestamp): PIC_TIMESTAMP: tsSecs: *omit);
CEESECS(%char(EPOCHSTART): PIC_TIMESTAMP: epochStartSecs: *omit);

epochSecs = tsSecs - epochStartSecs;
if (adjustUTC);
   CEEUTCO(utc.offHours: utc.offMins: utc.offSecs);
   epochSecs = epochSecs - %int(utc.offSecs);
endif;

return epochSecs;

end-proc;

// -----------------------------------------------------------------------
//  Converts a MI time value to a RPG timestamp.
// -----------------------------------------------------------------------
//  Parameters:
//
//   i_miTime      - MI time value.
//   i_adjustUTC   - Determine whether the time should be adjusted by the
//                   UTC offset.
//                   true  - adjust for UTC offset
//                   false - do not adjust for UTC offset
//
//  Returns:
//   timestamp     - RPG timestamp value
// -----------------------------------------------------------------------
dcl-proc f_cvtMiTimeTS export;
dcl-pi *N              timestamp;
  i_miTime        char(20) const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pi;

// Return value
dcl-s timestamp       timestamp inz;

// Parameter position
dcl-c p_adjustUTC 2;

// Optional parameters
dcl-s adjustUTC       like(i_adjustUTC);

// Variables
dcl-ds tmpDate qualified;
  date            char(8) inz('00010101');
  time            char(6) inz('000000');
  mSecs           char(6) inz('000000');
end-ds;
dcl-ds utc likeds(cee_utco_t) inz;
dcl-s timeZone        char(116);
dcl-ds errCode likeds(errCode_t) inz;

if (%parms() >= p_adjustUTC and %addr(i_adjustUTC) <> *null);
   adjustUTC = i_adjustUTC;
else;
   adjustUTC = cTrue;
endif;

errCode = f_newApiErrCode(cFalse);
QWCCVTDT('*DTS' : i_miTime : '*YYMD' : tmpDate: errCode
         : '*JOB': '*JOB': timeZone: %len(timeZone): '1');

timestamp = %date(tmpDate.date: *ISO0) +
            %time(tmpDate.time: *ISO0);
timestamp += %mseconds(%int(tmpDate.mSecs));

if (not adjustUTC);
   CEEUTCO(utc.offHours: utc.offMins: utc.offSecs);
   timestamp = timestamp - %seconds(%int(utc.offSecs));
endif;

return timestamp;

end-proc;

// -----------------------------------------------------------------------
//  Converts a RPG timestamp to an epoch value.
// -----------------------------------------------------------------------
//  Parameters:
//
//   i_timestamp   - The OS/400 timestamp value.
//   i_adjustUTC   - Determine whether the time should be adjusted by the
//                   UTC offset.
//                   true  - adjust for UTC offset
//                   false - do not adjust for UTC offset
//
//  Returns:
//   epoch         - Epoch value
// -----------------------------------------------------------------------
dcl-proc f_cvtTSMiTime export;
dcl-pi *N              char(20);
  i_timestamp     timestamp const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pi;

// Return value
dcl-s miTime          char(20) inz(*ALLx'00');

// Parameter position
dcl-c p_adjustUTC 2;

// Optional parameters
dcl-s adjustUTC       like(i_adjustUTC);

// Variables
dcl-s timestamp       like(i_timestamp);
dcl-ds tmpDate qualified;
  date            char(8) inz('00010101');
  time            char(6) inz('000000');
  mSecs           char(6) inz('000000');
end-ds;
dcl-ds utc likeds(cee_utco_t) inz;
dcl-s timeZone        char(116);
dcl-ds errCode likeds(errCode_t) inz;

if (%parms() >= p_adjustUTC and %addr(i_adjustUTC) <> *null);
   adjustUTC = i_adjustUTC;
else;
   adjustUTC = cTrue;
endif;

timestamp = i_timestamp;

if (not adjustUTC);
   CEEUTCO(utc.offHours: utc.offMins: utc.offSecs);
   timestamp = timestamp + %seconds(%int(utc.offSecs));
endif;

errCode = f_newApiErrCode(cFalse);
QWCCVTDT('*YYMD' : %char(timestamp: *ISO0) : '*DTS' : miTime: errCode
         : '*JOB': '*JOB': timeZone: %len(timeZone): '1');

return miTime;

end-proc;
//
