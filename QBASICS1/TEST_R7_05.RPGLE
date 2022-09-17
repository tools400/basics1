      *===============================================================*
      *    CALL PGM(TEST_R7_05) PARM('Hello World')                   *
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
     D                 PR                         extpgm('TEST_R7_05')
     D  gi_string                    32A   const  options(*nopass)
      *
     D main...
     D                 PR
     D  i_string                     32A   const  varying
      *
      *===============================================================*
      *  Program Entry Point
      *===============================================================*
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_string                    32A   const  options(*nopass)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= %parmNum(gi_string));
            main(%trimR(gi_string));
         else;
            main('Hello World!');
         endif;

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
     D  i_string                     32A   const  varying
      *
      *  Helper fields
     D buffer          S             64A                      inz
     D sha1AsHex       DS                  likeds(sha1_t    ) inz
     D sha1AsString    DS                  likeds(sha1_t    ) inz
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Generate a hexadecimal SHA-1.
         // Note: Parameters 'cSHA1_HEX' and 'length'
         //       are optional. Default is 'cSHA1_HEX'.
         sha1AsHex = f_genSHA1(i_string: cSHA1_HEX);

         msg = f_newMsg(cMSG_ID_NONE:
                        'SHA-1 as ' + %char(sha1AsHex.length) +
                        '-byte hex value: ' + sha1AsHex.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Generate a string SHA-1.
         sha1AsString = f_genSHA1(i_string: cSHA1_STRING);

         msg = f_newMsg(cMSG_ID_NONE:
                        'SHA-1 as ' + %char(sha1AsString.length) +
                        '-byte string value: ' + sha1AsString.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Generate a string SHA-1 from a buffer.
         buffer      = i_string;
         sha1AsString = f_genSHA1(%addr(buffer): cSHA1_STRING: %len(i_string));

         msg = f_newMsg(cMSG_ID_NONE:
                        'SHA-1 as ' + %char(sha1AsString.length) +
                        '-byte string value: ' + sha1AsString.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
