**free
//=====================================================================*
//  BASICS1R4  - SrvPgm: Basic Routines - Assert/This/Caller           *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  08.10.2003                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  12.07.2006  Th.Raddatz    Changed f_caller() and f_this() to       *
//                            return the statement ID as the next      *
//                            optional parameter.                      *
//                                                                     *
//  12.07.2006  Th.Raddatz    Changed p_assert(), f_this() and         *
//                            f_caller() to use a static buffer of     *
//                            2048 byte to receive the test message    *
//                            for better performance.                  *
//                                                                     *
//  13.06.2008  Th.Raddatz    Added parameter 'offset' to f_caller().  *
//                                                                     *
//  17.09.2022  Th.Raddatz    Changed module to use:  xalloc()         *
//                                                    xrealloc()       *
//                                                    xdealloc()       *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
// =================================================================== *

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1R4

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/define INCLUDE_INTERNAL_PROCDURES
/copy QBASICS1,PBASICS1R8
/undefine INCLUDE_INTERNAL_PROCDURES

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Global constants
// -----------------------------------------

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  RPG equivalent of the C Assert macro.
//=========================================================================
//  Parameters:
//   i_condition   - The condition that must be TRUE.
//   i_msgText     - The message text that is sent in case that
//                   i_condition is FALSE.
//                   Default:        *BLANKS
//
//  Returns:
//   void
//=========================================================================
dcl-proc p_assert export;
  dcl-pi *n;
    i_condition ind const;
    i_msgText   char(128) options(*nopass) const;
  end-pi;

  //  Make sure that the p_assert procedure is not included
  //  when the condition name COMPILE_NO_DEBUG is specified at
  //  the CRTRPGMOD command.
/if NOT DEFINED (COMPILE_NO_DEBUG)

  //  Positions of optional parameters
  dcl-c p_msgText 2;

  //  Fields for optional parameters
  dcl-s msgText like(i_msgText) inz;

  //  Local constants
  dcl-c cTEXT_MSG 'Who is before me?';

  //  Fields for sender information
  dcl-s procedure varchar(256) inz;
  dcl-s module char(10) inz;
  dcl-s program char(10) inz;
  dcl-s stmtID char(10) inz;

  //  Helper fields QMHSNDPM/QMHRCVPM
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-s msgKey char(4) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  dcl-ds callStkEQ qualified;
    module  char(10) inz;
    program char(10) inz;
  end-ds;

  //  Helper fields QMHRCVPM
  dcl-s memSize int(10) inz;
  dcl-ds sndInf likeds(sndInf_t) based(pSndInf);
  dcl-ds rcvm0300 likeds(rcvm0300_t) based(pRcvm0300);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if   not i_condition;

    // Process optional parameters
    if   %parms >= p_msgText;
      msgText = i_msgText;
    else;
      msgText = '*N';
    endif;

    // Send a test message
    clear   qMsgF;
    qMsgF.name   = 'QCPFMSG';
    qMsgF.lib    = '*LIBL';
    errCode      = f_newApiErrCode(cTrue);
    callStkEQ.module  = '*NONE';
    callStkEQ.program = '*NONE';
    qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
             '*': 1: msgKey: errCode: 1: callStkEQ: 0);

    if   not f_isApiError(errCode);
      memSize   = 2048;
      pRcvm0300 = xalloc(memSize);
      errCode   = f_newApiErrCode(cTrue);
      callStkEQ.module  = '*NONE';
      callStkEQ.program = '*NONE';
      qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
               '*': 1: '*INFO': msgKey: 0: '*REMOVE': errCode:
               1: callStkEQ);
    endif;

    // If everything worked as designed, ...
    if   not f_isApiError(errCode) and
             rcvm0300.bytAvl <= memSize;
      // ... then retrieve sender information
      pSndInf = pRcvm0300 + %size(rcvm0300)
                          + rcvm0300.lenRplDataR
                          + rcvm0300.lenMsgR
                          + rcvm0300.lenMsgHlpR;
      procedure = %trimR(sndInf.rcvProc);
      module    = sndInf.rcvModule;
      program   = sndInf.rcvPgm;
      stmtID    = sndInf.rcvPgmStmtNbr(1);
    else;
      // ... else set sender information to "not available"
      procedure = '*N';
      module    = '*N';
      program   = '*N';
      stmtID    = '*N';
    endif;

    // Create "assert" message
    msgText = %trimr(program)   + '/'  +
              %trimr(module )   + '.'  +
              %trimr(procedure) + ' (' +
              'Stmt: '                         +
              %trimr(stmtID)    + ') ' +
              ': ' + %trim(msgText);

    // Free memory
    if (pRcvm0300 <> *NULL);
      xdealloc(pRcvm0300);
    endif;

    // Send "assert" *ESCAPE message
    msgKey  = ' ';
    errCode = f_newApiErrCode(cTrue);
    callStkEQ.module  = '*NONE';
    callStkEQ.program = '*NONE';
    qmhsndpm('CPF9898': qMsgF: msgText: %size(msgText): '*ESCAPE':
             '*': 1: msgKey: errCode: 1: callStkEQ: 0);

  endif;

/endif
end-proc;

//=========================================================================
//  Returns the procedure, module and program name
//  of the current procedure.
//=========================================================================
//  Parameters:
//   o_module      - The module that contains the procedure.
//   o_program     - The program that contains the module.
//
//  Returns:
//   procedure     - The name of the procedure that called f_this.
//=========================================================================
dcl-proc f_this export;
  dcl-pi *n varchar(256);
    o_module  char(10) options(*nopass: *omit);
    o_program char(10) options(*nopass: *omit);
    o_stmtID  char(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s procedure varchar(256) inz;

  //  Positions of optional parameters
  dcl-c p_module 1;
  dcl-c p_program 2;
  dcl-c p_stmtID 3;

  //  Fields for optional parameters
  dcl-s module like(o_module) inz;
  dcl-s program like(o_program) inz;
  dcl-s stmtID like(o_stmtID) inz;

  //  Local constants
  dcl-c cTEXT_MSG 'Who is before me?';

  //  Helper fields QMHSNDPM/QMHRCVPM
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-s msgKey char(4) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  dcl-ds callStkEQ qualified;
    module  char(10) inz;
    program char(10) inz;
  end-ds;

  //  Helper fields QMHRCVPM
  dcl-s memSize int(10) inz;
  dcl-ds sndInf likeds(sndInf_t) based(pSndInf);
  dcl-ds rcvm0300 likeds(rcvm0300_t) based(pRcvm0300);

  //  Helper fields CEETSTA
  dcl-s isPresent int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Send a test message
  clear   qMsgF;
  qMsgF.name   = 'QCPFMSG';
  qMsgF.lib    = '*LIBL';
  errCode      = f_newApiErrCode(cTrue);
  callStkEQ.module  = '*NONE';
  callStkEQ.program = '*NONE';
  qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
           '*': 1: msgKey: errCode: 1: callStkEQ: 0);

  if   not f_isApiError(errCode);
    memSize   = 2048;
    pRcvm0300 = xalloc(memSize);
    errCode   = f_newApiErrCode(cTrue);
    callStkEQ.module  = '*NONE';
    callStkEQ.program = '*NONE';
    qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
             '*': 1: '*INFO': msgKey: 0: '*REMOVE': errCode:
             1: callStkEQ);
  endif;

  // If everything worked as designed, ...
  if   not f_isApiError(errCode) and
           rcvm0300.bytAvl <= memSize;
    // ... then retrieve sender information
    pSndInf = pRcvm0300 + %size(rcvm0300)
                        + rcvm0300.lenRplDataR
                        + rcvm0300.lenMsgR
                        + rcvm0300.lenMsgHlpR;
    procedure = %trimR(sndInf.rcvProc);
    module    = sndInf.rcvModule;
    program   = sndInf.rcvPgm;
    stmtID    = sndInf.rcvPgmStmtNbr(1);
  else;
    procedure = '*N';
    module    = '*N';
    program   = '*N';
    stmtID    = '*N';
  endif;

  // Free memory
  if   pRcvm0300 <> *NULL;
    xdealloc(pRcvm0300);
  endif;

  // Process optional output parameters ...
  // .. o_module
  if   %parms >= p_module;
    CEETSTA(isPresent: p_module: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_module = module;
  endif;

  // .. o_program
  if   %parms >= p_program;
    CEETSTA(isPresent: p_program: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_program = program;
  endif;

  // .. o_stmtID
  if   %parms >= p_stmtID;
    CEETSTA(isPresent: p_stmtID: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_stmtID = stmtID;
  endif;

  return   procedure;

end-proc;

//=========================================================================
//  Returns the procedure, module and program name
//  that called the current procedure.
//=========================================================================
//  Parameters:
//   o_module      - The module that contains the procedure.
//   o_program     - The program that contains the module.
//
//  Returns:
//   procedure     - The name of the caller of the procedure
//                   that called f_caller.
//=========================================================================
dcl-proc f_caller export;
  dcl-pi *n varchar(256);
    o_module  char(10) options(*nopass: *omit);
    o_program char(10) options(*nopass: *omit);
    o_stmtID  char(10) options(*nopass: *omit);
    i_offset  int(3) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s procedure varchar(256) inz;

  //  Positions of optional parameters
  dcl-c p_module 1;
  dcl-c p_program 2;
  dcl-c p_stmtID 3;
  dcl-c p_offset 4;

  //  Fields for optional parameters
  dcl-s module like(o_module) inz;
  dcl-s program like(o_program) inz;
  dcl-s stmtID like(o_stmtID) inz;
  dcl-s offset like(i_offset) inz(0);

  //  Local constants
  dcl-c cTEXT_MSG 'Who is before me?';

  //  Helper fields QMHSNDPM/QMHRCVPM
  dcl-ds qMsgF likeds(qObj_t) inz;
  dcl-s msgKey char(4) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  dcl-ds callStkEQ qualified;
    module  char(10) inz;
    program char(10) inz;
  end-ds;

  //  Helper fields QMHRCVPM
  dcl-s memSize int(10) inz;
  dcl-ds sndInf likeds(sndInf_t) based(pSndInf);
  dcl-ds rcvm0300 likeds(rcvm0300_t) based(pRcvm0300);

  //  Helper fields CEETSTA
  dcl-s isPresent int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Get optional input parameters ...
  // .. i_offset
  if (%parms() >= p_offset and %addr(i_offset) <> *NULL);
    offset = i_offset;
  endif;

  // Send a test message
  clear   qMsgF;
  qMsgF.name   = 'QCPFMSG';
  qMsgF.lib    = '*LIBL';
  errCode      = f_newApiErrCode(cTrue);
  callStkEQ.module  = '*NONE';
  callStkEQ.program = '*NONE';
  qmhsndpm('CPF9897': qMsgF: cTEXT_MSG: %size(cTEXT_MSG): '*INFO':
           '*': 2+offset: msgKey: errCode: 1: callStkEQ: 0);

  if   not f_isApiError(errCode);
    // Receive and remove test message
    memSize   = 2048;
    pRcvm0300 = xalloc(memSize);
    errCode   = f_newApiErrCode(cTrue);
    callStkEQ.module  = '*NONE';
    callStkEQ.program = '*NONE';
    qmhrcvpm(rcvm0300: memSize: 'RCVM0300':
             '*': 2+offset: '*INFO': msgKey: 0: '*REMOVE': errCode:
             1: callStkEQ);
  endif;

  // If everything worked as designed, ...
  if   not f_isApiError(errCode) and
           rcvm0300.bytAvl <= memSize;
    // ... then retrieve sender information
    pSndInf = pRcvm0300 + %size(rcvm0300)
                        + rcvm0300.lenRplDataR
                        + rcvm0300.lenMsgR
                        + rcvm0300.lenMsgHlpR;
    procedure = %trimR(sndInf.rcvProc);
    module    = sndInf.rcvModule;
    program   = sndInf.rcvPgm;
    stmtID    = sndInf.rcvPgmStmtNbr(1);
  else;
    procedure = '*N';
    module    = '*N';
    program   = '*N';
    stmtID    = '*N';
  endif;

  // Free memory
  if   pRcvm0300 <> *NULL;
    xdealloc(pRcvm0300);
  endif;

  // Process optional output parameters ...
  // .. o_module
  if   %parms >= p_module;
    CEETSTA(isPresent: p_module: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_module = module;
  endif;

  // .. o_program
  if   %parms >= p_program;
    CEETSTA(isPresent: p_program: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_program = program;
  endif;

  // .. o_stmtID
  if   %parms >= p_stmtID;
    CEETSTA(isPresent: p_stmtID: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    o_stmtID = stmtID;
  endif;

  return   procedure;

end-proc;