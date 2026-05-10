**free
/if NOT DEFINED(BASICS1RD)
/define BASICS1RD

/copy QBASICS1,FDURL

//  Error ocdes
dcl-c cURL_ERROR_EMPTY_URL -1;
dcl-c cURL_ERROR_NO_PROTOCOL -2;
dcl-c cURL_ERROR_UNSUPPORTED_PROTOCOL -3;
dcl-c cURL_ERROR_INVALID_PORT_NUMBER -4;
dcl-c cURL_ERROR_UNSUPPORTED_OPERATION -5;
dcl-c cURL_ERROR_INVALID_OBJECT_DATA -6;

//  Creates a new URL.
dcl-pr Url_new like(url_t) extproc('BASICS1RD_Url_new');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Returns the protocol of a given URL.
dcl-pr Url_getProtocol like(url_t) extproc('BASICS1RD_Url_getProtocol');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the protocol of a given URL.
dcl-pr Url_setProtocol ind extproc('BASICS1RD_Url_setProtocol');
  io_url     like(url_t);
  i_protocol like(url_t) options(*varsize) const;
  o_rc       int(10) options(*nopass: *omit);
end-pr;

//  Returns the host name of a given URL.
dcl-pr Url_getHost like(url_t) extproc('BASICS1RD_Url_getHost');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the host name of a given URL.
dcl-pr Url_setHost ind extproc('BASICS1RD_Url_setHost');
  io_url like(url_t);
  i_host like(url_t) options(*varsize) const;
  o_rc   int(10) options(*nopass: *omit);
end-pr;

//  Returns the port of a given URL.
dcl-pr Url_getPort int(10) extproc('BASICS1RD_Url_getPort');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the port number of a given URL.
dcl-pr Url_setPort ind extproc('BASICS1RD_Url_setPort');
  io_url like(url_t);
  i_port int(10) const;
  o_rc   int(10) options(*nopass: *omit);
end-pr;

//  Returns the path name of a given URL.
dcl-pr Url_getPath like(url_t) extproc('BASICS1RD_Url_getPath');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the path of a given URL.
dcl-pr Url_setPath ind extproc('BASICS1RD_Url_setPath');
  io_url like(url_t);
  i_path like(url_t) options(*varsize) const;
  o_rc   int(10) options(*nopass: *omit);
end-pr;

//  Returns the file name of a given URL.
dcl-pr Url_getFile like(url_t) extproc('BASICS1RD_Url_getFile');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the file of a given URL.
dcl-pr Url_setFile ind extproc('BASICS1RD_Url_setFile');
  io_url like(url_t);
  i_file like(url_t) options(*varsize) const;
  o_rc   int(10) options(*nopass: *omit);
end-pr;

//  Returns the query part of a given URL.
dcl-pr Url_getQuery like(url_t) extproc('BASICS1RD_Url_getQuery');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Sets the query part of a given URL.
dcl-pr Url_setQuery ind extproc('BASICS1RD_Url_setQuery');
  io_url  like(url_t);
  i_query like(url_t) options(*varsize) const;
  o_rc    int(10) options(*nopass: *omit);
end-pr;

//  Returns the string representation of a given URL.
dcl-pr Url_toString varchar(512) extproc('BASICS1RD_Url_toString');
  i_url like(url_t) const;
  o_rc  int(10) options(*nopass: *omit);
end-pr;

//  Returns the library, file and member of a URL of type 'mbr'.
dcl-pr Url_getMbr ind extproc('BASICS1RD_Url_getMbr');
  i_url  like(url_t) const;
  o_file char(10) options(*nopass: *omit);
  o_lib  char(10) options(*nopass: *omit);
  o_mbr  char(10) options(*nopass: *omit);
  o_rc   int(10) options(*nopass: *omit);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/endif