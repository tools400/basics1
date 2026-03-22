**FREE
//===============================================================*
//    CALL PGM(TEST_R7_03)                                       *
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
       extpgm('TEST_R7_03');
end-pr;

dcl-pr main;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
end-pi;

//  Helper fields
dcl-ds uuidAsHex likeds(uuid_t    ) inz;
dcl-ds uuidAsString likeds(uuid_t    ) inz;
dcl-ds msg likeds(msg_t     ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Generate a hexadecimal UUID.
// Note: Parameter 'cUUID_HEX' is
//       are optional. Default is 'cUUID_HEX'.
uuidAsHex = f_genUUID(cUUID_HEX);

msg = f_newMsg(cMSG_ID_NONE:
               'UUID as ' + %char(uuidAsHex.length) +
               '-byte hex value: ' + uuidAsHex.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Generate a string UUID.
uuidAsString = f_genUUID(cUUID_STRING);

msg = f_newMsg(cMSG_ID_NONE:
               'UUID as ' + %char(uuidAsString.length) +
               '-byte string value: ' + uuidAsString.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

