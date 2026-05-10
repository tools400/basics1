**free
// ==========================================================================
//  RUCALLTST TSTPGM(TEST_R3_15)
// ==========================================================================
// >>PRE-COMPILER<<
//   >>CRTCMD<<  RUCRTRPG TSTPGM(&LI/&OB) SRCFILE(&SL/&SF) SRCMBR(&SM);
//   >>IMPORTANT<<
//     >>PARM<<  BNDSRVPGM(*LIBL/BASICS1);
//     >>PARM<<  COPTION(*EVENTF);
//   >>END-IMPORTANT<<
//   >>EXECUTE<<
// >>END-PRE-COMPILER<<
// ==========================================================================
ctl-opt nomain option(*srcstmt: *nodebugio);

/include qbasics1,pbasics1
/include qinclude,testcase

dcl-proc testStartsWith export;
  dcl-pi *n;
  end-pi;
  assert(f_startsWith('': 'DEMO01')
         : '''DEMO01'' starts with an empty prefix.');
  assert(not f_startsWith('Prefix': '')
         : 'An empty string does not start with ''Prefix''');
  assert(not f_startsWith('DEMO01A': 'DEMO01')
         : '''DEMO01'' does not start with ''DEMO01A''');
  assert(f_startsWith('DEMO01': 'DEMO01A')
         : '''DEMO01A'' does start with ''DEMO01''');
end-proc;

dcl-proc testEndsWith export;
  dcl-pi *n;
  end-pi;
  assert(f_endsWith('': 'DEMO01')
         : '''DEMO01'' ends with an empty suffix.');
  assert(not f_endsWith('Suffix': '')
         : 'An empty string does not end with ''Suffix''');
  assert(not f_endsWith('DEMO01A': 'DEMO01')
         : '''DEMO01'' does not end with ''DEMO01A''');
  assert(f_endsWith('01': 'DEMO01')
         : '''DEMO01'' does end with ''01''');
end-proc;
