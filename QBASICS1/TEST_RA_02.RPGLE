**FREE
//===============================================================*
//    CALL PGM(TEST_RA_02)                                       *
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
       extpgm('TEST_RA_02');
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

dcl-pi main;
end-pi;

//  Helper fields
dcl-s x               int(10) inz;
dcl-s numE            int(10) inz;
dcl-s hList           like(BasicList_handle_t )  inz;
dcl-ds anArray dim(10)   qualified;
  data            like(aString      )        inz;
end-ds;
dcl-s aString         varchar(32) inz;

dcl-ds elem qualified;
  isNull          int(10) inz;
  isNotNull       int(10) inz;
end-ds;

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

// Test the last string element for a NULL value
p_assert(not BasicList_isNullValue(hList: %elem(anArray))
         : 'BasicList_isNullValue returned invalid value');

// Set some element to NULL
numE = BasicList_getNumE(hList);
BasicList_setNull(hList: 3);
BasicList_setNull(hList: 6);
BasicList_setNull(hList: 8);

// Verify number of elements
p_assert(BasicList_getNumE(hList) = numE
         : 'List contains invalid number of elements');

// Count NULL and non-NULL values
for x = 1 to BasicList_getNumE(hList);
   if (BasicList_isNullValue(hList: x));
      elem.isNull = elem.isNull + 1;
      p_assert(x = 3 or x = 6 or x = 8 or x = 11
               : 'Found element that should not be NULL');
   else;
      elem.isNotNull = elem.isNotNull + 1;
   endif;
endfor;

p_assert(elem.isNull = 4
         : 'List contains invalid number of NULL elements');
p_assert(elem.isNotNull = 7
         : 'List contains invalid number of non-NULL elements');

// Delete list
BasicList_delete(hList);

p_assert(hList = BasicList_null()
         : 'List handle not set to NULL');

return;


end-proc main;

