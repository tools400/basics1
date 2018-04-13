      *===============================================================*
      *    CALL PGM(TEST_RC_05)                                       *
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
     D key_t           S            256A   varying                 based(pDummy)
     D value_t...
     D                 DS                  qualified               based(pDummy)
     D  seq                          10I 0
     D  data                         32A   varying
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
     D                 PR                         extpgm('TEST_RC_05')
      *
     D main...
     D                 PR
      *
      *  Comparator for comparing to 'key' values.
     D compareKeys...
     D                 PR            10I 0 extproc('compareKeys')
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
      *  Comparator for comparing to 'value' structures.
     D compareValues...
     D                 PR            10I 0 extproc('compareValues')
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
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
      *  Comparator for comparing to 'key' values.
      *===============================================================*
     P compareKeys...
     P                 B
      *
     D compareKeys...
     D                 PI            10I 0
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
     D rc              S             10I 0 inz
     D key             S                   like(key_t     ) based(i_pKeyData )
     D elem            S                   like(key_t     ) based(i_pElemData)
     D null            S                   like(key_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P compareKeys...
     P                 E
      *
      *===============================================================*
      *  Comparator for comparing to 'value' structures.
      *===============================================================*
     P compareValues...
     P                 B
      *
     D compareValues...
     D                 PI            10I 0
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
     D rc              S             10I 0 inz
     D key             DS                  likeds(value_t ) based(i_pKeyData )
     D elem            DS                  likeds(value_t ) based(i_pElemData)
     D null            DS                  likeds(value_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P compareValues...
     P                 E
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
     D x               S             10I 0 inz
     D lastKey         S             10I 0 inz
     D lastSeq         S             10I 0 inz
     D hMap            S                   like(BasicMap_handle_t  ) inz
     D key             S                   like(key_t     ) inz
     D value           DS                  likeds(value_t ) inz
     D hKeys           S                   like(BasicList_handle_t ) inz
     D hValues         S                   like(BasicList_handle_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P main...
     P                 E
      *
