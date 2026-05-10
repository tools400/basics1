**free
//===============================================================*
//    CALL PGM(TEST_RC_05)                                       *
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
dcl-s key_t varchar(256) based(pDummy);
dcl-ds value_t qualified based(pDummy);
  seq  int(10);
  data varchar(32);
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

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_RC_05');
end-pr;

dcl-pr main;
end-pr;

//  Comparator for comparing to 'key' values.
dcl-pr compareKeys int(10) extproc('compareKeys');
  i_pKeyData  pointer value;
  i_keySize   int(10) value;
  i_pElemData pointer value;
  i_elemSize  int(10) value;
end-pr;

//  Comparator for comparing to 'value' structures.
dcl-pr compareValues int(10) extproc('compareValues');
  i_pKeyData  pointer value;
  i_keySize   int(10) value;
  i_pElemData pointer value;
  i_elemSize  int(10) value;
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
//  Comparator for comparing to 'key' values.
//===============================================================*
dcl-proc compareKeys;
  dcl-pi *n int(10);
    i_pKeyData  pointer value;
    i_keySize   int(10) value;
    i_pElemData pointer value;
    i_elemSize  int(10) value;
  end-pi;

  dcl-s rc int(10) inz;
  dcl-s key like(key_t) based(i_pKeyData);
  dcl-s elem like(key_t) based(i_pElemData);
  dcl-s null like(key_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pElemData = *NULL);
    i_pElemData = %addr(null);
  endif;

  if (i_pKeyData = *NULL);
    i_pKeyData = %addr(null);
  endif;

  select;
  when (key < elem);
    rc = -1;
  when (key > elem);
    rc = 1;
  other;
    rc = 0;
  endsl;

  return rc * -1;   // Sort descending


end-proc;

//===============================================================*
//  Comparator for comparing to 'value' structures.
//===============================================================*
dcl-proc compareValues;
  dcl-pi *n int(10);
    i_pKeyData  pointer value;
    i_keySize   int(10) value;
    i_pElemData pointer value;
    i_elemSize  int(10) value;
  end-pi;

  dcl-s rc int(10) inz;
  dcl-ds key likeds(value_t) based(i_pKeyData);
  dcl-ds elem likeds(value_t) based(i_pElemData);
  dcl-ds null likeds(value_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pElemData = *NULL);
    i_pElemData = %addr(null);
  endif;

  if (i_pKeyData = *NULL);
    i_pKeyData = %addr(null);
  endif;

  select;
  when (key.seq < elem.seq);
    rc = -1;
  when (key.seq > elem.seq);
    rc = 1;
  other;
    rc = 0;
  endsl;

  return rc * -1;   // Sort descending


end-proc;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s lastKey int(10) inz;
  dcl-s lastSeq int(10) inz;
  dcl-s hMap like(BasicMap_handle_t) inz;
  dcl-s key like(key_t) inz;
  dcl-ds value likeds(value_t) inz;
  dcl-s hKeys like(BasicList_handle_t) inz;
  dcl-s hValues like(BasicList_handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create a BasicMap
  hMap = BasicMap_new();

  // Add some entries to it
  for x = 1 to 32;
    clear value;
    value.seq  = x;
    value.data = %char(x) + '. Hello World!';
    key = %editc(x: 'X');
    BasicMap_put(hMap: key: %addr(value): %size(value));
  endfor;

  // Add a NULL entry
  key = %editc(x: 'X');
  BasicMap_put(hMap: key: *NULL);

  // Get all keys that are in the map
  hKeys = BasicMap_getKeys(hMap: %paddr('compareKeys'));

  // Check keys
  x = BasicList_getNumE(hKeys);
  lastKey = *HIVAL;
  for x = 1 to BasicList_getNumE(hKeys);
    key = BasicList_getString(hKeys: x);
    p_assert(lastKey > f_val(key)
             : 'lastKey must be greater than key');
    lastKey = f_val(key);
  endfor;

  // Delete the list of keys
  BasicList_delete(hKeys);

  // Get all values that are in the map
  hValues = BasicMap_getValues(hMap: %paddr('compareValues'));

  // Check values
  x = BasicList_getNumE(hValues);
  lastSeq = *HIVAL;
  for x = 1 to BasicList_getNumE(hValues);
    BasicList_get(hValues: x: %addr(value): %size(value));
    p_assert(lastSeq > value.seq
             : 'lastSeq must be greater than value.seq');
    lastSeq = value.seq;
  endfor;

  // Delete the list of values
  BasicList_delete(hValues);

  // Delete the BasicMap
  BasicMap_delete(hMap);
  p_assert(hMap = BasicMap_null()
           : 'Map handle not set to NULL');

  return;


end-proc main;
