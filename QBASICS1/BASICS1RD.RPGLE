**free
//=====================================================================*
//  BASICS1RC  - SrvPgm: Basic Routines - URL                          *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  20.12.2007                                              *
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
/copy QBASICS1,PBASICS1RD

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

/copy QBASICS1,FDURL

//  Parsed URL
dcl-ds parsedUrl_t len(512) qualified based(pDummy);
  type     char(10);
  pos      uns(5);
  protocol likeds(substr_t);
  host     likeds(substr_t);
  port     likeds(substr_t);
  file     likeds(substr_t);
  path     likeds(substr_t);
  query    likeds(substr_t);
  data     like(url_t);
end-ds;

//  For internal use only
dcl-ds substr_t qualified based(pDummy);
  start       uns(5);
  length      uns(5);
  baseStart   uns(5);
  totalLength uns(5);
end-ds;

// -----------------------------------------
//  Imported Prototypes
// -----------------------------------------
/copy QBASICS1,CEELIB

/copy QBASICS1,PBASICS1R3

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Parses a given URL.
dcl-pr parseUrl likeds(parsedUrl_t);
  i_url like(url_t) const;
  o_rc  int(10);
end-pr;

//  Parsen Standard-URL
dcl-pr parseStandardUrl likeds(parsedUrl_t);
  i_parsedUrl likeds(parsedUrl_t) const;
  o_rc        int(10);
end-pr;

//  Returns the sub-string defined by 'i_subString'.
dcl-pr getSubstring varchar(512);
  i_string    varchar(512) const;
  i_subString likeds(substr_t) const;
end-pr;

//  Breaks the path of a given URL into the pieces: library, file and member
dcl-pr splittPath ind opdesc;
  i_url    likeds(parsedUrl_t) const;
  i_dftObj char(256) options(*varsize) const;
  o_file   char(10);
  o_lib    char(10);
  o_obj    char(256) options(*varsize);
  o_rc     int(10);
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------

dcl-c cEND_OF_PROTOCOL ':';
dcl-c cSTART_OF_HOST '//';
dcl-c cSTART_OF_FILE '/';
dcl-c cSTART_OF_PORT ':';
dcl-c cSTART_OF_QUERY '?';
dcl-c cHANDLE_TYPE '*URL';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Creates a new Url.
//=========================================================================
//  Parameters:
//   i_url         - The string representation of a Url.
//
//  Returns:
//   parsedUrl     - A parsed Url.
//=========================================================================
dcl-proc Url_new export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to create URL. Error code: ' + %char(rc));
    endif;
  endif;

  return parsedUrl;


end-proc;

//=========================================================================
//  Returns the protocol of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   protocol      - The protocol of the URL.
//=========================================================================
dcl-proc Url_getProtocol export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s protocol like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);

  if (rc = 0);
    protocol = f_lcase(getSubstring(parsedUrl.data
                                    : parsedUrl.protocol));
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve protocol. Error code: ' +
                %char(rc));
    endif;
  endif;

  return protocol;


end-proc;

//=========================================================================
//  Sets the protocol of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_protocol    - The protocol of the URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the protocol could be set,
//                   else cFalse.
//=========================================================================
dcl-proc Url_setProtocol export;
  dcl-pi *n ind;
    io_url     like(url_t);
    i_protocol like(url_t) options(*varsize) const;
    o_rc       int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpProtocol like(i_protocol) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    tmpProtocol = %trimR(%subst(i_protocol: 1: %len(i_protocol)));

    // replace protocol of URL
    if (tmpProtocol = '');
      parsedUrl.data = %replace(''
                                : parsedUrl.data
                                : parsedUrl.protocol.baseStart
                                : parsedUrl.protocol.totalLength);
    else;
      if (not f_endsWith(cEND_OF_PROTOCOL: tmpProtocol));
        tmpProtocol = tmpProtocol + cEND_OF_PROTOCOL;
      endif;
      parsedUrl.data = %replace(tmpProtocol
                                : parsedUrl.data
                                : parsedUrl.protocol.baseStart
                                : parsedUrl.protocol.totalLength);
    endif;

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_URL = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set protocol. Error code: ' + %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the host name of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   host          - The host name of the URL.
//=========================================================================
dcl-proc Url_getHost export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s host like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);
  if (rc = 0);
    host = getSubstring(parsedUrl.data: parsedUrl.host);
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve host name. Error code: ' +
                %char(rc));
    endif;
  endif;

  return host;


end-proc;

//=========================================================================
//  Sets the host name of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_host        - The name of the host.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the host name could be set,
//                   else cFalse.
//=========================================================================
dcl-proc Url_setHost export;
  dcl-pi *n ind;
    io_url like(url_t);
    i_host like(url_t) options(*varsize) const;
    o_rc   int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpHost like(i_host) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    tmpHost = %trimR(%subst(i_host: 1: %len(i_host)));

    // replace host name of URL
    if (tmpHost = '');
      parsedUrl.data = %replace(''
                                : parsedUrl.data
                                : parsedUrl.host.baseStart
                                : parsedUrl.host.totalLength);
    else;
      if not f_startsWith(cSTART_OF_HOST: tmpHost);
        tmpHost = cSTART_OF_HOST + tmpHost;
      endif;
      parsedUrl.data = %replace(tmpHost
                                : parsedUrl.data
                                : parsedUrl.host.baseStart
                                : parsedUrl.host.totalLength);
    endif;

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_url = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set host name. Error code: ' + %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the port of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   port          - The port of the URL.
//=========================================================================
dcl-proc Url_getPort export;
  dcl-pi *n int(10);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s port int(10) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);
  if (rc = 0);
    port = atoi(getSubstring(parsedUrl.data: parsedUrl.port));
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve port. Error code: ' + %char(rc));
    endif;
  endif;

  return port;


end-proc;

//=========================================================================
//  Sets the port number of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_port        - The port number.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the port number could be set,
//                   else cFalse.
//=========================================================================
dcl-proc Url_setPort export;
  dcl-pi *n ind;
    io_url like(url_t);
    i_port int(10) const;
    o_rc   int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpPort varchar(30) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    // replace port of URL
    if (i_port = 0);
      parsedUrl.data = %replace(''
                                : parsedUrl.data
                                : parsedUrl.port.baseStart
                                : parsedUrl.port.totalLength);
    else;
      tmpPort = cSTART_OF_PORT + %char(i_port);
      parsedUrl.data = %replace(tmpPort
                                : parsedUrl.data
                                : parsedUrl.port.baseStart
                                : parsedUrl.port.totalLength);
    endif;

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_url = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set port number. Error code: ' + %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the path of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   path          - The path of the URL. The path of a URL is the
//                   file name without the query parameters.
//=========================================================================
dcl-proc Url_getPath export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s path like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);
  if (rc = 0);
    path = getSubstring(parsedUrl.data: parsedUrl.path);
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve path. Error code: ' + %char(rc));
    endif;
  endif;

  return path;


end-proc;

//=========================================================================
//  Sets the path of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_path        - The path. The path of a URL is the file name
//                   without the query parameters.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the path could be set, else cFalse.
//=========================================================================
dcl-proc Url_setPath export;
  dcl-pi *n ind;
    io_url like(url_t);
    i_path like(url_t) options(*varsize) const;
    o_rc   int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    // replace path of URL
    parsedUrl.data = %replace(%trimR(%subst(i_path: 1: %len(i_path)))
                              : parsedUrl.data
                              : parsedUrl.path.baseStart
                              : parsedUrl.path.totalLength);

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_url = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set path. Error code: ' + %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the file of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   file          - The file of the URL. The file of a URL is everything
//                   behind the host name (and port number).
//=========================================================================
dcl-proc Url_getFile export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s file like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);
  if (rc = 0);
    file = getSubstring(parsedUrl.data: parsedUrl.file);
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve file. Error code: ' + %char(rc));
    endif;
  endif;

  return file;


end-proc;

//=========================================================================
//  Sets the file of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_file        - The file. The file of a URL is everything behind the
//                   hostname (and port number).
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the file could be set, else cFalse.
//=========================================================================
dcl-proc Url_setFile export;
  dcl-pi *n ind;
    io_url like(url_t);
    i_file like(url_t) options(*varsize) const;
    o_rc   int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    // replace file of URL
    parsedUrl.data = %replace(%trimR(%subst(i_file: 1: %len(i_file)))
                              : parsedUrl.data
                              : parsedUrl.file.baseStart
                              : parsedUrl.file.totalLength);

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_url = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set file. Error code: ' + %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the query part of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   query         - The query part of the URL.
//=========================================================================
dcl-proc Url_getQuery export;
  dcl-pi *n like(url_t);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s query like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(i_url: rc);
  if (rc = 0);
    query = getSubstring(parsedUrl.data: parsedUrl.query);
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to retrieve query. Error code: ' + %char(rc));
    endif;
  endif;

  return query;


end-proc;

//=========================================================================
//  Sets the query part of a given URL.
//=========================================================================
//  Parameters:
//   io_url        - The URL.
//   i_query       - The query part of the URL.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isSet         - Returns cTrue if the query part could be set,
//                   else cFalse.
//=========================================================================
dcl-proc Url_setQuery export;
  dcl-pi *n ind;
    io_url  like(url_t);
    i_query like(url_t) options(*varsize) const;
    o_rc    int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s isSet ind inz(cFalse);

  //  Parameter positions
  dcl-c p_rc 3;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s tmpQuery like(i_query) inz;
  dcl-s tmpUrl like(io_URL) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(%trim(io_url): rc);
    if (rc <> 0);
      leave;
    endif;

    tmpQuery = %trimR(%subst(i_query: 1: %len(i_query)));

    // replace query part of the URL
    if (tmpQuery = '');
      parsedUrl.data = %replace(''
                                : parsedUrl.data
                                : parsedUrl.query.baseStart
                                : parsedUrl.query.totalLength);
    else;
      if not f_startsWith(cSTART_OF_QUERY: tmpQuery);
        tmpQuery = cSTART_OF_QUERY + tmpQuery;
      endif;
      parsedUrl.data = %replace(tmpQuery
                                : parsedUrl.data
                                : parsedUrl.query.baseStart
                                : parsedUrl.query.totalLength);
    endif;

    // parse changed URL
    tmpUrl = parseUrl(parsedUrl.data: rc);
    if (rc <> 0);
      leave;
    endif;

    io_url = tmpUrl;
    isSet = cTrue;
  enddo;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to set query parameters. Error code: ' +
                %char(rc));
    endif;
  endif;

  return isSet;


end-proc;

//=========================================================================
//  Returns the string representation of a given URL.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//
//  Returns:
//   string        - The string representation of the URL.
//=========================================================================
dcl-proc Url_toString export;
  dcl-pi *n varchar(512);
    i_url like(url_t) const;
    o_rc  int(10) options(*nopass: *omit);
  end-pi;

  //  Return value
  dcl-s string like(url_t) inz;

  //  Parameter positions
  dcl-c p_rc 2;

  //  Fields for optional parameters
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s isPresent int(10) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = parseUrl(%trim(i_URL): rc);
  if (rc = 0);
    string = %trimR(parsedUrl.data);
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to get string representation. Error code: ' +
                %char(rc));
    endif;
  endif;

  return string;


end-proc;

//=========================================================================
//  Returns the library, file and member of a URL of type 'mbr'.
//=========================================================================
//  Parameters:
//   i_url         - The URL.
//   o_file        - The file name of a URL of type 'mbr'.
//   o_lib         - The library name of a URL of type 'mbr'.
//   o_mbr         - The member name of a URL of type 'mbr'.
//   o_rc          - Return code. 0 = no errror.
//
//  Returns:
//   isOK          - Returns cTrue on success, else cFalse.
//=========================================================================
dcl-proc Url_getMbr export;
  dcl-pi *n ind;
    i_url  like(url_t) const;
    o_file char(10) options(*nopass: *omit);
    o_lib  char(10) options(*nopass: *omit);
    o_mbr  char(10) options(*nopass: *omit);
    o_rc   int(10) options(*nopass: *omit);
  end-pi;

  //  Funktionswert
  dcl-s isDone ind inz(cFalse);

  //  Parameterpositionen
  dcl-c p_file 2;
  dcl-c p_lib 3;
  dcl-c p_mbr 4;
  dcl-c p_rc 5;

  //  Felder fr optionale Parameter
  dcl-s file like(o_file) inz;
  dcl-s lib like(o_lib) inz;
  dcl-s mbr like(o_mbr) inz;
  dcl-s rc like(o_rc) inz;

  //  Lokale Arbeitsfelder
  dcl-s isPresent int(10) inz;
  dcl-s protocol like(url_t) inz;
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dou '1';
    parsedUrl = parseUrl(i_URL: rc);
    if (rc <> 0);
      leave;
    endif;

    protocol = Url_getProtocol(parsedUrl: rc);
    if (rc <> 0);
      leave;
    endif;

    if (protocol <> 'mbr');
      o_rc = cURL_ERROR_UNSUPPORTED_OPERATION;
      leave;
    endif;

    if (not splittPath(parsedUrl: '*FIRST': file: lib: mbr: rc));
      leave;
    endif;

  enddo;

  // Set values of optional parameters ...
  // ... file
  if (%parms() >= p_file);
    CEETSTA(isPresent: p_file: *omit);
    if (isPresent = 1);
      o_file = file;
    endif;
  endif;

  // ... lib
  if %parms() >= p_lib;
    CEETSTA(isPresent: p_lib: *omit);
    if (isPresent = 1);
      o_lib = lib;
    endif;
  endif;

  // ... mbr
  if %parms() >= p_mbr;
    CEETSTA(isPresent: p_mbr: *omit);
    if (isPresent = 1);
      o_mbr = mbr;
    endif;
  endif;

  if (%parms() >= p_rc);
    CEETSTA(isPresent: p_rc: *omit);
    if (isPresent = 1);
      o_rc = rc;
    endif;
  else;
    if (rc <> 0);
      p_assert(cFalse:
               'Failed to get file, library, member. Error code: ' +
                %char(rc));
    endif;
  endif;

  return cTrue;


end-proc;

//=========================================================================
//  Parses a given URL.
//=========================================================================
dcl-proc parseUrl;
  dcl-pi *n likeds(parsedUrl_t);
    i_url like(url_t) const;
    o_rc  int(10);
  end-pi;

  //  Return value
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;

  //  Helper fields
  dcl-s itemStart int(10) inz;
  dcl-s protocol varchar(20) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_url = '');
    o_rc = cURL_ERROR_EMPTY_URL;
    return parsedUrl;
  endif;

  if f_left(i_url: %len(parsedUrl_t.type)) = cHANDLE_TYPE;
    o_rc = 0;
    return i_url;
  endif;

  clear parsedUrl;
  parsedUrl.data = %trimR(i_url);

  // Get protocol from URL
  parsedUrl.pos = 1;
  itemStart = parsedUrl.pos;
  dow (parsedUrl.pos <= %len(parsedUrl.data)) and
      (parsedUrl.protocol.start = 0);
    select;
    when f_containsStringAt(parsedUrl.data: parsedUrl.pos
                                          : cEND_OF_PROTOCOL);

      parsedUrl.protocol.start  = itemStart;
      parsedUrl.protocol.length = parsedUrl.pos - itemStart;

      parsedUrl.protocol.baseStart   = itemStart;
      parsedUrl.protocol.totalLength = parsedUrl.pos - itemStart + 1;

      parsedUrl.pos = parsedUrl.pos + %len(cEND_OF_PROTOCOL);
    other;
      parsedUrl.pos = parsedUrl.pos + 1;
    endsl;
  enddo;

  // Failed to retrieve protocol ==> error
  if parsedUrl.protocol.length = 0;
    o_rc = cURL_ERROR_NO_PROTOCOL;
    return parsedUrl;
  endif;

  protocol = f_lcase(getSubstring(parsedUrl.data: parsedUrl.protocol));

  // Unknown protocol ==> error
  if (protocol <> 'http' ) and (protocol <> 'https' ) and
     (protocol <> 'ftp'  ) and (protocol <> 'ftps'  ) and
     (protocol <> 'file' ) and (protocol <> 'mbr'   );
    o_rc = cURL_ERROR_UNSUPPORTED_PROTOCOL;
    return parsedUrl;
  endif;

  // Parse URL for protocol ...
  select;
  other;
    parsedUrl = parseStandardUrl(parsedUrl: o_rc);
  endsl;

  // Set missing start position and length information ...
  // ... protocol (should not happen)
  if (parsedUrl.protocol.length = 0);
    parsedUrl.protocol.start     = 1;
    parsedUrl.protocol.baseStart = parsedUrl.protocol.start;
  endif;
  // ... host
  if (parsedUrl.host.length = 0);
    parsedUrl.host.start     = parsedUrl.protocol.baseStart +
                               parsedUrl.protocol.totalLength;
    parsedUrl.host.baseStart = parsedUrl.host.start;
  endif;
  // ... port
  if (parsedUrl.port.length = 0);
    parsedUrl.port.start     = parsedUrl.host.baseStart +
                               parsedUrl.host.totalLength;
    parsedUrl.port.baseStart = parsedUrl.port.start;
  endif;
  // ... path
  if (parsedUrl.path.length) = 0;
    parsedUrl.path.start     = parsedUrl.port.baseStart +
                               parsedUrl.port.totalLength;
    parsedUrl.path.baseStart = parsedUrl.path.start;
  endif;
  // ... file
  if (parsedUrl.file.length) = 0;
    parsedUrl.file.start     = parsedUrl.port.baseStart +
                               parsedUrl.port.totalLength;
    parsedUrl.file.baseStart = parsedUrl.file.start;
  endif;
  // ... query
  if (parsedUrl.query.length) = 0;
    parsedUrl.query.start     = parsedUrl.path.baseStart +
                                parsedUrl.path.totalLength;
    parsedUrl.query.baseStart = parsedUrl.query.start;
  endif;

  o_rc = 0;

  return parsedUrl;


end-proc;

//=========================================================================
//  Parsen Standard-URL
//=========================================================================
dcl-proc parseStandardUrl;
  dcl-pi *n likeds(parsedUrl_t);
    i_parsedUrl likeds(parsedUrl_t) const;
    o_rc        int(10);
  end-pi;

  //  Funktionswert
  dcl-ds parsedUrl likeds(parsedUrl_t) inz;

  //  Lokale Arbeitsfelder
  dcl-s baseStart int(10) inz;
  dcl-s itemStart int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  parsedUrl = i_parsedUrl;

  // Get host name from URL
  if (f_containsStringAt(parsedUrl.data
                         : parsedUrl.pos
                         : cSTART_OF_HOST));
    baseStart = parsedUrl.pos;
    parsedUrl.pos = parsedUrl.pos + %len(cSTART_OF_HOST);
    itemStart = parsedUrl.pos;
    dow (parsedUrl.pos <= %len(parsedUrl.data)) and
        (parsedUrl.host.start = 0);
      select;
      when f_containsStringAt(parsedUrl.data: parsedUrl.pos
                                            : cSTART_OF_FILE);
        parsedUrl.host.start  = itemStart;
        parsedUrl.host.length = parsedUrl.pos - itemStart;

        parsedUrl.host.baseStart   = baseStart;
        parsedUrl.host.totalLength = parsedUrl.pos - baseStart;

      when f_containsStringAt(parsedUrl.data: parsedUrl.pos
                                            : cSTART_OF_PORT);
        parsedUrl.host.start  = itemStart;
        parsedUrl.host.length = parsedUrl.pos - itemStart;

        parsedUrl.host.baseStart   = baseStart;
        parsedUrl.host.totalLength = parsedUrl.pos - baseStart;

      other;
        parsedUrl.pos = parsedUrl.pos + 1;
      endsl;
    enddo;
  endif;

  // Get port number from URL
  if (f_containsStringAt(parsedUrl.data: parsedUrl.pos: cSTART_OF_PORT));
    baseStart = parsedUrl.pos;
    parsedUrl.pos = parsedUrl.pos + %len(cSTART_OF_PORT);
    itemStart = parsedUrl.pos;
    dow (parsedUrl.pos <= %len(parsedUrl.data)) and
        (parsedUrl.port.start = 0);
      select;
      when parsedUrl.pos = %len(parsedUrl.data) or
           f_containsStringAt(parsedUrl.data: parsedUrl.pos
                                            : cSTART_OF_FILE);
        if (parsedUrl.pos = %len(parsedUrl.data));
          parsedUrl.pos = parsedUrl.pos + 1;
        endif;

        parsedUrl.port.start  = itemStart;
        parsedUrl.port.length = parsedUrl.pos - itemStart;

        parsedUrl.port.baseStart   = baseStart;
        parsedUrl.port.totalLength = parsedUrl.pos - baseStart;

      when f_containsInvalidCharAt(parsedUrl.data: parsedUrl.pos
                                                 : '0123456789');
        // Stop parsing on invalid character
        o_rc = cURL_ERROR_INVALID_PORT_NUMBER;
        return parsedUrl;
      other;
        parsedUrl.pos = parsedUrl.pos + 1;
      endsl;
    enddo;
  endif;

  // Get file / path / query from URL
  //    File  :  path + query
  //    Path  :  path of the file without trailing parameters (query)
  //    Query :  parameters (query)
  if (parsedUrl.pos <= %len(parsedUrl.data));

    // Info: File = Path + Query
    parsedUrl.file.start  = parsedUrl.pos;
    parsedUrl.file.length = %len(parsedUrl.data) - parsedUrl.pos + 1;
    parsedUrl.file.baseStart   = parsedUrl.file.start;
    parsedUrl.file.totalLength = parsedUrl.file.length;

    parsedUrl.path = parsedUrl.file;

    dow (parsedUrl.pos <= %len(parsedUrl.data));
      if (f_containsStringAt(parsedUrl.data: parsedUrl.pos
                                           : cSTART_OF_QUERY));

        parsedUrl.path.length = parsedUrl.pos -
                                parsedUrl.path.start;
        parsedUrl.path.totalLength = parsedUrl.path.length;

        if (parsedUrl.pos < %len(parsedUrl.data));
          parsedUrl.query.start  = parsedUrl.pos + 1;
          parsedUrl.query.length = %len(parsedUrl.data) -
                                   parsedUrl.pos;
          parsedUrl.query.baseStart   = parsedUrl.query.start - 1;
          parsedUrl.query.totalLength = parsedUrl.query.length + 1;
        else;
          parsedUrl.query.start  = 0;
          parsedUrl.query.length = 0;
          parsedUrl.query.baseStart   = 0;
          parsedUrl.query.totalLength = 0;
        endif;

        leave;
      endif;

      parsedUrl.pos = parsedUrl.pos + 1;
    enddo;

  endif;

  parsedUrl.type = cHANDLE_TYPE;

  o_rc = 0;

  return parsedUrl;


end-proc;

//=========================================================================
//  Returns the sub-string defined by 'i_subString'.
//=========================================================================
dcl-proc getSubstring;
  dcl-pi *n varchar(512);
    i_string    varchar(512) const;
    i_subString likeds(substr_t) const;
  end-pi;

  //  Return value
  dcl-s string varchar(512) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_subString.start  > 0) and
     (i_subString.length > 0) and
     (%len(i_string) >= i_subString.start + i_subString.length - 1);
    string = %subst(i_string: i_subString.start: i_subString.length);
  else;
    string = '';
  endif;

  return string;


end-proc;

//=========================================================================
//  Breaks a given URL into the pieces: library, file and member
//=========================================================================
dcl-proc splittPath;
  dcl-pi *n ind opdesc;
    i_url    likeds(parsedUrl_t) const;
    i_dftObj char(256) options(*varsize) const;
    o_file   char(10);
    o_lib    char(10);
    o_obj    char(256) options(*varsize);
    o_rc     int(10);
  end-pi;

  //  Parameter positions
  dcl-c p_dftObj 2;
  dcl-c p_obj 5;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s path like(url_t) inz;
  dcl-s closingChar char(1) inz;

  dcl-s isError ind inz(cFalse);

  dcl-s dftObj like(i_dftObj) inz;
  dcl-s file like(o_file) inz;
  dcl-s lib like(o_lib) inz;
  dcl-s obj like(o_obj) inz;

  dcl-ds dftObjInf likeds(strInf_t) inz;
  dcl-ds objInf likeds(strInf_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CEEGSI(p_dftObj: dftObjInf.dataType
                 : dftObjInf.curlen
                 : dftObjInf.maxlen  : *omit);

  CEEGSI(p_obj: objInf.dataType
              : objInf.curlen
              : objInf.maxlen  : *omit);

  if (dftObjInf.curlen > 0);
    dftObj = %subst(i_dftObj: 1: dftObjInf.curlen);
  else;
    dftObj = '';
  endif;

  o_file = '';
  o_lib  = '';
  %subst(o_obj: 1 : objInf.curlen ) = '';
  o_rc   = 0;

  dou '1';

    path = f_ucase(%trim(Url_getPath(i_url: o_rc)));
    if (o_rc <> 0);
      isError = cTrue;
      leave;
    endif;

    // Get library name from path
    x = %scan('/': path);

    select;
    when x > 11;
      isError = cTrue;
      leave;
    when x > 1;
      lib = %subst(path: 1: x-1);
      if (x < %len(path));
        path = %subst(path: x+1);
      else;
        isError = cTrue;
        leave;
      endif;
    when x = 1;
      lib = '*LIBL';
      path = %subst(path: x+1);
    other;
      lib = '*LIBL';
    endsl;

    // Get file name from path
    x = %scan('(': path);
    if (x > 0);
      closingChar = ')';
    else;
      x = %scan('.': path);
      if (x > 0);
        closingChar = '';
      else;
        x = %len(path) + 1;
      endif;
    endif;

    select;
    when x > 11;
      isError = cTrue;
      leave;
    when x > 1;
      file = %subst(path: 1: x-1);
      if (x < %len(path));
        path = %subst(path: x+1);
      else;
        if (dftObj <> '');
          obj = dftObj;
        else;
          isError = cTrue;
        endif;
        leave;
      endif;
    when x = 1;
      isError = cTrue;
      leave;
    endsl;

    // Get member name from path
    if (closingChar = '');
      x = %len(path) + 1;
    else;
      x = %scan(closingChar: path);
      if (x = 0);
        isError = cTrue;
        leave;
      endif;
    endif;

    select;
    when x > 11;
      isError = cTrue;
      leave;
    when x > 1;
      obj = %subst(path: 1: x-1);
    other;
      isError = cTrue;
      leave;
    endsl;

  enddo;

  if (isError);
    o_rc = cURL_ERROR_INVALID_OBJECT_DATA;
    return cFalse;
  endif;

  o_file = file;
  o_lib  = lib;
  %subst(o_obj: 1 : objInf.curlen ) = obj;

  return cTrue;


end-proc;