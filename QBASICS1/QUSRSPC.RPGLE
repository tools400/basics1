      /IF NOT DEFINED(QUSRSPC)
      /DEFINE QUSRSPC
      *
      *  Create User Space (QUSCRTUS) API
     D QUSCRTUS...
     D                 PR                  extpgm('QUSCRTUS')
     D  i_qUsrSpc                    20A   const
     D  i_extAttr                    10A   const
     D  i_initSize                   10I 0 const
     D  i_initValue                   1A   const
     D  i_pubAuth                    10A   const
     D  i_text                       50A   const
     D  i_replace                    10A   const options(*nopass)               | optGrp 1
     D  io_ErrCode                65535A         options(*nopass: *varsize)     |
     D  i_domain                     10A   const options(*nopass)               | optGrp 2
     D  i_tfrSizeReq                 10I 0 const options(*nopass)               | optGrp 3
     D  i_optSpcAlgn                  1A   const options(*nopass)               | optGrp 3
      *
      *  Change User Space (QUSCHGUS) API
     D QUSCHGUS...
     D                 PR                  extpgm('QUSCHGUS')
     D  i_qUsrSpc                    20A   const
     D  i_start                      10I 0 const
     D  i_length                     10I 0 const
     D  i_data                    65535A   const options(*varsize)
     D  i_force                       1A   const
     D  io_ErrCode                65535A         options(*nopass: *varsize)     | optGrp 1
      *
      *  Retrieve User Space (QUSRTVUS) API
     D QUSRTVUS...
     D                 PR                  extpgm('QUSRTVUS')
     D  i_qUsrSpc                    20A   const
     D  i_start                      10I 0 const
     D  i_length                     10I 0 const
     D  o_rcvVar                  65535A   const options(*varsize)
     D  io_ErrCode                65535A         options(*nopass: *varsize)     | optGrp 1
      *
      *  Retrieve Pointer to User Space (QUSPTRUS) API
     D QUSPTRUS...
     D                 PR                  extpgm('QUSPTRUS')
     D  i_qUsrSpc                    20A   const
     D  o_pUsrSpc                      *
     D  io_ErrCode                65535A         options(*nopass: *varsize)     | optGrp 1
      *
      *  Change User Space Attributes (QUSCUSAT) API
     D QUSCUSAT...
     D                 PR                  extpgm('QUSCUSAT')
     D  o_rtnLib                     10A
     D  i_qUsrSpc                    20A   const
     D  i_attrs                   65535A   const options(*varsize)
     D  io_ErrCode                65535A         options(*varsize)
      *
     D QUSRSPC_ATTR_SIZE...
     D                 C                   1                                    BINARY(4)
     D QUSRSPC_ATTR_INITIAL_VALUE...
     D                 C                   2                                    CHAR(1)
     D QUSRSPC_ATTR_AUTO_EXTEND...
     D                 C                   3                                    CHAR(1)
     D QUSRSPC_ATTR_TRANSFER_SIZE_REQ...
     D                 C                   4                                    BINARY(4)
      *
     D QUSRSPC_attr_size_t...
     D                 DS                  qualified               based(pDummy)
     D  key                          10I 0
     D  dataLen                      10I 0
     D  size                         10I 0
      *
     D QUSRSPC_initial_value_t...
     D                 DS                  qualified               based(pDummy)
     D  key                          10I 0
     D  dataLen                      10I 0
     D  value                         1A
      *
     D QUSRSPC_auto_extend_t...
     D                 DS                  qualified               based(pDummy)
     D  key                          10I 0
     D  dataLen                      10I 0
     D  autoExtend                    1A
      *
     D QUSRSPC_ztansfer_size_req_t...
     D                 DS                  qualified               based(pDummy)
     D  key                          10I 0
     D  dataLen                      10I 0
     D  tfrSizeReq                   10I 0
      *
      *  Retrieve User Space Attributes (QUSRUSAT) API
     D QUSRUSAT...
     D                 PR                  extpgm('QUSRUSAT')
     D  o_rcvVar                  65535A         options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  i_qUsrSpc                    20A   const
     D  io_ErrCode                65535A         options(*varsize)
      *
      *  SPCA0100 Format
     D SPCA0100_t      DS                  qualified               based(pDummy)
     D  bytRet                 1      4I 0
     D  bytAvl                 5      8I 0
     D  size                   9     12I 0
     D  autoExtend            13     13A
     D  initValue             14     14A
     D  usrSpcLib             15     24A
      *
      *  Delete User Space (QUSDLTUS) API
     D QUSDLTUS...
     D                 PR                  extpgm('QUSDLTUS')
     D  i_qUsrSpc                    20A   const
     D  io_ErrCode                65535A         options(*varsize)
      *
      /ENDIF
