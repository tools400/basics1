**FREE
//===============================================================*
//  CALL PGM(TEST_R5_02) PARM('QRPGSRC' 'QGPL' '*FILE' '*FIRST') *
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
       extpgm('TEST_R5_02');
  gi_file         char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
  gi_mbr          char(10) const  options(*nopass);
end-pr;

dcl-pr main;
  i_file          const  like(gi_file   );
  i_lib           const  like(gi_lib    );
  i_mbr           const  like(gi_mbr    );
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_file         char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
  gi_mbr          char(10) const  options(*nopass);
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_mbr));
   main(gi_file: gi_lib: gi_mbr);
else;
   main('QBASICS1': '*LIBL': 'TEST_R5_02');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
  i_file          const  like(gi_file   );
  i_lib           const  like(gi_lib    );
  i_mbr           const  like(gi_mbr    );
end-pi;

//  Helper fields
dcl-ds msg likeds(msg_t     ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (not f_startsWith('*': i_lib) and
    not f_exist(i_lib: *omit: '*LIB'));
   msg = f_newMsg('CPF9898': 'Library ' + %trim(i_lib)
                             + ' does not exist');
   f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
else;
   if   not f_exist(i_file: i_lib: '*FILE': i_mbr);
      msg = f_newMsg('CPF9898': 'Member ' + %trim(i_lib) + '/'
                                + %trim(i_file) + ' (' + %trim(i_mbr)
                                + ') does not exist');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
   else;
      msg = f_newMsg('CPF9897': 'Done');
      f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
   endif;
endif;

return;


end-proc main;

