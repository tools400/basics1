      *=====================================================================*
      *  BASICS1R6  - SrvPgm: Basic Routines - Commands                     *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  08.10.2003                                              *
      *  E-mail  :  thomas.raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  10.10.2006  Th.Raddatz    Changed f_getEnvVarByIndex to respect    *
      *                            the length of the environment variable.  *
      *                                                                     *
      *  18.12.2007  Th.Raddatz    Changed f_execute() to receive an error  *
      *                            message directly rather that trying to   *
      *                            get it from the errorCode parameter.     *
      *                                                                     *
      *  05.02.2009  Th.Raddatz    Added p_wait() procedure.                *
      *                                                                     *
      *  24.03.2009  Th.Raddatz    Added prompter action support to         *
      *                            f_execute().                             *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R6
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      *  len(envVarBuf) = len(name(128)) + len(value(1024)) + len(null-byte(1))
     D envVarBuf_t     S           1153A   based(pDummy)
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Initialize Environment for Variables
     D lf_initEnv...
     D                 PR            10I 0
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Executes a CL command.
      *=========================================================================
      *  Parameters:
      *   i_cmd         - The CL command to execute.
      *   i_typeCmdPrc  - The type of command processing.
      *                   Default:        cCMD_PRC_EXC_QCMDEXC
      *   o_msg         - The API error message.
      *
      *  Returns:
      *   isExecuted    - Returns cTrue when the command was executed
      *                   successfully.
      *=========================================================================
      *
     P f_execute...
     P                 B                   export
      *
     D f_execute...
     D                 PI              N   opdesc
     D  i_cmd                     16384A   const  options(*varsize)
     D  i_typeCmdPrc                 10I 0 const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D isExecuted      S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_cmd           C                   const(1)
     D p_typeCmdPrc    C                   const(2)
     D p_msg           C                   const(3)
      *
      *  Optional parameter fields
     D typeCmdPrc      S                   like(i_typeCmdPrc) inz
     D msg             DS                  likeds(o_msg     ) inz
      *
      *  Helper fields CEEGSI
     D si_cmd          DS                  likeds(strInf_t  ) inz
      *
      *  Helper fields QCAPCMD
     D optCtrlBlk      DS                  qualified
     D  typeCmdPrc             1      4I 0 inz(0)                               QCMDEXC
     D  DBCS_data              5      5A   inz('0')                             ignore DBCS
     D  prmtAction             6      6A   inz('0')                             never prompt
     D  cmdStrSyntax           7      7A   inz('0')                             AS/400 Syntax
     D  msgRtvKey              8     11A   inz(*BLANKS)                         no msg key
     D  res_01                12     20A   inz(*ALLx'00')
      *
     D chgCmd          S            128A   inz
     D chgCmdBytAvl    S             10I 0 inz
      *
     D errCode         DS                  likeds(errCode_t ) inz
      *
      *  Helper fields CEETSTA
     D isPresent       S             10I 0 inz
      *
      *  Helper fields
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_execute...
     P                 E
      *
      *=========================================================================
      *  Gets an environment variable.
      *=========================================================================
      *  Parameters:
      *   i_envVar      - Name of environment variable to read.
      *
      *  Returns:
      *   value         - Returns the value of the environment variable.
      *=========================================================================
      *
     P f_getEnvVar...
     P                 B                   export
      *
     D f_getEnvVar...
     D                 PI          1024A          varying
     D  i_pEnvVar                      *   const  options(*string)
      *
      *  Return value
     D value           S           1024A   varying   inz
      *
      *  Helper fields
     D pValue          S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pValue = getenv(i_pEnvVar);

         if   pValue <> *NULL;
            value = %str(pValue);
         else;
            value = '';
         endif;

         return   value;

      /END-FREE
      *
     P f_getEnvVar...
     P                 E
      *
      *=========================================================================
      *  Sets an environment variable.
      *=========================================================================
      *  Parameters:
      *   i_envVar      - Name of environment variable to read.
      *   i_value       - Value of the environment variable.
      *
      *  Returns:
      *   isSet         - Returns cTrue when the variable was set
      *                   successfully.
      *=========================================================================
      *
     P f_setEnvVar...
     P                 B                   export
      *
     D f_setEnvVar...
     D                 PI              N
     D  i_envVar                           const  like(envVar_t.name )
     D  i_value                            const  like(envVar_t.value)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Helper fields
     D envVarBuf       S                   like(envVarBuf_t) inz
     D rc              S             10I 0                   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         envVarBuf = i_envVar + '=' + i_value + x'00';
         rc = putenv(%addr(envVarBuf));

         if   rc = 0;
            isSet = cTrue;
         else;
            isSet = cFalse;
         endif;

         return   isSet;

      /END-FREE
      *
     P f_setEnvVar...
     P                 E
      *
      *=========================================================================
      *  Deletes a given environment variable.
      *=========================================================================
      *  Parameters:
      *   i_envVar      - Name of given environment variable to delete.
      *
      *  Returns:
      *   value         - Returns the value of the environment variable.
      *=========================================================================
      *
     P f_delEnvVar...
     P                 B                   export
      *
     D f_delEnvVar...
     D                 PI              N
     D  i_pEnvVar                      *   const  options(*string)
      *
      *  Return value
     D isDeleted       S               N   inz(cFalse)
      *
      *  Helper fields
     D rc              S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         rc = Qp0zDltEnv(i_pEnvVar);

         if   rc = 0;
            isDeleted = cTrue;
         else;
            isDeleted = cFalse;
         endif;

         return   isDeleted;

      /END-FREE
      *
     P f_delEnvVar...
     P                 E
      *
      *=========================================================================
      *  Gets the number of environment variables.
      *=========================================================================
      *  Parameters:
      *
      *  Returns:
      *   numEnvVar     - Returns the number of environment variables
      *                   on success, else -1.
      *=========================================================================
      *
     P f_getNumEnvVar...
     P                 B                   export
      *
     D f_getNumEnvVar...
     D                 PI            10I 0
      *
      *  Return value
     D numEnvVar       S             10I 0 inz
      *
      *  Helper fields
     D ppEnvVar        S               *   based(pEnvVar)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_getNumEnvVar...
     P                 E
      *
      *=========================================================================
      *  Gets an environment variable by its index.
      *=========================================================================
      *  Parameters:
      *   i_index       - Index of the environment variable.
      *
      *  Returns:
      *   envVar        - Returns an envVar structure.
      *                   envVar.name is blanks if the environment variable
      *                   does not exist.
      *=========================================================================
      *
     P f_getEnvVarByIndex...
     P                 B                   export
      *
     D f_getEnvVarByIndex...
     D                 PI                         likeds(envVar_t )
     D  i_index                      10I 0 const
      *
      *  Return value
     D envVar          DS                  likeds(envVar_t ) inz
      *
      *  Helper fields
     D index           S                   like(i_index    ) inz
     D ppEnvVar        S               *   based(pEnvVar)
     D length          S             10I 0                   inz
      *
      *  len(envVarBuf) = len(name(128)) + len(value(1024)) + len(null-byte(1))
     D envVarBuf       S                   like(envVarBuf_t) inz
     D x               S             10I 0                   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P f_getEnvVarByIndex...
     P                 E
      *
      *=========================================================================
      *  Waits for the specified number of seconds.
      *=========================================================================
      *  Parameters:
      *   i_seconds     - Number of seconds to wait.
      *
      *  Returns:
      *   void
      *=========================================================================
      *
     P p_wait...
     P                 B                   export
      *
     D p_wait...
     D                 PI
     D  i_seconds                    10I 0 const
      *
      *  Helper fields
     D mi_time         S              8A   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         mitime(mi_time: 0: 0: i_seconds: 0);

         waittime(mi_time: cWAIT_NORMAL + cWAIT_SIGNALS);

         return;

      /END-FREE
      *
     P p_wait...
     P                 E
      *
      *=========================================================================
    R *  *** PRIVATE ***
      *  Initialize Environment for Variables
      *=========================================================================
      *
     P lf_initEnv...
     P                 B
      *
     D lf_initEnv...
     D                 PI            10I 0
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isInit          S               N   inz(cFalse) static
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if not isInit;
            rc = Qp0zInitEnv();
            if rc = 0;
               isInit = cTrue;
            endif;
         else;
            rc = 0;
         endif;

         return   rc;

      /END-FREE
      *
     P lf_initEnv...
     P                 E
      *
