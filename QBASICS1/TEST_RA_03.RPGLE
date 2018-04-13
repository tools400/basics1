      *===============================================================*
      *    CALL PGM(TEST_RA_03)                                       *
      *===============================================================*
      *   >>PRE-COMPILER<<                                            *
      *                                                               *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
      *                              SRCFILE(&SL/&SF) +               *
      *                              SRCMBR(&SM);                     *
      *                                                               *
      *     >>COMPILE<<                                               *
      *       >>PARM<< TRUNCNBR(*NO);                                 *
      *       >>PARM<< DBGVIEW(*LIST);                                *
      *       >>PARM<< TGTRLS(*CURRENT);                              *
      *     >>END-COMPILE<<                                           *
      *                                                               *
      *     >>EXECUTE<<                                               *
      *                                                               *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
      *                              MODULE(&LI/&OB) +                *
      *                              ACTGRP(*NEW) +                   *
      *                              BNDSRVPGM(&LI/BASICS1) +         *
      *                              BNDDIR(QC2LE) +                  *
      *                              TGTRLS(*CURRENT) +               *
      *                              DETAIL(*BASIC);                  *
      *                                                               *
      *   >>END-PRE-COMPILER<<                                        *
      *===============================================================*
     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DECEDIT('0,') DATEDIT(*DMY.)
     H DATFMT(*ISO )  TIMFMT(*ISO )
     H EXPROPTS(*RESDECPOS)
     H EXTBININT(*YES)
      *===============================================================*
      *
      * ------------------------------------
      *  Type Definitions
      * ------------------------------------
      *
     D hList_t         DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  extType                            like(BasicList_type_t  )
     D  memSize                      10U 0
     D  numE                         10U 0
     D  maxNumE                      10U 0
     D  totalMemSize                 10U 0
     D  increment                    10U 0
      /IF NOT DEFINED(*V5R2M0)
     D  signature                          like(signature_t)
     D  sortSignature                      like(signature_t)
      /ELSE
     D  signature                          likeds(signature_t)
     D  sortSignature                      likeds(signature_t)
      /ENDIF
     D  pBase                          *
     D  pAutoSortFnc                   *   procptr
      *
    * *signature_t     DS                  qualified   based(pDummy)   align
    * * tmStmp                         Z
    * * counter                      10U 0
      *
     D signature_t     DS                  qualified   based(pDummy)
     D  time                         10U 0
     D  millitm                      10U 0
     D  counter                      10U 0
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Global Fields
      * ------------------------------------
      *
      * ------------------------------------
      *  Global Constants
      * ------------------------------------
     D cTYPE_TEST...
     D                 C                   const('*TEST')
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_RA_03')
      *
     D main...
     D                 PR
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main();

         *inlr = *on;

         return;

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
      *
     D main...
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0                            inz
     D numE            S             10I 0                            inz
     D hList           S                   like(BasicList_handle_t )  inz
     D hClonedList     S                   like(BasicList_handle_t )  inz
     D anArray         DS                  dim(10)   qualified
     D  data                               like(aString      )        inz
     D aString         S             32A   varying                    inz
     D aString2        S             32A   varying                    inz
      *
     D handle1         DS                  likeds(hList_t ) based(hList       )
     D handle2         DS                  likeds(hList_t ) based(hClonedList )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Initialize Array
         anArray( 1).data = 'Donald Duck';
         anArray( 2).data = 'Dagobert Duck';
         anArray( 3).data = 'Tick';
         anArray( 4).data = 'Trick';
         anArray( 5).data = 'Track';
         anArray( 6).data = 'Daisy';
         anArray( 7).data = 'Klaas Klever';
         anArray( 8).data = 'Daniel Düsentrieb';
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

      /END-FREE
      *
     P main...
     P                 E
      *
