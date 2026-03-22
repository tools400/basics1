**FREE
//===============================================================*
//    CALL PGM(TEST_R7_09) PARM('Hello World.txt')               *
//    CALL PGM(TEST_R7_09) PARM('20050731-019-i32.exe')          *
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
/COPY QBASICS1,CLIB
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
       extpgm('TEST_R7_09');
  gi_path         char(32) const;
end-pr;

dcl-pr main;
  i_path          varchar(32) const;
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
  gi_path         char(32) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main(%trimR(gi_path));

*inlr = *on;

return;


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
  i_path          varchar(32) const;
end-pi;

//  Helper fields
dcl-s is1Call         ind inz(cFalse);
dcl-s crc32Options    uns(5) inz;
dcl-s hFile           int(10) inz;
dcl-ds inBuff qualified;
  size            uns(10) inz;
  value           char(8192) inz;
end-ds;
dcl-s bytesLeft       uns(10) inz;
dcl-ds crc32 likeds(crc32_t   ) inz;
dcl-ds st_stat likeds(st_stat_t ) inz;
dcl-ds msg likeds(msg_t     ) inz;
dcl-ds elapsedTime qualified;
  start           timestamp inz;
  end             timestamp inz;
end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Generate a CRC32 checksum of a given stream file:

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

elapsedTime.start = %timestamp();

// Read 1. chunk of data
inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));

is1Call = cTrue;   // First call to f_genCRC32

dow inBuff.size > 0;

   // Set CRC32 options
   if is1Call;
      if inBuff.size < bytesLeft;
         crc32Options = cCRC32_FIRST;
      else;
         crc32Options = cCRC32_ONLY;
      endif;
      is1Call = cFalse;
   else;
      if inBuff.size < bytesLeft;
         crc32Options = cCRC32_MIDDLE;
      else;
         crc32Options = cCRC32_FINAL;
      endif;
   endif;

   // Call CRC32 generation
   crc32 = f_genCRC32(%addr(inBuff.value): crc32Options: inBuff.size);

   // Decrease number of bytes left
   bytesLeft = bytesLeft - inBuff.size;

   // Read next chunk of data
   inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));
enddo;

// Close stream file
callp close(hFile);

elapsedTime.end   = %timestamp();

msg = f_newMsg(cMSG_ID_NONE:
               'CRC32 as ' + %char(crc32.length) +
               '-byte string value: ' + %trimR(crc32.value) +
               ' Elapsed time: ' +
                   %char(%diff(elapsedTime.end:
                               elapsedTime.start: *mseconds)));
f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

return;


end-proc main;

