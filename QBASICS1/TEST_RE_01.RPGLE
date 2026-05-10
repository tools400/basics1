**free
//===============================================================*
//    CALL PGM(TEST_RE_01)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RE_01');
  gi_year  packed(15: 5) options(*nopass) const;
  gi_month packed(15: 5) options(*nopass) const;
  gi_day   packed(15: 5) options(*nopass) const;
end-pr;

dcl-pr main;
  i_year  int(10) const;
  i_month int(10) const;
  i_day   int(10) const;
end-pr;

//  Sends a message to QCMD
dcl-pr sndMsg;
  i_text        varchar(128) value;
  i_doSendToExt ind options(*nopass) value;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_year  packed(15: 5) options(*nopass) const;
  gi_month packed(15: 5) options(*nopass) const;
  gi_day   packed(15: 5) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 3);
  main(gi_year: gi_month: gi_day);
else;
  main(1900: 1: 1);
endif;

*inlr = *on;

return;


//===============================================================*
//  Sends a message to the caller.
//===============================================================*
dcl-proc sndMsg;
  dcl-pi *n;
    i_text        varchar(128) value;
    i_doSendToExt ind options(*nopass) value;
  end-pi;

  //  Return value
  dcl-s pBuffer pointer inz;

  //  Local fields
  dcl-s msgKey char(4) inz;

  dcl-ds qMsgF qualified inz;
    name char(10);
    lib  char(10);
  end-ds;

  dcl-ds errCode qualified inz;
    bytPrv   int(10);
    bytAvl   int(10);
    excID    char(7);
    reserved char(1);
    excDta   char(256);
  end-ds;

  //  Send Program Message (QMHSNDPM) API
  dcl-pr QMHSNDPM extpgm('QMHSNDPM');
    i_msgID      char(7) const;
    i_qMsgF      char(20) const;
    i_msgData    char(32767) options(*varsize) const;
    i_length     int(10) const;
    i_msgType    char(10) const;
    i_callStkE   char(32767) options(*varsize) const;
    i_callStkC   int(10) const;
    o_msgKey     char(4);
    io_ErrCode   char(32767) options(*varsize);
    i_lenStkE    int(10) options(*nopass) const; // | optGrp 1
    i_callStkEQ  char(20) options(*nopass) const; // |
    i_wait       int(10) options(*nopass) const; // |
    i_callStkEDT char(10) options(*nopass) const; // | optGrp 2
    i_ccsid      int(10) options(*nopass) const; // |
  end-pr;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


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


end-proc;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_year  int(10) const;
    i_month int(10) const;
    i_day   int(10) const;
  end-pi;

  //  Helper fields
  dcl-s days int(10) inz;
  dcl-s months int(10) inz;
  dcl-s years int(10) inz;
  dcl-s today date inz;
  dcl-s date date inz;
  dcl-s inpDate date inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc main;
