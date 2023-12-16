      *=====================================================================*
      *  BASICS1RG  - SrvPgm: Basic Routines - BasicProperties              *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  06.05.2011                                              *
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
      *       >>PARM<< OPTION(*EVENTF);                                     *
      *       >>PARM<< TGTRLS(V7R3M0);                                      *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H NOMAIN
      *  Standard H-Specs w/o DECEDIT(...)
      /DEFINE NO_DECEDIT
      /COPY QBASICS1,H_SPEC
     H DECEDIT('0.')
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
     FPROPERTIESIF   F  512        DISK    usropn
     F                                     extfile(g_properties.file)
     F                                     extmbr(g_properties.name)
     F                                     infds(g_propsOpnInf)
      *
     D g_properties    DS                  qualified
     D  file                         21A   inz
     D  name                         10A   inz
      *
     D g_propsOpnInf   DS                  qualified
     D  rcdLength            125    126I 0
     D  sourceFile           163    163A
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RG
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D hProperties_t   DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  pMap                               like(BasicMap_handle_t)
     D  increment                    10I 0
     D  heapID                       10I 0
     D  memMgr                             likeds(MemoryManager_manager_t)
      *
     D readLine_line_t...
     D                 S           1024A   varying     based(pDummy)
      *
      * -----------------------------------------
      *  Imported Prototypes
      * -----------------------------------------
      /COPY QBASICS1,CLIB                          C-Prototypes
      /COPY QBASICS1,PBASICS1RC                    BasicMap
      *
     D property_t      DS                  qualified               based(pDummy)
     D  key                         512A   varying
     D  value                       512A   varying
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Reads a line from a given file descriptor.
     D readLine...
     D                 PR            10I 0        extproc('readLine')
     D  i_fd                         10I 0 const
     D  io_line                                   like(readLine_line_t)
     D  i_isFirstLine                  N   const
      *
      *  Test the specified buffer, splitts the buffer and adds the property
      *  to the property list.
     D retrieveAndAddPropertyToMap...
     D                 PR
     D                                            extproc('+
     D                                            retrieveAndAddPropertyToMap')
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_buffer                   4096A   const  varying  options(*varsize)
      *
      *  Adds the specified key and value to the map.
     D addPropertyToMap...
     D                 PR            10I 0
     D                                            extproc('+
     D                                            addPropertyToMap')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_property                         const  likeds(property_t      )
      *
      *  Returns the value that is associated to a given key
      *  from the specified map.
     D getStringFromMap...
     D                 PR              N
     D                                            extproc('+
     D                                            getStringFromMap')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D  o_string                                  like(property_t.value  )
      *
      *  Checks, whether a given handle is a valid properties handle, or not.
     D checkPropertiesHandle...
     D                 PR
     D                                            extproc('+
     D                                            checkPropertiesHandle')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Sends an ESCAPE message to signal an error condition.
     D signalError...
     D                 PR
     D                                            extproc('signalError')
     D  i_text                      128A   const  varying
     D  i_proc                      256A   const  varying
      *
      *  Send message to the job log.
     D sendToJobLog...
     D                 PR
     D                                            extproc('sendToJobLog')
     D  i_text                      512A   const  varying
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cHANDLE_TYPE_PROPERTIES...
     D                 C                   const(6689984643550298433)           =  *Props
     D cHANDLE_PROPERTIES_SIZE...
     D                 C                   const(%size(hProperties_t))
      *
     D cERROR_PROPERTIES_HANDLE_NULL...
     D                 C                   const('Properties handle is NULL')
     D cERROR_PROPERTIES_HANDLE_INVALID...
     D                 C                   const('Properties handle is invalid')
      *
     D BOOLEAN_FALSE...
     D                 C                   'false'
     D BOOLEAN_TRUE...
     D                 C                   'true'
     D BOOLEAN_0...
     D                 C                   '0'
     D BOOLEAN_1...
     D                 C                   '1'
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new BasicProperties.
      *=========================================================================
      *  Parameters:
      *   i_heapID       - ID of the heap that is used to allocate memory.
      *
      *  Returns:
      *   pProperties    - Returns the basing pointer of the properties on
      *                    success, else NULL.
      *=========================================================================
     P BasicProperties_new...
     P                 B                   export
      *
     D BasicProperties_new...
     D                 PI                         like(BasicProperties_handle_t)
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D pProperties     S                   like(BasicProperties_handle_t) inz
      *
      *  Parameter positions
     D p_increment     C                   const(1)
     D p_heapID        C                   const(1)
      *
      *  Fields for optional parameters
     D increment       S                   like(i_increment ) inz
     D heapID          S                   like(i_heapID    ) inz
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get values of optional parameters
         // ... i_increment
         if (%parms() >= p_increment and %addr(i_increment) <> *NULL);
            increment = i_increment;
         else;
            increment = 512;
         endif;

         // ... i_heapID
         if (%parms() >= p_heapID and %addr(i_heapID) <> *NULL);
            heapID = i_heapID;
         else;
            heapID = 0;
         endif;

         // Set memory manager
         mm_memMgr = MemoryManager_getDefaultManager();

         // Allocate memory for properties handle
         pProperties = mm_allocate(%size(hProperties_t): heapID);

         // Initialize properties handle
         clear hProperties;
         hProperties.intType   = cHANDLE_TYPE_PROPERTIES;
         hProperties.intSize   = %size(hProperties);
         hProperties.pMap      = BasicMap_new(increment: heapID);
         hProperties.increment = increment;
         hProperties.heapID    = heapID;
         hProperties.memMgr    = mm_memMgr;

         return pProperties;

      /END-FREE
      *
     P BasicProperties_new...
     P                 E
      *
      *=========================================================================
      *  Clones a given BasicProperties.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned by
      *                    BasicProperties_new().
      *
      *  Returns:
      *   pProperties   - Returns the basing pointer of the properies on
      *                   success, else NULL.
      *=========================================================================
     P BasicProperties_clone...
     P                 B                   export
      *
     D BasicProperties_clone...
     D                 PI                         like(BasicProperties_handle_t)
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D pPropertiesRtn  S                   like(BasicProperties_handle_t) inz
     D hPropertiesRtn  DS                  likeds(hProperties_t)
     D                                     based(pPropertiesRtn)
      *
      *  Local fields
     D x               S             10I 0 inz
     D numE            S             10I 0 inz
     D key             S                   like(BasicMap_key_t ) inz
     D size            S             10I 0 inz
     D pData           S               *   inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         // Create a new and empty properties
         pPropertiesRtn = BasicProperties_new(hProperties.increment);

         // Copy properties entries of embedded map
         numE = BasicMap_getNumE(hProperties.pMap);
         for x = 1 to numE;
            key   = BasicMap_getKeyByIndex(hProperties.pMap: x);
            pData = BasicMap_getValueByIndex(hProperties.pMap: x);
            size  = BasicMap_getSizeByIndex(hProperties.pMap: x);
            BasicMap_put(hPropertiesRtn.pMap: key: pData: size);
         endfor;

         return pPropertiesRtn;

      /END-FREE
      *
     P BasicProperties_clone...
     P                 E
      *
      *=========================================================================
      *  Load properties from a given physical file member.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *   i_file         - File that contains the member that contains the
      *                    properties.
      *   i_lib          - (optional) Library that contains the file.
      *   i_mbr          - (optional) Member that contains the properties.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_loadFromMember...
     P                 B                   export
      *
     D BasicProperties_loadFromMember...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_file                       10A   const  varying
     D  i_lib                        10A   const  varying
     D                                            options(*nopass: *omit)
     D  i_mbr                        10A   const  varying
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_lib           C                   const(3)
     D p_mbr           C                   const(4)
      *
      *  Fields for optional parameters
     D lib             S                   like(i_lib ) inz
     D mbr             S                   like(i_mbr ) inz
      *
      *  Local fields
     D length          S             10I 0 inz
     D warnLength      S               N   inz(cTrue)
      *
     D inBufMbr        DS                  qualified
     D  data                        512A
      *
     D inBufSrcMbr     DS                  qualified
     D  srcSeq                        6S 2
     D  srcDat                        6S 0
     D  srcDta                      500A
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         // Get values of optional parameters
         // ... i_lib
         if (%parms() >= p_lib and %addr(i_lib) <> *NULL);
            lib = i_lib;
         else;
            lib = '*LIBL';
         endif;

         // ... i_mbr
         if (%parms() >= p_mbr and %addr(i_mbr) <> *NULL);
            mbr = i_mbr;
         else;
            mbr = '*FIRST';
         endif;

         // Check library
         if (not f_startsWith('*': lib));
            if not f_exist(lib: *omit: '*LIB');
               sendToJobLog('Library ' + %trim(lib) + ' not found');
               return rc;
            endif;
         endif;

         // Check file
         if (not f_exist(i_file: lib: '*FILE'));
               sendToJobLog('File ' + %trim(i_file) +
                            ' in library ' + %trim(lib) + ' not found');
            return rc;
         endif;

         // Check member
         if not f_exist(i_file: lib: '*FILE': mbr);
               sendToJobLog('Member ' + %trim(mbr) +
                            ' of file ' + %trim(i_file) +
                            ' in library ' + %trim(lib) + ' not found');
            return rc;
         endif;

         // Open member
         g_properties.file = %trim(lib) + '/' + %trim(i_file);
         g_properties.name = mbr;

         open(E) PROPERTIES;
         if (%error());
            sendToJobLog('Could not open member ' + %trim(mbr) +
                         ' of file ' + %trim(i_file) +
                         ' in library ' + %trim(lib));
            return rc;
         endif;

         p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);

         // Load properties from member
         setll 1 PROPERTIES;
         dow %found(PROPERTIES);
            if (g_propsOpnInf.sourceFile = 'Y');
               read PROPERTIES inBufSrcMbr;
            else;
               read PROPERTIES inBufMbr;
            endif;

            if %eof(PROPERTIES);
               leave;
            endif;

            if (g_propsOpnInf.sourceFile = 'Y');
               length = g_propsOpnInf.rcdLength - (%size(inBufSrcMbr.SrcSeq) +
                                                   %size(inBufSrcMbr.SrcDat));
               retrieveAndAddPropertyToMap(
                     hProperties.pMap: %subst(inBufSrcMbr.srcDta: 1: length));
            else;
               if (g_propsOpnInf.rcdLength > %len(inBufMbr.data));
                  length = %len(inBufMbr.data);
                  if (not warnLength);
                     sendToJobLog('Record length of properties file +
                                   exceeded maximum of ' +
                                   %char(%len(inBufMbr.data)) + ' byte.');
                     warnLength = cTrue;
                  endif;
               else;
                  length = g_propsOpnInf.rcdLength;
               endif;
               retrieveAndAddPropertyToMap(
                     hProperties.pMap: %subst(inBufMbr.data: 1: length));
            endif;
         enddo;

         // Close member
         close PROPERTIES;

         rc = 0;

         return rc;

      /END-FREE
      *
     P BasicProperties_loadFromMember...
     P                 E
      *
      *=========================================================================
      *  Load properties from a given stream file.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *   i_stmf         - Stream file that contains the properties.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_loadFromStmf...
     P                 B                   export
      *
     D BasicProperties_loadFromStmf...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_stmf                     5000A   const  varying options(*varsize)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Local fields
     D fd              S             10I 0 inz
     D st_stat         DS                  likeds(st_stat_t      ) inz
     D line            S                   like(readLine_line_t  ) inz
     D isFirstLine     S               N   inz(cTrue)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         // Check stream file
         if (stat(%trim(i_stmf): %addr(st_stat)) = -1);
            sendToJobLog(
                  'File or directory ' + %trim(i_stmf) + ' does not exist');
            return rc;
         endif;

         // Open stream file
         monitor;
            fd = open(%trim(i_stmf): O_RDONLY + O_SHARE_RDONLY + O_TEXTDATA);
         on-error;
            sendToJobLog('Could not open stream file: ' + %trim(i_stmf));
            return rc;
         endmon;

         // Load properties from steam file
         isFirstLine = cTrue;
         dow (readLine(fd: line: isFirstLine) <> -1);
            retrieveAndAddPropertyToMap(hProperties.pMap: line);
            isFirstLine = cFalse;
         enddo;

         // Close member
         close PROPERTIES;

         rc = 0;

         return rc;

      /END-FREE
      *
     P BasicProperties_loadFromStmf...
     P                 E
      *
      *=========================================================================
      *  Removes the entry that is associated to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *   i_key          - Key of the entry that is removed from the list
      *                    of properties.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_remove...
     P                 B                   export
      *
     D BasicProperties_remove...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Local fields
     D  key            S                   like(i_key ) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         key = f_lcase(i_key);
         rc = BasicMap_remove(hProperties.pMap: key);

         return rc;

      /END-FREE
      *
     P BasicProperties_remove...
     P                 E
      *
      *=========================================================================
      *  Returns true if the list of properties contains a entry matching
      *  the specified key value.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *   i_key          - Key the list of properties is searched for.
      *
      *  Returns:
      *   isFound       - Returns TRUE is the list of properties contains an
      *                   entry matching the specified key, else FALSE.
      *=========================================================================
     P BasicProperties_containsKey...
     P                 B                   export
      *
     D BasicProperties_containsKey...
     D                 PI              N
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
      *
      *  Return value
     D isFound         S               N   inz(cFalse)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         isFound = BasicMap_containsKey(hProperties.pMap: i_key);

         return isFound;

      /END-FREE
      *
     P BasicProperties_containsKey...
     P                 E
      *
      *=========================================================================
      *  Returns the string that is associated to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key the list of properties is searched for.
      *
      *  Returns:
      *   string        - String value addressed by 'i_key'.
      *=========================================================================
     P BasicProperties_getString...
     P                 B                   export
      *
     D BasicProperties_getString...
     D                 PI          4096A          varying
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                  4096A   const  varying
     D                                            options(*nopass: *varsize)
      *
      *  Return value
     D string          S                   like(property_t.value ) inz
      *
      *  Parameter positions
     D p_default       C                   const(3)
      *
      *  Local fields
     D isFound         S               N   inz(cFalse)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         isFound = getStringFromMap(hProperties.pMap: i_key: string);
         if (not isFound and %parms() >= p_default);
            return i_default;
         endif;

         return string;

      /END-FREE
      *
     P BasicProperties_getString...
     P                 E
      *
      *=========================================================================
      *  Returns the integer value that is associated to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key the list of properties is searched for.
      *
      *  Returns:
      *   integer       - Integer value addressed by 'i_key'.
      *=========================================================================
     P BasicProperties_getInteger...
     P                 B                   export
      *
     D BasicProperties_getInteger...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                    10I 0 const  options(*nopass)
      *
      *  Return value
     D integer         S             10I 0 inz
      *
      *  Parameter positions
     D p_default       C                   const(3)
      *
      *  Local fields
     D string          S                   like(property_t.value ) inz
     D isFound         S               N   inz(cFalse)
      *
      *  Local constants
     D INT_LEN         C                   %len(integer)
     D INT_DECPOS      C                   %decpos(integer)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         isFound = getStringFromMap(hProperties.pMap: i_key: string);
         if (not isFound and %parms() >= p_default);
            return i_default;
         endif;

         if (string = '');   // Existing key but no value assigned to it.
            return 0;
         endif;

         integer = %dec(string: INT_LEN: INT_DECPOS);

         return integer;

      /END-FREE
      *
     P BasicProperties_getInteger...
     P                 E
      *
      *=========================================================================
      *  Returns the boolean value that is associated to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key the list of properties is searched for.
      *
      *  Returns:
      *   integer       - Boolean value addressed by 'i_key'.
      *=========================================================================
     P BasicProperties_getBoolean...
     P                 B                   export
      *
     D BasicProperties_getBoolean...
     D                 PI              N
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                      N   const  options(*nopass)
      *
      *  Return value
     D boolean         S               N   inz(cFalse)
      *
      *  Parameter positions
     D p_default       C                   const(3)
      *
      *  Local fields
     D string          S                   like(property_t.value ) inz
     D isFound         S               N   inz(cFalse)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         isFound = getStringFromMap(hProperties.pMap: i_key: string);
         if (not isFound and %parms() >= p_default);
            return i_default;
         endif;

         if (string = '');   // Existing key but no value assigned to it.
            return cFalse;
         endif;

         string = f_lcase(string);

         select;
         when (string = BOOLEAN_FALSE or string = BOOLEAN_0);
            boolean = cFalse;
         when (string = BOOLEAN_TRUE or string = BOOLEAN_1);
            boolean = cTrue;
         other;
            sendToJobLog('Invalid boolean value <' + string + '> +
                          associated to key <' + i_key + '>');
         endsl;

         return boolean;

      /END-FREE
      *
     P BasicProperties_getBoolean...
     P                 E
      *
      *=========================================================================
      *  Returns the decimal value that is associated to the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key the list of properties is searched for.
      *
      *  Returns:
      *   decimal       - Decimal value addressed by 'i_key'.
      *=========================================================================
     P BasicProperties_getDecimal...
     P                 B                   export
      *
     D BasicProperties_getDecimal...
     D                 PI                         like(BasicProperties_decVal_t)
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                          const  like(BasicProperties_decVal_t)
     D                                            options(*nopass)
      *
      *  Return value
     D decimal         S                   like(BasicProperties_decVal_t) inz
      *
      *  Parameter positions
     D p_default       C                   const(3)
      *
      *  Local fields
     D string          S                   like(property_t.value ) inz
     D isFound         S               N   inz(cFalse)
      *
      *  Local constants
     D DEC_LEN         C                   %len(BasicProperties_decVal_t)
     D DEC_DECPOS      C                   %decpos(BasicProperties_decVal_t)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         isFound = getStringFromMap(hProperties.pMap: i_key: string);
         if (not isFound and %parms() >= p_default);
            return i_default;
         endif;

         if (string = '');   // Existing key but no value assigned to it.
            return 0;
         endif;

         decimal = %dec(string: DEC_LEN: DEC_DECPOS);

         return decimal;

      /END-FREE
      *
     P BasicProperties_getDecimal...
     P                 E
      *
      *=========================================================================
      *  Associates the specified string value to a given key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key that is associated to the specified string value.
      *   i_string       - The string value that is associated to a given key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_putString...
     P                 B                   export
      *
     D BasicProperties_putString...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_string                   4096A   const  varying
     D                                            options(*varsize)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Local fields
     D property        DS                  likeds(property_t) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         property.key   = i_key;
         property.value = i_string;
         rc = addPropertyToMap(hProperties.pMap: property);

         return rc;

      /END-FREE
      *
     P BasicProperties_putString...
     P                 E
      *
      *=========================================================================
      *  Associates the specified integer value to a given key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key that is associated to the specified integer value.
      *   i_integer      - The integer value that is associated to a given key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_putInteger...
     P                 B                   export
      *
     D BasicProperties_putInteger...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_integer                    10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Local fields
     D property        DS                  likeds(property_t) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         property.key   = i_key;
         property.value = %char(i_integer);
         rc = addPropertyToMap(hProperties.pMap: property);

         return rc;

      /END-FREE
      *
     P BasicProperties_putInteger...
     P                 E
      *
      *=========================================================================
      *  Associates the specified boolean value to a given key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key that is associated to the specified integer value.
      *   i_boolean      - The boolean value that is associated to a given key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_putBoolean...
     P                 B                   export
      *
     D BasicProperties_putBoolean...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_boolean                      N   const
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Local fields
     D property        DS                  likeds(property_t) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         property.key   = i_key;

         if (i_boolean);
            property.value = BOOLEAN_TRUE;
         else;
            property.value = BOOLEAN_FALSE;
         endif;

         rc = addPropertyToMap(hProperties.pMap: property);

         return rc;

      /END-FREE
      *
     P BasicProperties_putBoolean...
     P                 E
      *
      *=========================================================================
      *  Associates the specified decimal value to a given key.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *   i_key          - Key that is associated to the specified decimal value.
      *   i_decimal      - The decimal value that is associated to a given key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_putDecimal...
     P                 B                   export
      *
      * TODO: think about how to change the return value to int(10)
      *       for know I think that is impossible without breaking
      *       backward compatibility
     D BasicProperties_putDecimal...
     D                 PI                         like(BasicProperties_decVal_t)
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_decimal                          const  like(BasicProperties_decVal_t)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D property        DS                  likeds(property_t) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         property.key   = i_key;

         property.value = %editc(i_decimal: 'P');
         x = %checkr('0': property.value);   // trim trailing '0'
         if (x < %len(property.value));
            %subst(property.value: x+1) = '';
         endif;

         property.value = %trim(property.value);
         rc = addPropertyToMap(hProperties.pMap: property);

         return rc;

      /END-FREE
      *
     P BasicProperties_putDecimal...
     P                 E
      *
      *=========================================================================
      *  Returns the number of key-value mappings in this properties list.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *
      *  Returns:
      *   numE          - NUmber of entries on success, else -1;
      *=========================================================================
     P BasicProperties_getNumE...
     P                 B                   export
      *
     D BasicProperties_getNumE...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D numE            S             10I 0 inz(-1)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         numE = BasicMap_getNumE(hProperties.pMap);

         return numE;

      /END-FREE
      *
     P BasicProperties_getNumE...
     P                 E
      *
      *=========================================================================
      *  Returns the heap ID of a given BasicProperties.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *
      *  Returns:
      *   numE          - NUmber of entries on success, else -1;
      *=========================================================================
     P BasicProperties_getHeapID...
     P                 B                   export
      *
     D BasicProperties_getHeapID...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D heapID          S             10I 0 inz(-1)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         heapID = BasicMap_getHeapID(hProperties.pMap);

         return heapID;

      /END-FREE
      *
     P BasicProperties_getHeapID...
     P                 E
      *
      *=========================================================================
      *  Removes all entries from a given properties list.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned   ew().
      *                    by BasicProperties_new().
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicProperties_clear...
     P                 B                   export
      *
     D BasicProperties_clear...
     D                 PI            10I 0
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         rc = BasicMap_clear(hProperties.pMap);

         return rc;

      /END-FREE
      *
     P BasicProperties_clear...
     P                 E
      *
      *=========================================================================
      *  Deletes a given BasicProperties.
      *=========================================================================
      *  Parameters:
      *   io_pProperties - Basing pointer of the properties as returned by
      *                    BasicProperties_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicProperties_delete...
     P                 B                   export
      *
     D BasicProperties_delete...
     D                 PI            10I 0
     D  io_pProperties...
     D                                            like(BasicProperties_handle_t)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Helper fields
     D x               S             10I 0 inz
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(io_pProperties)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(io_pProperties);

         dou 1=1;

            // Set memory manager
            mm_memMgr = hProperties.memMgr;

            // Delete underlaying BasicMap.
            BasicMap_delete(hProperties.pMap);

            // Clear properties handle
            clear hProperties;
            hProperties.intType       = 0;
            hProperties.intSize       = 0;
            hProperties.pMap          = BasicMap_null();
            hProperties.increment     = 0;
            hProperties.heapID        = 0;
            clear hProperties.memMgr;

            // Free memory of properties handle
            mm_free(io_pProperties);

            io_pProperties = BasicProperties_null();

         enddo;

         return rc;

      /END-FREE
      *
     P BasicProperties_delete...
     P                 E
      *
      *=========================================================================
      *  Returns a BasicProperties NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pProperties    - NULL handle of a BasicProperties.
      *=========================================================================
     P BasicProperties_null...
     P                 B                   export
      *
     D BasicProperties_null...
     D                 PI                         like(BasicProperties_handle_t)
      *
      *  Return value
     D pProperties     S                   like(BasicProperties_handle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pProperties = *NULL;

         return pProperties;

      /END-FREE
      *
     P BasicProperties_null...
     P                 E
      *
      *=========================================================================
      *  Checks a given BasicProperties handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *
      *  Returns:
      *   isNull         - Returns TRUE if the handle is null, else FALSE.
      *=========================================================================
     P BasicProperties_isNull...
     P                 B                   export
      *
     D BasicProperties_isNull...
     D                 PI              N
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D isNull          S               N   inz(cTrue)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_pProperties = BasicProperties_null());
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return isNull;

      /END-FREE
      *
     P BasicProperties_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns the list of key values from a given properties list.
      *=========================================================================
      *  Parameters:
      *   i_pProperties  - Basing pointer of the properties as returned
      *                    by BasicProperties_new().
      *
      *  Returns:
      *   pKeySet       - Handle of the key set.
      *=========================================================================
      *  Note:            Use BasicKeySet_delete() to delete the key set.
      *=========================================================================
     P BasicProperties_newKeySet...
     P                 B                   export
      *
     D BasicProperties_newKeySet...
     D                 PI                         like(BasicKeySet_handle_t)
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Return value
     D pKeySet         S                   like(BasicKeySet_handle_t) inz
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkPropertiesHandle(i_pProperties);

         pKeySet = BasicMap_newKeySet(hProperties.pMap);

         return pKeySet;

      /END-FREE
      *
     P BasicProperties_newKeySet...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks, whether a given handle is a valid properties handle, or not.
      *  Returns TRUE for a valid properties handle, else FALSE.
      *=========================================================================
     P checkPropertiesHandle...
     P                 B
      *
     D checkPropertiesHandle...
     D                 PI
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Properties handle
     D hProperties     DS                  likeds(hProperties_t)
     D                                     based(i_pProperties )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (BasicProperties_isNull(i_pProperties));
            signalError(cERROR_PROPERTIES_HANDLE_NULL: f_caller());
         endif;

         if (hProperties.intType <> cHANDLE_TYPE_PROPERTIES);
            signalError(cERROR_PROPERTIES_HANDLE_INVALID: f_caller());
         endif;

         if (hProperties.intSize <> cHANDLE_PROPERTIES_SIZE);
            signalError(cERROR_PROPERTIES_HANDLE_INVALID: f_caller());
         endif;

         return;

      /END-FREE
      *
     P checkPropertiesHandle...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Reads a line from a given file descriptor.
      *=========================================================================
     P readLine...
     P                 B
      *
     D readLine...
     D                 PI            10I 0
     D  i_fd                         10I 0 const
     D  io_line                                   like(readLine_line_t)
     D  i_isFirstLine                  N   const
      *
      *  Helper fields
     D rd              DS                  qualified static
     D  buffer                     4096A   inz
     D  pos                          10I 0 inz
     D  len                          10I 0 inz
     D  pChar                          *   inz
     D  lineFeed                      1A   inz(x'00')
      *
     D char            S              1A   based(rd.pChar)
     D isEndOfLine     S               N   inz(cFalse)
      *
     D line            DS                  qualified based(pLine)
     D  len                           5I 0
     D  data                       1024A
      *
     D MAX_LENGTH      C                   1024
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_isFirstLine);
            reset rd;
         endif;

         pLine = %addr(io_line);
         line.len = 0;

         dou (isEndOfLine);

            if (rd.pos >= rd.len);
               rd.pos = 0;
               rd.len = read(i_fd: %addr(rd.buffer): %size(rd.buffer));
               if (rd.len < 1);
                  return -1;
               endif;
               rd.pChar = %addr(rd.buffer);
            endif;

            if (rd.lineFeed = x'00' and (char = x'25' or char = x'0D'));
               rd.lineFeed = char;
            endif;

            if (char <> x'25' and char <> x'0D' and line.len < MAX_LENGTH);
               line.len = line.len + 1;
               %subst(line.data: line.len: 1) = char;
            endif;

            if (char = rd.lineFeed);
               isEndOfLine = cTrue;
            endif;

            rd.pChar = rd.pChar + 1;
            rd.pos   = rd.pos + 1;
         enddo;

         return line.len;

      /END-FREE
      *
     P readLine...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Test the specified buffer, splitts the buffer and adds the property
      *  to the property list.
      *=========================================================================
     P retrieveAndAddPropertyToMap...
     P                 B
      *
     D retrieveAndAddPropertyToMap...
     D                 PI
     D  i_pMap                             const  like(BasicMap_handle_t    )
     D  i_buffer                   4096A   const  varying  options(*varsize)
      *
      *  Helper fields
     D x               S             10I 0                    inz
     D char            S              1A                      inz
     D buffer          S                   like(i_buffer    ) inz
     D property        DS                  likeds(property_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         buffer = %trim(i_buffer);

         if buffer = '';
            return;
         endif;

         char   = %subst(buffer: 1: 1);

         if (char <> '#') and (char <> ';') and (char <> '!');
            x = %scan('=': buffer);
            if (x > 1) and (x < %len(buffer));
               property.key   = %trim(%subst(buffer: 1: x-1));
               property.value = %trim(%subst(buffer: x+1));
               addPropertyToMap(i_pMap: property);
            endif;
         endif;

         return;

      /END-FREE
      *
     P retrieveAndAddPropertyToMap...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Adds the specified key and value to the map.
      *=========================================================================
     P addPropertyToMap...
     P                 B
      *
     D addPropertyToMap...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_property                         const  likeds(property_t      )
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D  key            S                   like(i_property.key ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         key = f_lcase(i_property.key);
         rc = BasicMap_putString(i_pMap: key: i_property.value);

         return rc;

      /END-FREE
      *
     P addPropertyToMap...
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Returns the value that is associated to a given key
      *  from the specified map.
      *=========================================================================
     P getStringFromMap...
     P                 B
      *
     D getStringFromMap...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D  o_string                                  like(property_t.value  )
      *
      *  Helper fields
     D  key            S                   like(property_t.key ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         key = f_lcase(i_key);
         if (not BasicMap_containsKey(i_pMap: key));
            return cFalse;
         endif;

         o_string = BasicMap_getString(i_pMap: key);

         return cTrue;

      /END-FREE
      *
     P getStringFromMap...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sends an ESCAPE message to signal an error condition.
      *=========================================================================
     P signalError...
     P                 B
      *
     D signalError...
     D                 PI
     D  i_text                      128A   const  varying
     D  i_proc                      256A   const  varying
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg('CPF9898'
                        : 'BasicProperties: ERROR - ' + i_text
                        : cMsg_Escape: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: i_proc);

         return;

      /END-FREE
      *
     P signalError...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sends a DIAGNOSTIC message to the job log.
      *=========================================================================
     P sendToJobLog...
     P                 B
      *
     D sendToJobLog...
     D                 PI
     D  i_text                      512A   const  varying
      *
      *  Helper fields
     D proc            S            256A   varying inz
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         proc = f_caller();

         msg = f_newMsg('CPF9897'
                        : 'BasicProperties: WARNING - ' + i_text + '.'
                        : cMsg_Diag: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: proc);

         return;

      /END-FREE
      *
     P sendToJobLog...
     P                 E
      *
