      /IF NOT DEFINED(BASICS1R5)
      /DEFINE BASICS1R5
      *
      *  Reference fields
      /COPY QBASICS1,FDQFILE
      /COPY QBASICS1,FDQOBJ
      /COPY QBASICS1,FDQQSYSOBJ
      /COPY QBASICS1,FDOBJD0100
      /COPY QBASICS1,FDMBRD0100
      /COPY QBASICS1,FDMBRD0200
      *
     D qProc_t         DS                  qualified      based(pDummy)
     D  name                        256A   varying
     D  module                       10A
     D  qPgm                               likeds(qObj_t)
      *
     D actSrvPgm_t     DS                  qualified      based(pDummy)
     D  procptr                        *   procptr
     D  actMark                      10I 0
     D  name                         10A
     D  lib                          10A
      *
     D actProc_t       DS                  qualified      based(pDummy)
     D  procptr                        *   procptr
     D  actMark                      10I 0
     D  name                        256A   varying
     D  srvPgm                       10A
     D  lib                          10A
      *
      *  Checks object existance.
     D f_exist...
     D                 PR              N
     D                                     extproc('BASICS1R5+
     D                                     _f_exist+
     D                                     ')
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
     D  i_mbr                        10A   const  options(*nopass)
      *
      *  Retrieve object description.
     D f_rtvObjD...
     D                 PR          1024A
     D                                     extproc('BASICS1R5+
     D                                     _f_rtvObjD+
     D                                     ')
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
     D  i_format                      8A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieve member description.
     D f_rtvMbrD...
     D                 PR          1024A
     D                                     extproc('BASICS1R5+
     D                                     _f_rtvMbrD+
     D                                     ')
     D  i_file                       10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_mbr                        10A   const
     D  i_format                      8A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Produces a temporary object name.
     D f_getTmpName...
     D                 PR                         like(qObj_t     )
     D                                     extproc('BASICS1R5+
     D                                     _f_getTmpName+
     D                                     ')
      *
      *  Produces a unique object name.  (experimental)
     D f_getUniqueName...
     D                 PR                         like(qObj_t     )
     D                                     extproc('BASICS1R5+
     D                                     _f_getUniqueName+
     D                                     ')
     D  i_type                       10A   const
     D  i_lib                        10A   const
      *
      *  Creates a user space.
     D f_crtUsrSpc...
     D                 PR              N
     D                                     extproc('BASICS1R5+
     D                                     _f_crtUsrSpc+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const
     D  i_text                       50A   const  options(*omit: *nopass)
     D  i_size                       10U 0 const  options(*omit: *nopass)
     D  i_extAtr                     10A   const  options(*omit: *nopass)
     D  i_pubAuth                    10A   const  options(*omit: *nopass)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Retrieves a pointer to the content of a user space.
     D f_rtvUsrSpcPtr...
     D                 PR              *
     D                                     extproc('BASICS1R5+
     D                                     _f_rtvUsrSpcPtr+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Returns the current size of a given user space.
     D f_getUsrSpcSize...
     D                 PR            10I 0
     D                                     extproc('BASICS1R5+
     D                                     _f_getUsrSpcSize+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Returns cTrue if the user space is extended automatically by the
      *  system when the end of the space is encountered.
     D f_getUsrSpcAutoExt...
     D                 PR              N
     D                                     extproc('BASICS1R5+
     D                                     _f_getUsrSpcAutoExt+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Returns the initial value of a given user space.
     D f_getUsrSpcInitValue...
     D                 PR             1A          varying
     D                                     extproc('BASICS1R5+
     D                                     _f_getUsrSpcInitValue+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Changes the size of a given user space.
     D f_chgUsrSpcSize...
     D                 PR            10I 0
     D                                     extproc('BASICS1R5+
     D                                     _f_chgUsrSpcSize+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_size                       10I 0 const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Changes the automatic extendibility of a given user space.
     D f_chgUsrSpcAutoExt...
     D                 PR              N
     D                                     extproc('BASICS1R5+
     D                                     _f_chgUsrSpcAutoExt+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_isAutoExt                    N   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Changes the initial value of a given user space.
     D f_chgUsrSpcInitValue...
     D                 PR             1A          varying
     D                                     extproc('BASICS1R5+
     D                                     _f_chgUsrSpcInitValue+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_initValue                   1A   const
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Deletes a given user space.
     D f_dltUsrSpc...
     D                 PR              N
     D                                     extproc('BASICS1R5+
     D                                     _f_dltUsrSpc+
     D                                     ')
     D  i_usrSpc                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Activates a service program.
     D f_activateSrvPgm...
     D                 PR                         likeds(actSrvPgm_t )
     D                                     extproc('BASICS1R5+
     D                                     _f_activateSrvPgm+
     D                                     ')
     D  i_srvPgm                     10A   const
     D  i_lib                        10A   const  options(*nopass: *omit)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Gets a procedure pointer by name.
     D f_getProcPtrByName...
     D                 PR                         likeds(actProc_t  )
     D                                     extproc('BASICS1R5+
     D                                     _f_getProcPtrByName+
     D                                     ')
     D  i_proc                      256A   const
     D  i_actSrvPgm                        const  likeds(actSrvPgm_t)
     D  o_msg                                     likeds(msg_t    )
     D                                            options(*nopass: *omit)
      *
      *  Returns the name of the library that contains a given object.
     D f_getObjLib...
     D                 PR            10A
     D                                     extproc('BASICS1R5+
     D                                     _f_getObjLib+
     D                                     ')
     D  i_obj                        10A   const
     D  i_lib                        10A   const  options(*omit)
     D  i_type                       10A   const
      *
      *  Converts a QSYS object name to a path.
     D f_cvtQSYSObjNameToPath...
     D                 PR          5000A   varying opdesc
     D                                     extproc('BASICS1R5+
     D                                     _f_cvtQSYSObjNameToPath+
     D                                     ')
     D  i_obj                        40A   const  options(*varsize)
     D  i_libOrType                  10A   const  options(*nopass: *omit)
     D  i_mbrOrType                  10A   const  options(*nopass: *omit)
     D  i_objType                    10A   const  options(*nopass: *omit)
      *
      *  Resolve Integrated File System Path Name into
      *  QSYS Object Name
     D f_cvtPathToQSYSObjName...
     D                 PR                  likeds(qQSYSObj_t)
     D                                     extproc('BASICS1R5+
     D                                     _f_cvtPathToQSYSObjName+
     D                                     ')
     D  i_path                     5000A   const  varying options(*varsize)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,MILIB                        MI-Library
      /COPY QBASICS1,PBASICS1R1                   Messages
      /COPY QBASICS1,PBASICS1R7                   Mathematics
      *
      /ENDIF
