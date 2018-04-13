      *===============================================================*
      *    CALL PGM(TEST_R8_01)                                       *
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
     D handle1_t       DS                  qualified   based(pDummy)
     D  numE                         10I 0
     D  type                         20A
      *
     D handle2_t       DS                  qualified   based(pDummy)
     D  type                         20A
     D  numE                         10I 0
      *
      * ------------------------------------
      *  External Prototypes
      * ------------------------------------
      /COPY QBASICS1,CLIB
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
     D                 PR                         extpgm('TEST_R8_01')
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
     D aHandle1        S                   like(HANDLE_handle_t) inz
     D aHandle2        S                   like(HANDLE_handle_t) inz
     D handle1         DS                  likeds(handle1_t    ) based(pHandle1)
     D handle2         DS                  likeds(handle2_t    ) based(pHandle2)
     D msg             DS                  likeds(msg_t        ) inz
      *
      *  Constants
     D cTYPE1          C                   const('*HANDLE1')
     D cTYPE2          C                   const('*HANDLE2')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create handles
         aHandle1 = HANDLE_new(cTYPE1: %size(handle1_t));
         aHandle2 = HANDLE_new(cTYPE2: %size(handle2_t));

         // Check handle types
         if not HANDLE_isTypeOf(aHandle1: cTYPE1);
            dsply 'Invalid type of handle 1' '*EXT';
         endif;

         if not HANDLE_isTypeOf(aHandle2: cTYPE2);
            dsply 'Invalid type of handle 2' '*EXT';
         endif;

         // Change data of handle 1
         pHandle1 = HANDLE_getPointer(aHandle1);
         handle1.numE = 4;
         handle1.type = cTYPE1;

         // Change data of handle 2
         pHandle2 = HANDLE_getPointer(aHandle2);
         handle2.numE = 8;
         handle2.type = cTYPE2;

         // Change data of handle 1
         pHandle1 = HANDLE_getPointer(aHandle1);
         handle1.numE = handle1.numE * 2;
         handle1.type = cTYPE1 + cType1;

         // Change data of handle 2
         pHandle2 = HANDLE_getPointer(aHandle2);
         handle2.numE = handle2.numE * 2;
         handle2.type = cTYPE2 + cTYPE2;

         // Verify handle data
         if handle1.numE <> 8 or handle1.type <> cTYPE1 + cType1;
            dsply 'Invalid data of handle 1' '*EXT';
         endif;

         if handle2.numE <> 16 or handle2.type <> cTYPE2 + cType2;
            dsply 'Invalid data of handle 2' '*EXT';
         endif;

         // Delete handles
         HANDLE_delete(aHandle1);
         HANDLE_delete(aHandle2);

         // Create a NULL Handle
         aHandle1 = HANDLE_null();

         // Check for a NULL Handle
         if not HANDLE_isNull(aHandle1);
            dsply 'Handle is not a NULL handle' '*EXT';
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
