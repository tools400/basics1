      *===============================================================*
      *    CALL PGM(TEST_R7_04) PARM('Hello World')                   *
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
     D                 PR                         extpgm('TEST_R7_04')
     D  gi_string                    32A   const
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
     D  gi_string                    32A   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         main(%trimR(gi_string));

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
     D md5AsHex        DS                  likeds(md5_t     ) inz
     D md5AsString     DS                  likeds(md5_t     ) inz
     D msg             DS                  likeds(msg_t     ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Generate a hexadecimal MD5.
         // Note: Parameters 'cMD5_HEX' and 'length'
         //       are optional. Default is 'cMD5_HEX'.
         md5AsHex = f_genMD5(i_string: cMD5_HEX);

         msg = f_newMsg(cMSG_ID_NONE:
                        'MD5 as ' + %char(md5AsHex.length) +
                        '-byte hex value: ' + md5AsHex.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Generate a string MD5.
         md5AsString = f_genMD5(i_string: cMD5_STRING);

         msg = f_newMsg(cMSG_ID_NONE:
                        'MD5 as ' + %char(md5AsString.length) +
                        '-byte string value: ' + md5AsString.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         // Generate a string MD5 from a buffer.
         buffer      = i_string;
         md5AsString = f_genMD5(%addr(buffer): cMD5_STRING: %size(buffer));

         msg = f_newMsg(cMSG_ID_NONE:
                        'MD5 as ' + %char(md5AsString.length) +
                        '-byte string value: ' + md5AsString.value);
         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
