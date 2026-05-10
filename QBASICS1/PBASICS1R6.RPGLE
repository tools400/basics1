**free
/if NOT DEFINED(BASICS1R6)
/define BASICS1R6

//  Reference fields
/copy QBASICS1,FDENVVAR

//  Constants
//  f_execute:            Refer to description of QCAPCMD API for details
dcl-c cCMD_PRC_EXC_QCMDEXC 0;
dcl-c cCMD_PRC_CHK_QCMDCHK 1;
dcl-c cCMD_PRC_EXC_CMDLINE 2;
dcl-c cCMD_PRC_CHK_CMDLINE 3;
dcl-c cCMD_PRC_CHK_CL_STMT 4;
dcl-c cCMD_PRC_CHK_SEU_CL 5;
dcl-c cCMD_PRC_CHK_SEU_CMD 6;
dcl-c cCMD_PRC_CHK_SEU_BND 7;
dcl-c cCMD_PRC_CHK_UDO 8;
dcl-c cCMD_PRC_CHK_SEU_CLLE 9;

dcl-c cCMD_PRC_PROMPT_NEVER 0;
dcl-c cCMD_PRC_PROMPT_ALWAYS x'00010000'; //  65536
dcl-c cCMD_PRC_PROMPT_ON_REQUEST x'00020000'; // 131072
dcl-c cCMD_PRC_PROMPT_HELP x'00040000'; // 262144

//  Executes a CL command.
dcl-pr f_execute ind opdesc extproc('BASICS1R6_f_execute');
  i_cmd        char(16384) options(*varsize) const;
  i_typeCmdPrc int(10) options(*nopass: *omit) const;
  o_msg        likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Gets an environment variable.
dcl-pr f_getEnvVar varchar(1024) extproc('BASICS1R6_f_getEnvVar');
  i_pEnvVar pointer options(*string) const;
end-pr;

//  Sets an environment variable.
dcl-pr f_setEnvVar ind extproc('BASICS1R6_f_setEnvVar');
  i_envVar like(envVar_t.name) const;
  i_value  like(envVar_t.value) const;
end-pr;

//  Deletes an environment variable.
dcl-pr f_delEnvVar ind extproc('BASICS1R6_f_delEnvVar');
  i_pEnvVar pointer options(*string) const;
end-pr;

//  Gets the number of environment variables.
dcl-pr f_getNumEnvVar int(10) extproc('BASICS1R6_f_getNumEnvVar');
end-pr;

//  Gets an environment variable by its index.
dcl-pr f_getEnvVarByIndex likeds(envVar_t) extproc('BASICS1R6_f_getEnvVarByIndex');
  i_index int(10) const;
end-pr;

//  Waits for the specified number of seconds.
dcl-pr p_wait extproc('BASICS1R6_p_wait');
  i_seconds int(10) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R1                   Messages
/copy QBASICS1,PBASICS1R2                   API Error Handling

/endif