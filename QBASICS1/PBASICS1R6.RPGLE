**FREE
/IF NOT DEFINED(BASICS1R6)
/DEFINE BASICS1R6

//  Reference fields
/COPY QBASICS1,FDENVVAR

//  Constants
//  f_execute:            Refer to description of QCAPCMD API for details
dcl-c cCMD_PRC_EXC_QCMDEXC
      const(0);
dcl-c cCMD_PRC_CHK_QCMDCHK
      const(1);
dcl-c cCMD_PRC_EXC_CMDLINE
      const(2);
dcl-c cCMD_PRC_CHK_CMDLINE
      const(3);
dcl-c cCMD_PRC_CHK_CL_STMT
      const(4);
dcl-c cCMD_PRC_CHK_SEU_CL
      const(5);
dcl-c cCMD_PRC_CHK_SEU_CMD
      const(6);
dcl-c cCMD_PRC_CHK_SEU_BND
      const(7);
dcl-c cCMD_PRC_CHK_UDO
      const(8);
dcl-c cCMD_PRC_CHK_SEU_CLLE
      const(9);

dcl-c cCMD_PRC_PROMPT_NEVER
      const(0);
dcl-c cCMD_PRC_PROMPT_ALWAYS
      const(x'00010000');                                                //  65536
dcl-c cCMD_PRC_PROMPT_ON_REQUEST
      const(x'00020000');                                                // 131072
dcl-c cCMD_PRC_PROMPT_HELP
      const(x'00040000');                                                // 262144

//  Executes a CL command.
dcl-pr f_execute
       ind opdesc
       extproc('BASICS1R6+
       _f_execute+
       ');
  i_cmd           char(16384) const  options(*varsize);
  i_typeCmdPrc    int(10) const  options(*nopass: *omit);
  o_msg           likeds(msg_t    )
options(*nopass: *omit);
end-pr;

//  Gets an environment variable.
dcl-pr f_getEnvVar
       varchar(1024)
       extproc('BASICS1R6+
       _f_getEnvVar+
       ');
  i_pEnvVar       pointer const  options(*string);
end-pr;

//  Sets an environment variable.
dcl-pr f_setEnvVar
       ind
       extproc('BASICS1R6+
       _f_setEnvVar+
       ');
  i_envVar        const  like(envVar_t.name );
  i_value         const  like(envVar_t.value);
end-pr;

//  Deletes an environment variable.
dcl-pr f_delEnvVar
       ind
       extproc('BASICS1R6+
       _f_delEnvVar+
       ');
  i_pEnvVar       pointer const  options(*string);
end-pr;

//  Gets the number of environment variables.
dcl-pr f_getNumEnvVar
       int(10)
       extproc('BASICS1R6+
       _f_getNumEnvVar+
       ');
end-pr;

//  Gets an environment variable by its index.
dcl-pr f_getEnvVarByIndex
       likeds(envVar_t )
extproc('BASICS1R6+
_f_getEnvVarByIndex+
');
i_index         int(10) const;
end-pr;

//  Waits for the specified number of seconds.
dcl-pr p_wait
       extproc('BASICS1R6+
       _p_wait+
       ');
  i_seconds       int(10) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R1                   Messages
/COPY QBASICS1,PBASICS1R2                   API Error Handling

/ENDIF
