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
      //       >>PARM<< TRUNCNBR(*NO);
      //       >>PARM<< DBGVIEW(*LIST);
      //       >>PARM<< TGTRLS(V6R1M0);
      //     >>END-COMPILE<<
      //
      //     >>EXECUTE<<
      //
      //   >>END-PRE-COMPILER<<
      // -------------------------------------------------------------------
     H NOMAIN
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*

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

     D EPOCHSTART      s               z   inz(z'1970-01-01-00.00.00.000000')

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
     P f_dateSerial...
     P                 b                   export
     D                 pi              D
     D  i_year                       10I 0 const
     D  i_month                      10I 0 const
     D  i_day                        10I 0 const

      //  Return value
     D date            s               D   inz

      //  Helper fields
     D tmpDate         s             10A   inz
      /free

         tmpDate = %editc(%dec(i_year: 4: 0): 'X') + '-' + '01' + '-' + '01';
         date = %date(tmpDate: *ISO);
         date = date + %months(i_month-1);
         date = date + %days(i_day-1);

         return date;

      /end-free
     P                 e

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
     P f_cvtEpochTS...
     P                 b                   export
     D                 pi              z
     D  i_epochSecs                  10i 0 const
     D  i_adjustUTC                    n   const options(*nopass: *omit)

      // Return value
     D timestamp       s               z   inz

      // Parameter position
     D p_adjustUTC     c                   2

      // Optional parameters
     D adjustUTC       s                   like(i_adjustUTC)

      // Variables.
     D utc             ds                  likeds(cee_utco_t) inz
      /free

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

      /end-free
     p                 e

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
     P f_cvtTSEpoch...
     P                 b                   export
     D                 pi            10i 0
     D  i_timestamp                    z   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)

      // Return value
     D epochSecs       s             10i 0 inz

      // Parameter position
     D p_adjustUTC     c                   2

      // Optional parameters
     D adjustUTC       s                   like(i_adjustUTC)

      // Constants.
     D PIC_TIMESTAMP   c                   'YYYY-MM-DD-HH.MI.SS.999999'

      // Variables.
     D utc             ds                  likeds(cee_utco_t) inz
     D tsSecs          s              8f   inz
     D epochStartSecs  s              8f   inz
      /free

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

      /end-free
     p                 e

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
     P f_cvtMiTimeTS...
     P                 b                   export
     D                 pi              z
     D  i_miTime                     20a   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)

      // Return value
     D timestamp       s               z   inz

      // Parameter position
     D p_adjustUTC     c                   2

      // Optional parameters
     D adjustUTC       s                   like(i_adjustUTC)

      // Variables
     D tmpDate         ds                  qualified
     D  date                   1      8a   inz('00010101')
     D  time                   9     14a   inz('000000')
     D  mSecs                 15     20a   inz('000000')
     D utc             ds                  likeds(cee_utco_t) inz
     D timeZone        s            116a
     D errCode         ds                  likeds(errCode_t) inz
      /free

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

      /end-free
     p                 e

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
     P f_cvtTSMiTime...
     P                 b                   export
     D                 pi            20a
     D  i_timestamp                    z   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)

      // Return value
     D miTime          s             20a   inz(*ALLx'00')

      // Parameter position
     D p_adjustUTC     c                   2

      // Optional parameters
     D adjustUTC       s                   like(i_adjustUTC)

      // Variables
     D timestamp       s                   like(i_timestamp)
     D tmpDate         ds                  qualified
     D  date                   1      8a   inz('00010101')
     D  time                   9     14a   inz('000000')
     D  mSecs                 15     20a   inz('000000')
     D utc             ds                  likeds(cee_utco_t) inz
     D timeZone        s            116a
     D errCode         ds                  likeds(errCode_t) inz
      /free

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

      /end-free
     p                 e
      *
