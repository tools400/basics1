**free
//===============================================================*
//    CALL PGM(TEST_RA_03)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< OPTION(*EVENTF);                               *
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

dcl-ds hList_t qualified based(pDummy) align;
  intType       uns(20);
  intSize       uns(10);
  extType       like(BasicList_type_t);
  memSize       uns(10);
  numE          uns(10);
  maxNumE       uns(10);
  totalMemSize  uns(10);
  increment     uns(10);
  signature     likeds(signature_t);
  sortSignature likeds(signature_t);
  pBase         pointer;
  pAutoSortFnc  pointer(*proc);
end-ds;

//signature_t     DS                  qualified   based(pDummy)   align
// tmStmp                         Z
// counter                      10U 0

dcl-ds signature_t qualified based(pDummy);
  time    uns(10);
  millitm uns(10);
  counter uns(10);
end-ds;

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
dcl-c cTYPE_TEST '*TEST';

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RA_03');
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
  dcl-s x int(10) inz;
  dcl-s numE int(10) inz;
  dcl-s hList like(BasicList_handle_t) inz;
  dcl-s hClonedList like(BasicList_handle_t) inz;
  dcl-ds anArray dim(10) qualified;
    data like(aString) inz;
  end-ds;
  dcl-s aString varchar(32) inz;
  dcl-s aString2 varchar(32) inz;

  dcl-ds handle1 likeds(hList_t) based(hList);
  dcl-ds handle2 likeds(hList_t) based(hClonedList);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Initialize Array
  anArray( 1).data = 'Donald Duck';
  anArray( 2).data = 'Dagobert Duck';
  anArray( 3).data = 'Tick';
  anArray( 4).data = 'Trick';
  anArray( 5).data = 'Track';
  anArray( 6).data = 'Daisy';
  anArray( 7).data = 'Klaas Klever';
  anArray( 8).data = 'Daniel Dsentrieb';
  anArray( 9).data = 'Micky Maus';
  anArray(10).data = 'Goofy';

  // Create BasicList
  hList = BasicList_new(cTYPE_TEST);

  // Add elements to list
  for x = 1 to %elem(anArray);
    BasicList_addString(hList: anArray(x).data);
  endfor;

  // Verify elements in list
  for x = 1 to %elem(anArray);
    aString = BasicList_getString(hList: x);
    p_assert(aString = anArray(x).data
             : 'Field contents do not match');
  endfor;

  // Add a NULL values
  x = BasicList_addNull(hList);
  p_assert(x = %elem(anArray) + 1
           : 'Unexpected number of elements in BasicList');

  x = BasicList_getNumE(hList);
  p_assert(x = %elem(anArray) + 1
           : 'Unexpected number of elements in BasicList');

  // Test the latest element for a NULL value
  p_assert(BasicList_isNullValue(hList: x)
           : 'BasicList_isNullValue returned invalid value');

  // Clone the list
  hClonedList = BasicList_clone(hList);

  // Compare handles
  p_assert(handle1.intType        = handle2.intType        );
  p_assert(handle1.intSize        = handle2.intSize        );
  p_assert(handle1.extType        = handle2.extType        );
  p_assert(handle1.memSize        = handle2.memSize        );
  p_assert(handle1.numE           = handle2.numE           );
  p_assert(handle1.maxNumE        = handle2.maxNumE        );
  p_assert(handle1.totalMemSize   = handle2.totalMemSize   );
  p_assert(handle1.increment      = handle2.increment      );
  p_assert(handle1.signature     <> handle2.signature      );
  p_assert(handle1.sortSignature <> handle2.sortSignature  );
  p_assert(handle1.pBase         <> handle2.pBase          );
  p_assert(handle1.pAutoSortFnc   = handle2.pAutoSortFnc   );

  // Check entries of cloned list
  for x = 1 to BasicList_getNumE(hList);
    aString  = BasicList_getString(hList: x);
    aString2 = BasicList_getString(hClonedList: x);
    p_assert(aString = aString2
             : 'List entries do not match');
    p_assert(BasicList_isNullValue(hList: x) =
             BasicList_isNullValue(hClonedList: x)
             : 'NULL values do not match');
  endfor;

  // Delete list
  BasicList_delete(hList);

  p_assert(hList = BasicList_null()
           : 'List handle not set to NULL');

  // Delete cloned list
  BasicList_delete(hClonedList);

  p_assert(hClonedList = BasicList_null()
           : 'Cloned list handle not set to NULL');

  return;


end-proc main;
