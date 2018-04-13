      *===============================================================*
      *    CALL PGM(TEST_R7_07) PARM('Hello World.txt')               *
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
     D                 PR                         extpgm('TEST_R7_07')
     D  gi_path                      32A   const
      *
     D main...
     D                 PR
     D  i_path                       32A   const  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_path                      32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(%trimR(gi_path));

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
     D  i_path                       32A   const  varying
      *
      *  Helper fields
     D is1Call         S               N                      inz(cFalse)
     D shaOptions      S              5U 0                    inz
     D hFile           S             10I 0                    inz
     D inBuff          DS                  qualified
     D  size                         10U 0                    inz
     D  value                        64A                      inz
     D bytesLeft       S             10U 0                    inz
     D shaAsString     DS                  likeds(sha1_t    ) inz
     D st_stat         DS                  likeds(st_stat_t ) inz
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Generate a string SHA-1 of a given stream file:

         // Open stream file
         hFile = open(i_path: O_RDONLY);
         if hFile = RC_ERROR;
            return;
         endif;

         // Get size of stream file
         if stat(i_path: %addr(st_stat)) = RC_ERROR;
            callp close(hFile);
            return;
         else;
            bytesLeft = st_stat.size;
         endif;

         // Read 1. chunk of data
         inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));

         is1Call = cTrue;   // First call to f_genSHA1

         dow inBuff.size > 0;

            // Set SHA-1 options
            if is1Call;
               if inBuff.size < bytesLeft;
                  shaOptions = cSHA1_FIRST;
               else;
                  shaOptions = cSHA1_ONLY;
               endif;
               is1Call = cFalse;
            else;
               if inBuff.size < bytesLeft;
                  shaOptions = cSHA1_MIDDLE;
               else;
                  shaOptions = cSHA1_FINAL;
               endif;
            endif;

            shaOptions = shaOptions + cSHA1_STRING;

            // Call SHA generation
            shaAsString = f_genSHA1(%addr(inBuff.value):shaOptions:inBuff.size);

            // Decrease number of bytes left
            bytesLeft = bytesLeft - inBuff.size;

            // Read next chunk of data
            inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));
         enddo;

         // Close stream file
         callp close(hFile);

         msg = f_newMsg(cMSG_ID_NONE:
                        'SHA-1 as ' + %char(shaAsString.length) +
                        '-byte string value: ' + shaAsString.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
