**FREE
/IF NOT DEFINED(BASICS1RE)
/DEFINE BASICS1RE

//  Produces a date from a given year, month and day.
dcl-pr f_dateSerial
       date
       extproc('BASICS1RE+
       _f_dateSerial+
       ');
  i_year          int(10) const;
  i_month         int(10) const;
  i_day           int(10) const;
end-pr;

//  Converts an epoch date to a RPG timestamp.
dcl-pr f_cvtEpochTS
       timestamp
       extproc('BASICS1RE+
       _f_cvtEpochTS+
       ');
  i_epochSecs     int(10) const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pr;

//  Converts a RPG timestamp to an epoch value.
dcl-pr f_cvtTSEpoch
       int(10)
       extproc('BASICS1RE+
       _f_cvtTSEpoch+
       ');
  i_timestamp     timestamp const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pr;

//  Converts a MI time value to a RPG timestamp.
dcl-pr f_cvtMiTimeTS
       timestamp
       extproc('BASICS1RE+
       _f_cvtMiTimeTS+
       ');
  i_miTime        char(20) const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pr;

//  Converts a RPG timestamp to a MI time value.
dcl-pr f_cvtTSMiTime
       char(20)
       extproc('BASICS1RE+
       _f_cvtTSMiTime+
       ');
  i_timestamp     timestamp const;
  i_adjustUTC     ind const options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/ENDIF
