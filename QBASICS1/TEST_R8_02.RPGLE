      *===============================================================*
      *    CALL PGM(TEST_R8_02)                                       *
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
     D                 PR                         extpgm('TEST_R8_02')
      *
     D main...
     D                 PR
      *
      *  Show cells
     D showCells...
     D                 PR
     D  i_aMemList                     *   value
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
     D aMemList        S               *   inz
     D pTheMemCell     S               *   inz   dim(5)
     D aCellPayload    S             20A   based(pACellPayload)
      *
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create first memory cell
         pTheMemCell(1) = MEMORY_allocate(aMemList: %size(aCellPayload));
         pACellPayload = pTheMemCell(1);
         aCellPayload  = 'first cell';

         // Create second memory cell
         pTheMemCell(2) = MEMORY_allocate(aMemList: %size(aCellPayload));
         pACellPayload = pTheMemCell(2);
         aCellPayload  = 'second cell';

         // Create third memory cell
         pTheMemCell(3) = MEMORY_allocate(aMemList: %size(aCellPayload));
         pACellPayload = pTheMemCell(3);
         aCellPayload  = 'third cell';

         // Create fourth memory cell
         pTheMemCell(4) = MEMORY_allocate(aMemList: %size(aCellPayload));
         pACellPayload = pTheMemCell(4);
         aCellPayload  = 'fourth cell';

         // Create fifth memory cell
         pTheMemCell(5) = MEMORY_allocate(aMemList: %size(aCellPayload));
         pACellPayload = pTheMemCell(5);
         aCellPayload  = 'fifth cell';

         // Show cells:
         msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         showCells(aMemList);

         // Free third cell
         msg = f_newMsg(cMSG_ID_NONE: '--> Free third cell');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         MEMORY_free(aMemList: pTheMemCell(3));

         // Show cells:
         msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (4) ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         showCells(aMemList);

         // Free fith cell
         msg = f_newMsg(cMSG_ID_NONE: '--> Free fifth cell');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         MEMORY_free(aMemList: pTheMemCell(5));

         // Show cells:
         msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (3) ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         showCells(aMemList);

         // Free first cell
         msg = f_newMsg(cMSG_ID_NONE: '--> Free first cell');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         MEMORY_free(aMemList: pTheMemCell(1));

         // Show cells:
         msg = f_newMsg(cMSG_ID_NONE: '*** Start list of memory cells (2) ***');
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         showCells(aMemList);

         // Free memory
         MEMORY_freeAll(aMemList);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
      *===============================================================*
      *  Show cells
      *===============================================================*
     P showCells...
     P                 B
      *
     D showCells...
     D                 PI
     D  i_aMemList                     *   value
      *
      *  Helper fields
     D cellPayload     S             20A   based(pCellPayload)
      *
     D cell            DS                  qualified   based(pCell)
     D  pPrvCell                       *
     D  size                         10I 0
      *
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pCell = i_aMemList;

         dou pCell = *NULL;
            pCellPayload = pCell - cell.size;

            msg = f_newMsg(cMSG_ID_NONE: cellPayload);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

            pCell = cell.pPrvCell;
         enddo;

         return;

      /END-FREE
      *
     P showCells...
     P                 E
      *
