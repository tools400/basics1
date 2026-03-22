**FREE
//===============================================================*
//    CALL PGM(TEST_RC_04)                                       *
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

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_RC_04');
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
dcl-s hMap            like(BasicMap_handle_t  ) inz;
dcl-s hClonedMap      like(BasicMap_handle_t  ) inz;

dcl-ds value1 qualified;
  key             like(BasicMap_key_t ) inz;
  size            int(10) inz;
  pData           pointer inz;
  string          char(32) inz;
end-ds;

dcl-ds value2 likeds(value1 ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Create a BasicMap
hMap = BasicMap_new();

// Add some entries to it
for x = 1 to 32;
   BasicMap_putString(hMap: %char(x): %char(x) + '. Hello World!');
endfor;

// Add a NULL entry
BasicMap_put(hMap: %char(x): *NULL);

// Clone the BasicMap
hClonedMap = BasicMap_clone(hMap);

// Check entries of cloned map
for x = 1 to BasicMap_getNumE(hMap);
   value1.key    = BasicMap_getKeyByIndex(hMap: x);
   value1.pData  = BasicMap_getValueByIndex(hMap: x);
   value1.size   = BasicMap_getSizeByIndex(hMap: x);
   value1.string = BasicMap_getString(hMap: value1.key);

   value2.key    = BasicMap_getKeyByIndex(hClonedMap: x);
   value2.pData  = BasicMap_getValueByIndex(hClonedMap: x);
   value2.size   = BasicMap_getSizeByIndex(hClonedMap: x);
   value2.string = BasicMap_getString(hClonedMap: value2.key);

   p_assert(value1.string = value2.string
            : 'Map entries do not match');

   if (value1.pData = *NULL);
      p_assert(value1.pData  = value2.pData
               : 'Map NULL entries do not match');
   endif;
endfor;

// Delete the BasicMap
BasicMap_delete(hMap);
p_assert(hMap = BasicMap_null()
         : 'Map handle not set to NULL');

// Delete the cloned BasicMap
BasicMap_delete(hClonedMap);
p_assert(hClonedMap = BasicMap_null()
         : 'Cloned map handle not set to NULL');

return;


end-proc main;

