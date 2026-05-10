**free
//===============================================================*
//    CALL PGM(TEST_RG_01)                                       *
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
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RA_01');
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


//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s hProperties like(BasicProperties_handle_t) inz;

  dcl-s bValue ind;
  dcl-s dValue like(BasicProperties_decVal_t);
  dcl-s iValue int(10);
  dcl-s sValue varchar(4096);

  dcl-s size int(10);
  dcl-s rc int(10);
  dcl-s hKeySet like(BasicKeySet_handle_t);
  dcl-s keys varchar(100) dim(4);
  dcl-s i int(10);
  dcl-s count int(10);

  dcl-c BOOLEAN '*BOOLEAN';
  dcl-c DECIMAL '*DECIMAL';
  dcl-c INTEGER '*INTEGER';
  dcl-c STRING '*STRING';
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create BasicProperties
  hProperties = BasicProperties_new();

  // Add elements
  BasicProperties_putBoolean(hProperties: BOOLEAN: cTrue);
  BasicProperties_putDecimal(hProperties: DECIMAL: 123.45);
  BasicProperties_putInteger(hProperties: INTEGER: 678);
  BasicProperties_putString(hProperties: STRING: 'Donald Duck');

  // Verify number of items
  size = BasicProperties_getNumE(hProperties);
  p_assert(size = 4: 'Properties must contain 4 items');

  // Verify property entries
  bValue = BasicProperties_getBoolean(hProperties: BOOLEAN);
  p_assert(bValue = cTrue: 'bValue must be TRUE');

  dValue = BasicProperties_getDecimal(hProperties: DECIMAL);
  p_assert(dValue = 123.45: 'dValue must equal 123.45');

  iValue = BasicProperties_getInteger(hProperties: INTEGER);
  p_assert(iValue = 678: 'iValue must equal 678');

  sValue = BasicProperties_getString(hProperties: STRING);
  p_assert(bValue = cTrue: 'bValue must match ''Donald Duck''');

  // Remove items
  rc = BasicProperties_remove(hProperties: DECIMAL + '_NO_ENTRY');
  p_assert(rc = -1: 'Key not found! ''rc'' must equal -1');

  rc = BasicProperties_remove(hProperties: DECIMAL);
  p_assert(rc = 0: 'Key exists! ''rc'' must equal 0');

  size = BasicProperties_getNumE(hProperties);
  p_assert(size = 3: 'Properties must contain 3 items');

  // Check keySet
  hKeySet = BasicProperties_newKeySet(hProperties);
  keys(1) = BasicKeySet_getFirst(hKeySet);
  keys(2) = BasicKeySet_getNext(hKeySet);
  keys(3) = BasicKeySet_getNext(hKeySet);
  keys(4) = BasicKeySet_getNext(hKeySet);
  BasicKeySet_delete(hKeySet);

  for i = 1 to %elem(keys);
    if (keys(i) <> '');
      rc = BasicProperties_remove(hProperties : keys(i));
      p_assert(rc = 0: 'Key must exist and ''rc'' must equal 0');
      count += 1;
    endif;
  endfor;

  p_assert(count = 3: '3 items must have been removed from properties');

  size = BasicProperties_getNumE(hProperties);
  p_assert(size = 0: 'Properties must be empty, now');

  // Delete properties
  BasicProperties_delete(hProperties);

  p_assert(hProperties = BasicProperties_null()
           : 'Properties handle not set to NULL');

  return;

end-proc;
