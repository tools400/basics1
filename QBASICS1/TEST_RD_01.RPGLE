      *===============================================================*
      *    CALL PGM(TEST_RD_01)                                       *
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
     D                 PR                         extpgm('TEST_RD_01')
      *
     D main...
     D                 PR
      *
      *  Sends a message to QCMD
     D sndMsg...
     D                 PR
     D  i_text                      128A   value  varying
     D  i_doSendToExt                  N   VALUE  options(*nopass)
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
      *  Sends a message to the caller.
      *===============================================================*
     P sndMsg...
     P                 B
      *
     D sndMsg...
     D                 PI
     D  i_text                      128A   value  varying
     D  i_doSendToExt                  N   VALUE  options(*nopass)
      *
      *  Return value
     D pBuffer         S               *   inz
      *
      *  Local fields
     D msgKey          S              4A                        inz
      *
     D qMsgF           DS                  qualified            inz
     D  name                         10A
     D  lib                          10A
      *
     D errCode         DS                  qualified            inz
     D  bytPrv                       10I 0
     D  bytAvl                       10I 0
     D  excID                         7A
     D  reserved                      1A
     D  excDta                      256A
      *
      *  Send Program Message (QMHSNDPM) API
     D QMHSNDPM        PR                         extpgm('QMHSNDPM')
     D   i_msgID                      7A   const
     D   i_qMsgF                     20A   const
     D   i_msgData                32767A   const  options(*varsize )
     D   i_length                    10I 0 const
     D   i_msgType                   10A   const
     D   i_callStkE               32767A   const  options(*varsize )
     D   i_callStkC                  10I 0 const
     D   o_msgKey                     4A
     D   io_ErrCode               32767A          options(*varsize )
     D   i_lenStkE                   10I 0 const  options(*nopass  )            | optGrp 1
     D   i_callStkEQ                 20A   const  options(*nopass  )            |
     D   i_wait                      10I 0 const  options(*nopass  )            |
     D   i_callStkEDT                10A   const  options(*nopass  )            | optGrp 2
     D   i_ccsid                     10I 0 const  options(*nopass  )            |
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      *
      /FREE

         clear qMsgF;
         qMsgF.name = 'QCPFMSG';
         qMsgF.lib  = '*LIBL';

         clear errCode;
         errCode.bytPrv = %size(errCode);

         if %parms() >= 2 and i_doSendToExt;
            QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                     : '*CTLBDY': 1
                     : msgKey: errCode);
         else;
            QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*INFO'
                     : '*CTLBDY': 0
                     : msgKey: errCode);
         endif;

         return;

      /END-FREE
      *
     P sndMsg...
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
     D msg             DS                  likeds(msg_t     ) inz
      *
     D isSet           S               N   inz(cFalse)
     D isOK            S               N   inz(cFalse)
     D rc              S             10I 0 inz
     D url             S                   like(url_t )
     D stringUrl       S                   like(url_t )
     D integer         S             10I 0 inz
     D string          S            512A   varying inz
     D file            S             10A   inz
     D lib             S             10A   inz
     D mbr             S             10A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Create URL
         stringUrl =
            'http://www.tools400.de:80/downloads/basics1.zip?fast=y;secure=n';

         url = Url_new(stringUrl);

         // Check string representation
         string = Url_toString(url);
         p_assert(string = stringUrl:
                  'Invalid string representation: ' + string);
         sndMsg('Url_toString(): ' + string: cTrue);

         // Check protocol
         string = Url_getProtocol(url);
         p_assert(string = 'http':
                  'Invalid protocol: ' + string + ' Expected ''http''');
         sndMsg('Url_getProtocol(): ' + string: cTrue);

         // Check host
         string = Url_getHost(url);
         p_assert(string = 'www.tools400.de':
                  'Invalid host: ' + string + ' Expected ''www.tools400.de''');
         sndMsg('Url_getHost(): ' + string: cTrue);

         // Check port
         integer = Url_getPort(url);
         p_assert(integer = 80:
                  'Invalid port: ' + %char(integer) + ' Expected ''80''');
         sndMsg('Url_getPort(): ' + %char(integer): cTrue);

         // Check path
         string = Url_getPath(url);
         p_assert(string = '/downloads/basics1.zip':
                  'Invalid path: ' + string +
                  ' Expected ''/downloads/basics1.zip''');
         sndMsg('Url_getPath(): ' + string: cTrue);

         // Check file
         string = Url_getFile(url);
         p_assert(string = '/downloads/basics1.zip?fast=y;secure=n':
                  'Invalid path: ' + string +
                  ' Expected ''/downloads/basics1.zip?fast=y;secure=n''');
         sndMsg('Url_getFile(): ' + string: cTrue);

         // Check query
         string = Url_getQuery(url);
         p_assert(string = 'fast=y;secure=n':
                  'Invalid path: ' + string +
                  ' Expected ''fast=y;secure=n''');
         sndMsg('Url_getQuery(): ' + string: cTrue);

         // Now change the URL
         // ... protocol
         isSet = Url_setProtocol(url: 'https': rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         string = Url_getProtocol(url);
         p_assert(string = 'https':
                  'Invalid protocol: ' + string + ' Expected ''https''');

         // ... host
         isSet = Url_setHost(url: 'www.tools400.com': rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         string = Url_getHost(url);
         p_assert(string = 'www.tools400.com':
                  'Invalid host: ' + string + ' Expected ''www.tools400.com''');

         // ... port
         isSet = Url_setPort(url: 8080: rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         integer = Url_getPort(url);
         p_assert(integer = 8080:
                  'Invalid port: ' + %char(integer) + ' Expected ''8080''');

         // ... path
         isSet = Url_setPath(url: '/HelloWorld.zip': rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         string = Url_getPath(url);
         p_assert(string = '/HelloWorld.zip':
                  'Invalid path: ' + string +
                  ' Expected ''/HelloWorld.zip''');
         string = Url_getQuery(url);   // Query must have remained unchanged!
         p_assert(string = 'fast=y;secure=n':
                  'Invalid path: ' + string +
                  ' Expected ''fast=y;secure=n''');

         // ... query
         isSet = Url_setQuery(url: '?blueSky=sure': rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         string = Url_getQuery(url);
         p_assert(string = 'blueSky=sure':
                  'Invalid path: ' + string +
                  ' Expected ''blueSky=sure''');

         // ... file
         isSet = Url_setFile(url: '/Holiday.zip?forever=n': rc);
         p_assert(isSet = cTrue: 'Invalid return value: ' + isSet);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         string = Url_getFile(url);
         p_assert(string = '/Holiday.zip?forever=n':
                  'Invalid path: ' + string +
                  ' Expected ''/Holiday.zip?forever=n''');

         // Test a special 'mbr' URL (FTP syntax)
         stringUrl = 'mbr:QUSRSYS/QBASICS1.A_README';

         url = Url_new(stringUrl);
         isOK = Url_getMbr(url: file: lib:mbr: rc);
         p_assert(isOK = cTrue: 'Invalid return value: ' + isOK);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         p_assert(file = 'QBASICS1':
                  'Invalid return parameter ''file'': ' + file);
         p_assert(lib  = 'QUSRSYS':
                  'Invalid return parameter ''lib'': ' + lib);
         p_assert(mbr  = 'A_README':
                  'Invalid return parameter ''mbr'': ' + mbr);

         // Test a special 'mbr' URL (Client Access syntax)
         stringUrl = 'mbr:QUSRSYS/QBASICS1(BASICS1C7)';

         url = Url_new(stringUrl);
         isOK = Url_getMbr(url: file: lib:mbr: rc);
         p_assert(isOK = cTrue: 'Invalid return value: ' + isOK);
         p_assert(rc = 0: 'Invalid return parameter: ' + %char(rc));
         p_assert(file = 'QBASICS1':
                  'Invalid return parameter ''file'': ' + file);
         p_assert(lib  = 'QUSRSYS':
                  'Invalid return parameter ''lib'': ' + lib);
         p_assert(mbr  = 'BASICS1C7':
                  'Invalid return parameter ''mbr'': ' + mbr);

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
