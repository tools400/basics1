      /IF NOT DEFINED(BASICS1R6)
      /DEFINE BASICS1R6
      *
      *  Reference fields
      /COPY QBASICS1,FDENVVAR
      *
      *  Constants
      *  f_execute:            Refer to description of QCAPCMD API for details
     D cCMD_PRC_EXC_QCMDEXC...
     D                 C                   const(0)
     D cCMD_PRC_CHK_QCMDCHK...
     D                 C                   const(1)
     D cCMD_PRC_EXC_CMDLINE...
     D                 C                   const(2)
     D cCMD_PRC_CHK_CMDLINE...
     D                 C                   const(3)
     D cCMD_PRC_CHK_CL_STMT...
     D                 C                   const(4)
     D cCMD_PRC_CHK_SEU_CL...
     D                 C                   const(5)
     D cCMD_PRC_CHK_SEU_CMD...
     D                 C                   const(6)
     D cCMD_PRC_CHK_SEU_BND...
     D                 C                   const(7)
     D cCMD_PRC_CHK_UDO...
     D                 C                   const(8)
     D cCMD_PRC_CHK_SEU_CLLE...
     D                 C                   const(9)
      *
     D cCMD_PRC_PROMPT_NEVER...
     D                 C                   const(0)
     D cCMD_PRC_PROMPT_ALWAYS...
     D                 C                   const(x'00010000')                    65536
     D cCMD_PRC_PROMPT_ON_REQUEST...
     D                 C                   const(x'00020000')                   131072
     D cCMD_PRC_PROMPT_HELP...
     D                 C                   const(x'00040000')                   262144
      *
      *  Executes a CL command.
     D f_execute...
     D                 PR              N   opdesc
     D                                     extproc('BASICS1R6+
     D                                     _f_execute+
     D                                     ')
     D  i_cmd                     16384A   const  options(*varsize)
     D  i_typeCmdPrc                 10I 0 const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Gets an environment variable.
     D f_getEnvVar...
     D                 PR          1024A          varying
     D                                     extproc('BASICS1R6+
     D                                     _f_getEnvVar+
     D                                     ')
     D  i_pEnvVar                      *   const  options(*string)
      *
      *  Sets an environment variable.
     D f_setEnvVar...
     D                 PR              N
     D                                     extproc('BASICS1R6+
     D                                     _f_setEnvVar+
     D                                     ')
     D  i_envVar                           const  like(envVar_t.name )
     D  i_value                            const  like(envVar_t.value)
      *
      *  Deletes an environment variable.
     D f_delEnvVar...
     D                 PR              N
     D                                     extproc('BASICS1R6+
     D                                     _f_delEnvVar+
     D                                     ')
     D  i_pEnvVar                      *   const  options(*string)
      *
      *  Gets the number of environment variables.
     D f_getNumEnvVar...
     D                 PR            10I 0
     D                                     extproc('BASICS1R6+
     D                                     _f_getNumEnvVar+
     D                                     ')
      *
      *  Gets an environment variable by its index.
     D f_getEnvVarByIndex...
     D                 PR                         likeds(envVar_t )
     D                                     extproc('BASICS1R6+
     D                                     _f_getEnvVarByIndex+
     D                                     ')
     D  i_index                      10I 0 const
      *
      *  Waits for the specified number of seconds.
     D p_wait...
     D                 PR
     D                                     extproc('BASICS1R6+
     D                                     _p_wait+
     D                                     ')
     D  i_seconds                    10I 0 const
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R1                   Messages
      /COPY QBASICS1,PBASICS1R2                   API Error Handling
      *
      /ENDIF
