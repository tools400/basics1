**FREE
//===============================================================*
//    CALL PGM(TEST_RA_01)                                       *
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
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------
dcl-c cTYPE_TEST
      const('*TEST');

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_RA_01');
end-pr;

dcl-pr main;
end-pr;

dcl-pr sort
       int(10)
       extproc('sort');
  i_pKeyData      pointer value;
  i_keySize       int(10) value;
  i_pElemData     pointer value;
  i_elemSize      int(10) value;
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

dcl-pi main;
end-pi;

//  Helper fields
dcl-s x               int(10) inz;
dcl-s hList           like(BasicList_handle_t )  inz;
dcl-s isValid         ind inz;
dcl-s isSorted        ind inz;
dcl-s listType        like(BasicList_type_t  )   inz;
dcl-s entryType       like(BasicList_type_t  )   inz;
dcl-s aString         varchar(4096) inz;
dcl-s aField          char(20) based(paField);
dcl-s numE            int(10) inz;
dcl-s aSize           int(10) inz;
dcl-ds anArray dim(10)   qualified;
  size            like(aSize        )        inz;
  trimSize        like(aSize        )        inz;
  data            like(aField       )        inz;
end-ds;
dcl-s bufferCheck     char(128);

dcl-s aSortedArray    char(20) dim(10) inz;

dcl-ds msg likeds(msg_t      )        inz;
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

// Initialize the sort Array
for x = 1 to %elem(anArray);
   aSortedArray(x) = anArray(x).data;
endfor;
sorta aSortedArray;

// Set size of trimmed field data
for x = 1 to %elem(anArray);
   anArray(x).size     = %len(anArray(x).data);
   anArray(x).trimSize = %len(%trimR(anArray(x).data));
   p_assert(anArray(x).size <> anArray(x).trimSize
            : 'Size and trimmed size must be different');
endfor;

// Create BasicList
hList = BasicList_new(cTYPE_TEST);

// Add elements to list
for x = 1 to %elem(anArray);
   BasicList_add(hList: anArray(x).data);
endfor;

// Verify elements in list
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   aSize   = BasicList_getSize(hList: x);
   p_assert(aSize = %len(anArray(1).data)
            : 'Field size does not match expected size of 20');
   p_assert(%subst(aField: 1: aSize) = anArray(x).data
            : 'Field contents do not match');
endfor;

// Trim elements in list
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   BasicList_set(hList: x: %addr(anArray(x).data):anArray(x).trimSize);
endfor;

// Verify elements in list
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   aSize   = BasicList_getSize(hList: x);
   p_assert(aSize = anArray(x).trimSize
            : 'Field size does not match expected size');
   p_assert(%subst(aField: 1: aSize) = anArray(x).data
            : 'Field contents do not match');
endfor;

// Sort list
isSorted = BasicList_sort(hList: %paddr('sort'));
isSorted = BasicList_sort(hList: %paddr('sort'));
p_assert(isSorted = cTrue:
         'Variable isSorted does not match expected value: cTrue');

// Verify element order
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   p_assert(%str(paField) = aSortedArray(x)
            : 'List order does not match expected order');
endfor;

// Find a liste entry
x = BasicList_find(hList: 'Trick');
p_assert(x > 0
         : 'List entry ''Trick'' not found');
paField = BasicList_get(hList: x);
p_assert(%str(paField) = 'Trick'
         : 'List entry ''Trick'' contains invalid data');

// Change elements to new size 3
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   BasicList_set(hList: x: %addr(anArray(x).data): 3);
endfor;

// Verify elements in list
for x = 1 to %elem(anArray);
   paField = BasicList_get(hList: x);
   aSize   = BasicList_getSize(hList: x);
   p_assert(aSize = 3
            : 'Field size does not match expected size');
   p_assert(%subst(aField: 1: aSize) = %subst(anArray(x).data: 1: 3)
            : 'Field contents do not match');
   p_assert(%subst(aField: 4: 13) = *ALLx'00'
            : 'Field has not been properly cleared');
endfor;

// Verify number of elements in list
p_assert(BasicList_getNumE(hList) = 10
         : 'Number of elements in list does not match +
            expected number of 10');

// Add a string to the list
x = BasicList_addString(hList: 'Hello World');

isValid = BasicList_isTypeOf(hList: x: cBASICLIST_TYPE_VSTRING);
p_assert(isValid
         : '''Hello World'' is not of type VARYING');

entryType = BasicList_getType(hList: x);
p_assert(entryType = cBASICLIST_TYPE_VSTRING
         : '''Hello World'' is not of type STRING (varying)');

// Get a string from the list
aString = BasicList_getString(hList: x);

p_assert(aString = 'Hello World'
         : 'String contains wrong value');

// Search the list for a string
x = BasicList_findString(hList: 'Hello World');
p_assert(x > 0
         : 'List entry ''Hello World'' not found');
aString = BasicList_getString(hList: x);
p_assert(aString = 'Hello World'
         : 'List entry ''Hello World'' contains invalid data');

// Remove the string from the list
BasicList_remove(hList: x);

// Check invalid values
paField = BasicList_get(hList: 99);
p_assert(paField = *NULL
         : 'paField should be NULL');

aString = BasicList_getString(hList: 99);
p_assert(aString = ''
         : 'aString should be empty');

aSize = BasicList_getSize(hList: 99);
p_assert(aSize = -1
         : 'aSize should be -1');

// Check list type
isValid = BasicList_isListTypeOf(hList: '*TEST');
p_assert(isValid
         : 'List type does not match expected value of ' + cTYPE_TEST);
listType = BasicList_getListType(hList);
p_assert(listType = cTYPE_TEST
         : 'List type does not match expected value of ' + cTYPE_TEST);

// Set auto-sort option
BasicList_setAutoSort(hList: %paddr('sort'));

// Add some more entries
x = BasicList_add(hList: 'aaa');
x = BasicList_add(hList: 'bbb');
x = BasicList_add(hList: 'ccc');

// These entries should be the first entries in the list.
paField = BasicList_get(hList: 3);
p_assert(%str(paField) = 'ccc'
         : 'ccc is not at the expected position in the list');

paField = BasicList_get(hList: 2);
p_assert(%str(paField) = 'bbb'
         : 'bbb is not at the expected position in the list');

paField = BasicList_get(hList: 1);
p_assert(%str(paField) = 'aaa'
         : 'aaa is not at the expected position in the list');

// Buffer resize check
bufferCheck = *ALL'*';
x = BasicList_add(hList: %addr(bufferCheck): 32);
BasicList_get(hList: x:  %addr(bufferCheck): %size(bufferCheck) - 1);
p_assert(%subst(bufferCheck:  1: 32) = *ALL'*');
p_assert(%subst(bufferCheck: 33: %size(bufferCheck) - 33)= *ALLx'00');
p_assert(%subst(bufferCheck: %size(bufferCheck): 1) = *ALL'*');

// Add element and increase its size
BasicList_setAutoSort(hList: *NULL);

x = BasicList_add(hList: 'HelloWorld');
aSize   = BasicList_getSize(hList: x);
p_assert(aSize = 10
         : 'Field size does not match expected size of 10');

BasicList_set(hList: x: 'Hello World!');
aSize   = BasicList_getSize(hList: x);
p_assert(aSize = 12
         : 'Field size does not match expected size of 12');

BasicList_set(hList: x: 'Hello World! I love you.');
aSize   = BasicList_getSize(hList: x);
p_assert(aSize = 24
         : 'Field size does not match expected size of 24');

// Delete list
BasicList_delete(hList);

p_assert(hList = BasicList_null()
         : 'List handle not set to NULL');

return;


end-proc main;

//===============================================================*
//  Sort procedure
//===============================================================*
dcl-proc sort;

dcl-pi sort
       int(10);
  i_pKeyData      pointer value;
  i_keySize       int(10) value;
  i_pElemData     pointer value;
  i_elemSize      int(10) value;
end-pi;

//  Return value
dcl-s rc              int(10) inz;

//  Helper fields
dcl-s key             char(128) based(i_pKeyData );
dcl-s elem            char(128) based(i_pElemData);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

select;
when %subst(key: 1: i_keySize) > %subst(elem: 1: i_elemSize);
   rc = 1;
when %subst(key: 1: i_keySize) < %subst(elem: 1: i_elemSize);
   rc = -1;
other;
   rc = 0;
endsl;

return rc;


end-proc sort;

