      *===============================================================*
      *    CALL PGM(TEST_RC_01)                                       *
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
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_RC_01')
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
     D x               S             10I 0                           inz
     D y               S             10I 0                           inz
     D hMap            S                   like(BasicMap_handle_t  ) inz
     D nbrOfElm        S             10I 0                      inz
     D aSize           S             10I 0                      inz
     D aField          S           3000A                             inz
     D aPointer        S               *                             inz
     D isFound         S               N                             inz
     D anArray         DS                  dim(10)   qualified
     D  size                               like(aSize        )       inz
     D  trimSize                           like(aSize        )       inz
     D  data                               like(aField       )       inz
      *
     D msg             DS                  likeds(msg_t      )  inz
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

         // Set size of trimmed field data
         for x = 1 to %elem(anArray);
            anArray(x).size     = %len(anArray(x).data);
            anArray(x).trimSize = %len(%trimR(anArray(x).data));
            p_assert(anArray(x).size <> anArray(x).trimSize                                 //RADDAT
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
         endfor;

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

      /END-FREE
      *
     P main...
     P                 E
      *
