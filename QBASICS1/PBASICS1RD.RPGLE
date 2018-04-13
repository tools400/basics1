      /IF NOT DEFINED(BASICS1RD)
      /DEFINE BASICS1RD
      *
      /COPY QBASICS1,FDURL
      *
      *  Error ocdes
     D cURL_ERROR_EMPTY_URL...
     D                 C                   -1
     D cURL_ERROR_NO_PROTOCOL...
     D                 C                   -2
     D cURL_ERROR_UNSUPPORTED_PROTOCOL...
     D                 C                   -3
     D cURL_ERROR_INVALID_PORT_NUMBER...
     D                 C                   -4
     D cURL_ERROR_UNSUPPORTED_OPERATION...
     D                 C                   -5
     D cURL_ERROR_INVALID_OBJECT_DATA...
     D                 C                   -6
      *
      *  Creates a new URL.
     D Url_new...
     D                 PR                         like(url_t )
     D                                     extproc('BASICS1RD+
     D                                     _Url_new+
     D                                     ')
     D  i_url                              const  like(url_t )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the protocol of a given URL.
     D Url_getProtocol...
     D                 PR                         like(url_t )
     D                                     extproc('BASICS1RD+
     D                                     _Url_getProtocol+
     D                                     ')
     D  i_url                              const  like(url_t )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the protocol of a given URL.
     D Url_setProtocol...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setProtocol+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_protocol                         const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the host name of a given URL.
     D Url_getHost...
     D                 PR                         like(url_t )
     D                                     extproc('BASICS1RD+
     D                                     _Url_getHost+
     D                                     ')
     D  i_url                              const  like(url_t )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the host name of a given URL.
     D Url_setHost...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setHost+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_host                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the port of a given URL.
     D Url_getPort...
     D                 PR            10I 0
     D                                     extproc('BASICS1RD+
     D                                     _Url_getPort+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the port number of a given URL.
     D Url_setPort...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setPort+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_port                       10I 0 const
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the path name of a given URL.
     D Url_getPath...
     D                 PR                         like(url_t    )
     D                                     extproc('BASICS1RD+
     D                                     _Url_getPath+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the path of a given URL.
     D Url_setPath...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setPath+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_path                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the file name of a given URL.
     D Url_getFile...
     D                 PR                         like(url_t    )
     D                                     extproc('BASICS1RD+
     D                                     _Url_getFile+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the file of a given URL.
     D Url_setFile...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setFile+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_file                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the query part of a given URL.
     D Url_getQuery...
     D                 PR                         like(url_t    )
     D                                     extproc('BASICS1RD+
     D                                     _Url_getQuery+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Sets the query part of a given URL.
     D Url_setQuery...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_setQuery+
     D                                     ')
     D  io_url                                    like(url_t )
     D  i_query                            const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the string representation of a given URL.
     D Url_toString...
     D                 PR           512A          varying
     D                                     extproc('BASICS1RD+
     D                                     _Url_toString+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Returns the library, file and member of a URL of type 'mbr'.
     D Url_getMbr...
     D                 PR              N
     D                                     extproc('BASICS1RD+
     D                                     _Url_getMbr+
     D                                     ')
     D  i_url                              const  like(url_t    )
     D  o_file                       10A          options(*nopass: *omit)
     D  o_lib                        10A          options(*nopass: *omit)
     D  o_mbr                        10A          options(*nopass: *omit)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      /ENDIF
