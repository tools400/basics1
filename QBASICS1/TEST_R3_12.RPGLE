**FREE
//===============================================================*
//    CALL PGM(TEST_R3_12) PARM('SYSPROCS' 'QSYS2')              *
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
       extpgm('TEST_R3_12');
  gi_name         char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
end-pr;

dcl-pr main;
  i_name          char(10) const;
  i_lib           char(10) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_name         char(10) const  options(*nopass);
  gi_lib          char(10) const  options(*nopass);
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= 2);
   main(gi_name: gi_lib);
else;
   main('SYSPROCS': 'QSYS2');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
  i_name          char(10) const;
  i_lib           char(10) const;
end-pi;

//  Helper fields
dcl-s objName         char(21) inz;
dcl-ds qObj likeds(qObj_t) inz;
dcl-ds msg likeds(msg_t ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

qObj.name = i_name;
qObj.lib  = i_lib;
objName = f_objname(qObj);

p_assert(objName = %trimR(i_lib) + '/' + %trimR(i_name)
         : 'Fehler in Funktion f_objName()');

msg = f_newMsg(cMsg_ID_NONE: 'Qualified object name 1 is: ' + objName);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

objName = f_objname(i_name: i_lib);

p_assert(objName = %trimR(i_lib) + '/' + %trimR(i_name)
         : 'Fehler in Funktion f_objName()');

msg = f_newMsg(cMsg_ID_NONE: 'Qualified object name 2 is: ' + objName);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

