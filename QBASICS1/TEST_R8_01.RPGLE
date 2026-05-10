**free
//===============================================================*
//    CALL PGM(TEST_R8_01)                                       *
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
dcl-ds handle1_t qualified based(pDummy);
  numE int(10);
  type char(20);
end-ds;

dcl-ds handle2_t qualified based(pDummy);
  type char(20);
  numE int(10);
end-ds;

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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R8_01');
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
  dcl-s aHandle1 like(HANDLE_handle_t) inz;
  dcl-s aHandle2 like(HANDLE_handle_t) inz;
  dcl-ds handle1 likeds(handle1_t) based(pHandle1);
  dcl-ds handle2 likeds(handle2_t) based(pHandle2);
  dcl-ds msg likeds(msg_t) inz;

  //  Constants
  dcl-c cTYPE1 '*HANDLE1';
  dcl-c cTYPE2 '*HANDLE2';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create handles
  aHandle1 = HANDLE_new(cTYPE1: %size(handle1_t));
  aHandle2 = HANDLE_new(cTYPE2: %size(handle2_t));

  // Check handle types
  if not HANDLE_isTypeOf(aHandle1: cTYPE1);
    dsply 'Invalid type of handle 1' '*EXT';
  endif;

  if not HANDLE_isTypeOf(aHandle2: cTYPE2);
    dsply 'Invalid type of handle 2' '*EXT';
  endif;

  // Change data of handle 1
  pHandle1 = HANDLE_getPointer(aHandle1);
  handle1.numE = 4;
  handle1.type = cTYPE1;

  // Change data of handle 2
  pHandle2 = HANDLE_getPointer(aHandle2);
  handle2.numE = 8;
  handle2.type = cTYPE2;

  // Change data of handle 1
  pHandle1 = HANDLE_getPointer(aHandle1);
  handle1.numE = handle1.numE * 2;
  handle1.type = cTYPE1 + cType1;

  // Change data of handle 2
  pHandle2 = HANDLE_getPointer(aHandle2);
  handle2.numE = handle2.numE * 2;
  handle2.type = cTYPE2 + cTYPE2;

  // Verify handle data
  if handle1.numE <> 8 or handle1.type <> cTYPE1 + cType1;
    dsply 'Invalid data of handle 1' '*EXT';
  endif;

  if handle2.numE <> 16 or handle2.type <> cTYPE2 + cType2;
    dsply 'Invalid data of handle 2' '*EXT';
  endif;

  // Delete handles
  HANDLE_delete(aHandle1);
  HANDLE_delete(aHandle2);

  // Create a NULL Handle
  aHandle1 = HANDLE_null();

  // Check for a NULL Handle
  if not HANDLE_isNull(aHandle1);
    dsply 'Handle is not a NULL handle' '*EXT';
  endif;

  return;


end-proc main;
