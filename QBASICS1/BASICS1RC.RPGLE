**free
//=====================================================================*
//  BASICS1RC  - SrvPgm: Basic Routines - BasicMap                     *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  09.06.2004                                              *
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
//  08.11.2007  Th.Raddatz    Added procedures:                        *
//                            BasicMap_getSizeByIndex()                *
//                            BasicMap_putString()                     *
//                            BasicMap_getString()                     *
//                                                                     *
//  05.12.2007  Th.Raddatz    Added procedures:                        *
//                            BasicMap_putInteger()                    *
//                            BasicMap_getInteger()                    *
//                                                                     *
//  14.12.2007  Th.Raddatz    Added assert() to BasicMap_put() to      *
//                            ensure that key length is greater 0.     *
//                                                                     *
//  25.02.2008  Th.Raddatz    Fixed memory leak. BasicMap_remove()     *
//                            did remove the map entry from the        *
//                            underlaying list but did not free the    *
//                            memory allocted for that map entry.      *
//                                                                     *
//  24.04.2008  Th.Raddatz    Introduced a real map handle (hMap_t).   *
//                                                                     *
//  28.04.2008  Th.Raddatz    Check type of map handle and send an     *
//                            ESCAPE message for invalid handles.      *
//                            Added procedures:                        *
//                               BasicMap_KeySet_new()                 *
//                               BasicMap_KeySet_getFirst()            *
//                               BasicMap_KeySet_getNext()             *
//                               BasicMap_KeySet_delete()              *
//                                                                     *
//  14.05.2008  Th.Raddatz    Enabled BasicMap_KeySet_new() to be      *
//                            called more than once. Introduced        *
//                            counter to keep track of the number of   *
//                            references. (hMap.keySetNumRef)          *
//                                                                     *
//  27.05.2008  Th.Raddatz    Added procedures:                        *
//                               BasicMap_clone()                      *
//                            Enabled BasicMap to store NULL data.     *
//                                                                     *
//  09.05.2011  Th.Raddatz    Renamed the KeySet procedures and        *
//                            type templates to:                       *
//                               BasicMap_newKeySet()                  *
//                               BasicKeySet_getFirst()                *
//                               BasicKeySet_getNext()                 *
//                               BasicKeySet_delete()                  *
//                               BasicKeySet_handle_t                  *
//                                                                     *
//  11.08.2019  Th.Raddatz    Fixed 'index out of range' check in      *
//                              BasicMap_getSizeByIndex()              *
//                              BasicMap_getKeyByIndex()               *
//                              BasicMap_getValueByIndex()             *
//                            Special thanks to Ch. Bach for           *
//                            reporting these errors.                  *
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
ctl-opt bnddir('QC2LE');
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1RC

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

dcl-ds hMap_t qualified based(pDummy) align;
  intType       uns(20);
  intSize       uns(10);
  pList         like(BasicList_handle_t);
  pKeySet       like(BasicList_handle_t);
  keySetRefList pointer dim(64);
  keySetNumRef  int(10);
  increment     int(10);
  heapID        int(10);
  memMgr        likeds(MemoryManager_manager_t);
end-ds;

dcl-ds hKeySet_t qualified based(pDummy) align;
  intType uns(20);
  intSize uns(10);
  x       int(10);
  pMap    like(BasicMap_handle_t);
end-ds;

dcl-ds mapE_t qualified;
  pKey  pointer;
  pData pointer;
  size  int(10);
end-ds;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Produces a new KeySet handle.
dcl-pr produceKeySetHandle like(BasicKeySet_handle_t);
  i_pMap like(BasicMap_handle_t) const;
end-pr;

//  Frees a given KeySet handle.
dcl-pr freeKeySetHandle;
  io_pKeySet like(BasicKeySet_handle_t);
end-pr;

//  Adds a key to the associated key set of a given map.
dcl-pr addKeySetEntry int(10) extproc('addKeySetEntry');
  i_pList like(BasicList_handle_t) const;
  i_key   like(BasicMap_key_t) const;
end-pr;

//  Removes a key from the associated key set of a given map.
dcl-pr removeKeySetEntry int(10) extproc('removeKeySetEntry');
  i_pList like(BasicList_handle_t) const;
  i_key   like(BasicMap_key_t) const;
end-pr;

//  Frees the memory of a given map entry.
dcl-pr freeMapE int(10) extproc('freeMapE');
  i_pMap  like(BasicMap_handle_t) const;
  i_index int(10) const;
end-pr;

//  Searches the underlaying list for a given key.
dcl-pr findMapE int(10) extproc('findMapE');
  i_pMap like(BasicMap_handle_t) const;
  i_key  like(BasicMap_key_t) options(*varsize) const;
end-pr;

//  Sorts the map.
dcl-pr sortMap extproc('sortMap');
  i_pMap like(BasicMap_handle_t) const;
end-pr;

dcl-pr sortCallback int(10) extproc('sortCallback');
  i_pKeyData  pointer value;
  i_keySize   int(10) value;
  i_pElemData pointer value;
  i_elemSize  int(10) value;
end-pr;

//  Checks, whether a given handle is a valid map handle, or not.
dcl-pr checkMapHandle extproc('checkMapHandle');
  i_pMap like(BasicMap_handle_t) const;
end-pr;

//  Checks, whether a given handle is a valid KeySet handle, or not.
dcl-pr checkKeySetHandle extproc('checkKeySetHandle');
  i_pKeySet like(BasicKeySet_handle_t) const;
end-pr;

//  Sends an ESCAPE message to signal an error condition.
dcl-pr signalError extproc('signalError');
  i_text varchar(128) const;
  i_proc varchar(256) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cHANDLE_TYPE_MAP 6689113833186869569; // =  *Map
dcl-c cHANDLE_MAP_SIZE %size(hMap_t);

dcl-c cERROR_MAP_HANDLE_NULL 'Map handle is NULL';
dcl-c cERROR_MAP_HANDLE_INVALID 'Map handle is invalid';

dcl-c cHANDLE_TYPE_KEYSET 6688555357000016705; // =  *KeySet
dcl-c cHANDLE_KEYSET_SIZE %size(hKeySet_t);

dcl-c cERROR_KEYSET_HANDLE_NULL 'KeySet handle is NULL';
dcl-c cERROR_KEYSET_HANDLE_INVALID 'KeySet handle is invalid';

dcl-c cTYPE_KEYSET '*BASIC_KEYSET';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Creates a new BasicMap.
//=========================================================================
//  Parameters:
//   i_increment   - The number of empty elements that are added to the
//                   map when the map needs to be resized.
//
//  Returns:
//   pMap          - Returns the basing pointer of the map on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicMap_new export;
  dcl-pi *n like(BasicMap_handle_t);
    i_increment uns(10) options(*nopass: *omit) const;
    i_heapID    int(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s pMap like(BasicMap_handle_t) inz;

  //  Parameter positions
  dcl-c p_increment 1;
  dcl-c p_heapID 2;

  //  Fields for optional parameters
  dcl-s increment like(i_increment) inz;
  dcl-s heapID like(i_heapID) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Get values of optional parameters
  // ... i_increment
  if (%parms() >= p_increment and %addr(i_increment) <> *NULL);
    increment = i_increment;
  else;
    increment = 256;
  endif;

  // ... i_heapID
  if (%parms() >= p_heapID and %addr(i_heapID) <> *NULL);
    heapID = i_heapID;
  else;
    heapID = 0;
  endif;

  // Set memory manager
  mm_memMgr = MemoryManager_getDefaultManager();

  // Allocate memory for map handle
  pMap = mm_allocate(%size(hMap_t): heapID);

  // Initialize map handle
  clear hMap;
  hMap.intType   = cHANDLE_TYPE_MAP;
  hMap.intSize   = %size(hMap);
  hMap.pList     = BasicList_new('*BASICMAP': increment: heapID);
  hMap.pKeySet   = BasicList_null();
  clear hMap.keySetRefList;
  hMap.keySetNumRef = 0;
  hMap.increment = increment;
  hMap.heapID    = heapID;
  hMap.memMgr    = mm_memMgr;

  return pMap;


end-proc;

//=========================================================================
//  Clones a given BasicMap.
//=========================================================================
//  Parameters:
//   i_increment   - The number of empty elements that are added to the
//                   map when the map needs to be resized.
//
//  Returns:
//   pMap          - Returns the basing pointer of the map on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicMap_clone export;
  dcl-pi *n like(BasicMap_handle_t);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s pMapRtn like(BasicMap_handle_t) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s numE int(10) inz;
  dcl-s key like(BasicMap_key_t) inz;
  dcl-s size int(10) inz;
  dcl-s pData pointer inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Create a new and empty map
  pMapRtn = BasicMap_new(hMap.increment);

  // Copy map entries
  numE = BasicMap_getNumE(i_pMap);
  for x = 1 to numE;
    key   = BasicMap_getKeyByIndex(i_pMap: x);
    pData = BasicMap_getValueByIndex(i_pMap: x);
    size  = BasicMap_getSizeByIndex(i_pMap: x);
    BasicMap_put(pMapRtn: key: pData: size);
  endfor;

  // Create a key set if the base map has a key set
  if (not BasicList_isNull(hMap.pKeySet));
    BasicMap_newKeySet(i_pMap);
  endif;

  return pMapRtn;


end-proc;

//=========================================================================
//  Removes the entry to which this map maps the specified key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key whose associated value is to be removed.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_remove export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Local fields
  dcl-s x int(10) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Locate element by key in list
  x = findMapE(i_pMap: i_key);
  if x = -1;
    return rc;
  endif;

  // Free memory of map entry
  rc = freeMapE(i_pMap: x);

  return rc;


end-proc;

//=========================================================================
//  Returns true if this map contains a mapping for the specified key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key whose associated value is to be returned.
//
//  Returns:
//   isFound       - Returns TRUE is this map contains a mapping for the
//                   specified key, else FALSE.
//=========================================================================
dcl-proc BasicMap_containsKey export;
  dcl-pi *n ind;
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s isFound ind inz(cFalse);

  //  Local fields
  dcl-s x int(10) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Locate element by key in list
  if findMapE(i_pMap: i_key) = -1;
    isFound = cFalse;
  else;
    isFound = cTrue;
  endif;

  return isFound;


end-proc;

//=========================================================================
//  Returns the value to which this map maps the specified key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key whose associated value is to be returned.
//   i_pEntry      - Value to be associated with the specified key.
//   i_length      - Optional. The size of the value.
//
//  Returns:
//   pElemData     - Pointer to the value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicMap_get export;
  dcl-pi *n pointer;
    i_pMap   like(BasicMap_handle_t) const;
    i_key    like(BasicMap_key_t) options(*varsize) const;
    i_pEntry pointer options(*nopass) const;
    i_length int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s pElemData pointer inz;

  //  Parameter positions
  dcl-c p_pEntry 3;
  dcl-c p_length 4;

  //  Fields for optional parameters
  dcl-s pEntry like(i_pEntry) inz;
  dcl-s length like(i_length) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s maxSize int(10) inz;
  dcl-ds mapE likeds(mapE_t) based(pMapE);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Get values of optional parameters
  // ... pEntry
  p_assert(%parms() <> p_pEntry
           : 'length must be specified if pEntry is passed');

  // ... length
  if %parms() >= p_length;
    pEntry = i_pEntry;
    length = i_length;
  else;
    pEntry = *NULL;
    length = 0;
  endif;

  // Locate element by key in list
  x = findMapE(i_pMap: i_key);
  if x = -1;
    return pElemData;
  endif;

  // Get element from underlaying list
  pMapE = BasicList_get(hMap.pList: x);
  if pMapE = *NULL;
    return pElemData;
  endif;

  // Determine number of bytes to copy
  if length < mapE.size;
    maxSize = length;
  else;
    maxSize = mapE.size;
  endif;

  // Initialize return buffer
  if length > 0;
    memset(pEntry: x'00': length);
  endif;

  // Copy entry data
  if maxSize > 0;
    memcpy(pEntry: mapE.pData: maxSize);
    pElemData = pEntry;
  else;
    pElemData = mapE.pData;
  endif;

  return pElemData;


end-proc;

//=========================================================================
//  Returns the string value to which this map maps the specified key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key whose associated value is to be returned.
//
//  Returns:
//   string        - String value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicMap_getString export;
  dcl-pi *n varchar(4096);
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s string varchar(4096) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s length int(10) inz;
  dcl-s maxSize int(10) inz;
  dcl-ds mapE likeds(mapE_t) based(pMapE);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Locate element by key in list
  x = findMapE(i_pMap: i_key);
  if x = -1;
    return string;
  endif;

  // Get element from underlaying list
  pMapE = BasicList_get(hMap.pList: x);
  if pMapE = *NULL;
    return string;
  endif;

  // Determine size of return value
  length = %size(string);

  // Determine number of bytes to copy
  if length < mapE.size;
    maxSize = length;
  else;
    maxSize = mapE.size;
  endif;

  // Initialize return buffer
  if length > 0;
    memset(%addr(string): x'00': length);
  endif;

  // Copy entry data
  if maxSize > 0;
    memcpy(%addr(string): mapE.pData: maxSize);
  endif;

  return string;


end-proc;

//=========================================================================
//  Returns the integer value to which this map maps the specified key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key whose associated value is to be returned.
//
//  Returns:
//   integer       - Integer value addressed by 'i_key'.
//=========================================================================
dcl-proc BasicMap_getInteger export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s integer int(10) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (BasicMap_get(i_pMap:i_key:%addr(integer):%size(integer)) = *NULL);
    integer = 0;
  endif;

  return integer;


end-proc;

//=========================================================================
//  Returns the key addressed by a given index.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_index       - Index whose associated value is to be returned.
//
//  Returns:
//   key           - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_getKeyByIndex export;
  dcl-pi *n like(BasicMap_key_t);
    i_pMap  like(BasicMap_handle_t) const;
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-s key like(BasicMap_key_t) inz;

  //  Local fields
  dcl-s mapE_key like(BasicMap_key_t) based(mapE.pKey);
  dcl-ds mapE likeds(mapE_t) based(pMapE);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Sort list, to keep order stable in case the user performs
  // a BasicMap_get() once that he got the key.
  sortMap(i_pMap);

  // Get element from underlaying list
  pMapE = BasicList_get(hMap.pList: i_index);
  if pMapE = *NULL;
    return '';
  endif;

  key = %subst(mapE_key: 1: %len(mapE_key));

  return key;


end-proc;

//=========================================================================
//  Returns the value addressed by a given index.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_index       - Index whose associated value is to be returned.
//   i_pEntry      - Value to be associated with the specified key.
//   i_length      - Optional. The size of the value.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_getValueByIndex export;
  dcl-pi *n pointer;
    i_pMap   like(BasicMap_handle_t) const;
    i_index  int(10) const;
    i_pEntry pointer options(*nopass) const;
    i_length int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s pElemData pointer inz;

  //  Parameter positions
  dcl-c p_pEntry 3;
  dcl-c p_length 4;

  //  Fields for optional parameters
  dcl-s pEntry like(i_pEntry) inz;
  dcl-s length like(i_length) inz;

  //  Local fields
  dcl-s maxSize int(10) inz;
  dcl-ds mapE likeds(mapE_t) based(pMapE);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Get values of optional parameters
  // ... pEntry
  p_assert(%parms() <> p_pEntry
           : 'length must be specified if pEntry is passed');

  // ... length
  if %parms() >= p_length;
    pEntry = i_pEntry;
    length = i_length;
  else;
    pEntry = *NULL;
    length = 0;
  endif;

  // Sort list, to keep order stable in case the user performs
  // a BasicMap_get() once that he got the key.
  sortMap(i_pMap);

  // Get element from underlaying list
  pMapE = BasicList_get(hMap.pList: i_index);
  if pMapE = *NULL;
    return *NULL;
  endif;

  // Determine number of bytes to copy
  if length < mapE.size;
    maxSize = length;
  else;
    maxSize = mapE.size;
  endif;

  // Initialize return buffer
  if length > 0;
    memset(pEntry: x'00': length);
  endif;

  // Copy entry data
  if maxSize > 0;
    memcpy(pEntry: mapE.pData: maxSize);
    pElemData = pEntry;
  else;
    pElemData = mapE.pData;
  endif;

  return pElemData;


end-proc;

//=========================================================================
//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key with which the specified value is to be associated.
//   i_pEntry      - Value to be associated with the specified key.
//   i_length      - Optional. The size of the value.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_put export;
  dcl-pi *n int(10);
    i_pMap   like(BasicMap_handle_t) const;
    i_key    like(BasicMap_key_t) options(*varsize) const;
    i_pEntry pointer options(*string) const;
    i_length int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Parameter positions
  dcl-c p_length 4;

  //  Fields for optional parameters
  dcl-s length like(i_length) inz;

  //  Local fields
  dcl-s x int(10) inz;
  dcl-s key like(BasicMap_key_t) inz;
  dcl-ds mapE likeds(mapE_t) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  p_assert(%len(i_key) > 0:
           'Key length must be greater 0');

  // Get length of entry data
  if %parms() >= p_length;
    length = i_length;
  else;
    if i_pEntry = *NULL;
      length = 0;
    else;
      length = strlen(i_pEntry);
    endif;
  endif;

  // Set memory manager
  mm_memMgr = hMap.memMgr;

  // Locate element by key in list
  x = findMapE(i_pMap: i_key);
  if x = -1;
    // Add new entry to map
    key = i_key;

    clear mapE;
    mapE.pKey  = mm_allocate(%len(key) + 2: hMap.heapID);
    if (length = 0);
      mapE.pData = *NULL;
    else;
      mapE.pData = mm_allocate(length: hMap.heapID);
    endif;
    mapE.size  = length;
    memcpy(mapE.pKey : %addr(key): %len(key) + 2);
    memcpy(mapE.pData: i_pEntry  : length       );
    if BasicList_add(hMap.pList: %addr(mapE): %size(MapE)) <> -1;
      addKeySetEntry(hMap.pKeySet: key);
      rc = 0;
    endif;
    return rc;
  endif;

  // Get existing map entry from underlaying list
  if BasicList_get(hMap.pList: x: %addr(mapE): %size(mapE)) = *NULL;
    return rc;
  endif;

  // Associate new value to key
  mapE.pData = mm_reallocate(mapE.pData: length);
  mapE.size  = length;
  memcpy(mapE.pData: i_pEntry: length);

  // Write back map entry to list
  if BasicList_set(hMap.pList: x: %addr(mapE): %size(MapE)) <> -1;
    rc = 0;
  endif;

  return rc;


end-proc;

//=========================================================================
//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key with which the specified value is to be associated.
//   i_string      - String value to be associated with the specified key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_putString export;
  dcl-pi *n int(10);
    i_pMap   like(BasicMap_handle_t) const;
    i_key    like(BasicMap_key_t) options(*varsize) const;
    i_string varchar(4096) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Local fields
  dcl-s string like(i_string) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  string = i_string;
  rc = BasicMap_put(i_pMap: i_key: %addr(string): %len(string) + 2);

  return rc;


end-proc;

//=========================================================================
//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key with which the specified value is to be associated.
//   i_integer     - Integer value to be associated with the specified key.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicMap_putInteger export;
  dcl-pi *n int(10);
    i_pMap    like(BasicMap_handle_t) const;
    i_key     like(BasicMap_key_t) options(*varsize) const;
    i_integer int(10) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Local fields
  dcl-s integer like(i_integer) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  integer = i_integer;
  rc = BasicMap_put(i_pMap: i_key: %addr(integer): %size(integer));

  return rc;


end-proc;

//=========================================================================
//  Returns the size of of the element that is associated with this key.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_key         - Key of the value.
//
//  Returns:
//   size          - Returns the size of the element on success, else -1.
//=========================================================================
dcl-proc BasicMap_getSize export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s size int(10) inz(-1);

  //  Local fields
  dcl-s x int(10) inz;
  dcl-ds mapE likeds(mapE_t) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Locate element by key in list
  x = findMapE(i_pMap: i_key);
  if x = -1;
    return size;
  endif;

  // Get map entry from underlaying list
  if BasicList_get(hMap.pList: x: %addr(mapE): %size(mapE)) = *NULL;
    return size;
  endif;

  size = mapE.size;

  return size;


end-proc;

//=========================================================================
//  Returns the size of of the element that is addressed by a given index.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_index       - Index whose associated value is to be returned.
//
//  Returns:
//   size          - Returns the size of the element on success, else -1.
//=========================================================================
dcl-proc BasicMap_getSizeByIndex export;
  dcl-pi *n int(10);
    i_pMap  like(BasicMap_handle_t) const;
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-s size int(10) inz(-1);

  //  Local fields
  dcl-ds mapE likeds(mapE_t) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Get element from underlaying list
  if BasicList_get(hMap.pList: i_index: %addr(mapE): %size(mapE))= *NULL;
    return -1;
  endif;

  size = mapE.size;

  return size;


end-proc;

//=========================================================================
//  Returns the number of key-value mappings in this map.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   size          - Returns the number of elements in this list on
//                   success, else -1.
//=========================================================================
dcl-proc BasicMap_getNumE export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s numE int(10) inz(-1);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Return number of elements of underlaying list
  numE = BasicList_getNumE(hMap.pList);

  return numE;


end-proc;

//=========================================================================
//  Returns the heap ID of a given BasicMap.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   heapID        - ID of the heap this BasicMap belongs to.
//=========================================================================
dcl-proc BasicMap_getHeapID export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s heapID int(10) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Return the heap ID of underlaying list
  heapID = BasicList_getHeapID(hMap.pList);

  return heapID;


end-proc;

//=========================================================================
//  Returns a list of all keys that are in a given map.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_pSortFnc    - Optional: Procedure pointer of sort procedure.
//
//  Returns:
//   hList         - List, containing all keys of the map.
//=========================================================================
dcl-proc BasicMap_getKeys export;
  dcl-pi *n like(BasicList_handle_t);
    i_pMap     like(BasicMap_handle_t) const;
    i_pSortFnc pointer(*proc) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s hList like(BasicList_handle_t) inz;

  //  Parameter positions
  dcl-c p_pSortFnc 2;

  //  Fields for optional parameters
  dcl-s pSortFnc like(i_pSortFnc) inz;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s key like(BasicMap_key_t) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Get optional parameter values:
  // ... pSortFnc
  if (%parms() >= p_pSortFnc and %addr(i_pSortFnc) <> *NULL);
    pSortFnc = i_pSortFnc;
  else;
    pSortFnc = *NULL;
  endif;

  // Create a new BasicList
  hList = BasicList_new('*BASICMAP_KEYS'
                        : hMap.increment
                        : hMap.heapID);

  // Add map values to list
  for x = 1 to BasicMap_getNumE(i_pMap);
    key = BasicMap_getKeyByIndex(i_pMap: x);
    BasicList_addString(hList: key);
  endfor;

  // Sort list if the user passed a comparator
  if (pSortFnc <> *NULL);
    BasicList_sort(hList: pSortFnc);
  endif;

  return hList;


end-proc;

//=========================================================================
//  Returns a list of all values that are in a given map.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_pSortFnc    - Optional: Procedure pointer of sort procedure.
//
//  Returns:
//   hList         - List, containing all values of the map.
//=========================================================================
dcl-proc BasicMap_getValues export;
  dcl-pi *n like(BasicList_handle_t);
    i_pMap     like(BasicMap_handle_t) const;
    i_pSortFnc pointer(*proc) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s hList like(BasicList_handle_t) inz;

  //  Parameter positions
  dcl-c p_pSortFnc 2;

  //  Fields for optional parameters
  dcl-s pSortFnc like(i_pSortFnc) inz;

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s size int(10) inz;
  dcl-s pData pointer inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Get optional parameter values:
  // ... pSortFnc
  if (%parms() >= p_pSortFnc and %addr(i_pSortFnc) <> *NULL);
    pSortFnc = i_pSortFnc;
  else;
    pSortFnc = *NULL;
  endif;

  // Create a new BasicList
  hList = BasicList_new('*BASICMAP_VALUES'
                        : hMap.increment
                        : hMap.heapID);

  // Add map values to list
  for x = 1 to BasicMap_getNumE(i_pMap);
    pData = BasicMap_getValueByIndex(i_pMap: x);
    size  = BasicMap_getSizeByIndex(i_pMap: x);
    BasicList_add(hList: pData: size);
  endfor;

  // Sort list if the user passed a comparator
  if (pSortFnc <> *NULL);
    BasicList_sort(hList: pSortFnc);
  endif;

  return hList;


end-proc;

//=========================================================================
//  Removes all entries from a given map.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicMap_clear export;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s x int(10) inz;
  dcl-s numE int(10) inz;
  dcl-s aPointer pointer inz;
  dcl-ds mapE likeds(mapE_t) inz;

  //  Debug:
  dcl-s key like(BasicMap_key_t) based(mapE.pKey);
  dcl-s data char(65535) based(mapE.pData);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  // Remove elements from map.
  numE = BasicList_getNumE(hMap.pList);

  dow numE > 0;

    // Free memory of map entry
    freeMapE(i_pMap: numE);

    numE = BasicList_getNumE(hMap.pList);
  enddo;

  rc = 0;

  return rc;


end-proc;

//=========================================================================
//  Deletes a given BasicMap.
//=========================================================================
//  Parameters:
//   io_pMap       - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicMap_delete export;
  dcl-pi *n int(10);
    io_pMap like(BasicMap_handle_t);
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s x int(10) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(io_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(io_pMap);

  dou 1=1;

    // Set memory manager
    mm_memMgr = hMap.memMgr;

    // Free KeySet handles.
    for x = 1 to %elem(hMap.keySetRefList);
      if (hMap.keySetRefList(x) <> *NULL);
        freeKeySetHandle(hMap.keySetRefList(x));
      endif;
    endfor;

    // Remove elements from map.
    rc = BasicMap_clear(io_pMap);
    if rc <> 0;
      leave;
    endif;

    // Delete underlaying BasicList.
    BasicList_delete(hMap.pList);

    // Delete key set if present.
    if (not BasicList_isNull(hMap.pKeySet));
      BasicList_delete(hMap.pKeySet);
    endif;

    // Clear map handle
    clear hMap;
    hMap.intType       = 0;
    hMap.intSize       = 0;
    hMap.pList         = BasicList_null();
    hMap.pKeySet       = BasicList_null();
    for x = 1 to %elem(hMap.keySetRefList);
      p_assert(hMap.keySetRefList(x) = *NULL:
               'hMap.keySetRefList does not match +
                expected value *NULL');
    endfor;
    p_assert(hMap.keySetNumRef = 0:
             'hMap.keySetNumRef does not match expected value 0');
    hMap.increment     = 0;
    hMap.heapID        = 0;
    clear hMap.memMgr;

    // Free memory of map handle
    mm_free(io_pMap);

    io_pMap = BasicMap_null();

  enddo;

  return rc;


end-proc;

//=========================================================================
//  Returns a BasicMap NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pMap          - NULL handle of a BasicMap.
//=========================================================================
dcl-proc BasicMap_null export;
  dcl-pi *n like(BasicMap_handle_t);
  end-pi;

  //  Return value
  dcl-s pMap like(BasicMap_handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pMap = *NULL;

  return pMap;


end-proc;

//=========================================================================
//  Checks a given BasicMap handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle is null, else FALSE.
//=========================================================================
dcl-proc BasicMap_isNull export;
  dcl-pi *n ind;
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(cTrue);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pMap = BasicMap_null());
    isNull = cTrue;
  else;
    isNull = cFalse;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  Produces a list of keys from a given map.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   pList         - Handle of the list which contains all keys of
//                   the map.
//=========================================================================
//  Note:            Do not delete the list with BasicList_delete()!
//                   Use BasicKeySet_delete() to delete the list.
//=========================================================================
dcl-proc BasicMap_newKeySet export;
  dcl-pi *n like(BasicKeySet_handle_t);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);

  //  Helper fields
  dcl-s x int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkMapHandle(i_pMap);

  if (not BasicList_isNull(hMap.pKeySet));
    return produceKeySetHandle(i_pMap);
  endif;

  p_assert(hMap.keySetNumRef = 0
           : 'Expected 0 in hMap.keySetNumRef');

  hMap.pKeySet = BasicList_new(cTYPE_KEYSET: hMap.increment);

  for x = 1 to BasicMap_getNumE(i_pMap);
    BasicList_addString(hMap.pKeySet
                        : BasicMap_getKeyByIndex(i_pMap: x));
  endfor;

  return produceKeySetHandle(i_pMap);


end-proc;

//=========================================================================
//  Returns the first entry of a given key set.
//=========================================================================
//  Parameters:
//   i_pKeySet     - Handle of a given KeySet, returned by
//                   BasicMap_newKeySet().
//
//  Returns:
//   key           - Returns the key of a map entry on success, else ''.
//=========================================================================
dcl-proc BasicKeySet_getFirst export;
  dcl-pi *n like(BasicMap_key_t);
    i_pKeySet like(BasicKeySet_handle_t) const;
  end-pi;

  //  KeySet handle
  dcl-ds hKeySet likeds(hKeySet_t) based(i_pKeySet);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(hKeySet.pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkKeySetHandle(i_pKeySet);

  checkMapHandle(hKeySet.pMap);

  if (BasicList_isNull(hMap.pKeySet));
    return '';
  endif;

  hKeySet.x = 0;

  return BasicKeySet_getNext(i_pKeySet);


end-proc;

//=========================================================================
//  Returns the next entry of a given key set.
//=========================================================================
//  Parameters:
//   i_pKeySet     - Handle of a given KeySet, returned by
//                   BasicMap_newKeySet().
//
//  Returns:
//   key           - Returns the key of a map entry on success, else ''.
//=========================================================================
dcl-proc BasicKeySet_getNext export;
  dcl-pi *n like(BasicMap_key_t);
    i_pKeySet like(BasicKeySet_handle_t) const;
  end-pi;

  //  KeySet handle
  dcl-ds hKeySet likeds(hKeySet_t) based(i_pKeySet);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(hKeySet.pMap);

  //  Helper fields
  dcl-s numE int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkKeySetHandle(i_pKeySet);

  checkMapHandle(hKeySet.pMap);

  if (BasicList_isNull(hMap.pKeySet));
    return '';
  endif;

  numE = BasicList_getNumE(hMap.pKeySet);
  if (hKeySet.x >= numE);
    return '';
  endif;

  dow (hKeySet.x < numE);
    hKeySet.x = hKeySet.x + 1;
    if (not BasicList_isNullValue(hMap.pKeySet: hKeySet.x));
      return BasicList_getString(hMap.pKeySet: hKeySet.x);
    endif;
  enddo;

  return '';


end-proc;

//=========================================================================
//  Deletes the key list associated to a given map.
//=========================================================================
//  Parameters:
//   io_pKeySet    - Handle of a given KeySet, returned by
//                   BasicMap_newKeySet().
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc BasicKeySet_delete export;
  dcl-pi *n int(10);
    io_pKeySet like(BasicKeySet_handle_t);
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  KeySet handle
  dcl-ds hKeySet likeds(hKeySet_t) based(io_pKeySet);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkKeySetHandle(io_pKeySet);

  checkMapHandle(hKeySet.pMap);

  pMap = hKeySet.pMap;

  if (not BasicList_isNull(hMap.pKeySet));
    freeKeySetHandle(io_pKeySet);
    if (hMap.keySetNumRef = 0);
      BasicList_delete(hMap.pKeySet);
      hMap.pKeySet = BasicList_null();
    endif;
  endif;

  rc = 0;

  return rc;


end-proc;

//=========================================================================
//  *** private ***
//  Produces a new KeySet handle.
//=========================================================================
//  Parameters:
//   i_pMap        - Handle of a given map.
//
//  Returns:
//   pKeySet       - Returns a handle for the KeySet on success, else
//                   *NULL.
//=========================================================================
dcl-proc produceKeySetHandle;
  dcl-pi *n like(BasicKeySet_handle_t);
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s pKeySet like(BasicKeySet_handle_t);

  //  Helper fields
  dcl-s x int(10) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);

  //  KeySet handle
  dcl-ds hKeySet likeds(hKeySet_t) based(pKeySet);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(hMap.keySetNumRef < %elem(hMap.keySetRefList):
           'No more space for another KeySet');

  // Set memory manager
  mm_memMgr = hMap.memMgr;

  pKeySet = mm_allocate(%size(hKeySet): hMap.heapID);

  clear hKeySet;
  hKeySet.intType = cHANDLE_TYPE_KEYSET;
  hKeySet.intSize = %size(hKeySet);
  hKeySet.x       = 0;
  hKeySet.pMap    = i_pMap;

  x = %lookup(*NULL: hMap.keySetRefList);
  hMap.keySetRefList(x) = pKeySet;

  hMap.keySetNumRef = hMap.keySetNumRef + 1;

  return pKeySet;


end-proc;

//=========================================================================
//  *** private ***
//  Frees a given KeySet handle.
//=========================================================================
//  Parameters:
//   io_pKeySet    - Handle of a given KeySet.
//
//  Returns:
//   void
//=========================================================================
dcl-proc freeKeySetHandle;
  dcl-pi *n;
    io_pKeySet pointer;
  end-pi;

  //  Helper fields
  dcl-s x int(10) inz;

  //  KeySet handle
  dcl-ds hKeySet likeds(hKeySet_t) based(io_pKeySet);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(pMap);

  //  Memory Manager
/copy QBASICS1,MEMMGR
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pMap = hKeyset.pMap;

  // Set memory manager
  mm_memMgr = hMap.memMgr;

  x = %lookup(io_pKeySet: hMap.keySetRefList);
  p_assert(x > 0:
           'KeySet handle not found in list');

  mm_free(io_pKeySet);

  hMap.keySetRefList(x) = *NULL;
  hMap.keySetNumRef     = hMap.keySetNumRef - 1;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Adds a key to the associated key set of a given map.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the key set (list).
//   i_key         - Key to add.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc addKeySetEntry;
  dcl-pi *n int(10);
    i_pList like(BasicList_handle_t) const;
    i_key   like(BasicMap_key_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s x int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (BasicList_isNull(i_pList));
    rc = 0;
    return rc;
  endif;

  x = BasicList_findString(i_pList: i_key);

  p_assert(x = -1
           : 'Key already in key set');

  BasicList_addString(i_pList: i_key);

  rc = 0;

  return rc;


end-proc;

//=========================================================================
//  *** private ***
//  Removes a key from the associated key set of a given map.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the key set (list).
//   i_key         - Key to remove.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc removeKeySetEntry;
  dcl-pi *n int(10);
    i_pList like(BasicList_handle_t) const;
    i_key   like(BasicMap_key_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s x int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (BasicList_isNull(i_pList));
    rc = 0;
    return rc;
  endif;

  x = BasicList_findString(i_pList: i_key);

  p_assert(x > 0
           : 'Key in key set not found');

  // Actually the entry is not removed but set to NULL in order
  // to keep the positions of the list entries stable.
  BasicList_set(i_pList: x: *NULL);

  rc = 0;

  return rc;


end-proc;

//=========================================================================
//  *** private ***
//  Frees the memory of a given map entry.
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//   i_index       - Index of the map entry.
//
//  Returns:
//   rc            - Returns 0 on success, else -1.
//=========================================================================
dcl-proc freeMapE;
  dcl-pi *n int(10);
    i_pMap  like(BasicMap_handle_t) const;
    i_index int(10) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Helper fields
  dcl-s aPointer pointer inz;
  dcl-s key like(BasicMap_key_t) based(mapE.pKey);
  dcl-ds mapE likeds(mapE_t) inz;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);

  //  Memory Manager
/copy QBASICS1,MEMMGR
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Set memory manager
  mm_memMgr = hMap.memMgr;

  // Get map entry from underlaying list
  aPointer = BasicList_get(hMap.pList: i_index
                                     : %addr(mapE)
                                     : %size(mapE) );

  p_assert(aPointer <> *NULL
           : 'BasicList_get() failed');

  // Remove entry from an associated key set
  removeKeySetEntry(hMap.pKeySet: key);

  // Free memory of map entry
  mm_free(mapE.pKey);           // key

  if (mapE.pData <> *NULL);
    mm_free(mapE.pData);       // data
  endif;

  clear mapE;

  // Remove that map entry from the underlaying list
  rc = BasicList_remove(hMap.pList: i_index);

  p_assert(rc <> -1
           : 'BasicList_remove() failed');

  return rc;


end-proc;

//=========================================================================
//  *** private ***
//  Searches the underlaying list for a given key.
//  (Binary search algorithm)
//=========================================================================
//  Parameters:
//   i_pMap        - Basing pointer of the map returned by BasicMap_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle is null, else FALSE.
//=========================================================================
dcl-proc findMapE;
  dcl-pi *n int(10);
    i_pMap like(BasicMap_handle_t) const;
    i_key  like(BasicMap_key_t) options(*varsize) const;
  end-pi;

  //  Return value
  dcl-s index int(10) inz(-1);

  //  Helper fields
  dcl-s currentE int(10) inz;
  dcl-s lowerE int(10) inz;
  dcl-s upperE int(10) inz;
  dcl-s mapE_key like(BasicMap_key_t) based(mapE.pKey);
  dcl-ds mapE likeds(mapE_t) based(pMapE);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  sortMap(i_pMap);

  lowerE   = 1;
  upperE   = BasicList_getNumE(hMap.pList);

  dow (index = -1) and (lowerE <= upperE);

    currentE = %int((lowerE + upperE) / 2);

    pMapE = BasicList_get(hMap.pList: currentE);
    select;
    when i_key < mapE_key;
      upperE = currentE - 1;
    when i_key > mapE_key;
      lowerE = currentE + 1;
    other;
      index = currentE;
    endsl;

  enddo;

  return index;


end-proc;

//=========================================================================
//  *** private ***
//  Sorts the map.
//=========================================================================
dcl-proc sortMap;
  dcl-pi *n;
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Return value
  dcl-s isSorted ind inz(cFalse);

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  BasicList_sort(hMap.pList: %paddr('sortCallback'));

  return;


end-proc;

//=========================================================================
//  Procedure used by BasicList to sort this map.
//=========================================================================
dcl-proc sortCallback;
  dcl-pi *n int(10);
    i_pKeyData  pointer value;
    i_keySize   int(10) value;
    i_pElemData pointer value;
    i_elemSize  int(10) value;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz;

  //  Helper fields
  dcl-ds keyMapE likeds(mapE_t) based(i_pKeyData);
  dcl-ds elemMapE likeds(mapE_t) based(i_pElemData);
  dcl-s keyMapE_key like(BasicMap_key_t) based(keyMapE.pKey);
  dcl-s elemMapE_key like(BasicMap_key_t) based(elemMapE.pKey);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  select;
  when %subst(keyMapE_key : 1: %len(keyMapE_key )) >
       %subst(elemMapE_key: 1: %len(elemMapE_key));
    rc = 1;
  when %subst(keyMapE_key : 1: %len(keyMapE_key )) <
       %subst(elemMapE_key: 1: %len(elemMapE_key));
    rc = -1;
  other;
    rc = 0;
  endsl;

  return rc;


end-proc;

//=========================================================================
//  *** private ***
//  Checks, whether a given handle is a valid map handle, or not.
//  Returns TRUE for a valid map handle, else FALSE.
//=========================================================================
dcl-proc checkMapHandle;
  dcl-pi *n;
    i_pMap like(BasicMap_handle_t) const;
  end-pi;

  //  Map handle
  dcl-ds hMap likeds(hMap_t) based(i_pMap);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (BasicMap_isNull(i_pMap));
    signalError(cERROR_MAP_HANDLE_NULL: f_caller());
  endif;

  if (hMap.intType <> cHANDLE_TYPE_MAP);
    signalError(cERROR_MAP_HANDLE_INVALID: f_caller());
  endif;

  if (hMap.intSize <> cHANDLE_MAP_SIZE);
    signalError(cERROR_MAP_HANDLE_INVALID: f_caller());
  endif;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Checks, whether a given handle is a valid KeySet handle, or not.
//  Returns TRUE for a valid map handle, else FALSE.
//=========================================================================
dcl-proc checkKeySetHandle;
  dcl-pi *n;
    i_pKeySet like(BasicKeySet_handle_t) const;
  end-pi;

  //  Map handle
  dcl-ds hKeySet likeds(hKeySet_t) based(i_pKeySet);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pKeySet = *NULL);
    signalError(cERROR_KEYSET_HANDLE_NULL: f_caller());
  endif;

  if (hKeySet.intType <> cHANDLE_TYPE_KEYSET);
    signalError(cERROR_KEYSET_HANDLE_INVALID: f_caller());
  endif;

  if (hKeySet.intSize <> cHANDLE_KEYSET_SIZE);
    signalError(cERROR_KEYSET_HANDLE_INVALID: f_caller());
  endif;

  return;


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
                 : 'BasicMap: ERROR - ' + i_text
                 : cMsg_Escape: 'QCPFMSG': '*LIBL');
  f_sndPgmMsg(msg: cMsg_Same: i_proc);

  return;


end-proc;