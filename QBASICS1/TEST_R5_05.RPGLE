**free
//===============================================================*
//  CALL PGM(TEST_R5_05)                                         *
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
ctl-opt debug option(*srcstmt: *nodebugio);
ctl-opt decedit('0,') datedit(*DMY.);
ctl-opt datfmt(*iso) timfmt(*iso);
ctl-opt expropts(*resdecpos);
ctl-opt extbinint(*yes);
//===============================================================*

// ------------------------------------
//  Type Definitions
// ------------------------------------

// ------------------------------------
//  External Prototypes
// ------------------------------------
/copy QBASICS1,PBASICS1

// ------------------------------------
//  Global Fields
// ------------------------------------

// ------------------------------------
//  Global Constants
// ------------------------------------

// ------------------------------------
//  Prototypes
// ------------------------------------

dcl-pr PGM_ENTRY_POINT extpgm('TEST_R5_05');
end-pr;

dcl-pr main;
end-pr;

dcl-pr kill extproc('kill');
  i_text varchar(128) value;
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
//  Kills the program.
//===============================================================*
dcl-proc kill;
  dcl-pi *n;
    i_text varchar(128) value;
  end-pi;

  //  Return value
  dcl-s pBuffer pointer inz;

  //  Local fields
  dcl-s msgKey char(4) inz;

  dcl-ds qMsgF qualified inz;
    name char(10);
    lib  char(10);
  end-ds;

  dcl-ds errCode qualified inz;
    bytPrv   int(10);
    bytAvl   int(10);
    excID    char(7);
    reserved char(1);
    excDta   char(256);
  end-ds;

  //  Send Program Message (QMHSNDPM) API
  dcl-pr QMHSNDPM extpgm('QMHSNDPM');
    i_msgID      char(7) const;
    i_qMsgF      char(20) const;
    i_msgData    char(32767) options(*varsize) const;
    i_length     int(10) const;
    i_msgType    char(10) const;
    i_callStkE   char(32767) options(*varsize) const;
    i_callStkC   int(10) const;
    o_msgKey     char(4);
    io_ErrCode   char(32767) options(*varsize);
    i_lenStkE    int(10) options(*nopass) const;
    i_callStkEQ  char(20) options(*nopass) const;
    i_wait       int(10) options(*nopass) const;
    i_callStkEDT char(10) options(*nopass) const;
    i_ccsid      int(10) options(*nopass) const;
  end-pr;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  clear qMsgF;
  qMsgF.name = 'QCPFMSG';
  qMsgF.lib  = '*LIBL';

  clear errCode;
  errCode.bytPrv = %size(errCode);

  QMHSNDPM('CPF9897': qMsgF: i_text: %len(i_text): '*ESCAPE'
           : '*CTLBDY': 1
           : msgKey: errCode);

  return;

end-proc;

//===============================================================*
//  Main procedure
//===============================================================*
dcl-proc main;
  dcl-pi *n;
  end-pi;

  //  Helper fields
  dcl-ds qQSYSObj likeds(qQSYSObj_t) inz;
  dcl-ds qFile likeds(qFile_t) inz;
  dcl-ds qObj likeds(qObj_t) inz;
  dcl-ds qQSYSObj2 likeds(qQSYSObj_t) inz;
  dcl-s library char(10);
  dcl-s object char(10);
  dcl-s member char(10);
  dcl-s path varchar(5000);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  qQSYSObj.name = 'QBASICS1';
  qQSYSObj.lib = 'QGPL';
  qQSYSObj.mbr = 'PBASICS1';
  qQSYSObj.type = '*FILE';

  path = f_cvtQSYSObjNameToPath(qQSYSObj);
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
    kill('Error with qQSYSObj (*FILE)');
  endif;

  qQSYSObj.name = 'QMHSNDPM';
  qQSYSObj.lib = 'QSYS';
  qQSYSObj.mbr = '';
  qQSYSObj.type = '*PGM';

  path = f_cvtQSYSObjNameToPath(qQSYSObj);
  if (path <> '/QSYS.LIB/QMHSNDPM.PGM');
    kill('Error with qQSYSObj (*PGM)');
  endif;

  qQSYSObj.name = 'BASICS1';
  qQSYSObj.lib = 'UBMSYS';
  qQSYSObj.mbr = '';
  qQSYSObj.type = '*SRVPGM';

  path = f_cvtQSYSObjNameToPath(qQSYSObj);
  if (path <> '/QSYS.LIB/UBMSYS.LIB/BASICS1.SRVPGM');
    kill('Error with qQSYSObj (*SRVPGM)');
  endif;

  qFile.name = 'QBASICS1';
  qFile.lib = 'QGPL';
  qFile.mbr = 'PBASICS1';

  qObj.name = 'QBASICS1';
  qObj.lib = 'QGPL';

  object = 'QBASICS1';
  library = 'QGPL';
  member = 'PBASICS1';

  path = f_cvtQSYSObjNameToPath(qFile);
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
    kill('Error with qFile');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> object or
      qQSYSObj2.lib <> library or
      qQSYSObj2.mbr <> member or
      qQSYSObj2.type <> '*FILE');
    kill('Error with qQSYSObj2 from qFile');
  endif;

  path = f_cvtQSYSObjNameToPath(qFile: '*FILE');
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
    kill('Error with qFile and object type *FILE');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> object or
      qQSYSObj2.lib <> library or
      qQSYSObj2.mbr <> member or
      qQSYSObj2.type <> '*FILE');
    kill('Error with qQSYSObj2 from qFile');
  endif;

  monitor;
    path = f_cvtQSYSObjNameToPath(qFile: '*PGM');
    kill('Error with qFile and object type *PGM');
  on-error;
  // Exception seen
  endmon;

  path = f_cvtQSYSObjNameToPath(qObj: '*DTAARA');
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.DTAARA');
    kill('Error with qObj and object type *DTAARA');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> object or
      qQSYSObj2.lib <> library or
      qQSYSObj2.mbr <> '' or
      qQSYSObj2.type <> '*DTAARA');
    kill('Error with qQSYSObj2 from qObj and object type *DTAARA');
  endif;

  path = f_cvtQSYSObjNameToPath(library: '*LIB');
  if (path <> '/QSYS.LIB/QGPL.LIB');
    kill('Error with library and object type *LIB');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> library or
      qQSYSObj2.lib <> '' or
      qQSYSObj2.mbr <> '' or
      qQSYSObj2.type <> '*LIB');
    kill('Error with qQSYSObj2 from library and object type *LIB');
  endif;

  path = f_cvtQSYSObjNameToPath(object: '*OUTQ');
  if (path <> '/QSYS.LIB/%LIBL%.LIB/QBASICS1.OUTQ');
    kill('Error with object and object type *OUTQ');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> object or
      qQSYSObj2.lib <> '*LIBL' or
      qQSYSObj2.mbr <> '' or
      qQSYSObj2.type <> '*OUTQ');
    kill('Error with qQSYSObj2 from object and object type *OUTQ');
  endif;

  path = f_cvtQSYSObjNameToPath(object: library: '*MSGQ');
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.MSGQ');
    kill('Error with object/library and object type *MSGQ');
  endif;

  qQSYSObj2 = f_cvtPathToQSYSObjName(path);
  if (qQSYSObj2.name <> object or
      qQSYSObj2.lib <> library or
      qQSYSObj2.mbr <> '' or
      qQSYSObj2.type <> '*MSGQ');
    kill('Error with qQSYSObj2 from object, library and +
          object type *MSGQ');
  endif;

  path = f_cvtQSYSObjNameToPath(object: library: member: '*FILE');
  if (path <> '/QSYS.LIB/QGPL.LIB/QBASICS1.FILE/PBASICS1.MBR');
    kill('Error with object/library/member and object type *FILE');
  endif;

  monitor;
    path = f_cvtQSYSObjNameToPath(object: library: member: '*PGM');
    kill('Error with qFile and object type *PGM');
  on-error;
  // Exception seen
  endmon;

  return;


end-proc main;
