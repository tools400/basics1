      *===============================================================*
      *    CALL PGM(TEST_RB_01)                                       *
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
     D                 PR                         extpgm('TEST_RB_01')
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
     D hStack          S                   like(BasicStack_handle_t) inz
     D nbrOfElm        S             10I 0                      inz
     D aSize           S             10I 0                      inz
     D aField          S             20A                             inz
     D aField1         S             20A                             inz
     D aField2         S                   like(aField1      )  based(paField2)
     D aPointer        S               *                             inz
     D anArray         DS                  dim(10)   qualified
     D  size                               like(aSize        )       inz
     D  trimSize                           like(aSize        )       inz
     D  data                               like(aField1      )       inz
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
            p_assert(anArray(x).size <> anArray(x).trimSize
                     : 'Size and trimmed size must be different');
         endfor;

         // Create BasicStack
         hStack = BasicStack_new();

         // Add elements to stack
         for x = 1 to %elem(anArray);
            BasicStack_push(hStack: anArray(x).data);
         endfor;

         // Verify number of elements on stack
         nbrOfElm = BasicStack_getNumE(hStack);
         p_assert(nbrOfElm = %elem(anArray)
                  : 'Number of elements on stack does not match expected +
                     number of ' + %char(%elem(anArray)));

         // Remove elements from stack and verify element data
         for x = %elem(anArray) downto 1;
            aPointer = BasicStack_pop(hStack: %addr(aField1): %size(aField1));
            p_assert(%subst(aField1: 1: anArray(x).size) =
                     %subst(anArray(x).data : 1: anArray(x).trimSize)
                     : 'Entry data does not match');
         endfor;

         // Add elements to stack
         for x = 1 to %elem(anArray);
            BasicStack_push(hStack: anArray(x).data);
         endfor;

         // Remove elements from stack and verify element data
         // (reallocate memory for aField2)
         for x = %elem(anArray) downto 1;
            paField2 = %alloc(%size(aField2));
            aField2  = *all'=';
            aSize    = BasicStack_getSize(hStack);
            aPointer = BasicStack_pop(hStack: paField2: aSize);
            p_assert(%subst(aField2: 1: anArray(x).size) =
                     %subst(anArray(x).data : 1: anArray(x).trimSize)
                     : 'Entry data does not match');
         endfor;

         // Verify number of elements on stack
         nbrOfElm = BasicStack_getNumE(hStack);
         p_assert(nbrOfElm = 0
                  : 'Number of elements on stack does not match expected +
                     number of ' + %char(%elem(anArray)));

         // Delete stack
         BasicStack_delete(hStack);

         // Create a fresh BasicStack
         hStack = BasicStack_new();

         // Check auto-extension of stack
         aField = 'auto-extension check';
         for x = 1 to 1000;
            BasicStack_push(hStack: %addr(aField): %size(aField));
         endfor;

         x = 0;
         dow (BasicStack_getNumE(hStack) > 0);
            BasicStack_pop(hStack: %addr(aField): %size(aField));
            x = x + 1;
         enddo;

         p_assert(x = 1000
                  : 'Did not remove expected number of elements from stack');
         p_assert(BasicStack_getNumE(hStack) = 0
                  : 'Stack should have been empty');

         // Delete stack
         BasicStack_delete(hStack);

         p_assert(hStack = BasicStack_null()
                  : 'Stack handle not set to NULL');

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
