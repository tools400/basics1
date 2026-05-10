**free
//===============================================================*
//    CALL PGM(TEST_RC_01)                                       *
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
//       >>PARM<< OPTION(*EVENTF);                               *
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

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RC_01');
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
  dcl-s y int(10) inz;
  dcl-s size int(10) inz;
  dcl-s key like(BasicMap_key_t) inz;
  dcl-s pValue pointer inz;
  dcl-s hMap like(BasicMap_handle_t) inz;
  dcl-s nbrOfElm int(10) inz;
  dcl-s aSize int(10) inz;
  dcl-s aField char(3000) inz;
  dcl-s aPointer pointer inz;
  dcl-s isFound ind inz;
  dcl-ds anArray dim(10) qualified;
    size     like(aSize) inz;
    trimSize like(aSize) inz;
    data     like(aField) inz;
  end-ds;

  dcl-ds msg likeds(msg_t) inz;

  dcl-c MAX_INT_VALUE 2147483647;
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

  // Set size of trimmed field data
  for x = 1 to %elem(anArray);
    anArray(x).size     = %len(anArray(x).data);
    anArray(x).trimSize = %len(%trimR(anArray(x).data));
    p_assert(anArray(x).size <> anArray(x).trimSize                                   //RADDAT
             : 'Size and trimmed size must be different');
  endfor;

  // Create BasicMap
  hMap = BasicMap_new();

  // Add elements to map
  for x = 1 to %elem(anArray);
    y = %elem(anArray) - x + 1;
    BasicMap_put(hMap: 'Element_' + %editc(y: 'X')
                     : %addr(anArray(x).data)
                     : anArray(x).trimSize   );
  endfor;

  // Verify number of elements on stack
  nbrOfElm = BasicMap_getNumE(hMap);
  p_assert(nbrOfElm = %elem(anArray)
           : 'Number of elements on stack does not match expected +
              number of ' + %char(%elem(anArray)));

  // Search map for key 'Element_0000000003'
  x = 3;
  aPointer = BasicMap_get(hMap: 'Element_' + %editc(x: 'X')
                              : %addr(aField)
                              : %size(aField));

  p_assert(aPointer <> *NULL
           : 'Entry not found: ' + 'Element_3');

  // Check map for key 'Element_0000000007'
  x = 7;
  isFound = BasicMap_containsKey(hMap: 'Element_' + %editc(x: 'X'));

  p_assert(isFound
           : 'Entry not found: ' + 'Element_7');

  // Check map for key 'Element_99'
  x = 99;
  isFound = BasicMap_containsKey(hMap: 'Element_' + %editc(x: 'X'));

  p_assert(not isFound
           : 'Entry found: ' + 'Element_99');

  // Get element by index
  for x = 1 to %elem(anArray);
    y = %elem(anArray) - x + 1;
    aPointer = BasicMap_getValueByIndex(hMap: x
                                            : %addr(aField)
                                            : %size(aField));
    p_assert(aPointer <> *NULL
             : 'Entry not found: ' + 'index=4');
    p_assert(%str(aPointer) = anArray(y).data
             : 'Element contains invalid data');

    size = BasicMap_getSizeByIndex(hMap: x);

    p_assert(size = anArray(y).trimSize
             : 'Element contains invalid data');
  endfor;

  // Test index out of bounds
  size = BasicMap_getSizeByIndex(hMap: 0);
  p_assert(size = -1
           : 'Expected -1 for out of bounds condition');

  size = BasicMap_getSizeByIndex(hMap: MAX_INT_VALUE);
  p_assert(size = -1
           : 'Expected -1 for out of bounds condition');

  pValue = BasicMap_getValueByIndex(hMap: 0);
  p_assert(pValue = *NULL
           : 'Expected -1 for out of bounds condition');

  pValue = BasicMap_getValueByIndex(hMap: MAX_INT_VALUE);
  p_assert(pValue = *NULL
           : 'Expected -1 for out of bounds condition');

  key = BasicMap_getKeyByIndex(hMap: 0);
  p_assert(key = ''
           : 'Expected empty string for out of bounds condition');

  key = BasicMap_getKeyByIndex(hMap: MAX_INT_VALUE);
  p_assert(key = ''
           : 'Expected empty string for out of bounds condition');

  // Change size of data
  BasicMap_put(hMap: 'ChangeSize': 'HelloWorld');
  p_assert(BasicMap_getSize(hMap: 'ChangeSize') = 10);

  BasicMap_put(hMap: 'ChangeSize': 'Hello World!');
  p_assert(BasicMap_getSize(hMap: 'ChangeSize') = 12);

  // Delete map
  BasicMap_delete(hMap);

  p_assert(hMap = BasicMap_null()
           : 'Map handle not set to NULL');

  return;


end-proc main;
