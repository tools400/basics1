      *=====================================================================*
      *  BASICS1RC  - SrvPgm: Basic Routines - URL                          *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  20.12.2007                                              *
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
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
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
      /COPY QBASICS1,PBASICS1RD
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
      /COPY QBASICS1,FDURL
      *
      *  Parsed URL
     D parsedUrl_t...
     D                 DS           512    qualified               based(pDummy)
     D  type                         10A
     D  pos                           5U 0
     D  protocol                           likeds(substr_t)
     D  host                               likeds(substr_t)
     D  port                               likeds(substr_t)
     D  file                               likeds(substr_t)
     D  path                               likeds(substr_t)
     D  query                              likeds(substr_t)
     D  data                               like(url_t     )
      *
      *  For internal use only
     D substr_t...
     D                 DS                  qualified               based(pDummy)
     D  start                         5U 0
     D  length                        5U 0
     D  baseStart                     5U 0
     D  totalLength                   5U 0
      *
      * -----------------------------------------
      *  Imported Prototypes
      * -----------------------------------------
      /COPY QBASICS1,CEELIB
      *
      /COPY QBASICS1,PBASICS1R3
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Parses a given URL.
     D parseUrl...
     D                 PR                         likeds(parsedUrl_t )
     D  i_url                              const  like(url_t         )
     D  o_rc                         10I 0
      *
      *  Parsen Standard-URL
     D parseStandardUrl...
     D                 PR                         likeds(parsedUrl_t )
     D  i_parsedUrl                        const  likeds(parsedUrl_t )
     D  o_rc                         10I 0
      *
      *  Returns the sub-string defined by 'i_subString'.
     D getSubstring...
     D                 PR           512A          varying
     D  i_string                    512A   const  varying
     D  i_subString                        const  likeds(substr_t )
      *
      *  Breaks the path of a given URL into the pieces: library, file and member
     D splittPath...
     D                 PR              N   opdesc
     D  i_url                              const  likeds(parsedUrl_t )
     D  i_dftObj                    256A   const  options(*varsize)
     D  o_file                       10A
     D  o_lib                        10A
     D  o_obj                       256A          options(*varsize)
     D  o_rc                         10I 0
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
     D cEND_OF_PROTOCOL...
     D                 C                   const(':')
     D cSTART_OF_HOST...
     D                 C                   const('//')
     D cSTART_OF_FILE...
     D                 C                   const('/')
     D cSTART_OF_PORT...
     D                 C                   const(':')
     D cSTART_OF_QUERY...
     D                 C                   const('?')
     D cHANDLE_TYPE...
     D                 C                   const('*URL')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new Url.
      *=========================================================================
      *  Parameters:
      *   i_url         - The string representation of a Url.
      *
      *  Returns:
      *   parsedUrl     - A parsed Url.
      *=========================================================================
     P Url_new...
     P                 B                   export
      *
     D Url_new...
     D                 PI                         like(url_t )
     D  i_url                              const  like(url_t )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_new...
     P                 E
      *
      *=========================================================================
      *  Returns the protocol of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   protocol      - The protocol of the URL.
      *=========================================================================
     P Url_getProtocol...
     P                 B                   export
      *
     D Url_getProtocol...
     D                 PI                         like(url_t )
     D  i_url                              const  like(url_t )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D protocol        S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getProtocol...
     P                 E
      *
      *=========================================================================
      *  Sets the protocol of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_protocol    - The protocol of the URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the protocol could be set,
      *                   else cFalse.
      *=========================================================================
     P Url_setProtocol...
     P                 B                   export
      *
     D Url_setProtocol...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_protocol                         const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpProtocol     S                   like(i_protocol    ) inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setProtocol...
     P                 E
      *
      *=========================================================================
      *  Returns the host name of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   host          - The host name of the URL.
      *=========================================================================
     P Url_getHost...
     P                 B                   export
      *
     D Url_getHost...
     D                 PI                         like(url_t    )
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D host            S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getHost...
     P                 E
      *
      *=========================================================================
      *  Sets the host name of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_host        - The name of the host.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the host name could be set,
      *                   else cFalse.
      *=========================================================================
     P Url_setHost...
     P                 B                   export
      *
     D Url_setHost...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_host                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpHost         S                   like(i_host        ) inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setHost...
     P                 E
      *
      *=========================================================================
      *  Returns the port of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   port          - The port of the URL.
      *=========================================================================
     P Url_getPort...
     P                 B                   export
      *
     D Url_getPort...
     D                 PI            10I 0
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D port            S             10I 0 inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getPort...
     P                 E
      *
      *=========================================================================
      *  Sets the port number of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_port        - The port number.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the port number could be set,
      *                   else cFalse.
      *=========================================================================
     P Url_setPort...
     P                 B                   export
      *
     D Url_setPort...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_port                       10I 0 const
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpPort         S             30A   varying              inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setPort...
     P                 E
      *
      *=========================================================================
      *  Returns the path of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   path          - The path of the URL. The path of a URL is the
      *                   file name without the query parameters.
      *=========================================================================
     P Url_getPath...
     P                 B                   export
      *
     D Url_getPath...
     D                 PI                         like(url_t    )
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D path            S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getPath...
     P                 E
      *
      *=========================================================================
      *  Sets the path of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_path        - The path. The path of a URL is the file name
      *                   without the query parameters.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the path could be set, else cFalse.
      *=========================================================================
     P Url_setPath...
     P                 B                   export
      *
     D Url_setPath...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_path                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setPath...
     P                 E
      *
      *=========================================================================
      *  Returns the file of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   file          - The file of the URL. The file of a URL is everything
      *                   behind the host name (and port number).
      *=========================================================================
     P Url_getFile...
     P                 B                   export
      *
     D Url_getFile...
     D                 PI                         like(url_t    )
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D file            S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getFile...
     P                 E
      *
      *=========================================================================
      *  Sets the file of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_file        - The file. The file of a URL is everything behind the
      *                   hostname (and port number).
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the file could be set, else cFalse.
      *=========================================================================
     P Url_setFile...
     P                 B                   export
      *
     D Url_setFile...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_file                             const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setFile...
     P                 E
      *
      *=========================================================================
      *  Returns the query part of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   query         - The query part of the URL.
      *=========================================================================
     P Url_getQuery...
     P                 B                   export
      *
     D Url_getQuery...
     D                 PI                         like(url_t    )
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D query           S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getQuery...
     P                 E
      *
      *=========================================================================
      *  Sets the query part of a given URL.
      *=========================================================================
      *  Parameters:
      *   io_url        - The URL.
      *   i_query       - The query part of the URL.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isSet         - Returns cTrue if the query part could be set,
      *                   else cFalse.
      *=========================================================================
     P Url_setQuery...
     P                 B                   export
      *
     D Url_setQuery...
     D                 PI              N
     D  io_url                                    like(url_t )
     D  i_query                            const  like(url_t ) options(*varsize)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_rc            C                   3
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D tmpQuery        S                   like(i_query       ) inz
     D tmpUrl          S                   like(io_URL        ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_setQuery...
     P                 E
      *
      *=========================================================================
      *  Returns the string representation of a given URL.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *
      *  Returns:
      *   string        - The string representation of the URL.
      *=========================================================================
     P Url_toString...
     P                 B                   export
      *
     D Url_toString...
     D                 PI           512A          varying
     D  i_url                              const  like(url_t    )
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Return value
     D string          S                   like(url_t ) inz
      *
      *  Parameter positions
     D p_rc            C                   2
      *
      *  Fields for optional parameters
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_toString...
     P                 E
      *
      *=========================================================================
      *  Returns the library, file and member of a URL of type 'mbr'.
      *=========================================================================
      *  Parameters:
      *   i_url         - The URL.
      *   o_file        - The file name of a URL of type 'mbr'.
      *   o_lib         - The library name of a URL of type 'mbr'.
      *   o_mbr         - The member name of a URL of type 'mbr'.
      *   o_rc          - Return code. 0 = no errror.
      *
      *  Returns:
      *   isOK          - Returns cTrue on success, else cFalse.
      *=========================================================================
     P Url_getMbr...
     P                 B                   export
      *
     D Url_getMbr...
     D                 PI              N
     D  i_url                              const  like(url_t    )
     D  o_file                       10A          options(*nopass: *omit)
     D  o_lib                        10A          options(*nopass: *omit)
     D  o_mbr                        10A          options(*nopass: *omit)
     D  o_rc                         10I 0        options(*nopass: *omit)
      *
      *  Funktionswert
     D isDone          S               N   inz(cFalse)
      *
      *  Parameterpositionen
     D p_file          C                   const(2)
     D p_lib           C                   const(3)
     D p_mbr           C                   const(4)
     D p_rc            C                   const(5)
      *
      *  Felder f�r optionale Parameter
     D file            S                   like(o_file   ) inz
     D lib             S                   like(o_lib    ) inz
     D mbr             S                   like(o_mbr    ) inz
     D rc              S                   like(o_rc     ) inz
      *
      *  Lokale Arbeitsfelder
     D isPresent       S             10I 0 inz
     D protocol        S                   like(url_t         ) inz
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P Url_getMbr...
     P                 E
      *
      *=========================================================================
      *  Parses a given URL.
      *=========================================================================
     P parseUrl...
     P                 B
      *
     D parseUrl...
     D                 PI                         likeds(parsedUrl_t )
     D  i_url                              const  like(url_t         )
     D  o_rc                         10I 0
      *
      *  Return value
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      *
      *  Helper fields
     D itemStart       S             10I 0 inz
     D protocol        S             20A   varying inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P parseUrl...
     P                 E
      *
      *=========================================================================
      *  Parsen Standard-URL
      *=========================================================================
     P parseStandardUrl...
     P                 B
      *
     D parseStandardUrl...
     D                 PI                         likeds(parsedUrl_t )
     D  i_parsedUrl                        const  likeds(parsedUrl_t )
     D  o_rc                         10I 0
      *
      *  Funktionswert
     D parsedUrl       DS                  likeds(parsedUrl_t ) inz
      *
      *  Lokale Arbeitsfelder
     D baseStart       S             10I 0 inz
     D itemStart       S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P parseStandardUrl...
     P                 E
      *
      *=========================================================================
      *  Returns the sub-string defined by 'i_subString'.
      *=========================================================================
     P getSubstring...
     P                 B
      *
     D getSubstring...
     D                 PI           512A          varying
     D  i_string                    512A   const  varying
     D  i_subString                        const  likeds(substr_t )
      *
      *  Return value
     D string          S            512A   varying inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_subString.start  > 0) and
            (i_subString.length > 0) and
            (%len(i_string) >= i_subString.start + i_subString.length - 1);
            string = %subst(i_string: i_subString.start: i_subString.length);
         else;
            string = '';
         endif;

         return string;

      /END-FREE
      *
     P getSubstring...
     P                 E
      *
      *=========================================================================
      *  Breaks a given URL into the pieces: library, file and member
      *=========================================================================
     P splittPath...
     P                 B
      *
     D splittPath...
     D                 PI              N   opdesc
     D  i_url                              const  likeds(parsedUrl_t )
     D  i_dftObj                    256A   const  options(*varsize)
     D  o_file                       10A
     D  o_lib                        10A
     D  o_obj                       256A          options(*varsize)
     D  o_rc                         10I 0
      *
      *  Parameter positions
     D p_dftObj        C                   const(2)
     D p_obj           C                   const(5)
      *
      *  Helper fields
     D x               S             10I 0 inz
     D path            S                   like(url_t    ) inz
     D closingChar     S              1A   inz
      *
     D isError         S               N   inz(cFalse)
      *
     D dftObj          S                   like(i_dftObj ) inz
     D file            S                   like(o_file   ) inz
     D lib             S                   like(o_lib    ) inz
     D obj             S                   like(o_obj    ) inz
      *
     D dftObjInf       DS                  likeds(strInf_t) inz
     D objInf          DS                  likeds(strInf_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P splittPath...
     P                 E
      *
