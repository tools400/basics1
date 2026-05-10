**free
//===============================================================*
//    CALL PGM(TEST_R7_07) PARM('Hello World.txt')               *
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
//                              BNDDIR(QC2LE) +                  *
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
/copy QBASICS1,CLIB
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R7_07');
  gi_path char(32) const;
end-pr;

dcl-pr main;
  i_path varchar(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_path char(32) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(%trimR(gi_path));

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
    i_path varchar(32) const;
  end-pi;

  //  Helper fields
  dcl-s is1Call ind inz(cFalse);
  dcl-s shaOptions uns(5) inz;
  dcl-s hFile int(10) inz;
  dcl-ds inBuff qualified;
    size  uns(10) inz;
    value char(64) inz;
  end-ds;
  dcl-s bytesLeft uns(10) inz;
  dcl-ds shaAsString likeds(sha1_t) inz;
  dcl-ds st_stat likeds(st_stat_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Generate a string SHA-1 of a given stream file:

  // Open stream file
  hFile = open(i_path: O_RDONLY);
  if hFile = RC_ERROR;
    return;
  endif;

  // Get size of stream file
  if stat(i_path: %addr(st_stat)) = RC_ERROR;
    callp close(hFile);
    return;
  else;
    bytesLeft = st_stat.size;
  endif;

  // Read 1. chunk of data
  inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));

  is1Call = cTrue;   // First call to f_genSHA1

  dow inBuff.size > 0;

    // Set SHA-1 options
    if is1Call;
      if inBuff.size < bytesLeft;
        shaOptions = cSHA1_FIRST;
      else;
        shaOptions = cSHA1_ONLY;
      endif;
      is1Call = cFalse;
    else;
      if inBuff.size < bytesLeft;
        shaOptions = cSHA1_MIDDLE;
      else;
        shaOptions = cSHA1_FINAL;
      endif;
    endif;

    shaOptions = shaOptions + cSHA1_STRING;

    // Call SHA generation
    shaAsString = f_genSHA1(%addr(inBuff.value):shaOptions:inBuff.size);

    // Decrease number of bytes left
    bytesLeft = bytesLeft - inBuff.size;

    // Read next chunk of data
    inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));
  enddo;

  // Close stream file
  callp close(hFile);

  msg = f_newMsg(cMSG_ID_NONE:
                 'SHA-1 as ' + %char(shaAsString.length) +
                 '-byte string value: ' + shaAsString.value);
  f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

  return;


end-proc main;
