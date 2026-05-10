**free
/if NOT DEFINED(BASICS1R5)
/define BASICS1R5

//  Reference fields
/copy QBASICS1,FDQFILE
/copy QBASICS1,FDQOBJ
/copy QBASICS1,FDQQSYSOBJ
/copy QBASICS1,FDOBJD0100
/copy QBASICS1,FDMBRD0100
/copy QBASICS1,FDMBRD0200

dcl-ds qProc_t qualified based(pDummy);
  name   varchar(256);
  module char(10);
  qPgm   likeds(qObj_t);
end-ds;

dcl-ds actSrvPgm_t qualified based(pDummy);
  procptr pointer(*proc);
  actMark int(10);
  name    char(10);
  lib     char(10);
end-ds;

dcl-ds actProc_t qualified based(pDummy);
  procptr pointer(*proc);
  actMark int(10);
  name    varchar(256);
  srvPgm  char(10);
  lib     char(10);
end-ds;

//  Checks object existance.
dcl-pr f_exist ind extproc('BASICS1R5_f_exist');
  i_obj  char(10) const;
  i_lib  char(10) options(*omit) const;
  i_type char(10) const;
  i_mbr  char(10) options(*nopass) const;
end-pr;

//  Retrieve object description.
dcl-pr f_rtvObjD char(1024) extproc('BASICS1R5_f_rtvObjD');
  i_obj    char(10) const;
  i_lib    char(10) options(*omit) const;
  i_type   char(10) const;
  i_format char(8) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieve member description.
dcl-pr f_rtvMbrD char(1024) extproc('BASICS1R5_f_rtvMbrD');
  i_file   char(10) const;
  i_lib    char(10) options(*omit) const;
  i_mbr    char(10) const;
  i_format char(8) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Produces a temporary object name.
dcl-pr f_getTmpName like(qObj_t) extproc('BASICS1R5_f_getTmpName');
end-pr;

//  Produces a unique object name.  (experimental)
dcl-pr f_getUniqueName like(qObj_t) extproc('BASICS1R5_f_getUniqueName');
  i_type char(10) const;
  i_lib  char(10) const;
end-pr;

//  Creates a user space.
dcl-pr f_crtUsrSpc ind extproc('BASICS1R5_f_crtUsrSpc');
  i_usrSpc  char(10) const;
  i_lib     char(10) const;
  i_text    char(50) options(*omit: *nopass) const;
  i_size    uns(10) options(*omit: *nopass) const;
  i_extAtr  char(10) options(*omit: *nopass) const;
  i_pubAuth char(10) options(*omit: *nopass) const;
  o_msg     likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Retrieves a pointer to the content of a user space.
dcl-pr f_rtvUsrSpcPtr pointer extproc('BASICS1R5_f_rtvUsrSpcPtr');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Returns the current size of a given user space.
dcl-pr f_getUsrSpcSize int(10) extproc('BASICS1R5_f_getUsrSpcSize');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Returns cTrue if the user space is extended automatically by the
//  system when the end of the space is encountered.
dcl-pr f_getUsrSpcAutoExt ind extproc('BASICS1R5_f_getUsrSpcAutoExt');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Returns the initial value of a given user space.
dcl-pr f_getUsrSpcInitValue varchar(1) extproc('BASICS1R5_f_getUsrSpcInitValue');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Changes the size of a given user space.
dcl-pr f_chgUsrSpcSize int(10) extproc('BASICS1R5_f_chgUsrSpcSize');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*omit) const;
  i_size   int(10) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Changes the automatic extendibility of a given user space.
dcl-pr f_chgUsrSpcAutoExt ind extproc('BASICS1R5_f_chgUsrSpcAutoExt');
  i_usrSpc    char(10) const;
  i_lib       char(10) options(*omit) const;
  i_isAutoExt ind const;
  o_msg       likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Changes the initial value of a given user space.
dcl-pr f_chgUsrSpcInitValue varchar(1) extproc('BASICS1R5_f_chgUsrSpcInitValue');
  i_usrSpc    char(10) const;
  i_lib       char(10) options(*omit) const;
  i_initValue char(1) const;
  o_msg       likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Deletes a given user space.
dcl-pr f_dltUsrSpc ind extproc('BASICS1R5_f_dltUsrSpc');
  i_usrSpc char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Activates a service program.
dcl-pr f_activateSrvPgm likeds(actSrvPgm_t) extproc('BASICS1R5_f_activateSrvPgm');
  i_srvPgm char(10) const;
  i_lib    char(10) options(*nopass: *omit) const;
  o_msg    likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Gets a procedure pointer by name.
dcl-pr f_getProcPtrByName likeds(actProc_t) extproc('BASICS1R5_f_getProcPtrByName');
  i_proc      char(256) const;
  i_actSrvPgm likeds(actSrvPgm_t) const;
  o_msg       likeds(msg_t) options(*nopass: *omit);
end-pr;

//  Returns the name of the library that contains a given object.
dcl-pr f_getObjLib char(10) extproc('BASICS1R5_f_getObjLib');
  i_obj  char(10) const;
  i_lib  char(10) options(*omit) const;
  i_type char(10) const;
end-pr;

//  Converts a QSYS object name to a path.
dcl-pr f_cvtQSYSObjNameToPath varchar(5000) opdesc extproc('BASICS1R5_f_cvtQSYSObjNameToPath');
  i_obj       char(40) options(*varsize) const;
  i_libOrType char(10) options(*nopass: *omit) const;
  i_mbrOrType char(10) options(*nopass: *omit) const;
  i_objType   char(10) options(*nopass: *omit) const;
end-pr;

//  Resolve Integrated File System Path Name into
//  QSYS Object Name
dcl-pr f_cvtPathToQSYSObjName likeds(qQSYSObj_t) extproc('BASICS1R5_f_cvtPathToQSYSObjName');
  i_path varchar(5000) options(*varsize) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,MILIB                        MI-Library
/copy QBASICS1,PBASICS1R1                   Messages
/copy QBASICS1,PBASICS1R7                   Mathematics

/endif