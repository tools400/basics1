      *===============================================================*
      *    CALL PGM(TEST_R3_09)                                       *
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
     D                 PR                         extpgm('TEST_R3_09')
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
     D isEqual         S               N   inz
     D string          S            128A   inz   varying
     D mask            S            128A   inz   varying
     D wildcard        S              2A   inz
     D procedure       S             20A   inz   varying
      *
     D msg             DS                  likeds(msg_t      ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // ------------------------------------------------
         // Compare strings without using wildcards
         // ------------------------------------------------
         string = 'Hello World';
         mask   = 'hello world';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         string = 'Hello World';
         mask   = 'hello world';
         isEqual = f_genStrCmpIgnCase(string: mask);
         procedure = 'f_genStrCmpIgnCase';
         exsr sndMsg;
         p_assert(isEqual);

         // ------------------------------------------------
         // Compare strings, using asterisk
         // ------------------------------------------------
         string = 'Hello World';
         mask   = 'Hello*';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = '*World';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = '*llo Worl*';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = 'He*ld';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         // ------------------------------------------------
         // Compare strings using question mark
         // ------------------------------------------------
         string = 'Hello World';
         mask   = 'Hello ?o?ld';   // That is equal to 'Hello World' ...
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = 'Hello ?o?ld?';  // ... but that is not equal to 'Hello World'
                                   //     since the mask expects another character
                                   //     right after 'World'.
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         string = 'Hello World';
         mask   = '?Hello ?o?ld';  // ... That is also not equal to 'Hello World'
                                   //     since the mask expects a character just
                                   //     before 'Hello'.
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         string = 'Hello World';
         mask   = '*Hello ?o?ld';  // ... However that is equal to 'Hello World'
                                   //     since the asterisk stands for any or
                                   //     none character.
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = 'Hello ?o?ld*';  // ... However that is also equal to 'Hello World'
                                   //     since the asterisk stands for any or
                                   //     none character.
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         // ------------------------------------------------
         // Compare strings: mask is longer than string
         // ------------------------------------------------
         string = 'Hello World';
         mask   = 'Hello World!';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         // ------------------------------------------------
         // Compare strings: string is longer than mask
         // ------------------------------------------------
         string = 'Hello World!';
         mask   = 'Hello World';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         // ------------------------------------------------
         // Now using different wildcard characters
         // Use % instead of *
         // Use _ instead of ?
         // ------------------------------------------------
         string = 'Hello World';
         mask   = '%ello Worl%';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         string = 'Hello World';
         mask   = 'Hello _or_d';
         isEqual = f_genStrCmp(string: mask);
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(not isEqual);

         // Once the different wildcard characters are passed
         // to f_genStrCmp, the strings are equal:
         string = 'Hello World';
         mask   = '%ello Worl%';
         isEqual = f_genStrCmp(string: mask: '%_');
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         string = 'Hello World';
         mask   = 'Hello _or_d';
         isEqual = f_genStrCmp(string: mask: '%_');
         procedure = 'f_genStrCmp';
         exsr sndMsg;
         p_assert(isEqual);

         // ------------------------------------------------
         // Test cases added with v1.12
         // ------------------------------------------------
         // Generic mask with asterisks and
         // multiple 'a' (first char in mask) in i_string.
         string = 'tagesAbgangSchnittstelle200904161547580098.xml';
         mask   = '*abg*';
         isEqual = f_genStrCmpIgnCase(string: mask);
         procedure = 'f_genStrCmpIgnCase';
         exsr sndMsg;
         p_assert(isEqual);

         // Multiple dots
         string = '2009-06-24-13.54.25.112000__urn_uuid_+
                   C9187B2F662BE0D2881245844464833__.png';
         mask   = '*.png';
         isEqual = f_genStrCmpIgnCase(string: mask);
         procedure = 'f_genStrCmpIgnCase';
         exsr sndMsg;
         p_assert(isEqual);

         return;

         begsr sndMsg;

         if isEqual;
            msg = f_newMsg(cMsg_ID_NONE: procedure + ': ' +
                     '''' + string + ''' and ''' + mask + ''' are equal.');
         else;
            msg = f_newMsg(cMsg_ID_NONE: procedure + ': ' +
                     '''' + string + ''' and ''' + mask + ''' are not equal.');
         endif;

         f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);

         endsr;

      /END-FREE
      *
     P main...
     P                 E
      *
