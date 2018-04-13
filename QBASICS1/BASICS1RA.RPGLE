      *=====================================================================*
      *  BASICS1RA  - SrvPgm: Basic Routines - BasicList                    *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  18.05.2004                                              *
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
      *  24.08.2006  Th.Raddatz    Changed BasicList_get() to initialize    *
      *                            only that bytes of the return buffer     *
      *                            that are beyond the length of the list   *
      *                            entry.                                   *
      *                                                                     *
      *  24.04.2008  Th.Raddatz    Enabled BasicList to store NULL data.    *
      *                            Fixed problem that sortList() did not    *
      *                            return cTrue after having sorted the     *
      *                            list.                                    *
      *                            Renamed findEntryByDataPointer() to      *
      *                            findEntryBySignature() in order to       *
      *                            support NULL list entries.               *
      *                            Added procedures:                        *
      *                               BasicList_isSorted()                  *
      *                               BasicList_isNullValue()               *
      *                                                                     *
      *  28.04.2008  Th.Raddatz    Check type of list handle and send an    *
      *                            ESCAPE message for invalid handles.      *
      *                                                                     *
      *  27.05.2008  Th.Raddatz    Added procedure:                         *
      *                               BasicList_clone()                     *
      *                                                                     *
      *  23.03.2012  Th.Raddatz    Added error message 'Failed to allocate  *
      *                            memory' which is sent when the program   *
      *                            could not allocate/reallocate memory.    *
      *                                                                     *
      *  23.03.2012  Th.Raddatz    Changed 'signature_t' to use an epoch    *
      *                            time instead of a RPG timestamp value.   *
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
      *       >>PARM<< TGTRLS(V6R1M0);                                      *
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
      /COPY QBASICS1,PBASICS1RA
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D hList_t         DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  extType                            like(BasicList_type_t  )
     D  memSize                      10U 0
     D  numE                         10U 0
     D  maxNumE                      10U 0
     D  totalMemSize                 10U 0
     D  increment                    10U 0
      /IF NOT DEFINED(*V5R2M0)
     D  signature                          like(signature_t)
     D  sortSignature                      like(signature_t)
      /ELSE
     D  signature                          likeds(signature_t)
     D  sortSignature                      likeds(signature_t)
      /ENDIF
     D  heapID                       10I 0
     D  pBase                          *
     D  pAutoSortFnc                   *   procptr
     D  memMgr                             likeds(MemoryManager_manager_t)
      *
     D listE_t         DS                  qualified   based(pDummy)   align
     D  type                               like(BasicList_type_t  )
     D  size                         10U 0
     D  maxSize                      10U 0
      /IF NOT DEFINED(*V5R2M0)
     D  signature                          like(signature_t)
      /ELSE
     D  signature                          likeds(signature_t)
      /ENDIF
     D  pData                          *
      *
    * *signature_t     DS                  qualified   based(pDummy)   align
    * * tmStmp                         Z
    * * counter                      10U 0
      *
     D signature_t     DS                  qualified   based(pDummy)   align
     D  time                         10U 0
     D  millitm                      10U 0
     D  counter                      10U 0
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Produces a new list entry.
     D newEntry...
     D                 PR            10I 0
     D                                            extproc('newEntry')
     D  io_hList                                  likeds(hList_t   )
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Returns a pointer to the basing pointer of the
      *  liste entry.
     D getPointerArrayE...
     D                 PR              *
     D                                            extproc('getPointerArrayE')
     D  i_hList                            const  likeds(hList_t   )
     D  i_index                      10I 0 const
      *
      *  Returns a pointer to the element at the specified
      *  position in this list.
     D getPointerListE...
     D                 PR              *
     D                                            extproc('getPointerListE')
     D  i_hList                            const  likeds(hList_t   )
     D  i_index                      10I 0 const
      *
      *  Frees the memory of a given element in this list.
     D freeEntryData...
     D                 PR
     D                                            extproc('freeEntryData')
     D  io_hList                                  likeds(hList_t   )
     D  io_listE                                  likeds(listE_t   )
      *
      *  Returns TRUE if a given list contains no data.
     D entryData_isNULL...
     D                 PR              N
     D                                            extproc('entryData_isNULL')
     D  i_listE                            const  likeds(listE_t   )
      *
      *  Create a very basic list handle.
     D newListInternal...
     D                 PR              *
     D                                            extproc('newListInternal')
     D  i_extType                          const  like(BasicList_type_t  )
     D  i_increment                  10I 0 const
     D  i_heapID                     10I 0 const
     D  i_memMgr                           const  likeds(MemoryManager...
     D                                                   _manager_t)
      *
      *  Set the entry data.
     D setEntryData...
     D                 PR            10I 0
     D                                            extproc('setEntryData')
     D  io_hList                                  likeds(hList_t  )
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const
     D  i_length                     10I 0 const
      *
      *  Checks the range of the list index.
     D isIndexOutOfRange...
     D                 PR              N
     D                                            extproc('isIndexOutOfRange')
     D  i_hList                            const  likeds(hList_t  )
     D  i_index                      10I 0 const
      *
      *  Sorts a given list.
     D qsortCallback...
     D                 PR            10I 0
     D                                            extproc('qsortCallback')
     D  i_pKey                         *   value
     D  i_pElement                     *   value
      *
      *  Sorts the list if it is required and if an auto-sort procedure
      *  has been specified.
     D performAutoSort...
     D                 PR              N
     D                                            extproc('performAutoSort')
     D  io_hList                                  likeds(hList_t  )
      *
      *  Sorts the list.
     D sortList...
     D                 PR              N
     D                                            extproc('sortList')
     D  io_hList                                  likeds(hList_t  )
     D  i_pSortFnc                     *   const  procptr
      *
      *  Returns cTrue for a sorted list, else cFalse.                                       R
     D isSortedInternally...
     D                 PR              N
     D                                            extproc('isSortedInternally')
     D  i_hList                            const  likeds(hList_t  )
      *
      *  Searches the list for an entry that matches the specified data pointer
     D findEntryBySignature...
     D                 PR            10I 0
     D                                            extproc('+
     D                                            findEntryBySignature')
     D  i_hList                            const  likeds(hList_t    )
     D  i_signature                        const  likeds(signature_t)
      *
      *  Returns a new list signature.
     D Signature_new...
     D                 PR                         likeds(signature_t )
     D                                            extproc('Signature_new')
      *
      *  Checks, whether a given handle is a valid list handle, or not.
     D checkListHandle...
     D                 PR
     D                                            extproc('checkListHandle')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Sends a DIAG message to signal a problem.
     D signalProblem...
     D                 PR
     D                                            extproc('signalProblem')
     D  i_text                      128A   const  varying
     D  i_proc                      256A   const  varying
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
     D cHANDLE_TYPE_LIST...
     D                 C                   const(6688841203191988545)           =  *List
     D cHANDLE_SIZE...
     D                 C                   const(%size(hList_t))
      *
     D cERROR_LIST_HANDLE_NULL...
     D                 C                   const('List handle is NULL')
     D cERROR_LIST_HANDLE_INVALID...
     D                 C                   const('List handle is invalid')
     D cERROR_NO_MEMORY...
     D                 C                   const('Failed to allocate/+
     D                                            reallocate memory')
     D cPROBLEM_LIST_FULL...
     D                 C                   const('Maximum number of +
     D                                            list items reached')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_pSortFnc      S               *   inz procptr
      *
      *  Prototype of the external sort function. A procedure pointer
      *  of a function that matches this prototype must be passed to
      *  BasicList_sort().
      *
      *     Return Value          Meaning
      *     ---------------       -------------------------
      *     Less than 0           key less than element
      *     0                     key equal to element
      *     Greater than 0        key greater than element
      *
     D sortFnc...
     D                 PR            10I 0
     D                                     extproc(g_pSortFnc)
     D  i_pKeyData                     *   value
     D  i_keySize                    10I 0 value
     D  i_pElemData                    *   value
     D  i_elemSize                   10I 0 value
      *
      *=========================================================================
      *  Creates a new BasicList.
      *=========================================================================
      *  Parameters:
      *   i_extType     - The type of the list.
      *   i_increment   - The number of empty elements that are added to the
      *                   list when the list needs to be resized.
      *   i_memMgr      - The memory manager to use.
      *
      *  Returns:
      *   pList         - Returns the basing pointer of the list on
      *                   success, else NULL.
      *=========================================================================
     P BasicList_new...
     P                 B                   export
      *
     D BasicList_new...
     D                 PI                         like(BasicList_handle_t)
     D  i_extType                          const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D pList           S                   like(BasicList_handle_t) inz
      *
      *  Parameter positions
     D p_extType       C                   const(1)
     D p_increment     C                   const(2)
     D p_heapID        C                   const(3)
      *
      *  Fields for optional parameters
     D extType         S                   like(i_extType   ) inz
     D increment       S                   like(i_increment ) inz
     D heapID          S                   like(i_heapID    ) inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
      *
      *  House keeping:
      *     List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get values of optional parameters
         // ... i_extType
         if %parms() >= p_extType;
            CEETSTA(isPresent: p_extType: *omit);
         else;
            isPresent = 0;
         endif;

         if isPresent = 1;
            extType = i_extType;
         else;
            extType = '';
         endif;

         // ... i_increment
         if %parms() >= p_increment;
            CEETSTA(isPresent: p_increment: *omit);
         else;
            isPresent = 0;
         endif;

         if isPresent = 1;
            increment = i_increment;
         else;
            increment = 256;
         endif;

         // ... i_heapID
         if %parms() >= p_heapID;
            CEETSTA(isPresent: p_heapID: *omit);
         else;
            isPresent = 0;
         endif;

         if isPresent = 1;
            heapID = i_heapID;
         else;
            heapID = 0;
         endif;

         // Set memory manager
         mm_memMgr = MemoryManager_getDefaultManager();

         // Initialize house keeping fields
         pHList = *NULL;

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Create a very basic list
            pHList = newListInternal(extType: increment: heapID: mm_memMgr);

            // Ready
            isDone = cTrue;
         enddo;

         // Error!
         if isError;
            // Free memory of list handle
            if pHList <> *NULL;
               mm_free(pHList);
               pHList = *NULL;
            endif;
         endif;

         // Set return value
         if isDone;
            pList = pHList;
         else;
            pList = BasicList_null();
         endif;

         return pList;

      /END-FREE
      *
     P BasicList_new...
     P                 E
      *
      *=========================================================================
      *  Clones a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   pList         - Returns the basing pointer of the cloned list on
      *                   success, else NULL.
      *=========================================================================
     P BasicList_clone...
     P                 B                   export
      *
     D BasicList_clone...
     D                 PI                         like(BasicList_handle_t)
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D pListRtn        S                   like(BasicList_handle_t) inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D x               S             10I 0 inz
     D numE            S             10I 0 inz
     D size            S             10I 0 inz
     D pData           S               *   inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  House keeping:
      *     List handle
     D pTmpList        S                   like(BasicList_handle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         pListRtn = BasicList_null();

         // Initialize house keeping fields
         pTmpList = BasicList_null();

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = i_pList;

            // Create a new and empty list
            pTmpList = BasicList_new(hList.extType: hList.increment);
            if (BasicList_isNull(pTmpList));
               isError = cTrue;
               leave;
            endif;

            // Copy list entries
            numE = BasicList_getNumE(i_pList);
            for x = 1 to numE;
               if (BasicList_isNullValue(i_pList: x));
                  BasicList_addNull(pTmpList);
               else;
                  size  = BasicList_getSize(i_pList: x);
                  pData = BasicList_get(i_pList: x);
                  BasicList_add(pTmpList: pData: size);
               endif;
            endfor;

            // Set return value
            pListRtn = pTmpList;
            pTmpList = BasicList_null();

            // Done.
            isDone = cTrue;
         enddo;

         // House keeping ...
         // ... pTmpList
         if (not BasicList_isNull(pTmpList));
            BasicList_delete(pTmpList);
         endif;

         return pListRtn;

      /END-FREE
      *
     P BasicList_clone...
     P                 E
      *
      *=========================================================================
      *  Returns a given element.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *   i_pEntry      - Address where to copy the entry data to.
      *                   If this parameter is not passed, the address
      *                   of the list entry data is returned. Hence
      *                   you gain direct access to the list entry data!
      *   i_length      - The maximum size of the entry data.
      *
      *  Returns:
      *   pEntry        - Returns a pointer to the entry data on
      *                   success, else NULL.
      *=========================================================================
     P BasicList_get...
     P                 B                   export
      *
     D BasicList_get...
     D                 PI              *
     D  i_pList                            const  like(BasicList_handle_t)
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
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D maxSize         S             10I 0 inz
     D numRemBytes     S             10I 0 inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  List entry
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

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

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = i_pList;

            // Verify range of i_index
            if isIndexOutOfRange(hList: i_index);
               isError = cTrue;
               leave;
            endif;

            // Get access to entry data
            pListE = getPointerListE(hList: i_index);

            // Determine number of bytes to copy
            if length < listE.size;
               maxSize = length;
            else;
               maxSize = listE.size;
            endif;

            // Initialize return buffer (remaining bytes only)
            numRemBytes = length - listE.size;
            if numRemBytes > 0;
               memset((pEntry + listE.size): x'00': numRemBytes);
            endif;

            // Copy entry data
            if maxSize > 0;
               memcpy(pEntry: listE.pData: maxSize);
               pElemData = pEntry;
            else;
               pElemData = listE.pData;
            endif;

            // Done.
            isDone = cTrue;
         enddo;

         return pElemData;

      /END-FREE
      *
     P BasicList_get...
     P                 E
      *
      *=========================================================================
      *  Returns a given string.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   string        - Returns a string on success, else ''.
      *=========================================================================
     P BasicList_getString...
     P                 B                   export
      *
     D BasicList_getString...
     D                 PI          4096A          varying
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D string          S           4096A   varying inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         BasicList_get(i_pList: i_index: %addr(string): %size(string));

         return string;

      /END-FREE
      *
     P BasicList_getString...
     P                 E
      *
      *=========================================================================
      *  Returns a the pointer element from the specified position.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   pointer       - Returns a pointer on success, else *NULL.
      *=========================================================================
     P BasicList_getPointer...
     P                 B                   export
      *
     D BasicList_getPointer...
     D                 PI              *
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D pointer         S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         BasicList_get(i_pList: i_index: %addr(pointer): %size(pointer));

         return pointer;

      /END-FREE
      *
     P BasicList_getPointer...
     P                 E
      *
      *=========================================================================
      *  Returns the external type of the list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   type          - Returns the list type on success, else '';
      *=========================================================================
     P BasicList_getListType...
     P                 B                   export
      *
     D BasicList_getListType...
     D                 PI                         like(BasicList_type_t  )
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D type            S                   like(BasicList_type_t  ) inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         type = hList.extType;

         return type;

      /END-FREE
      *
     P BasicList_getListType...
     P                 E
      *
      *=========================================================================
      *  Checks the list for a given external type.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_type        - The type of the list.
      *
      *  Returns:
      *   isOfType      - Returns TRUE if the list matches the specified type,
      *                   else, FALSE.
      *=========================================================================
     P BasicList_isListTypeOf...
     P                 B                   export
      *
     D BasicList_isListTypeOf...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Return value
     D isValid         S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         if i_type = hList.extType;
            isValid  = cTrue;
         else;
            isValid  = cFalse;
         endif;

         return isValid;

      /END-FREE
      *
     P BasicList_isListTypeOf...
     P                 E
      *
      *=========================================================================
      *  Checks an list entry for a given type.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *   i_type        - The type of the list.
      *
      *  Returns:
      *   isOfType      - Returns TRUE if the list matches the specified type,
      *                   else, FALSE.
      *=========================================================================
     P BasicList_isTypeOf...
     P                 B                   export
      *
     D BasicList_isTypeOf...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Return value
     D isValid         S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         // Verify range of i_index
         if isIndexOutOfRange(hList: i_index);
            isValid = cFalse;
            return isValid;
         endif;

         // Get access to entry data
         pListE = getPointerListE(hList: i_index);

         // Verify entry type
         if listE.type = i_type;
            isvalid = cTrue;
         else;
            isvalid = cFalse;
         endif;

         return isValid;

      /END-FREE
      *
     P BasicList_isTypeOf...
     P                 E
      *
      *=========================================================================
      *  Returns the type of the specified list entry.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   type          - Returns the type on success, else ''.
      *=========================================================================
     P BasicList_getType...
     P                 B                   export
      *
     D BasicList_getType...
     D                 PI                         like(BasicList_type_t  )
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D type            S                   like(BasicList_type_t  ) inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         // Verify range of i_index
         if isIndexOutOfRange(hList: i_index);
            type = '';
            return type;
         endif;

         // Get access to entry data
         pListE = getPointerListE(hList: i_index);

         // Return entry type
         type = listE.type;

         return type;

      /END-FREE
      *
     P BasicList_getType...
     P                 E
      *
      *=========================================================================
      *  Returns the size of of an element.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   size          - Returns the size of the element on success, else -1.
      *=========================================================================
     P BasicList_getSize...
     P                 B                   export
      *
     D BasicList_getSize...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  List entry
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = i_pList;

            // Verify range of i_index
            if isIndexOutOfRange(hList: i_index);
               isError = cTrue;
               leave;
            endif;

            // Get access to entry data
            pListE = getPointerListE(hList: i_index);

            // Ready
            isDone = cTrue;
         enddo;

         // Set return value
         if isDone;
            size = listE.size;
         else;
            size = -1;
         endif;

         return size;

      /END-FREE
      *
     P BasicList_getSize...
     P                 E
      *
      *=========================================================================
      *  Adds a element to a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_pEntry      - The entry to be added to this list.
      *   i_length      - Optional. The size of the entry data.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_add...
     P                 B                   export
      *
     D BasicList_add...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass: *omit)
     D  i_type                             const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_length        C                   const(3)
     D p_type          C                   const(4)
      *
      *  Fields for optional parameters
     D length          S                   like(i_length     ) inz
     D type            S                   like(i_type       ) inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
     D x               S             10U 0 inz
     D pEntryData      S               *   inz
     D prvListSortSignature...
     D                 DS                  likeds(signature_t) inz
     D entrySignature  DS                  likeds(signature_t) inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get length of entry data
            if %parms() >= p_length;
               CEETSTA(isPresent: p_length: *omit);
            else;
               isPresent = 0;
            endif;

            if isPresent = 1;
               length = i_length;
            else;
               if i_pEntry = *NULL;
                  length = 0;
               else;
                  length = strlen(i_pEntry);
               endif;
            endif;

            // Get type of entry data
            if %parms() >= p_type;
               CEETSTA(isPresent: p_type: *omit);
            else;
               isPresent = 0;
            endif;

            if isPresent = 1;
               type = i_type;
            else;
               type = cBASICLIST_TYPE_UNKNOWN;
            endif;

            // Get access to list handle
            pHList = i_pList;

            // Produce new entry
            x = newEntry(hList: type);
            if x = 0;
               isError = cTrue;
               leave;
            endif;

            // Get access to entry data
            pListE = getPointerListE(hList: x);

            // Set entry data
            setEntryData(hList: x: i_pEntry: length);

            // Save pointer to entry signature
            entrySignature = listE.signature;

            // Sort list, if required
            prvListSortSignature = hList.sortSignature;
            performAutoSort(hList);

            // Find entry using its signature if the list
            // had been sorted.
            if (prvListSortSignature <> hList.sortSignature);
               x = findEntryBySignature(hList: entrySignature);
            endif;

            // Ready
            isDone = cTrue;
         enddo;

         // Set return value
         if isDone;
            index = x;
         else;
            index = -1;
         endif;

         return index;

      /END-FREE
      *
     P BasicList_add...
     P                 E
      *
      *=========================================================================
      *  Adds a string to a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_string      - The string to be added to this list.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_addString...
     P                 B                   export
      *
     D BasicList_addString...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_string                   4096A   const  varying
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Helper fields
     D string          S                   like(i_string) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = i_string;

         index = BasicList_add(i_pList: %addr(string)
                                      : %len(i_string) + 2
                                      : cBASICLIST_TYPE_VSTRING);

         return index;

      /END-FREE
      *
     P BasicList_addString...
     P                 E
      *
      *=========================================================================
      *  Adds a pointer to a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_pointer     - The pointer to be added to this list.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_addPointer...
     P                 B                   export
      *
     D BasicList_addPointer...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pointer                      *   const
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Helper fields
     D pointer         S                   like(i_pointer) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pointer = i_pointer;

         index = BasicList_add(i_pList: %addr(pointer)
                                      : %size(pointer)
                                      : cBASICLIST_TYPE_POINTER);

         return index;

      /END-FREE
      *
     P BasicList_addPointer...
     P                 E
      *
      *=========================================================================
      *  Adds a NULL value to a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_addNull...
     P                 B                   export
      *
     D BasicList_addNull...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         index = BasicList_add(i_pList: *NULL);

         return index;

      /END-FREE
      *
     P BasicList_addNull...
     P                 E
      *
      *=========================================================================
      *  Searches the list for a given element.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_pEntry      - The entry to be added to this list.
      *   i_length      - Optional. The size of the entry data.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_find...
     P                 B                   export
      *
     D BasicList_find...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_length        C                   const(3)
      *
      *  Fields for optional parameters
     D length          S                   like(i_length     ) inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D ignoreCase      S               N   inz(cFalse)
     D x               S             10U 0 inz
     D rc              S             10I 0 inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get length of entry data
            if %parms() >= p_length;
               length = i_length;
            else;
               length = strlen(i_pEntry);
            endif;

            // Get access to list handle
            pHList = i_pList;

            // Spin through entries in list searching for the request element
            for x = 1 to hList.numE;

               // Get access to entry data
               pListE = getPointerListE(hList: x);

               // Compare entry attributes
               if (length = listE.size);
                  if ignoreCase;
                     rc = memicmp(i_pEntry: listE.pData: length);
                  else;
                     rc = memcmp(i_pEntry: listE.pData: length);
                  endif;
               else;
                  rc = -1;
               endif;

               if rc = 0;
                  index = x;
                  leave;
               endif;

            endfor;

            // Ready
            isDone = cTrue;
         enddo;

         return index;

      /END-FREE
      *
     P BasicList_find...
     P                 E
      *
      *=========================================================================
      *  Searches the list for a given string.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_string      - The string to be added to this list.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_findString...
     P                 B                   export
      *
     D BasicList_findString...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_string                   4096A   const  varying
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D x               S             10U 0                inz
     D string          S                   like(i_string) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = i_string;

         index = BasicList_find(i_pList: %addr(string): %len(i_string) + 2);

         return index;

      /END-FREE
      *
     P BasicList_findString...
     P                 E
      *
      *=========================================================================
      *  Changes the element at the specified position in this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *   i_pEntry      - The entry to be added to this list.
      *   i_length      - Optional. The size of the entry data.
      *
      *  Returns:
      *   length        - Returns the length of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_set...
     P                 B                   export
      *
     D BasicList_set...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass: *omit)
     D  i_type                             const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D newLength       S             10I 0 inz(-1)
      *
      *  Parameter positions
     D p_length        C                   const(4)
     D p_type          C                   const(5)
      *
      *  Fields for optional parameters
     D length          S                   like(i_length     ) inz
     D type            S                   like(i_type       ) inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D isPresent       S             10I 0 inz
      *
      *  Handle Data
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get length of entry data
            if %parms() >= p_length;
               CEETSTA(isPresent: p_length: *omit);
            else;
               isPresent = 0;
            endif;

            if isPresent = 1;
               length = i_length;
            else;
               if i_pEntry = *NULL;
                  length = 0;
               else;
                  length = strlen(i_pEntry);
               endif;
            endif;

            // Get type of entry data
            if %parms() >= p_type;
               CEETSTA(isPresent: p_type: *omit);
            else;
               isPresent = 0;
            endif;

            if isPresent = 1;
               type = i_type;
            else;
               type = cBASICLIST_TYPE_UNKNOWN;
            endif;

            // Get access to list handle
            pHList = i_pList;

            // Set entry data
            newLength = setEntryData(hList: i_index: i_pEntry: length);

            // Sort list, if required
            performAutoSort(hList);

            // Ready
            isDone = cTrue;
         enddo;

         return newLength;

      /END-FREE
      *
     P BasicList_set...
     P                 E
      *
      *=========================================================================
      *  Changes the element at the specified position to NULL.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   length        - Returns the length (always 0) of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_setNull...
     P                 B                   export
      *
     D BasicList_setNull...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D newLength       S             10I 0 inz(-1)
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         newLength = BasicList_set(i_pList: i_index: *NULL);

         return newLength;

      /END-FREE
      *
     P BasicList_setNull...
     P                 E
      *
      *=========================================================================
      *  Changes the string at the specified position in this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *   i_string      - The string that is changed.
      *
      *  Returns:
      *   length        - Returns the length of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_setString...
     P                 B                   export
      *
     D BasicList_setString...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_string                   4096A   const  varying
      *
      *  Return value
     D newLength       S             10I 0 inz(-1)
      *
      *  Helper fields
     D string          S                   like(i_string) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = i_string;

         newLength = BasicList_set(i_pList: i_index
                                          : %addr(string)
                                          : %len(i_string) + 2
                                          : cBASICLIST_TYPE_VSTRING);

         return newLength;

      /END-FREE
      *
     P BasicList_setString...
     P                 E
      *
      *=========================================================================
      *  Changes the pointer at the specified position in this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *   i_pointer     - The pointer that is changed.
      *
      *  Returns:
      *   length        - Returns the length of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicList_setPointer...
     P                 B                   export
      *
     D BasicList_setPointer...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_pointer                      *   const
      *
      *  Return value
     D newLength       S             10I 0 inz(-1)
      *
      *  Helper fields
     D pointer         S                   like(i_pointer) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pointer = i_pointer;

         newLength = BasicList_set(i_pList: i_index
                                          : %addr(pointer)
                                          : %size(pointer)
                                          : cBASICLIST_TYPE_POINTER);

         return newLength;

      /END-FREE
      *
     P BasicList_setPointer...
     P                 E
      *
      *=========================================================================
      *  Removes the element at the specified position in this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Index of a given list element.
      *
      *  Returns:
      *   rc            - Returns 0 success, else -1.
      *=========================================================================
     P BasicList_remove...
     P                 B                   export
      *
     D BasicList_remove...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D pTarget         S               *   inz
     D pSource         S               *   inz
     D size            S             10U 0 inz
     D curIndex        S             10U 0 inz
     D numDeletedE     S             10U 0 inz
      *
     D range           DS                  qualified
     D  from                         10U 0 inz
     D  to                           10U 0 inz
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  List entry
     D listE           DS                  likeds(listE_t    ) based(pListE)
     D pListE          S               *   based(ppListE)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Set memory manager
         mm_memMgr = MemoryManager_getDefaultManager();

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = i_pList;

            // Return to caller if there are no entries in this list
            if hList.numE = 0;
               isDone = cTrue;
               leave;
            endif;

            // Determine the range of elements to remove
            if i_index = cBASICLIST_REMOVE_ALL;
               range.from = 1;
               range.to   = hList.numE;
            else;
               range.from = i_index;
               range.to   = i_index;
            endif;

            // Remove all entries within the specified range:
            numDeletedE = 0;

            for curIndex = range.from to range.to;

               // Increment number of removed entries
               numDeletedE = numDeletedE + 1;

               // Get access to entry data
               ppListE = getPointerArrayE(hList: curIndex);

               // Free entry data:
               if (pListE <> *NULL);
                  if not entryData_isNULL(listE);
                     clear listE.signature;
                     freeEntryData(hList: listE);
                  endif;

                  mm_free(pListE);
                  ppListE = *NULL;

                  hList.totalMemSize = hList.totalMemSize + %size(listE_t);
               endif;

            endfor;

            // If it was not the last entry that was removed
            // from the list, ...
            if range.to < hList.numE;

               // ... then shifts any subsequent elements to the left
               pTarget = getPointerArrayE(hList: range.from);
               pSource = getPointerArrayE(hList: range.to + 1);
               size    = (hList.numE - range.from) * %size(pDummy);
               memmove(pTarget: pSource: size);

            endif;

            // Compute number of elements remaining in this list
            hList.numE = hList.numE - numDeletedE;

            // Set new signature
            hList.signature = Signature_new();

            // Initialize freed memory
            pSource = getPointerArrayE(hList: hList.numE + 1);
            size    = numDeletedE * %size(pDummy);
            memset(pSource: x'00': size);

            // We just removed an element from the list.
            // Hence we do not need to sort the list again.
            hList.sortSignature = hList.signature;

            // Done.
            isDone = cTrue;
         enddo;

         // Set return value
         if isDone;
            rc = 0;
         else;
            rc = -1;
         endif;

         return rc;

      /END-FREE
      *
     P BasicList_remove...
     P                 E
      *
      *=========================================================================
      *  Returns the number of elements in this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   size          - Returns the number of elements in this list on
      *                   success, else -1.
      *=========================================================================
     P BasicList_getNumE...
     P                 B                   export
      *
     D BasicList_getNumE...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D numE            S             10I 0 inz(-1)
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = i_pList;

            // Ready
            isDone = cTrue;
         enddo;

         // Set return value
         if isDone;
            numE = hList.numE;
         else;
            numE = -1;
         endif;

         return numE;

      /END-FREE
      *
     P BasicList_getNumE...
     P                 E
      *
      *=========================================================================
      *  Returns the heap ID of a given BasicList.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   heapID        - ID of the heap this BasicList belongs to.
      *=========================================================================
     P BasicList_getHeapID...
     P                 B                   export
      *
     D BasicList_getHeapID...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D heapID          S             10I 0 inz(-1)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         heapID = hList.heapID;

         return heapID;

      /END-FREE
      *
     P BasicList_getHeapID...
     P                 E
      *
      *=========================================================================
      *  Sorts a list using the specified sort function.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_pSortFnc    - Procedure pointer of sort procedure.
      *
      *  Returns:
      *   isSorted      - Returns TRUE on success, else FALSE.
      *=========================================================================
     P BasicList_sort...
     P                 B                   export
      *
     D BasicList_sort...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pSortFnc                     *   const  procptr
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         // Sort the list.
         isSorted = sortList(hList: i_pSortFnc);

         return isSorted;

      /END-FREE
      *
     P BasicList_sort...
     P                 E
      *
      *=========================================================================
      *  Returns cTrue if a given list is sorted.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   isSorted      - Returns TRUE if the list is sorted, else cFalse.
      *=========================================================================
     P BasicList_isSorted...
     P                 B                   export
      *
     D BasicList_isSorted...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         return isSortedInternally(hList);

      /END-FREE
      *
     P BasicList_isSorted...
     P                 E
      *
      *=========================================================================
      *  Specifies an auto-sort function for this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_pSortFnc    - Procedure pointer of sort procedure.
      *
      *  Returns:
      *   isSet         - Returns TRUE on success, else FALSE.
      *=========================================================================
     P BasicList_setAutoSort...
     P                 B                   export
      *
     D BasicList_setAutoSort...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pSortFnc                     *   const  procptr
      *
      *  Return value
     D isSet           S               N   inz(cFalse)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         // Set auto-sort procedure address
         hList.pAutoSortFnc = i_pSortFnc;

         // Sort list
         if performAutoSort(hList);
            isSet = cTrue;
         else;
            isSet = cFalse;
         endif;

         return isSet;

      /END-FREE
      *
     P BasicList_setAutoSort...
     P                 E
      *
      *=========================================================================
      *  Removes all entries from a given list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicList_clear...
     P                 B                   export
      *
     D BasicList_clear...
     D                 PI            10I 0
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Return to caller if there are no entries in this list
         if BasicList_getNumE(i_pList) = 0;
            rc = 0;
         else;
            // Remove all entries from the list
            rc = BasicList_remove(i_pList: cBASICLIST_REMOVE_ALL);
         endif;

         return rc;

      /END-FREE
      *
     P BasicList_clear...
     P                 E
      *
      *=========================================================================
      *  Returns the total size of memory used by this list.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   totalSize     - Returns the total size of memory used by the list.
      *=========================================================================
     P BasicList_getTotalSize...
     P                 B                   export
      *
     D BasicList_getTotalSize...
     D                 PI            20I 0
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D totalSize       S             20I 0 inz(-1)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(i_pList);

         // Get access to list handle
         pHList = i_pList;

         // Set return value
         totalSize = hList.totalMemSize;

         return totalSize;

      /END-FREE
      *
     P BasicList_getTotalSize...
     P                 E
      *
      *=========================================================================
      *  Deletes a given BasicList.
      *=========================================================================
      *  Parameters:
      *   io_pList      - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicList_delete...
     P                 B                   export
      *
     D BasicList_delete...
     D                 PI            10I 0
     D  io_pList                                  like(BasicList_handle_t)
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkListHandle(io_pList);

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Get access to list handle
            pHList = io_pList;

            // Set memory manager
            mm_memMgr = hList.memMgr;

            // Free all list entries
            dow hList.numE > 0;
               BasicList_remove(io_pList: hList.numE);
            enddo;

            p_assert(hList.numE = 0);

            // Free memory of list handle
            if hList.pBase <> *NULL;
               hList.totalMemSize = hList.totalMemSize - hList.memSize;
               mm_free(hList.pBase);
               hList.memSize = 0;
            endif;

            p_assert(hList.pBase = *NULL);

            // Clear handle data
            clear hList;
            hList.intType       = 0;
            hList.intSize       = 0;
            hList.extType       = *ALLx'00';
            hList.memSize       = 0;
            hList.numE          = 0;
            hList.maxNumE       = 0;
            hList.totalMemSize  = 0;
            hList.increment     = 0;
            hList.signature     = Signature_new();
            hList.sortSignature = hList.signature;
            hList.pBase         = *NULL;
            hList.pAutoSortFnc  = *NULL;

            // Free memory of list handle
            mm_free(pHList);

            // Ready
            isDone = cTrue;
         enddo;

         // Set return parameter value
         if isDone;
            io_pList = BasicList_null();
         endif;

         // Set return value
         if isDone;
            rc = 0;
         else;
            rc = -1;
         endif;

         return rc;

      /END-FREE
      *
     P BasicList_delete...
     P                 E
      *
      *=========================================================================
      *  Returns a BasicList NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pList         - NULL handle of a BasicList.
      *=========================================================================
     P BasicList_null...
     P                 B                   export
      *
     D BasicList_null...
     D                 PI                         like(BasicList_handle_t)
      *
      *  Return value
     D pList           S                   like(BasicList_handle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pList = *NULL;

         return pList;

      /END-FREE
      *
     P BasicList_null...
     P                 E
      *
      *=========================================================================
      *  Checks a given BasicList handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle is null, else FALSE.
      *=========================================================================
     P BasicList_isNull...
     P                 B                   export
      *
     D BasicList_isNull...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Return value
     D isNull          S               N   inz(cTrue)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if i_pList = BasicList_null();
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return isNull;

      /END-FREE
      *
     P BasicList_isNull...
     P                 E
      *
      *=========================================================================
      *  Checks a given BasicList entry for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pList       - Basing pointer of the list returned by BasicList_new().
      *   i_index       - Position of the element.
      *
      *  Returns:
      *   isNull        - Returns TRUE if the liste entry is null, else FALSE.
      *=========================================================================
     P BasicList_isNullValue...
     P                 B                   export
      *
     D BasicList_isNullValue...
     D                 PI              N
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Return value
     D isNull          S               N   inz(cTrue)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  List entry
     D listE           DS                  likeds(listE_t    ) based(pListE)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get access to list handle
         pHList = i_pList;

         // Verify range of i_index
         if isIndexOutOfRange(hList: i_index);
            p_assert(cFalse:
                     'Index value (' + %char(i_index) + ') is out of range');
         endif;

         // Get access to entry data
         pListE = getPointerListE(hList: i_index);

         if (listE.pData = *NULL);
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return isNull;

      /END-FREE
      *
     P BasicList_isNullValue...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Produces a new list entry.
      *=========================================================================
     P newEntry...
     P                 B
      *
     D newEntry...
     D                 PI            10I 0
     D  i_hList                                   likeds(hList_t   )
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Return value
     D index           S             10I 0 inz
      *
      *  Loop control
     D isDone          S               N   inz(cFalse)
     D isError         S               N   inz(cFalse)
      *
      *  Helper fields
     D newMemSize      S                   like(hList_t.memSize) inz
     D listE           DS                  likeds(listE_t      ) based(pListE)
     D pListE          S               *   based(ppListE)
      *
      *  Maximum size for a non-Teraspace malloc()
     D MAX_MEM_SIZE    C                   16711568
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Do until everything is done or an error occured
         dou isDone or isError;

            // Set memory manager
            mm_memMgr = i_hList.memMgr;

            // If the there are no more free entries in this list, ...
            if i_hList.maxNumE = i_hList.numE;

               // ... then check amout of used memory and
               if i_hList.memSize >= MAX_MEM_SIZE;
                  signalError(cPROBLEM_LIST_FULL: f_caller());
                  // signalProblem(cPROBLEM_LIST_FULL: f_caller());
                  // signalProblem(
                  //       '#list items: ' +
                  //        %char(i_hList.maxNumE): f_caller());
                  // signalProblem(
                  //       '#total size of memory: ' +
                  //        %char(i_hList.totalMemSize): f_caller());
                  // return 0;
               endif;

               // ... (re)allocate additional memory
               newMemSize = i_hList.memSize +
                            (%size(pDummy) * i_hList.increment);

               if (newMemSize > MAX_MEM_SIZE);
                  newMemSize =
                        %div(MAX_MEM_SIZE: %size(pDummy)) * %size(pDummy);
               endif;

               if i_hList.pBase = *NULL;
                  i_hList.pBase = mm_allocate(newMemSize: i_hList.heapID);
               else;
                  i_hList.pBase = mm_reallocate(i_hList.pBase: newMemSize);
               endif;

               if i_hList.pBase = *NULL;
                  signalError(cERROR_NO_MEMORY: f_caller());
               endif;

               i_hList.totalMemSize = i_hList.totalMemSize - i_hList.memSize;

               i_hList.memSize      = newMemSize;
               i_hList.maxNumE      = i_hList.memSize / %size(pDummy);

               i_hList.totalMemSize = i_hList.totalMemSize + i_hList.memSize;
            endif;

            // Increment number of entries in this list
            i_hList.numE = i_hList.numE + 1;

            // Set new signature
            i_hList.signature = Signature_new();

            // Create liste entry
            ppListE = getPointerArrayE(i_hList: i_hList.numE);
            pListE = mm_allocate(%size(listE_t): i_hList.heapID);

            i_hList.totalMemSize = i_hList.totalMemSize + %size(listE_t);

            // Initialize entry data
            clear listE;
            listE.type      = i_type;
            listE.pData     = *NULL;
            listE.size      = 0;
            listE.maxSize   = 0;
            listE.signature = Signature_new();

            // Ready
            isDone = cTrue;
         enddo;

         // Set return value
         if isDone;
            index = i_hList.numE;
         else;
            index = 0;
         endif;

         return index;

      /END-FREE
      *
     P newEntry...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns a pointer to the basing pointer of the
      *  liste entry.
      *=========================================================================
     P getPointerArrayE...
     P                 B
      *
     D getPointerArrayE...
     D                 PI              *
     D  i_hList                            const  likeds(hList_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D ppListE         S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Compute memory address of list entry
         ppListE = i_hList.pBase + ((i_index-1) * %size(pDummy));

         return ppListE;

      /END-FREE
      *
     P getPointerArrayE...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns a pointer to the element at the specified
      *  position in this list.
      *=========================================================================
     P getPointerListE...
     P                 B
      *
     D getPointerListE...
     D                 PI              *
     D  i_hList                            const  likeds(hList_t   )
     D  i_index                      10I 0 const
      *
      *  Return value
     D pListE          S               *   based(ppListE)
     D ppListE         S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Compute memory address of list entry
         ppListE = getPointerArrayE(i_hList: i_index);

         return pListE;

      /END-FREE
      *
     P getPointerListE...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Frees the memory of a given element in this list.
      *=========================================================================
     P freeEntryData...
     P                 B
      *
     D freeEntryData...
     D                 PI
     D  i_hList                                   likeds(hList_t   )
     D  io_listE                                  likeds(listE_t   )
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Do until everything is done or an error occured
         dou '1';

            // Set memory manager
            mm_memMgr = i_hList.memMgr;

            // Keep track of the sized of memory used by the list
            i_hList.totalMemSize = i_hList.totalMemSize - io_listE.maxSize;

            // Initialize entry data
            if io_listE.size > 0;
               memset(io_listE.pData: x'00': io_listE.maxSize);
            endif;

            // Free memory of entry entry
            mm_free(io_listE.pData);
            io_listE.type    = '';
            io_listE.size    = 0;
            io_listE.maxSize = 0;

            i_hList.totalMemSize = i_hList.totalMemSize + io_listE.maxSize;
         enddo;

         return;

      /END-FREE
      *
     P freeEntryData...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns TRUE if a given list contains no data.
      *=========================================================================
     P entryData_isNULL...
     P                 B
      *
     D entryData_isNULL...
     D                 PI              N
     D  i_listE                            const  likeds(listE_t   )
      *
      *  Return value
     D isNULL          S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_listE.size = 0) and (i_listE.pData = *NULL);
            isNULL = cTrue;
         else;
            isNULL = cFalse;
         endif;

         return isNULL;

      /END-FREE
      *
     P entryData_isNULL...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Create a very basic list handle.
      *=========================================================================
     P newListInternal...
     P                 B
      *
     D newListInternal...
     D                 PI              *
     D  i_extType                          const  like(BasicList_type_t  )
     D  i_increment                  10I 0 const
     D  i_heapID                     10I 0 const
     D  i_memMgr                           const  likeds(MemoryManager...
     D                                                   _manager_t)
      *
      *  Return value
     D hList           DS                  likeds(hList_t    ) based(pHList)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Set memory manager
         mm_memMgr = i_memMgr;

         // Allocate memory for list handle
         pHList = mm_allocate(%size(hList_t): i_heapID);

         if pHList = *NULL;
            signalError(cERROR_NO_MEMORY: f_caller());
         endif;

         // Initialize list handle
         clear hList;
         hList.intType       = cHANDLE_TYPE_LIST;
         hList.intSize       = %size(hList);
         hList.extType       = i_extType;
         hList.memSize       = 0;
         hList.numE          = 0;
         hList.maxNumE       = 0;
         hList.totalMemSize  = 0;
         hList.increment     = i_increment;
         hList.signature     = Signature_new();
         hList.sortSignature = hList.signature;
         hList.pBase         = *NULL;
         hList.pAutoSortFnc  = *NULL;
         hList.memMgr        = i_memMgr;
         hList.heapID        = i_heapID;

         return pHList;

      /END-FREE
      *
     P newListInternal...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Set the entry data.
      *=========================================================================
     P setEntryData...
     P                 B
      *
     D setEntryData...
     D                 PI            10I 0
     D  io_hList                                  likeds(hList_t  )
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const
     D  i_length                     10I 0 const
      *
      *  Return Value
     D newLength       S             10I 0 inz(-1)
      *
      *  Entry Data
     D listE           DS                  likeds(listE_t    ) based(pListE)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Set memory manager
         mm_memMgr = io_hList.memMgr;

         // Get access to entry data
         pListE = getPointerListE(io_hList: i_index);

         // If the lenth of the entry data exceeds the
         // size of the allocated memory ...
         if i_length > listE.maxSize;
            // ... (re)allocate memory buffer
            if listE.pData = *NULL;
               listE.pData = mm_allocate(i_length: io_hList.heapID);
            else;
               listE.pData = mm_reallocate(listE.pData: i_length);
            endif;

            if listE.pData = *NULL;
               signalError(cERROR_NO_MEMORY: f_caller());
            endif;

            io_hList.totalMemSize = io_hList.totalMemSize - listE.maxSize;

            listE.maxSize = i_length;

            io_hList.totalMemSize = io_hList.totalMemSize + listE.maxSize;
         endif;

         // If entry data is available ...
         if i_length > 0;
            // ... then copy entry data to buffer
            memcpy(listE.pData: i_pEntry: i_length);
            // ... clear remaining data
            if i_length < listE.maxSize;
               memset(listE.pData + i_length: x'00': listE.maxSize - i_length);
            endif;
         else;
            // ... else clear entry data
            memset(listE.pData: x'00': listE.maxSize);
         endif;

         // Set new signature
         io_hList.signature = Signature_new();

         // Save current length of entry data
         listE.size = i_length;

         // Free entry data if applicable:
         if not entryData_isNULL(listE) and (listE.size = 0);
            freeEntryData(io_hList: listE);
         endif;

         newLength = listE.size;

         return newLength;

      /END-FREE
      *
     P setEntryData...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks the range of the list index.
      *=========================================================================
     P isIndexOutOfRange...
     P                 B
      *
     D isIndexOutOfRange...
     D                 PI              N
     D  i_hList                            const  likeds(hList_t  )
     D  i_index                      10I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_index < 1) or (i_index > i_hList.numE);
            return cTrue;
         else;
            return cFalse;
         endif;

      /END-FREE
      *
     P isIndexOutOfRange...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sorts a given list.
      *=========================================================================
     P qsortCallback...
     P                 B
      *
     D qsortCallback...
     D                 PI            10I 0
     D  i_pKey                         *   value
     D  i_pElement                     *   value
      *
     D pKey            S               *   based(i_pKey)
     D pElement        S               *   based(i_pElement)
      *
     D key             DS                  likeds(listE_t) based(pKey    )
     D element         DS                  likeds(listE_t) based(pElement)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return sortFnc(key.pData: key.size: element.pData: element.size);

      /END-FREE
      *
     P qsortCallback...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sorts the list if it is required and if an auto-sort procedure
      *  has been specified.
      *=========================================================================
     P performAutoSort...
     P                 B
      *
     D performAutoSort...
     D                 PI              N
     D  io_hList                                  likeds(hList_t  )
      *
      *  Parameter positions
     D p_currentE      C                   const(2)
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if io_hList.pAutoSortFnc <> *NULL;
            isSorted = sortList(io_hList: io_hList.pAutoSortFnc);
         else;
            isSorted = cTrue;
         endif;

         return isSorted;

      /END-FREE
      *
     P performAutoSort...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sorts the list.
      *=========================================================================
     P sortList...
     P                 B
      *
     D sortList...
     D                 PI              N
     D  io_hList                                  likeds(hList_t  )
     D  i_pSortFnc                     *   const  procptr
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (isSortedInternally(io_hList));
            isSorted = cTrue;
         else;

            p_assert(g_pSortFnc = *NULL
                     : 'g_pSortFnc should be NULL');

            // Set global variable to hold address of sort procedure
            g_pSortFnc = i_pSortFnc;

            // Sort list
            qsort(io_hList.pBase: io_hList.numE
                                : %size(pDummy)
                                : %paddr('qsortCallback'));

            // Set sort signature
            io_hList.sortSignature = io_hList.signature;

            // Clear global sort function pointer
            g_pSortFnc = *NULL;

            isSorted = cTrue;
         endif;

         return isSorted;

      /END-FREE
      *
     P sortList...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns cTrue for a sorted list, else cFalse.                                       R
      *=========================================================================
     P isSortedInternally...
     P                 B
      *
     D isSortedInternally...
     D                 PI              N
     D  i_hList                            const  likeds(hList_t  )
      *
      *  Return value
     D isSorted        S               N   inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if i_hList.signature = i_hList.sortSignature;
            isSorted = cTrue;
         else;
            isSorted = cFalse;
         endif;

         return isSorted;

      /END-FREE
      *
     P isSortedInternally...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Searches the list for an entry using the data pointer of the entry
      *=========================================================================
     P findEntryBySignature...
     P                 B
      *
     D findEntryBySignature...
     D                 PI            10I 0
     D  i_hList                            const  likeds(hList_t    )
     D  i_signature                        const  likeds(signature_t)
      *
      *  Return value
     D index           S             10I 0 inz(-1)
      *
      *  List entry
     D listE           DS                  likeds(listE_t    ) based(pListE)
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         for x = 1 to i_hList.numE;
            pListE = getPointerListE(i_hList: x);
            if listE.signature = i_signature;
               index = x;
               leave;
            endif;
         endfor;

         return index;

      /END-FREE
      *
     P findEntryBySignature...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Returns a new list signature.
      *=========================================================================
     P Signature_new...
     P                 B
      *
     D Signature_new...
     D                 PI                         likeds(signature_t )
      *
      *  Return value
     D signature       DS                  likeds(signature_t ) inz
      *
      *  Endless counter
     D lastCounter     S             10U 0 inz           static
     D maxCounter      S             10U 0 inz(*HIVAL)   static
     D now             DS                  likeds(timeb_t ) inz
      *
     D ftime           PR            10I 0 extproc('ftime')
     D  tp                                 const  likeds(timeb_t)
      *
     D timeb_t         DS                  qualified               based(pDummy)
     D  time                         10I 0
     D  millitm                      10I 0
     D  timezone                     10I 0
     D  dstflag                      10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // signature.tmStmp  = %timestamp();
      /IF NOT DEFINED(*V5R3M0)
         signature.time = time(*NULL);
         signature.millitm = 0;
      /ELSE
         ftime(now);   // API introduced: V5R3
         signature.time = now.time;
         signature.millitm = now.millitm;
      /ENDIF

         if lastCounter < maxCounter;
            signature.counter = lastCounter + 1;
         else;
            signature.counter = 1;
         endif;

         lastCounter = signature.counter;

         return signature;

      /END-FREE
      *
     P Signature_new...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks, whether a given handle is a valid list handle, or not.
      *  Returns TRUE for a valid list handle, else FALSE.
      *=========================================================================
     P checkListHandle...
     P                 B
      *
     D checkListHandle...
     D                 PI
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  List handle
     D hList           DS                  likeds(hList_t    ) based(i_pList)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (BasicList_isNull(i_pList));
            signalError(cERROR_LIST_HANDLE_NULL: f_caller());
         endif;

         if (hList.intType <> cHANDLE_TYPE_LIST);
            signalError(cERROR_LIST_HANDLE_INVALID: f_caller());
         endif;

         if (hList.intSize <> cHANDLE_SIZE);
            signalError(cERROR_LIST_HANDLE_INVALID: f_caller());
         endif;

         return;

      /END-FREE
      *
     P checkListHandle...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Sends a DIAG message to signal a problem.
      *=========================================================================
     P signalProblem...
     P                 B
      *
     D signalProblem...
     D                 PI
     D  i_text                      128A   const  varying
     D  i_proc                      256A   const  varying
      *
      *  Helper fields
     D msg             DS                  likeds(msg_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         msg = f_newMsg('CPF9897'
                        : 'BasicList: ERROR - ' + i_text
                        : cMsg_Diag: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: i_proc);

         return;

      /END-FREE
      *
     P signalProblem...
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
                        : 'BasicList: ERROR - ' + i_text
                        : cMsg_Escape: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: i_proc);

         return;

      /END-FREE
      *
     P signalError...
     P                 E
      *
