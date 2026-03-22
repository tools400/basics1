**FREE
//===============================================================*
//    CALL PGM(TEST_RD_01)                                       *
//===============================================================*
//   >>PRE-COMPILER<<                                            *
//                                                               *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                *
//                              SRCFILE(&SL/&SF) +               *
//                              SRCMBR(&SM);                     *
//                                                               *
//     >>COMPILE<<                                               *
//       >>PARM<< TRUNCNBR(*NO);                                 *
//       >>PARM<< DBGVIEW(*LIST);                                *
//       >>PARM<< TGTRLS(*CURRENT);                              *
//     >>END-COMPILE<<                                           *
//                                                               *
//     >>EXECUTE<<                                               *
//                                                               *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                   *
//                              MODULE(&LI/&OB) +                *
//                              ACTGRP(*NEW) +                   *
//                              BNDSRVPGM(&LI/BASICS1) +         *
//                              TGTRLS(*CURRENT) +               *
//                              DETAIL(*BASIC);                  *
//                                                               *
//   >>END-PRE-COMPILER<<                                        *
//===============================================================*
ctl-opt DEBUG OPTION(*SRCSTMT : *NODEBUGIO);
ctl-opt DECEDIT('0,') DATEDIT(*DMY.);
ctl-opt DATFMT(*ISO )  TIMFMT(*ISO );
ctl-opt EXPROPTS(*RESDECPOS);
ctl-opt EXTBININT(*YES);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT
       extpgm('TEST_RD_01');
end-pr;

dcl-pr main;
end-pr;

//  Sends a message to QCMD
dcl-pr sndMsg;
  i_text          varchar(128) value;
  i_doSendToExt   ind VALUE  options(*nopass);
end-pr;

//===============================================================*
//  Program Entry Point
//===============================================================*

dcl-pi PGM_ENTRY_POINT;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main();

*inlr = *on;

return;


//===============================================================*
//  Sends a message to the caller.
//===============================================================*
dcl-proc sndMsg;

dcl-pi sndMsg;
  i_text          varchar(128) value;
  i_doSendToExt   ind VALUE  options(*nopass);
end-pi;

//  Return value
dcl-s pBuffer         pointer inz;

//  Local fields
dcl-s msgKey          char(4) inz;

dcl-ds qMsgF qualified            inz;
  name            char(10);
  lib             char(10);
end-ds;

dcl-ds errCode qualified            inz;
  bytPrv          int(10);
  bytAvl          int(10);
  excID           char(7);
  reserved        char(1);
  excDta          char(256);
end-ds;

//  Send Program Message (QMHSNDPM) API
dcl-pr QMHSNDPM        extpgm('QMHSNDPM');
  i_msgID         char(7) const;
  i_qMsgF         char(20) const;
  i_msgData       char(32767) const  options(*varsize );
  i_length        int(10) const;
  i_msgType       char(10) const;
  i_callStkE      char(32767) const  options(*varsize );
  i_callStkC      int(10) const;
  o_msgKey        char(4);
  io_ErrCode      char(32767) options(*varsize );
  i_lenStkE       int(10) const  options(*nopass  );                     // | optGrp 1
  i_callStkEQ     char(20) const  options(*nopass  );                    // |
  i_wait          int(10) const  options(*nopass  );                     // |
  i_callStkEDT    char(10) const  options(*nopass  );                    // | optGrp 2
  i_ccsid         int(10) const  options(*nopass  );                     // |
end-pr;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


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


end-proc sndMsg;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;

dcl-pi main;
end-pi;

//  Helper fields
dcl-ds msg likeds(msg_t     ) inz;

dcl-s isSet           ind inz(cFalse);
dcl-s isOK            ind inz(cFalse);
dcl-s rc              int(10) inz;
dcl-s url             like(url_t );
dcl-s stringUrl       like(url_t );
dcl-s integer         int(10) inz;
dcl-s string          varchar(512) inz;
dcl-s file            char(10) inz;
dcl-s lib             char(10) inz;
dcl-s mbr             char(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc main;

