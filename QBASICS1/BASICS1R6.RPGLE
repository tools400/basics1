**free
//=====================================================================*
//  BASICS1R6  - SrvPgm: Basic Routines - Commands                     *
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
//  10.10.2006  Th.Raddatz    Changed f_getEnvVarByIndex to respect    *
//                            the length of the environment variable.  *
//                                                                     *
//  18.12.2007  Th.Raddatz    Changed f_execute() to receive an error  *
//                            message directly rather that trying to   *
//                            get it from the errorCode parameter.     *
//                                                                     *
//  05.02.2009  Th.Raddatz    Added p_wait() procedure.                *
//                                                                     *
//  24.03.2009  Th.Raddatz    Added prompter action support to         *
//                            f_execute().                             *
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
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1R6

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

//  len(envVarBuf) = len(name(128)) + len(value(1024)) + len(null-byte(1))
dcl-s envVarBuf_t char(1153) based(pDummy);

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Initialize Environment for Variables
dcl-pr lf_initEnv int(10);
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Executes a CL command.
//=========================================================================
//  Parameters:
//   i_cmd         - The CL command to execute.
//   i_typeCmdPrc  - The type of command processing.
//                   Default:        cCMD_PRC_EXC_QCMDEXC
//   o_msg         - The API error message.
//
//  Returns:
//   isExecuted    - Returns cTrue when the command was executed
//                   successfully.
//=========================================================================

dcl-proc f_execute export;
  dcl-pi *n ind opdesc;
    i_cmd        char(16384) options(*varsize) const;
    i_typeCmdPrc int(10) options(*nopass: *omit) const;
    o_msg        likeds(msg_t) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isExecuted ind inz(cFalse);

  //  Parameter positions
  dcl-c p_cmd 1;
  dcl-c p_typeCmdPrc 2;
  dcl-c p_msg 3;

  //  Optional parameter fields
  dcl-s typeCmdPrc like(i_typeCmdPrc) inz;
  dcl-ds msg likeds(o_msg) inz;

  //  Helper fields CEEGSI
  dcl-ds si_cmd likeds(strInf_t) inz;

  //  Helper fields QCAPCMD
  dcl-ds optCtrlBlk qualified;
    typeCmdPrc   int(10) inz(0); // QCMDEXC
    DBCS_data    char(1) inz('0'); // ignore DBCS
    prmtAction   char(1) inz('0'); // never prompt
    cmdStrSyntax char(1) inz('0'); // AS/400 Syntax
    msgRtvKey    char(4) inz(*blanks); // no msg key
    res_01       char(9) inz(*ALLx'00');
  end-ds;

  dcl-s chgCmd char(128) inz;
  dcl-s chgCmdBytAvl int(10) inz;

  dcl-ds errCode likeds(errCode_t) inz;

  //  Helper fields CEETSTA
  dcl-s isPresent int(10) inz;

  //  Helper fields
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Retrieve string information of i_cmd
  CEEGSI(p_cmd: si_cmd.datatype: si_cmd.curlen: si_cmd.maxlen: *omit);

  // Process optional parameter values ...
  // ... i_typeCmdPrc
  if   %parms >= p_typeCmdPrc;
    CEETSTA(isPresent: p_typeCmdPrc: *omit);
  else;
    isPresent = 0;
  endif;

  if   isPresent = 1;
    typeCmdPrc = i_typeCmdPrc;
  else;
    typeCmdPrc = cCMD_PRC_EXC_QCMDEXC;
  endif;

  // Set options control block
  reset   optCtrlBlk;
  optCtrlBlk.typeCmdPrc = %bitand(typeCmdPrc: x'0000FFFF');

  // Set prompter action
  select;
  when (f_isBitOn(cCMD_PRC_PROMPT_HELP: typeCmdPrc));
    optCtrlBlk.prmtAction = '3';

  when (f_isBitOn(cCMD_PRC_PROMPT_ON_REQUEST: typeCmdPrc));
    optCtrlBlk.prmtAction = '2';

  when (f_isBitOn(cCMD_PRC_PROMPT_ALWAYS: typeCmdPrc));
    optCtrlBlk.prmtAction = '1';

  other;
    optCtrlBlk.prmtAction = '0';

  endsl;

  // Execute the command
  p_rmvPgmMsg(cMsg_Rmv_All);

  monitor;
    errCode = f_newApiErrCode(cFalse);
    QCAPCMD(%subst(i_cmd: 1: si_cmd.curlen) :
            si_cmd.curlen                   :
            optCtrlBlk                      :
            %size(optCtrlBlk)               :
            'CPOP0100'                      :
            chgCmd                          :
            0                               :
            chgCmdBytAvl                    :
            errCode                         );
    msg = f_newMsg(cMSG_ID_OK);
    isExecuted = cTrue;
  on-error;
    rcvm0200 = f_rcvPgmMsg(cMsg_Any);
    msg = f_cvtRcvMsgToMsg(rcvm0200: cMsg_Escape);
    isExecuted = cFalse;
  endmon;

  // Process optional/omissible message parameter
  if   %parms >= p_msg;
    CEETSTA(isPresent: p_msg: *omit);
    if   isPresent = 1;
      o_msg = msg;
    endif;
  else;
    if   msg.ID <> cMSG_ID_OK;
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return   isExecuted;


end-proc;

//=========================================================================
//  Gets an environment variable.
//=========================================================================
//  Parameters:
//   i_envVar      - Name of environment variable to read.
//
//  Returns:
//   value         - Returns the value of the environment variable.
//=========================================================================

dcl-proc f_getEnvVar export;
  dcl-pi *n varchar(1024);
    i_pEnvVar pointer options(*string) const;
  end-pi;

  //  Return value
  dcl-s value varchar(1024) inz;

  //  Helper fields
  dcl-s pValue pointer inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pValue = getenv(i_pEnvVar);

  if   pValue <> *NULL;
    value = %str(pValue);
  else;
    value = '';
  endif;

  return   value;


end-proc;

//=========================================================================
//  Sets an environment variable.
//=========================================================================
//  Parameters:
//   i_envVar      - Name of environment variable to read.
//   i_value       - Value of the environment variable.
//
//  Returns:
//   isSet         - Returns cTrue when the variable was set
//                   successfully.
//=========================================================================

dcl-proc f_setEnvVar export;
  dcl-pi *n ind;
    i_envVar like(envVar_t.name) const;
    i_value  like(envVar_t.value) const;
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Helper fields
  dcl-s envVarBuf like(envVarBuf_t) inz;
  dcl-s rc int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  envVarBuf = i_envVar + '=' + i_value + x'00';
  rc = putenv(%addr(envVarBuf));

  if   rc = 0;
    isSet = cTrue;
  else;
    isSet = cFalse;
  endif;

  return   isSet;


end-proc;

//=========================================================================
//  Deletes a given environment variable.
//=========================================================================
//  Parameters:
//   i_envVar      - Name of given environment variable to delete.
//
//  Returns:
//   value         - Returns the value of the environment variable.
//=========================================================================

dcl-proc f_delEnvVar export;
  dcl-pi *n ind;
    i_pEnvVar pointer options(*string) const;
  end-pi;

  //  Return value
  dcl-s isDeleted ind inz(cFalse);

  //  Helper fields
  dcl-s rc int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  rc = Qp0zDltEnv(i_pEnvVar);

  if   rc = 0;
    isDeleted = cTrue;
  else;
    isDeleted = cFalse;
  endif;

  return   isDeleted;


end-proc;

//=========================================================================
//  Gets the number of environment variables.
//=========================================================================
//  Parameters:
//
//  Returns:
//   numEnvVar     - Returns the number of environment variables
//                   on success, else -1.
//=========================================================================

dcl-proc f_getNumEnvVar export;
  dcl-pi *n int(10);
  end-pi;

  //  Return value
  dcl-s numEnvVar int(10) inz;

  //  Helper fields
  dcl-s ppEnvVar pointer based(pEnvVar);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if lf_initEnv() = 0;
    pEnvVar = ENVIRON;
    dow ppEnvVar <> *NULL;
      numEnvVar = numEnvVar + 1;
      pEnvVar   = pEnvVar + %size(pEnvVar);
    enddo;
  else;
    numEnvVar = -1;
  endif;

  return   numEnvVar;


end-proc;

//=========================================================================
//  Gets an environment variable by its index.
//=========================================================================
//  Parameters:
//   i_index       - Index of the environment variable.
//
//  Returns:
//   envVar        - Returns an envVar structure.
//                   envVar.name is blanks if the environment variable
//                   does not exist.
//=========================================================================

dcl-proc f_getEnvVarByIndex export;
  dcl-pi *n likeds(envVar_t);
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-ds envVar likeds(envVar_t) inz;

  //  Helper fields
  dcl-s index like(i_index) inz;
  dcl-s ppEnvVar pointer based(pEnvVar);
  dcl-s length int(10) inz;

  //  len(envVarBuf) = len(name(128)) + len(value(1024)) + len(null-byte(1))
  dcl-s envVarBuf like(envVarBuf_t) inz;
  dcl-s x int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if lf_initEnv() = 0;
    pEnvVar = ENVIRON;
    index = 0;
    dow ppEnvVar <> *NULL and index < i_index;
      index = index + 1;
      if index < i_index;
        pEnvVar   = pEnvVar + %size(pEnvVar);
      endif;
    enddo;
    clear envVar;
    if index = i_index;
      length = strlen(ppEnvVar);
      envVarBuf = %str(ppEnvVar);
      x = %scan('=': envVarBuf);
      if x > 1;
        envVar.name = %subst(envVarBuf: 1: x-1);
        if x < %len(envVarBuf);
          envVar.value = %subst(envVarBuf: x+1: length - x);
        else;
          envVar.value = '';
        endif;
      endif;
    endif;
  endif;

  return   envVar;


end-proc;

//=========================================================================
//  Waits for the specified number of seconds.
//=========================================================================
//  Parameters:
//   i_seconds     - Number of seconds to wait.
//
//  Returns:
//   void
//=========================================================================

dcl-proc p_wait export;
  dcl-pi *n;
    i_seconds int(10) const;
  end-pi;

  //  Helper fields
  dcl-s mi_time char(8) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  mitime(mi_time: 0: 0: i_seconds: 0);

  waittime(mi_time: cWAIT_NORMAL + cWAIT_SIGNALS);

  return;


end-proc;

//=========================================================================
//  *** PRIVATE ***
//  Initialize Environment for Variables
//=========================================================================

dcl-proc lf_initEnv;
  dcl-pi *n int(10);
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isInit ind inz(cFalse) static;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if not isInit;
    rc = Qp0zInitEnv();
    if rc = 0;
      isInit = cTrue;
    endif;
  else;
    rc = 0;
  endif;

  return   rc;


end-proc;