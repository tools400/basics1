**FREE
//===============================================================*
//    CALL PGM(TEST_R4_01) PARM('1')                             *
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
       extpgm('TEST_R4_01');
  gi_boolean      char(1) const  options(*nopass);
end-pr;

dcl-pr main;
  i_boolean       ind const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_boolean      char(1) const  options(*nopass);
end-pi;

//  Local helper fields
dcl-ds msg likeds(msg_t     ) inz;
dcl-s procedure       char(256) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure = f_this();
msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                   + '*N' + '.'
                                   + %trimR(procedure));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

if (%parms() >= %parmNum(gi_boolean));
   main(gi_boolean);
else;
   main(*on);
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
  i_boolean       ind const;
end-pi;

//  Local helper fields
dcl-ds msg likeds(msg_t     ) inz;
dcl-s procedure       char(256) inz;
dcl-s module          char(10) inz;
dcl-s program         char(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure = f_this();
msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                   + '*N' + '.'
                                   + %trimR(procedure));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

procedure = f_this(module);
msg = f_newMsg(cMSG_ID_NONE: '=> ' + '*N/'
                                   + %trimR(module) + '.'
                                   + %trimR(procedure));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

procedure = f_this(module: program);
msg = f_newMsg(cMSG_ID_NONE: '=> ' + %trimR(program) + '/'
                                   + %trimR(module) + '.'
                                   + %trimR(procedure));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

procedure = f_caller(module: program);
msg = f_newMsg(cMSG_ID_NONE: '=> ' + %trimR(program) + '/'
                                   + %trimR(module) + '.'
                                   + %trimR(procedure));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

p_assert(i_boolean                        :                                          //RADDAT
         'Error detected by p_assert()'   );

return;


end-proc main;

