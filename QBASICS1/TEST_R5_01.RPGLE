**FREE
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
ctl-opt DEBUG OPTION(*SRCSTMT : *NODEBUGIO);
ctl-opt DECEDIT('0,') DATEDIT(*DMY.);
ctl-opt DATFMT(*ISO )  TIMFMT(*ISO );
ctl-opt EXPROPTS(*RESDECPOS);
ctl-opt EXTBININT(*YES);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_R5_01');
  gi_obj          char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
  gi_type         char(10) const  options(*nopass);
end-pr;

dcl-pr main;
  i_obj           const  like(gi_obj    );
  i_lib           const  like(gi_lib    );
  i_type          const  like(gi_type   );
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_obj          char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
  gi_type         char(10) const  options(*nopass);
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

dcl-pi main;
  i_obj           const  like(gi_obj    );
  i_lib           const  like(gi_lib    );
  i_type          const  like(gi_type   );
end-pi;

//  Helper fields
dcl-ds msg likeds(msg_t     ) inz;
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

