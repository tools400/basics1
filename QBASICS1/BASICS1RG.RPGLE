**free
//=====================================================================*
//  BASICS1RG  - SrvPgm: Basic Routines - BasicProperties              *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  06.05.2011                                              *
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
//  Standard H-Specs w/o DECEDIT(...)
/define NO_DECEDIT
/copy QBASICS1,H_SPEC
ctl-opt decedit('0.');
/copy QBASICS1,COPYRIGHT
//=====================================================================*
dcl-f PROPERTIES disk(512) usropn extfile(g_properties.file) extmbr(g_properties.name)
  infds(g_propsOpnInf);

dcl-ds g_properties qualified;
  file char(21) inz;
  name char(10) inz;
end-ds;

dcl-ds g_propsOpnInf qualified;
  rcdLength  int(5) pos(125);
  sourceFile char(1) pos(163);
end-ds;

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1RG

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

dcl-ds hProperties_t qualified based(pDummy) align;
  intType   uns(20);
  intSize   uns(10);
  pMap      like(BasicMap_handle_t);
  increment int(10);
  heapID    int(10);
  memMgr    likeds(MemoryManager_manager_t);
end-ds;

dcl-s readLine_line_t varchar(1024) based(pDummy);

// -----------------------------------------
//  Imported Prototypes
// -----------------------------------------
/copy QBASICS1,CLIB                          C-Prototypes
/copy QBASICS1,PBASICS1RC                    BasicMap

dcl-ds property_t qualified based(pDummy);
  key   varchar(512);
  value varchar(512);
end-ds;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Reads a line from a given file descriptor.
dcl-pr readLine int(10) extproc('readLine');
  i_fd          int(10) const;
  io_line       like(readLine_line_t);
  i_isFirstLine ind const;
end-pr;

//  Test the specified buffer, splitts the buffer and adds the property
//  to the property list.
dcl-pr retrieveAndAddPropertyToMap extproc('retrieveAndAddPropertyToMap');
  i_pMap   like(BasicMap_handle_t) const;
  i_buffer varchar(4096) options(*varsize) const;
end-pr;

//  Adds the specified key and value to the map.
dcl-pr addPropertyToMap int(10) extproc('addPropertyToMap');
  i_pMap     like(BasicMap_handle_t) const;
  i_property likeds(property_t) const;
end-pr;

//  Returns the value that is associated to a given key
//  from the specified map.
dcl-pr getStringFromMap ind extproc('getStringFromMap');
  i_pMap   like(BasicMap_handle_t) const;
  i_key    like(BasicMap_key_t) const;
  o_string like(property_t.value);
end-pr;

//  Checks, whether a given handle is a valid properties handle, or not.
dcl-pr checkPropertiesHandle extproc('checkPropertiesHandle');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Sends an ESCAPE message to signal an error condition.
dcl-pr signalError extproc('signalError');
  i_text varchar(128) const;
  i_proc varchar(256) const;
end-pr;

//  Send message to the job log.
dcl-pr sendToJobLog extproc('sendToJobLog');
  i_text varchar(512) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cHANDLE_TYPE_PROPERTIES 6689984643550298433; // =  *Props
dcl-c cHANDLE_PROPERTIES_SIZE %size(hProperties_t);

dcl-c cERROR_PROPERTIES_HANDLE_NULL 'Properties handle is NULL';
dcl-c cERROR_PROPERTIES_HANDLE_INVALID 'Properties handle is invalid';

dcl-c BOOLEAN_FALSE 'false';
dcl-c BOOLEAN_TRUE 'true';
dcl-c BOOLEAN_0 '0';
dcl-c BOOLEAN_1 '1';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Creates a new BasicProperties.
//=========================================================================
//  Parameters:
//   i_heapID       - ID of the heap that is used to allocate memory.
//
//  Returns:
//   pProperties    - Returns the basing pointer of the properties on
//                    success, else NULL.
//=========================================================================
dcl-proc BasicProperties_new export;
  dcl-pi *n like(BasicProperties_handle_t);
    i_increment uns(10) options(*nopass: *omit) const;
    i_heapID    int(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s pProperties like(BasicProperties_handle_t) inz;

  //  Parameter positions
  dcl-c p_increment 1;
  dcl-c p_heapID 1;

  //  Fields for optional parameters
  dcl-s increment like(i_increment) inz;
  dcl-s heapID like(i_heapID) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Clones a given BasicProperties.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned by
//                    BasicProperties_new().
//
//  Returns:
//   pProperties   - Returns the basing pointer of the properies on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicProperties_clone export;
  dcl-pi *n like(BasicProperties_handle_t);
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s pPropertiesRtn like(BasicProperties_handle_t) inz;
  dcl-ds hPropertiesRtn likeds(hProperties_t) based(pPropertiesRtn);

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s numE int(10) inz;
  dcl-s key like(BasicMap_key_t) inz;
  dcl-s size int(10) inz;
  dcl-s pData pointer inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Load properties from a given physical file member.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//   i_file         - File that contains the member that contains the
//                    properties.
//   i_lib          - (optional) Library that contains the file.
//   i_mbr          - (optional) Member that contains the properties.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_loadFromMember export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_file        varchar(10) const;
    i_lib         varchar(10) options(*nopass: *omit) const;
    i_mbr         varchar(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Parameter positions
  dcl-c p_lib 3;
  dcl-c p_mbr 4;

  //  Fields for optional parameters
  dcl-s lib like(i_lib) inz;
  dcl-s mbr like(i_mbr) inz;

  //  Local fields
  dcl-s length int(10) inz;
  dcl-s warnLength ind inz(cTrue);

  dcl-ds inBufMbr qualified;
    data char(512);
  end-ds;

  dcl-ds inBufSrcMbr qualified;
    srcSeq zoned(6: 2);
    srcDat zoned(6);
    srcDta char(500);
  end-ds;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Load properties from a given stream file.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//   i_stmf         - Stream file that contains the properties.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_loadFromStmf export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_stmf        varchar(5000) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Local fields
  dcl-s fd int(10) inz;
  dcl-ds st_stat likeds(st_stat_t) inz;
  dcl-s line like(readLine_line_t) inz;
  dcl-s isFirstLine ind inz(cTrue);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Removes the entry that is associated to the specified key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//   i_key          - Key of the entry that is removed from the list
//                    of properties.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_remove export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Local fields
  dcl-s key like(i_key) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  key = f_lcase(i_key);
  rc = BasicMap_remove(hProperties.pMap: key);

  return rc;


end-proc;

//=========================================================================
//  Returns true if the list of properties contains a entry matching
//  the specified key value.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//   i_key          - Key the list of properties is searched for.
//
//  Returns:
//   isFound       - Returns TRUE is the list of properties contains an
//                   entry matching the specified key, else FALSE.
//=========================================================================
dcl-proc BasicProperties_containsKey export;
  dcl-pi *n ind;
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s isFound ind inz(cFalse);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  isFound = BasicMap_containsKey(hProperties.pMap: i_key);

  return isFound;


end-proc;

//=========================================================================
//  Returns the string that is associated to the specified key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key the list of properties is searched for.
//
//  Returns:
//   string        - String value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicProperties_getString export;
  dcl-pi *n varchar(4096);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_default     varchar(4096) options(*nopass: *varsize) const;
  end-pi;

  //  Return value
  dcl-s string like(property_t.value) inz;

  //  Parameter positions
  dcl-c p_default 3;

  //  Local fields
  dcl-s isFound ind inz(cFalse);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  isFound = getStringFromMap(hProperties.pMap: i_key: string);
  if (not isFound and %parms() >= p_default);
    return i_default;
  endif;

  return string;


end-proc;

//=========================================================================
//  Returns the integer value that is associated to the specified key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key the list of properties is searched for.
//
//  Returns:
//   integer       - Integer value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicProperties_getInteger export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_default     int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s integer int(10) inz;

  //  Parameter positions
  dcl-c p_default 3;

  //  Local fields
  dcl-s string like(property_t.value) inz;
  dcl-s isFound ind inz(cFalse);

  //  Local constants
  dcl-c INT_LEN %len(integer);
  dcl-c INT_DECPOS %decpos(integer);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the boolean value that is associated to the specified key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key the list of properties is searched for.
//
//  Returns:
//   integer       - Boolean value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicProperties_getBoolean export;
  dcl-pi *n ind;
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_default     ind options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s boolean ind inz(cFalse);

  //  Parameter positions
  dcl-c p_default 3;

  //  Local fields
  dcl-s string like(property_t.value) inz;
  dcl-s isFound ind inz(cFalse);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the decimal value that is associated to the specified key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key the list of properties is searched for.
//
//  Returns:
//   decimal       - Decimal value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicProperties_getDecimal export;
  dcl-pi *n like(BasicProperties_decVal_t);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_default     like(BasicProperties_decVal_t) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s decimal like(BasicProperties_decVal_t) inz;

  //  Parameter positions
  dcl-c p_default 3;

  //  Local fields
  dcl-s string like(property_t.value) inz;
  dcl-s isFound ind inz(cFalse);

  //  Local constants
  dcl-c DEC_LEN %len(BasicProperties_decVal_t);
  dcl-c DEC_DECPOS %decpos(BasicProperties_decVal_t);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Associates the specified string value to a given key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key that is associated to the specified string value.
//   i_string       - The string value that is associated to a given key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_putString export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_string      varchar(4096) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Local fields
  dcl-ds property likeds(property_t) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  property.key   = i_key;
  property.value = i_string;
  rc = addPropertyToMap(hProperties.pMap: property);

  return rc;


end-proc;

//=========================================================================
//  Associates the specified integer value to a given key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key that is associated to the specified integer value.
//   i_integer      - The integer value that is associated to a given key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_putInteger export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_integer     int(10) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Local fields
  dcl-ds property likeds(property_t) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  property.key   = i_key;
  property.value = %char(i_integer);
  rc = addPropertyToMap(hProperties.pMap: property);

  return rc;


end-proc;

//=========================================================================
//  Associates the specified boolean value to a given key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key that is associated to the specified integer value.
//   i_boolean      - The boolean value that is associated to a given key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_putBoolean export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_boolean     ind const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Local fields
  dcl-ds property likeds(property_t) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  property.key   = i_key;

  if (i_boolean);
    property.value = BOOLEAN_TRUE;
  else;
    property.value = BOOLEAN_FALSE;
  endif;

  rc = addPropertyToMap(hProperties.pMap: property);

  return rc;


end-proc;

//=========================================================================
//  Associates the specified decimal value to a given key.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//   i_key          - Key that is associated to the specified decimal value.
//   i_decimal      - The decimal value that is associated to a given key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_putDecimal export;

  // TODO: think about how to change the return value to int(10)
  //       for know I think that is impossible without breaking
  //       backward compatibility
  dcl-pi *n like(BasicProperties_decVal_t);
    i_pProperties like(BasicProperties_handle_t) const;
    i_key         like(BasicMap_key_t) options(*varsize) const;
    i_decimal     like(BasicProperties_decVal_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-ds property likeds(property_t) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the number of key-value mappings in this properties list.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//
//  Returns:
//   numE          - NUmber of entries on success, else -1;
//=========================================================================
dcl-proc BasicProperties_getNumE export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s numE int(10) inz(-1);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  numE = BasicMap_getNumE(hProperties.pMap);

  return numE;


end-proc;

//=========================================================================
//  Returns the heap ID of a given BasicProperties.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//
//  Returns:
//   numE          - NUmber of entries on success, else -1;
//=========================================================================
dcl-proc BasicProperties_getHeapID export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s heapID int(10) inz(-1);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  heapID = BasicMap_getHeapID(hProperties.pMap);

  return heapID;


end-proc;

//=========================================================================
//  Removes all entries from a given properties list.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned   ew().
//                    by BasicProperties_new().
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicProperties_clear export;
  dcl-pi *n int(10);
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  rc = BasicMap_clear(hProperties.pMap);

  return rc;


end-proc;

//=========================================================================
//  Deletes a given BasicProperties.
//=========================================================================
//  Parameters:
//   io_pProperties - Basing pointer of the properties as returned by
//                    BasicProperties_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicProperties_delete export;
  dcl-pi *n int(10);
    io_pProperties like(BasicProperties_handle_t);
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s x int(10) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(io_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns a BasicProperties NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pProperties    - NULL handle of a BasicProperties.
//=========================================================================
dcl-proc BasicProperties_null export;
  dcl-pi *n like(BasicProperties_handle_t);
  end-pi;

  //  Return value
  dcl-s pProperties like(BasicProperties_handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pProperties = *NULL;

  return pProperties;


end-proc;

//=========================================================================
//  Checks a given BasicProperties handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//
//  Returns:
//   isNull         - Returns TRUE if the handle is null, else FALSE.
//=========================================================================
dcl-proc BasicProperties_isNull export;
  dcl-pi *n ind;
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(cTrue);

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pProperties = BasicProperties_null());
    isNull = cTrue;
  else;
    isNull = cFalse;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  Returns the list of key values from a given properties list.
//=========================================================================
//  Parameters:
//   i_pProperties  - Basing pointer of the properties as returned
//                    by BasicProperties_new().
//
//  Returns:
//   pKeySet       - Handle of the key set.
//=========================================================================
//  Note:            Use BasicKeySet_delete() to delete the key set.
//=========================================================================
dcl-proc BasicProperties_newKeySet export;
  dcl-pi *n like(BasicKeySet_handle_t);
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Return value
  dcl-s pKeySet like(BasicKeySet_handle_t) inz;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkPropertiesHandle(i_pProperties);

  pKeySet = BasicMap_newKeySet(hProperties.pMap);

  return pKeySet;


end-proc;

//=========================================================================
//  *** private ***
//  Checks, whether a given handle is a valid properties handle, or not.
//  Returns TRUE for a valid properties handle, else FALSE.
//=========================================================================
dcl-proc checkPropertiesHandle;
  dcl-pi *n;
    i_pProperties like(BasicProperties_handle_t) const;
  end-pi;

  //  Properties handle
  dcl-ds hProperties likeds(hProperties_t) based(i_pProperties);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Reads a line from a given file descriptor.
//=========================================================================
dcl-proc readLine;
  dcl-pi *n int(10);
    i_fd          int(10) const;
    io_line       like(readLine_line_t);
    i_isFirstLine ind const;
  end-pi;

  //  Helper fields
  dcl-ds rd qualified static;
    buffer   char(4096) inz;
    pos      int(10) inz;
    len      int(10) inz;
    pChar    pointer inz;
    lineFeed char(1) inz(x'00');
  end-ds;

  dcl-s char char(1) based(rd.pChar);
  dcl-s isEndOfLine ind inz(cFalse);

  dcl-ds line qualified based(pLine);
    len  int(5);
    data char(1024);
  end-ds;

  dcl-c MAX_LENGTH 1024;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Test the specified buffer, splitts the buffer and adds the property
//  to the property list.
//=========================================================================
dcl-proc retrieveAndAddPropertyToMap;
  dcl-pi *n;
    i_pMap   like(BasicMap_handle_t) const;
    i_buffer varchar(4096) options(*varsize) const;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s char char(1) inz;
  dcl-s buffer like(i_buffer) inz;
  dcl-ds property likeds(property_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  *** Private ***
//  Adds the specified key and value to the map.
//=========================================================================
dcl-proc addPropertyToMap;
  dcl-pi *n int(10);
    i_pMap     like(BasicMap_handle_t) const;
    i_property likeds(property_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-s key like(i_property.key) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  key = f_lcase(i_property.key);
  rc = BasicMap_putString(i_pMap: key: i_property.value);

  return rc;


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the value that is associated to a given key
//  from the specified map.
//=========================================================================
dcl-proc getStringFromMap;
  dcl-pi *n ind;
    i_pMap   like(BasicMap_handle_t) const;
    i_key    like(BasicMap_key_t) const;
    o_string like(property_t.value);
  end-pi;

  //  Helper fields
  dcl-s key like(property_t.key) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  key = f_lcase(i_key);
  if (not BasicMap_containsKey(i_pMap: key));
    return cFalse;
  endif;

  o_string = BasicMap_getString(i_pMap: key);

  return cTrue;


end-proc;

//=========================================================================
//  *** private ***
//  Sends an ESCAPE message to signal an error condition.
//=========================================================================
dcl-proc signalError;
  dcl-pi *n;
    i_text varchar(128) const;
    i_proc varchar(256) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg('CPF9898'
                 : 'BasicProperties: ERROR - ' + i_text
                 : cMsg_Escape: 'QCPFMSG': '*LIBL');
  f_sndPgmMsg(msg: cMsg_Same: i_proc);

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Sends a DIAGNOSTIC message to the job log.
//=========================================================================
dcl-proc sendToJobLog;
  dcl-pi *n;
    i_text varchar(512) const;
  end-pi;

  //  Helper fields
  dcl-s proc varchar(256) inz;
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc = f_caller();

  msg = f_newMsg('CPF9897'
                 : 'BasicProperties: WARNING - ' + i_text + '.'
                 : cMsg_Diag: 'QCPFMSG': '*LIBL');
  f_sndPgmMsg(msg: cMsg_Same: proc);

  return;


end-proc;