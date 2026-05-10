**free
//===============================================================*
//    CALL PGM(TEST_R3_13)                                       *
//         PARM('2009-01-23' 'YYYY-MM-DD' 'ZD Mmmmmmmmmz YYYY')  *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_13');
  gi_date_str char(32) options(*nopass) const;
  gi_pic_str  char(32) options(*nopass) const;
  gi_fmt_str  char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_date_str varchar(32) const;
  i_pic_str  varchar(32) const;
  i_fmt_str  varchar(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_date_str char(32) options(*nopass) const;
  gi_pic_str  char(32) options(*nopass) const;
  gi_fmt_str  char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 3);
  main(%trim(gi_date_str): %trim(gi_pic_str): %trim(gi_fmt_str));
else;
  main(%char(%date(): *ISO): 'YYYY-MM-DD': 'ZD. Mmmmmmmmmz YYYY');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_date_str varchar(32) const;
    i_pic_str  varchar(32) const;
    i_fmt_str  varchar(32) const;
  end-pi;

  //  Helper fields
  dcl-s date date inz;
  dcl-s date_str varchar(64) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  date = f_parseDate(i_date_str: i_pic_str);

  date_str = f_formatDate(date: i_fmt_str);

  msg = f_newMsg(cMsg_ID_NONE: 'Converted ' + f_addQuotes(i_date_str) +
                 ' to date ' + %char(date: *EUR) + ' and string: ' +
                 date_str);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
