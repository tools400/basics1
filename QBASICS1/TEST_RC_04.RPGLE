      *===============================================================*
      *    CALL PGM(TEST_RC_04)                                       *
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
     D                 PR                         extpgm('TEST_RC_04')
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
     D hMap            S                   like(BasicMap_handle_t  ) inz
     D hClonedMap      S                   like(BasicMap_handle_t  ) inz
      *
     D value1          DS                  qualified
     D  key                                like(BasicMap_key_t ) inz
     D  size                         10I 0 inz
     D  pData                          *   inz
     D  string                       32A   inz
      *
     D value2          DS                  likeds(value1 ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P main...
     P                 E
      *
