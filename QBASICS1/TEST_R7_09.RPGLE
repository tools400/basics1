      *===============================================================*
      *    CALL PGM(TEST_R7_09) PARM('Hello World.txt')               *
      *    CALL PGM(TEST_R7_09) PARM('20050731-019-i32.exe')          *
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
     D                 PR                         extpgm('TEST_R7_09')
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
     D crc32Options    S              5U 0                    inz
     D hFile           S             10I 0                    inz
     D inBuff          DS                  qualified
     D  size                         10U 0                    inz
     D  value                      8192A                      inz
     D bytesLeft       S             10U 0                    inz
     D crc32           DS                  likeds(crc32_t   ) inz
     D st_stat         DS                  likeds(st_stat_t ) inz
     D msg             DS                  likeds(msg_t     ) inz
     D elapsedTime     DS                  qualified
     D  start                          Z   inz
     D  end                            Z   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Generate a CRC32 checksum of a given stream file:

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

         elapsedTime.start = %timestamp();

         // Read 1. chunk of data
         inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));

         is1Call = cTrue;   // First call to f_genCRC32

         dow inBuff.size > 0;

            // Set CRC32 options
            if is1Call;
               if inBuff.size < bytesLeft;
                  crc32Options = cCRC32_FIRST;
               else;
                  crc32Options = cCRC32_ONLY;
               endif;
               is1Call = cFalse;
            else;
               if inBuff.size < bytesLeft;
                  crc32Options = cCRC32_MIDDLE;
               else;
                  crc32Options = cCRC32_FINAL;
               endif;
            endif;

            // Call CRC32 generation
            crc32 = f_genCRC32(%addr(inBuff.value): crc32Options: inBuff.size);

            // Decrease number of bytes left
            bytesLeft = bytesLeft - inBuff.size;

            // Read next chunk of data
            inBuff.size = read(hFile: %addr(inBuff.value): %size(inBuff.value));
         enddo;

         // Close stream file
         callp close(hFile);

         elapsedTime.end   = %timestamp();

         msg = f_newMsg(cMSG_ID_NONE:
                        'CRC32 as ' + %char(crc32.length) +
                        '-byte string value: ' + %trimR(crc32.value) +
                        ' Elapsed time: ' +
                            %char(%diff(elapsedTime.end:
                                        elapsedTime.start: *mseconds)));
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
