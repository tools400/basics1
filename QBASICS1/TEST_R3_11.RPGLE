**free
//===============================================================*
//    CALL PGM(TEST_R3_11) PARM(x'C88593939640E696999384')       *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R3_11');
  gi_buffer char(32) options(*nopass) const;
end-pr;

dcl-pr main;
  i_buffer char(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_buffer char(32) options(*nopass) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (%parms() >= %parmNum(gi_buffer));
  main(gi_buffer);
else;
  main('Hello World!');
endif;

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_buffer char(32) const;
  end-pi;

  //  Helper fields
  dcl-s size int(5) inz;
  dcl-s buffer like(i_buffer) inz;
  dcl-s string varchar(64) inz;
  dcl-s msgText char(128) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Convert a buffer to a hex string.
  buffer = i_buffer;
  size   = %len(%trimR(buffer));
  string = f_cvtBufferToHexString(%addr(buffer): size);

  msgText = 'Buffer: ''' + %trimR(buffer) + '''' +
            ' ==> Hex-String: ''' + string + '''';
  msg = f_newMsg(cMsg_ID_NONE: msgText);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  // Convert a string of hex values to a buffer
  string = 'C140A297818385948195408381948540A39981A5859393899587';
  size = f_cvtHexStringToBuffer(string: %addr(buffer): %size(buffer));

  msgText = 'Hex-String: ''' + string + '''' +
            ' ==> Buffer: ''' + %subst(buffer: 1: size) + '''';
  msg = f_newMsg(cMsg_ID_NONE: msgText);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
