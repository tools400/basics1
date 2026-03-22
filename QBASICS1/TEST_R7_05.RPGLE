**FREE
//===============================================================*
//    CALL PGM(TEST_R7_05) PARM('Hello World')                   *
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
       extpgm('TEST_R7_05');
  gi_string       char(32) const  options(*nopass);
end-pr;

dcl-pr main;
  i_string        varchar(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_string       char(32) const  options(*nopass);
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_string));
   main(%trimR(gi_string));
else;
   main('Hello World!');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
  i_string        varchar(32) const;
end-pi;

//  Helper fields
dcl-s buffer          char(64) inz;
dcl-ds sha1AsHex likeds(sha1_t    ) inz;
dcl-ds sha1AsString likeds(sha1_t    ) inz;
dcl-ds msg likeds(msg_t     ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Generate a hexadecimal SHA-1.
// Note: Parameters 'cSHA1_HEX' and 'length'
//       are optional. Default is 'cSHA1_HEX'.
sha1AsHex = f_genSHA1(i_string: cSHA1_HEX);

msg = f_newMsg(cMSG_ID_NONE:
               'SHA-1 as ' + %char(sha1AsHex.length) +
               '-byte hex value: ' + sha1AsHex.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Generate a string SHA-1.
sha1AsString = f_genSHA1(i_string: cSHA1_STRING);

msg = f_newMsg(cMSG_ID_NONE:
               'SHA-1 as ' + %char(sha1AsString.length) +
               '-byte string value: ' + sha1AsString.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Generate a string SHA-1 from a buffer.
buffer      = i_string;
sha1AsString = f_genSHA1(%addr(buffer): cSHA1_STRING: %len(i_string));

msg = f_newMsg(cMSG_ID_NONE:
               'SHA-1 as ' + %char(sha1AsString.length) +
               '-byte string value: ' + sha1AsString.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

