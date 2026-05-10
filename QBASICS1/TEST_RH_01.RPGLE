**free
//===============================================================*
//    CALL PGM(TEST_RH_01)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//     >>EXECUTE<<                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              BNDDIR(QC2LE) +                  *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RH_01');
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
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s hReader like(memRdr_handle_t) inz;
  dcl-s hWriter like(memWtr_handle_t) inz;
  dcl-s fromBuffer char(1024) inz;
  dcl-s toBuffer char(1024) inz;
  dcl-s tBuffer char(3) inz;
  dcl-s nRead int(10) inz;
  dcl-s nWrite int(10) inz;
  dcl-s errno int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  fromBuffer = 'The quick brown fox jumps over the lazy dog.';
  toBuffer   = '';

  hReader = MemoryReader_new(%addr(fromBuffer):%len(%trimR(fromBuffer)));
  hWriter = MemoryWriter_new(%addr(toBuffer  ):%size(toBuffer  ));

  dou (nRead = 0 or nRead = RC_ERROR);
    nRead = MemoryReader_read(hReader: %addr(tBuffer): %size(tBuffer));
    if (nRead > 0);
      nWrite = MemoryWriter_write(hWriter: %addr(tBuffer): nRead);
      p_assert(nRead = nWrite
               : 'nRead (' + %char(nRead) +
                 ') does not match nWrite (' + %char(nWrite) + ')');
    endif;
  enddo;

  MemoryReader_delete(hReader);
  MemoryWriter_delete(hWriter);

  p_assert(hReader = 0: 'hReader must be 0');
  p_assert(hWriter = 0: 'hWriter must be 0');

  p_assert(%trimR(fromBuffer) = %trimR(toBuffer)
           : 'fromBuffer is not equal to toBuffer');

  // ------------------------------------------------
  // Test: toBuffer is too small.
  // ------------------------------------------------

  fromBuffer = 'The quick brown fox jumps over the lazy dog.';
  toBuffer   = '';

  hReader = MemoryReader_new(%addr(fromBuffer):%len(%trimR(fromBuffer)));
  hWriter = MemoryWriter_new(%addr(toBuffer  ): 17);

  dou (nRead = 0 or nRead = RC_ERROR);
    nRead = MemoryReader_read(hReader: %addr(tBuffer): %size(tBuffer));
    if (nRead > 0);
      nWrite = MemoryWriter_write(hWriter: %addr(tBuffer): nRead);
      select;
      when (nWrite = RC_ERROR);
        errno = f_errno();
        p_assert(errno = ENOBUFS_C
                 : 'errno does not match expected value: ENOBUFS');
        leave;
      when (nWrite > 0);
        p_assert(nRead = nWrite
                 : 'nRead (' + %char(nRead) +
                   ') does not match nWrite (' + %char(nWrite) + ')');
      endsl;
    endif;
  enddo;

  MemoryReader_delete(hReader);
  MemoryWriter_delete(hWriter);

  // ------------------------------------------------
  // Test: Bad handle: MemoryWriter
  // ------------------------------------------------
  f_clrErrno();
  nWrite = MemoryWriter_write(hWriter: %addr(tBuffer): nRead);
  p_assert(nWrite = RC_ERROR
           : 'nWrite does not match expected value: RC_ERROR');
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');
  f_clrErrno();
  MemoryWriter_delete(hWriter);
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');

  f_clrErrno();
  hReader = MemoryReader_new(%addr(fromBuffer):%len(%trimR(fromBuffer)));
  f_clrErrno();
  nWrite = MemoryWriter_write(hReader: %addr(tBuffer): nRead);
  p_assert(nWrite = RC_ERROR
           : 'nWrite does not match expected value: RC_ERROR');
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');
  f_clrErrno();
  MemoryReader_delete(hReader);

  // ------------------------------------------------
  // Test: Bad handle: MemoryReader
  // ------------------------------------------------
  f_clrErrno();
  nRead = MemoryReader_read(hReader: %addr(tBuffer): nRead);
  p_assert(nWrite = RC_ERROR
           : 'nWrite does not match expected value: RC_ERROR');
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');
  f_clrErrno();
  MemoryReader_delete(hReader);
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');

  f_clrErrno();
  hWriter = MemoryWriter_new(%addr(fromBuffer):%len(%trimR(fromBuffer)));
  f_clrErrno();
  nRead = MemoryReader_read(hWriter: %addr(tBuffer): 10);
  p_assert(nRead = RC_ERROR
           : 'nRead does not match expected value: RC_ERROR');
  p_assert(f_errno() = EBADF_C
           : 'errno does not match expected value: EBADF');
  f_clrErrno();
  MemoryWriter_delete(hWriter);

  return;


end-proc main;
