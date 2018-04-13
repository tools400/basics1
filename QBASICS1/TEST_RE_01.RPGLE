      *===============================================================*
      *    CALL PGM(TEST_RE_01)                                       *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/BASICS1) +         *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_RE_01')
     D  gi_year                      15P 5 const  options(*nopass)
     D  gi_month                     15P 5 const  options(*nopass)
     D  gi_day                       15P 5 const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_year                       10I 0 const
     D  i_month                      10I 0 const
     D  i_day                        10I 0 const
      *
      *  Sends a message to QCMD
     D sndMsg...
     D                 PR
     D  i_text                      128A   value  varying
     D  i_doSendToExt                  N   VALUE  options(*nopass)
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_year                      15P 5 const  options(*nopass)
     D  gi_month                     15P 5 const  options(*nopass)
     D  gi_day                       15P 5 const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= 3);
            main(gi_year: gi_month: gi_day);
         else;
            main(1900: 1: 1);
         endif;

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Sends a message to the caller.
      *===============================================================*
     P sndMsg...
     P                 B
      *
     D sndMsg...
     D                 PI
     D  i_text                      128A   value  varying
     D  i_doSendToExt                  N   VALUE  options(*nopass)
      *
      *  Return value
     D pBuffer         S               *   inz
      *
      *  Local fields
     D msgKey          S              4A                        inz
      *
     D qMsgF           DS                  qualified            inz
     D  name                         10A
     D  lib                          10A
      *
     D errCode         DS                  qualified            inz
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved                      1A
     D  excDta                      256A
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D   i_msgID                      7A   const
     D   i_qMsgF                     20A   const
     D   i_msgData                32767A   const  options(*varsize )
     D   i_length                    10I 0 const
     D   i_msgType                   10A   const
     D   i_callStkE               32767A   const  options(*varsize )
     D   i_callStkC                  10I 0 const
     D   o_msgKey                     4A
     D   io_ErrCode               32767A          options(*varsize )
     D   i_lenStkE                   10I 0 const  options(*nopass  )            | optGrp 1
     D   i_callStkEQ                 20A   const  options(*nopass  )            |
     D   i_wait                      10I 0 const  options(*nopass  )            |
     D   i_callStkEDT                10A   const  options(*nopass  )            | optGrp 2
     D   i_ccsid                     10I 0 const  options(*nopass  )            |
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      /FREE

         clear qMsgF;
         qMsgF.name = 'QCPFMSG';
         qMsgF.lib  = '*LIBL';

         clear errCode;
         errCode.bytPrv = %size(errCode);

         if %parms() >= 2 and i_doSendToExt;
            QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                     : '*CTLBDY': 1
                     : msgKey: errCode);
         else;
            QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                     : '*CTLBDY': 0
                     : msgKey: errCode);
         endif;

         return;

      /END-FREE
      *
     P sndMsg...
     P                 E
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_year                       10I 0 const
     D  i_month                      10I 0 const
     D  i_day                        10I 0 const
      *
      *  Helper fields
     D days            S             10I 0 inz
     D months          S             10I 0 inz
     D years           S             10I 0 inz
     D today           S               D   inz
     D date            S               D   inz
     D inpDate         S               D   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         today = %date();

         // Produce todays's date
         date = f_dateSerial(%subdt(today: *YEARS)
                             : %subdt(today: *MONTHS)
                             : %subdt(today: *DAYS));
         p_assert(date = today
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date - 10 days
         days = -10;
         months = 0;
         years  = 0;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date - 5 months
         months = -5;
         months = 0;
         years  = 0;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date + 10 days
         days = 10;
         months = 0;
         years  = 0;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date + 5 months
         months = 5;
         months = 0;
         years  = 0;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date + 7 days - 4 months
         days   = 7;
         months = -4;
         years  = 0;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date + 7 days - 4 months + 10 years
         days   = 7;
         months = -4;
         years  = 10;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce todays's date - 7 days + 4 months - 10 years
         days   = -7;
         months = 4;
         years  = -10;
         date = f_dateSerial(%subdt(today: *YEARS)    + years
                             : %subdt(today: *MONTHS) + months
                             : %subdt(today: *DAYS)   + days);
         p_assert(date = today + %years(years) + %months(months) + %days(days)
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(today) + '''');

         // Produce date from passed values
         date = f_dateSerial(i_year: i_month: i_day);
         inpDate = %date(%editc(%dec(i_year : 4: 0): 'X') + '-' +
                         %editc(%dec(i_month: 2: 0): 'X') + '-' +
                         %editc(%dec(i_day  : 2: 0): 'X'));
         p_assert(date = inpDate
                  : 'Returned value ''' + %char(date) + ''' does not match +
                     expected value ''' + %char(inpDate) + '''');
         sndMsg('The specified date was: ' + %char(date): cTrue);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
