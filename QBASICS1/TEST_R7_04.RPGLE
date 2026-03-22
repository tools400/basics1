**FREE
//===============================================================*
//    CALL PGM(TEST_R7_04) PARM('Hello World')                   *
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
       extpgm('TEST_R7_04');
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
dcl-ds md5AsHex likeds(md5_t     ) inz;
dcl-ds md5AsString likeds(md5_t     ) inz;
dcl-ds msg likeds(msg_t     ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Generate a hexadecimal MD5.
// Note: Parameters 'cMD5_HEX' and 'length'
//       are optional. Default is 'cMD5_HEX'.
md5AsHex = f_genMD5(i_string: cMD5_HEX);

msg = f_newMsg(cMSG_ID_NONE:
               'MD5 as ' + %char(md5AsHex.length) +
               '-byte hex value: ' + md5AsHex.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Generate a string MD5.
md5AsString = f_genMD5(i_string: cMD5_STRING);

msg = f_newMsg(cMSG_ID_NONE:
               'MD5 as ' + %char(md5AsString.length) +
               '-byte string value: ' + md5AsString.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

// Generate a string MD5 from a buffer.
buffer      = i_string;
md5AsString = f_genMD5(%addr(buffer): cMD5_STRING: %size(buffer));

msg = f_newMsg(cMSG_ID_NONE:
               'MD5 as ' + %char(md5AsString.length) +
               '-byte string value: ' + md5AsString.value);
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

