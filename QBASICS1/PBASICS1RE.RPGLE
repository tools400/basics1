      /IF NOT DEFINED(BASICS1RE)
      /DEFINE BASICS1RE
      *
      *  Produces a date from a given year, month and day.
     D f_dateSerial...
     D                 PR              d
     D                                     extproc('BASICS1RE+
     D                                     _f_dateSerial+
     D                                     ')
     D  i_year                       10i 0 const
     D  i_month                      10i 0 const
     D  i_day                        10i 0 const
      *
      *  Converts an epoch date to a RPG timestamp.
     D f_cvtEpochTS...
     D                 PR              z
     D                                     extproc('BASICS1RE+
     D                                     _f_cvtEpochTS+
     D                                     ')
     D  i_epochSecs                  10i 0 const
     D  i_adjustUTC                    n   const options(*nopass: *omit)
      *
      *  Converts a RPG timestamp to an epoch value.
     D f_cvtTSEpoch...
     D                 PR            10i 0
     D                                     extproc('BASICS1RE+
     D                                     _f_cvtTSEpoch+
     D                                     ')
     D  i_timestamp                    z   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)
      *
      *  Converts a MI time value to a RPG timestamp.
     D f_cvtMiTimeTS...
     D                 PR              z
     D                                     extproc('BASICS1RE+
     D                                     _f_cvtMiTimeTS+
     D                                     ')
     D  i_miTime                     20a   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)
      *
      *  Converts a RPG timestamp to a MI time value.
     D f_cvtTSMiTime...
     D                 PR            20a
     D                                     extproc('BASICS1RE+
     D                                     _f_cvtTSMiTime+
     D                                     ')
     D  i_timestamp                    z   const
     D  i_adjustUTC                    n   const options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      /ENDIF
