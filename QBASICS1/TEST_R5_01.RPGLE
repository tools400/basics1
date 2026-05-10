**free
//===============================================================*
//    CALL PGM(TEST_R5_01) PARM('CHKOB' 'QSYS' '*CMD')           *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R5_01');
  gi_obj  char(10) options(*nopass) const;
  gi_lib  char(10) options(*nopass) const;
  gi_type char(10) options(*nopass) const;
end-pr;

dcl-pr main;
  i_obj  like(gi_obj) const;
  i_lib  like(gi_lib) const;
  i_type like(gi_type) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_obj  char(10) options(*nopass) const;
  gi_lib  char(10) options(*nopass) const;
  gi_type char(10) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_type));
  main(gi_obj: gi_lib: gi_type);
else;
  main('QCPFMSG': 'QSYS': '*MSGF');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_obj  like(gi_obj) const;
    i_lib  like(gi_lib) const;
    i_type like(gi_type) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if   not f_exist(i_lib: *omit: '*LIB');
    msg = f_newMsg('CPF9898': 'Library ' + %trim(i_lib)
                              + ' does not exist');
    f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
  else;
    if   not f_exist(i_obj: i_lib: i_type);
      msg = f_newMsg('CPF9898': 'Object ' + %trim(i_lib) + '/'
                                + %trim(i_obj) + ' (' + %trim(i_type)
                                + ') does not exist');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    else;
      msg = f_newMsg('CPF9897': 'Done');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
    endif;
  endif;

  return;


end-proc main;
