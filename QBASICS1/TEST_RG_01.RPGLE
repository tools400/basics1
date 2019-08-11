      *===============================================================*
      *    CALL PGM(TEST_RG_01)                                       *
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
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,PBASICS1
      *
      * ------------------------------------
      *  Prototypes
      * ------------------------------------
      *
     D PGM_ENTRY_POINT...
     D                 PR                         extpgm('TEST_RA_01')
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

      /END-FREE
      *
      *===============================================================*
      *  Main procedure
      *===============================================================*
     P main...
     P                 B
     D                 PI
      *
      *  Helper fields
     D x               S             10I 0 inz
     D hProperties     S                   like(BasicProperties_handle_t) inz
      *
     D bValue          S               N
     D dValue          S                   like(BasicProperties_decVal_t)
     D iValue          S             10I 0
     D sValue          S           4096A   varying
      *
     D size            S             10I 0
     D rc              S             10I 0
     D hKeySet         S                   like(BasicKeySet_handle_t)
     D keys            S            100A   varying dim(4)
     D i               S             10I 0
     D count           S             10I 0
      *
     D BOOLEAN         C                   '*BOOLEAN'
     D DECIMAL         C                   '*DECIMAL'
     D INTEGER         C                   '*INTEGER'
     D STRING          C                   '*STRING'
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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
           if (key(i) <> '');
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

      /END-FREE
     P                 E
      *
