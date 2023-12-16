      *=====================================================================*
      *  BASICS1RC  - SrvPgm: Basic Routines - BasicMap                     *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  09.06.2004                                              *
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
      *  08.11.2007  Th.Raddatz    Added procedures:                        *
      *                            BasicMap_getSizeByIndex()                *
      *                            BasicMap_putString()                     *
      *                            BasicMap_getString()                     *
      *                                                                     *
      *  05.12.2007  Th.Raddatz    Added procedures:                        *
      *                            BasicMap_putInteger()                    *
      *                            BasicMap_getInteger()                    *
      *                                                                     *
      *  14.12.2007  Th.Raddatz    Added assert() to BasicMap_put() to      *
      *                            ensure that key length is greater 0.     *
      *                                                                     *
      *  25.02.2008  Th.Raddatz    Fixed memory leak. BasicMap_remove()     *
      *                            did remove the map entry from the        *
      *                            underlaying list but did not free the    *
      *                            memory allocted for that map entry.      *
      *                                                                     *
      *  24.04.2008  Th.Raddatz    Introduced a real map handle (hMap_t).   *
      *                                                                     *
      *  28.04.2008  Th.Raddatz    Check type of map handle and send an     *
      *                            ESCAPE message for invalid handles.      *
      *                            Added procedures:                        *
      *                               BasicMap_KeySet_new()                 *
      *                               BasicMap_KeySet_getFirst()            *
      *                               BasicMap_KeySet_getNext()             *
      *                               BasicMap_KeySet_delete()              *
      *                                                                     *
      *  14.05.2008  Th.Raddatz    Enabled BasicMap_KeySet_new() to be      *
      *                            called more than once. Introduced        *
      *                            counter to keep track of the number of   *
      *                            references. (hMap.keySetNumRef)          *
      *                                                                     *
      *  27.05.2008  Th.Raddatz    Added procedures:                        *
      *                               BasicMap_clone()                      *
      *                            Enabled BasicMap to store NULL data.     *
      *                                                                     *
      *  09.05.2011  Th.Raddatz    Renamed the KeySet procedures and        *
      *                            type templates to:                       *
      *                               BasicMap_newKeySet()                  *
      *                               BasicKeySet_getFirst()                *
      *                               BasicKeySet_getNext()                 *
      *                               BasicKeySet_delete()                  *
      *                               BasicKeySet_handle_t                  *
      *                                                                     *
      *  11.08.2019  Th.Raddatz    Fixed 'index out of range' check in      *
      *                              BasicMap_getSizeByIndex()              *
      *                              BasicMap_getKeyByIndex()               *
      *                              BasicMap_getValueByIndex()             *
      *                            Special thanks to Ch. Bach for           *
      *                            reporting these errors.                  *
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
     H BNDDIR('QC2LE')
      *  Standard H-Specs
      /COPY QBASICS1,H_SPEC
      /COPY QBASICS1,COPYRIGHT
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RC
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D hMap_t          DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  pList                              like(BasicList_handle_t)
     D  pKeySet                            like(BasicList_handle_t)
     D  keySetRefList                  *   dim(64)
     D  keySetNumRef                 10I 0
     D  increment                    10I 0
     D  heapID                       10I 0
     D  memMgr                             likeds(MemoryManager_manager_t)
      *
     D hKeySet_t       DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  x                            10I 0
     D  pMap                               like(BasicMap_handle_t )
      *
     D mapE_t          DS                  qualified
     D  pKey                           *
     D  pData                          *
     D  size                         10I 0
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Produces a new KeySet handle.
     D produceKeySetHandle...
     D                 PR                         like(BasicKeySet_handle_t)
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Frees a given KeySet handle.
     D freeKeySetHandle...
     D                 PR
     D  io_pKeySet                                like(BasicKeySet_handle_t)
      *
      *  Adds a key to the associated key set of a given map.
     D addKeySetEntry...
     D                 PR            10I 0
     D                                            extproc('addKeySetEntry')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_key                              const  like(BasicMap_key_t    )
      *
      *  Removes a key from the associated key set of a given map.
     D removeKeySetEntry...
     D                 PR            10I 0
     D                                            extproc('removeKeySetEntry')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_key                              const  like(BasicMap_key_t    )
      *
      *  Frees the memory of a given map entry.
     D freeMapE...
     D                 PR            10I 0
     D                                            extproc('freeMapE')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Searches the underlaying list for a given key.
     D findMapE...
     D                 PR            10I 0
     D                                            extproc('findMapE')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Sorts the map.
     D sortMap...
     D                 PR
     D                                            extproc('sortMap')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
     D sortCallback...
     D                 PR            10I 0
     D                                     extproc('sortCallback')
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
      *  Checks, whether a given handle is a valid map handle, or not.
     D checkMapHandle...
     D                 PR
     D                                            extproc('checkMapHandle')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Checks, whether a given handle is a valid KeySet handle, or not.
     D checkKeySetHandle...
     D                 PR
     D                                            extproc('checkKeySetHandle')
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  Sends an ESCAPE message to signal an error condition.
     D signalError...
     D                 PR
     D                                            extproc('signalError')
     D  i_text                      128A   const  varying
     D  i_proc                      256A   const  varying
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cHANDLE_TYPE_MAP...
     D                 C                   const(6689113833186869569)           =  *Map
     D cHANDLE_MAP_SIZE...
     D                 C                   const(%size(hMap_t))
      *
     D cERROR_MAP_HANDLE_NULL...
     D                 C                   const('Map handle is NULL')
     D cERROR_MAP_HANDLE_INVALID...
     D                 C                   const('Map handle is invalid')
      *
     D cHANDLE_TYPE_KEYSET...
     D                 C                   const(6688555357000016705)           =  *KeySet
     D cHANDLE_KEYSET_SIZE...
     D                 C                   const(%size(hKeySet_t))
      *
     D cERROR_KEYSET_HANDLE_NULL...
     D                 C                   const('KeySet handle is NULL')
     D cERROR_KEYSET_HANDLE_INVALID...
     D                 C                   const('KeySet handle is invalid')
      *
     D cTYPE_KEYSET...
     D                 C                   const('*BASIC_KEYSET')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new BasicMap.
      *=========================================================================
      *  Parameters:
      *   i_increment   - The number of empty elements that are added to the
      *                   map when the map needs to be resized.
      *
      *  Returns:
      *   pMap          - Returns the basing pointer of the map on
      *                   success, else NULL.
      *=========================================================================
     P BasicMap_new...
     P                 B                   export
      *
     D BasicMap_new...
     D                 PI                         like(BasicMap_handle_t )
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D pMap            S                   like(BasicMap_handle_t ) inz
      *
      *  Parameter positions
     D p_increment     C                   const(1)
     D p_heapID        C                   const(2)
      *
      *  Fields for optional parameters
     D increment       S                   like(i_increment ) inz
     D heapID          S                   like(i_heapID    ) inz
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_new...
     P                 E
      *
      *=========================================================================
      *  Clones a given BasicMap.
      *=========================================================================
      *  Parameters:
      *   i_increment   - The number of empty elements that are added to the
      *                   map when the map needs to be resized.
      *
      *  Returns:
      *   pMap          - Returns the basing pointer of the map on
      *                   success, else NULL.
      *=========================================================================
     P BasicMap_clone...
     P                 B                   export
      *
     D BasicMap_clone...
     D                 PI                         like(BasicMap_handle_t )
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D pMapRtn         S                   like(BasicMap_handle_t ) inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D numE            S             10I 0 inz
     D key             S                   like(BasicMap_key_t ) inz
     D size            S             10I 0 inz
     D pData           S               *   inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_clone...
     P                 E
      *
      *=========================================================================
      *  Removes the entry to which this map maps the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key whose associated value is to be removed.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_remove...
     P                 B                   export
      *
     D BasicMap_remove...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Local fields
     D x               S             10I 0 inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkMapHandle(i_pMap);

         // Locate element by key in list
         x = findMapE(i_pMap: i_key);
         if x = -1;
            return rc;
         endif;

         // Free memory of map entry
         rc = freeMapE(i_pMap: x);

         return rc;

      /END-FREE
      *
     P BasicMap_remove...
     P                 E
      *
      *=========================================================================
      *  Returns true if this map contains a mapping for the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key whose associated value is to be returned.
      *
      *  Returns:
      *   isFound       - Returns TRUE is this map contains a mapping for the
      *                   specified key, else FALSE.
      *=========================================================================
     P BasicMap_containsKey...
     P                 B                   export
      *
     D BasicMap_containsKey...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D isFound         S               N   inz(cFalse)
      *
      *  Local fields
     D x               S             10I 0                       inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkMapHandle(i_pMap);

         // Locate element by key in list
         if findMapE(i_pMap: i_key) = -1;
            isFound = cFalse;
         else;
            isFound = cTrue;
         endif;

         return isFound;

      /END-FREE
      *
     P BasicMap_containsKey...
     P                 E
      *
      *=========================================================================
      *  Returns the value to which this map maps the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key whose associated value is to be returned.
      *   i_pEntry      - Value to be associated with the specified key.
      *   i_length      - Optional. The size of the value.
      *
      *  Returns:
      *   pElemData     - Pointer to the value addressed by 'i_key'.
      *=========================================================================
     P BasicMap_get...
     P                 B                   export
      *
     D BasicMap_get...
     D                 PI              *
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Return value
     D pElemData       S               *   inz
      *
      *  Parameter positions
     D p_pEntry        C                   const(3)
     D p_length        C                   const(4)
      *
      *  Fields for optional parameters
     D pEntry          S                   like(i_pEntry     ) inz
     D length          S                   like(i_length     ) inz
      *
      *  Local fields
     D x               S             10I 0                       inz
     D maxSize         S             10I 0                       inz
     D mapE            DS                  likeds(mapE_t       )
     D                                     based(pMapE         )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_get...
     P                 E
      *
      *=========================================================================
      *  Returns the string value to which this map maps the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key whose associated value is to be returned.
      *
      *  Returns:
      *   string        - String value addressed by 'i_key'.
      *=========================================================================
     P BasicMap_getString...
     P                 B                   export
      *
     D BasicMap_getString...
     D                 PI          4096A          varying
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D string          S           4096A   varying inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D length          S             10I 0 inz
     D maxSize         S             10I 0 inz
     D mapE            DS                  likeds(mapE_t       )
     D                                     based(pMapE         )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getString...
     P                 E
      *
      *=========================================================================
      *  Returns the integer value to which this map maps the specified key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key whose associated value is to be returned.
      *
      *  Returns:
      *   integer       - Integer value addressed by 'i_key'.
      *=========================================================================
     P BasicMap_getInteger...
     P                 B                   export
      *
     D BasicMap_getInteger...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D integer         S             10I 0 inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (BasicMap_get(i_pMap:i_key:%addr(integer):%size(integer)) = *NULL);
            integer = 0;
         endif;

         return integer;

      /END-FREE
      *
     P BasicMap_getInteger...
     P                 E
      *
      *=========================================================================
      *  Returns the key addressed by a given index.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_index       - Index whose associated value is to be returned.
      *
      *  Returns:
      *   key           - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_getKeyByIndex...
     P                 B                   export
      *
     D BasicMap_getKeyByIndex...
     D                 PI                         like(BasicMap_key_t    )
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Return value
     D key             S                   like(BasicMap_key_t    ) inz
      *
      *  Local fields
     D mapE_key        S                   like(BasicMap_key_t )
     D                                     based(mapE.pKey)
     D mapE            DS                  likeds(mapE_t       )
     D                                     based(pMapE         )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getKeyByIndex...
     P                 E
      *
      *=========================================================================
      *  Returns the value addressed by a given index.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_index       - Index whose associated value is to be returned.
      *   i_pEntry      - Value to be associated with the specified key.
      *   i_length      - Optional. The size of the value.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_getValueByIndex...
     P                 B                   export
      *
     D BasicMap_getValueByIndex...
     D                 PI              *
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Return value
     D pElemData       S               *   inz
      *
      *  Parameter positions
     D p_pEntry        C                   const(3)
     D p_length        C                   const(4)
      *
      *  Fields for optional parameters
     D pEntry          S                   like(i_pEntry     ) inz
     D length          S                   like(i_length     ) inz
      *
      *  Local fields
     D maxSize         S             10I 0                       inz
     D mapE            DS                  likeds(mapE_t       )
     D                                     based(pMapE         )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getValueByIndex...
     P                 E
      *
      *=========================================================================
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key with which the specified value is to be associated.
      *   i_pEntry      - Value to be associated with the specified key.
      *   i_length      - Optional. The size of the value.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_put...
     P                 B                   export
      *
     D BasicMap_put...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_length        C                   const(4)
      *
      *  Fields for optional parameters
     D length          S                   like(i_length     ) inz
      *
      *  Local fields
     D x               S             10I 0 inz
     D key             S                   like(BasicMap_key_t ) inz
     D mapE            DS                  likeds(mapE_t       ) inz
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_put...
     P                 E
      *
      *=========================================================================
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key with which the specified value is to be associated.
      *   i_string      - String value to be associated with the specified key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_putString...
     P                 B                   export
      *
     D BasicMap_putString...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_string                   4096A   const  varying
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Local fields
     D string          S                   like(i_string       ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = i_string;
         rc = BasicMap_put(i_pMap: i_key: %addr(string): %len(string) + 2);

         return rc;

      /END-FREE
      *
     P BasicMap_putString...
     P                 E
      *
      *=========================================================================
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key with which the specified value is to be associated.
      *   i_integer     - Integer value to be associated with the specified key.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicMap_putInteger...
     P                 B                   export
      *
     D BasicMap_putInteger...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_integer                    10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Local fields
     D integer         S                   like(i_integer      ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         integer = i_integer;
         rc = BasicMap_put(i_pMap: i_key: %addr(integer): %size(integer));

         return rc;

      /END-FREE
      *
     P BasicMap_putInteger...
     P                 E
      *
      *=========================================================================
      *  Returns the size of of the element that is associated with this key.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_key         - Key of the value.
      *
      *  Returns:
      *   size          - Returns the size of the element on success, else -1.
      *=========================================================================
     P BasicMap_getSize...
     P                 B                   export
      *
     D BasicMap_getSize...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Local fields
     D x               S             10I 0 inz
     D mapE            DS                  likeds(mapE_t       ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getSize...
     P                 E
      *
      *=========================================================================
      *  Returns the size of of the element that is addressed by a given index.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_index       - Index whose associated value is to be returned.
      *
      *  Returns:
      *   size          - Returns the size of the element on success, else -1.
      *=========================================================================
     P BasicMap_getSizeByIndex...
     P                 B                   export
      *
     D BasicMap_getSizeByIndex...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Local fields
     D mapE            DS                  likeds(mapE_t       ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkMapHandle(i_pMap);

         // Get element from underlaying list
         if BasicList_get(hMap.pList: i_index: %addr(mapE): %size(mapE))= *NULL;
            return -1;
         endif;

         size = mapE.size;

         return size;

      /END-FREE
      *
     P BasicMap_getSizeByIndex...
     P                 E
      *
      *=========================================================================
      *  Returns the number of key-value mappings in this map.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   size          - Returns the number of elements in this list on
      *                   success, else -1.
      *=========================================================================
     P BasicMap_getNumE...
     P                 B                   export
      *
     D BasicMap_getNumE...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D numE            S             10I 0 inz(-1)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkMapHandle(i_pMap);

         // Return number of elements of underlaying list
         numE = BasicList_getNumE(hMap.pList);

         return numE;

      /END-FREE
      *
     P BasicMap_getNumE...
     P                 E
      *
      *=========================================================================
      *  Returns the heap ID of a given BasicMap.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   heapID        - ID of the heap this BasicMap belongs to.
      *=========================================================================
     P BasicMap_getHeapID...
     P                 B                   export
      *
     D BasicMap_getHeapID...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D heapID          S             10I 0 inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkMapHandle(i_pMap);

         // Return the heap ID of underlaying list
         heapID = BasicList_getHeapID(hMap.pList);

         return heapID;

      /END-FREE
      *
     P BasicMap_getHeapID...
     P                 E
      *
      *=========================================================================
      *  Returns a list of all keys that are in a given map.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_pSortFnc    - Optional: Procedure pointer of sort procedure.
      *
      *  Returns:
      *   hList         - List, containing all keys of the map.
      *=========================================================================
     P BasicMap_getKeys...
     P                 B                   export
      *
     D BasicMap_getKeys...
     D                 PI                         like(BasicList_handle_t)
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_pSortFnc                     *   const  procptr
     D                                            options(*nopass)
      *
      *  Return value
     D hList           S                   like(BasicList_handle_t ) inz
      *
      *  Parameter positions
     D p_pSortFnc      C                   2
      *
      *  Fields for optional parameters
     D pSortFnc        S                   like(i_pSortFnc  ) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D key             S                   like(BasicMap_key_t ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getKeys...
     P                 E
      *
      *=========================================================================
      *  Returns a list of all values that are in a given map.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_pSortFnc    - Optional: Procedure pointer of sort procedure.
      *
      *  Returns:
      *   hList         - List, containing all values of the map.
      *=========================================================================
     P BasicMap_getValues...
     P                 B                   export
      *
     D BasicMap_getValues...
     D                 PI                         like(BasicList_handle_t)
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_pSortFnc                     *   const  procptr
     D                                            options(*nopass)
      *
      *  Return value
     D hList           S                   like(BasicList_handle_t ) inz
      *
      *  Parameter positions
     D p_pSortFnc      C                   2
      *
      *  Fields for optional parameters
     D pSortFnc        S                   like(i_pSortFnc  ) inz
      *
      *  Helper fields
     D x               S             10I 0 inz
     D size            S             10I 0 inz
     D pData           S               *   inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_getValues...
     P                 E
      *
      *=========================================================================
      *  Removes all entries from a given map.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicMap_clear...
     P                 B                   export
      *
     D BasicMap_clear...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Helper fields
     D x               S             10I 0 inz
     D numE            S             10I 0 inz
     D aPointer        S               *   inz
     D mapE            DS                  likeds(mapE_t       ) inz
      *
      *  Debug:
     D key             S                   like(BasicMap_key_t )
     D                                     based(mapE.pKey)
     D data            S          65535A   based(mapE.pData)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_clear...
     P                 E
      *
      *=========================================================================
      *  Deletes a given BasicMap.
      *=========================================================================
      *  Parameters:
      *   io_pMap       - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicMap_delete...
     P                 B                   export
      *
     D BasicMap_delete...
     D                 PI            10I 0
     D  io_pMap                                   like(BasicMap_handle_t )
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
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(io_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_delete...
     P                 E
      *
      *=========================================================================
      *  Returns a BasicMap NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pMap          - NULL handle of a BasicMap.
      *=========================================================================
     P BasicMap_null...
     P                 B                   export
      *
     D BasicMap_null...
     D                 PI                         like(BasicMap_handle_t )
      *
      *  Return value
     D pMap            S                   like(BasicMap_handle_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pMap = *NULL;

         return pMap;

      /END-FREE
      *
     P BasicMap_null...
     P                 E
      *
      *=========================================================================
      *  Checks a given BasicMap handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle is null, else FALSE.
      *=========================================================================
     P BasicMap_isNull...
     P                 B                   export
      *
     D BasicMap_isNull...
     D                 PI              N
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D isNull          S               N   inz(cTrue)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_pMap = BasicMap_null());
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return isNull;

      /END-FREE
      *
     P BasicMap_isNull...
     P                 E
      *
      *=========================================================================
      *  Produces a list of keys from a given map.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   pList         - Handle of the list which contains all keys of
      *                   the map.
      *=========================================================================
      *  Note:            Do not delete the list with BasicList_delete()!
      *                   Use BasicKeySet_delete() to delete the list.
      *=========================================================================
     P BasicMap_newKeySet...
     P                 B                   export
      *
     D BasicMap_newKeySet...
     D                 PI                         like(BasicKeySet_handle_t)
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicMap_newKeySet...
     P                 E
      *
      *=========================================================================
      *  Returns the first entry of a given key set.
      *=========================================================================
      *  Parameters:
      *   i_pKeySet     - Handle of a given KeySet, returned by
      *                   BasicMap_newKeySet().
      *
      *  Returns:
      *   key           - Returns the key of a map entry on success, else ''.
      *=========================================================================
     P BasicKeySet_getFirst...
     P                 B                   export
      *
     D BasicKeySet_getFirst...
     D                 PI                         like(BasicMap_key_t    )
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  KeySet handle
     D hKeySet         DS                  likeds(hKeySet_t  )
     D                                     based(i_pKeySet)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     )
     D                                     based(hKeySet.pMap)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkKeySetHandle(i_pKeySet);

         checkMapHandle(hKeySet.pMap);

         if (BasicList_isNull(hMap.pKeySet));
            return '';
         endif;

         hKeySet.x = 0;

         return BasicKeySet_getNext(i_pKeySet);

      /END-FREE
      *
     P BasicKeySet_getFirst...
     P                 E
      *
      *=========================================================================
      *  Returns the next entry of a given key set.
      *=========================================================================
      *  Parameters:
      *   i_pKeySet     - Handle of a given KeySet, returned by
      *                   BasicMap_newKeySet().
      *
      *  Returns:
      *   key           - Returns the key of a map entry on success, else ''.
      *=========================================================================
     P BasicKeySet_getNext...
     P                 B                   export
      *
     D BasicKeySet_getNext...
     D                 PI                         like(BasicMap_key_t    )
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  KeySet handle
     D hKeySet         DS                  likeds(hKeySet_t  )
     D                                     based(i_pKeySet)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     )
     D                                     based(hKeySet.pMap)
      *
      *  Helper fields
     D numE            S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicKeySet_getNext...
     P                 E
      *
      *=========================================================================
      *  Deletes the key list associated to a given map.
      *=========================================================================
      *  Parameters:
      *   io_pKeySet    - Handle of a given KeySet, returned by
      *                   BasicMap_newKeySet().
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P BasicKeySet_delete...
     P                 B                   export
      *
     D BasicKeySet_delete...
     D                 PI            10I 0
     D  io_pKeySet                                like(BasicKeySet_handle_t)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  KeySet handle
     D hKeySet         DS                  likeds(hKeySet_t  )
     D                                     based(io_pKeySet  )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     )
     D                                     based(pMap        )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P BasicKeySet_delete...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Produces a new KeySet handle.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Handle of a given map.
      *
      *  Returns:
      *   pKeySet       - Returns a handle for the KeySet on success, else
      *                   *NULL.
      *=========================================================================
     P produceKeySetHandle...
     P                 B
      *
     D produceKeySetHandle...
     D                 PI                         like(BasicKeySet_handle_t)
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D pKeySet         S                   like(BasicKeySet_handle_t)
      *
      *  Helper fields
     D x               S             10I 0 inz
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      *
      *  KeySet handle
     D hKeySet         DS                  likeds(hKeySet_t  ) based(pKeySet)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P produceKeySetHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Frees a given KeySet handle.
      *=========================================================================
      *  Parameters:
      *   io_pKeySet    - Handle of a given KeySet.
      *
      *  Returns:
      *   void
      *=========================================================================
     P freeKeySetHandle...
     P                 B
      *
     D freeKeySetHandle...
     D                 PI
     D  io_pKeySet                     *
      *
      *  Helper fields
     D x               S             10I 0 inz
      *
      *  KeySet handle
     D hKeySet         DS                  likeds(hKeySet_t  )
     D                                     based(io_pKeySet  )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     )
     D                                     based(pMap        )
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P freeKeySetHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Adds a key to the associated key set of a given map.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the key set (list).
      *   i_key         - Key to add.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P addKeySetEntry...
     P                 B
      *
     D addKeySetEntry...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_key                              const  like(BasicMap_key_t    )
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P addKeySetEntry...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Removes a key from the associated key set of a given map.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the key set (list).
      *   i_key         - Key to remove.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P removeKeySetEntry...
     P                 B
      *
     D removeKeySetEntry...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_key                              const  like(BasicMap_key_t    )
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P removeKeySetEntry...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Frees the memory of a given map entry.
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *   i_index       - Index of the map entry.
      *
      *  Returns:
      *   rc            - Returns 0 on success, else -1.
      *=========================================================================
     P freeMapE...
     P                 B
      *
     D freeMapE...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Helper fields
     D aPointer        S               *   inz
     D key             S                   like(BasicMap_key_t )
     D                                     based(mapE.pKey)
     D mapE            DS                  likeds(mapE_t       ) inz
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P freeMapE...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Searches the underlaying list for a given key.
      *  (Binary search algorithm)
      *=========================================================================
      *  Parameters:
      *   i_pMap        - Basing pointer of the map returned by BasicMap_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle is null, else FALSE.
      *=========================================================================
     P findMapE...
     P                 B
      *
     D findMapE...
     D                 PI            10I 0
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Helper fields
     D currentE        S             10I 0                       inz
     D lowerE          S             10I 0                       inz
     D upperE          S             10I 0                       inz
     D mapE_key        S                   like(BasicMap_key_t )
     D                                     based(mapE.pKey)
     D mapE            DS                  likeds(mapE_t )
     D                                     based(pMapE   )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P findMapE...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sorts the map.
      *=========================================================================
     P sortMap...
     P                 B
      *
     D sortMap...
     D                 PI
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         BasicList_sort(hMap.pList: %paddr('sortCallback'));

         return;

      /END-FREE
      *
     P sortMap...
     P                 E
      *
      *=========================================================================
      *  Procedure used by BasicList to sort this map.
      *=========================================================================
     P sortCallback...
     P                 B
      *
     D sortCallback...
     D                 PI            10I 0
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
      *  Return value
     D rc              S             10I 0 inz
      *
      *  Helper fields
     D keyMapE         DS                  likeds(mapE_t )
     D                                     based(i_pKeyData )
     D elemMapE        DS                  likeds(mapE_t )
     D                                     based(i_pElemData)
     D keyMapE_key     S                   like(BasicMap_key_t )
     D                                     based(keyMapE.pKey)
     D elemMapE_key    S                   like(BasicMap_key_t )
     D                                     based(elemMapE.pKey)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P sortCallback...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks, whether a given handle is a valid map handle, or not.
      *  Returns TRUE for a valid map handle, else FALSE.
      *=========================================================================
     P checkMapHandle...
     P                 B
      *
     D checkMapHandle...
     D                 PI
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Map handle
     D hMap            DS                  likeds(hMap_t     ) based(i_pMap )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P checkMapHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks, whether a given handle is a valid KeySet handle, or not.
      *  Returns TRUE for a valid map handle, else FALSE.
      *=========================================================================
     P checkKeySetHandle...
     P                 B
      *
     D checkKeySetHandle...
     D                 PI
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  Map handle
     D hKeySet         DS                  likeds(hKeySet_t  ) based(i_pKeySet)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

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

      /END-FREE
      *
     P checkKeySetHandle...
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
                        : 'BasicMap: ERROR - ' + i_text
                        : cMsg_Escape: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: i_proc);

         return;

      /END-FREE
      *
     P signalError...
     P                 E
      *
