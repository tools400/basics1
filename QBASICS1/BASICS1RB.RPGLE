      *=====================================================================*
      *  BASICS1RB  - SrvPgm: Basic Routines - BasicStack                   *
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
      *  28.04.2008  Th.Raddatz    Introduced a real stack handle (hStack_t)*
      *                                                                     *
      *  28.04.2008  Th.Raddatz    Check type of stack handle and send an   *
      *                            ESCAPE message for invalid handles.      *
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
      /COPY QBASICS1,PBASICS1RB
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D hStack_t        DS                  qualified   based(pDummy)   align
     D  intType                      20U 0
     D  intSize                      10U 0
     D  heapID                       10I 0
     D  pList                              like(BasicList_handle_t)
     D  memMgr                             likeds(MemoryManager_manager_t)
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Checks, whether a given handle is a valid stack handle, or not.
     D checkStackHandle...
     D                 PR
     D                                            extproc('checkStackHandle')
     D  i_pStack                           const  like(BasicStack_handle_t  )
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
     D cHANDLE_TYPE_STACK...
     D                 C                   const(6693091772879487297)           =  *Stack
     D cHANDLE_SIZE...
     D                 C                   const(%size(hStack_t))
      *
     D cERROR_STACK_HANDLE_NULL...
     D                 C                   const('Stack handle is NULL')
     D cERROR_STACK_HANDLE_INVALID...
     D                 C                   const('Stack handle is invalid')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new BasicStack.
      *=========================================================================
      *  Parameters:
      *   i_increment   - The number of empty elements that are added to the
      *                   stack when the stack needs to be resized.
      *
      *  Returns:
      *   pStack        - Returns the basing pointer of the stack on
      *                   success, else NULL.
      *=========================================================================
     P BasicStack_new...
     P                 B                   export
      *
     D BasicStack_new...
     D                 PI                         like(BasicStack_handle_t  )
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10U 0 const  options(*nopass: *omit)
      *
      *  Return value
     D pStack          S                   like(BasicStack_handle_t  ) inz
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
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Get values of optional parameters
         // i_increment
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

         // Allocate memory for stack handle
         pStack = mm_allocate(%size(hStack_t): heapID);

         // Initialize stack handle
         clear hStack;
         hStack.intType = cHANDLE_TYPE_STACK;
         hStack.intSize = %size(hStack);
         hStack.pList   = BasicList_new('*BASICSTACK': increment);
         hStack.heapID  = heapID;
         hStack.memMgr  = mm_memMgr;

         return pStack;

      /END-FREE
      *
     P BasicStack_new...
     P                 E
      *
      *=========================================================================
      *  Clones a given BasicStack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   pStack        - Returns the basing pointer of the cloned stack on
      *                   success, else NULL.
      *=========================================================================
     P BasicStack_clone...
     P                 B                   export
      *
     D BasicStack_clone...
     D                 PI                         like(BasicStack_handle_t  )
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D pStackRtn       S                   like(BasicStack_handle_t  ) inz
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(cFalse
                  : 'Procedure not yet implemented');

         return pStackRtn;

      /END-FREE
      *
     P BasicStack_clone...
     P                 E
      *
      *=========================================================================
      *  Gets the last entry from top of the stack without removing it from stack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *   i_pEntry      - Optional. Address where to copy the entry data to.
      *   i_length      - Optional. The maximum size of the entry data.
      *
      *  Returns:
      *   pEntry        - Returns a pointer to the entry data on
      *                   success, else NULL.
      *=========================================================================
     P BasicStack_peek...
     P                 B                   export
      *
     D BasicStack_peek...
     D                 PI              *
     D  i_pStack                           const  like(BasicStack_handle_t  )
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Return value
     D pElemData       S               *   inz
      *
      *  Parameter positions
     D p_pEntry        C                   const(2)
     D p_length        C                   const(3)
      *
      *  Fields for optional parameters
     D pEntry          S                   like(i_pEntry    ) inz
     D length          S                   like(i_length    ) inz
      *
      *  Local fields
     D numElements     S             10I 0 inz
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         p_assert(%parms() <> p_pEntry
                  : 'Invalid number of arguments: i_length is missing');

         // Get element from underlaying BasicList
         numElements = BasicList_getNumE(hStack.pList);
         if numElements <> -1;
            if %parms() >= p_length;
               pElemData = BasicList_get(hStack.pList: numElements
                                         : i_pEntry: i_length);
            else;
               pElemData = BasicList_get(hStack.pList: numElements);
            endif;
         else;
            pElemData = *NULL;
         endif;

         return pElemData;

      /END-FREE
      *
     P BasicStack_peek...
     P                 E
      *
      *=========================================================================
      *  Removes the lement at the top of the stack and returnns that element.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *   i_pEntry      - Address where to copy the entry data to.
      *   i_length      - The maximum size of the entry data.
      *
      *  Returns:
      *   pEntry        - Returns a pointer to the entry data on
      *                   success, else NULL.
      *=========================================================================
     P BasicStack_pop...
     P                 B                   export
      *
     D BasicStack_pop...
     D                 PI              *
     D  i_pStack                           const  like(BasicStack_handle_t  )
     D  i_pEntry                       *   const
     D  i_length                     10I 0 const
      *
      *  Return value
     D pElemData       S               *   inz
      *
      *  Local fields
     D numElements     S             10I 0 inz
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Get element from underlaying BasicList
         numElements = BasicList_getNumE(hStack.pList);
         if numElements <> -1;
            pElemData = BasicList_get(
                             hStack.pList: numElements: i_pEntry: i_length);
            BasicList_remove(hStack.pList: numElements);
         else;
            pElemData = *NULL;
         endif;

         return pElemData;

      /END-FREE
      *
     P BasicStack_pop...
     P                 E
      *
      *=========================================================================
      *  Pushes an item onto the top of the stack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *   i_pEntry      - The entry to be added to this stack.
      *   i_length      - Optional. The size of the entry data.
      *
      *  Returns:
      *   index         - Returns the index of the element on
      *                   success, else -1.
      *=========================================================================
     P BasicStack_push...
     P                 B                   export
      *
     D BasicStack_push...
     D                 PI            10I 0
     D  i_pStack                           const  like(BasicStack_handle_t  )
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
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Get length of entry data
         if %parms() >= p_length;
            length = i_length;
         else;
            length = strlen(i_pEntry);
         endif;

         // Add entry to underlaying BasicList
         index = BasicList_add(hStack.pList: i_pEntry: length);

         return index;

      /END-FREE
      *
     P BasicStack_push...
     P                 E
      *
      *=========================================================================
      *  Returns the size of of the element that is on top of this stack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   size          - Returns the size of the element on success, else -1.
      *=========================================================================
     P BasicStack_getSize...
     P                 B                   export
      *
     D BasicStack_getSize...
     D                 PI            10I 0
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D size            S             10I 0 inz(-1)
      *
      *  Local fields
     D numElements     S             10I 0 inz
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Get index of last element of this stack
         numElements = BasicList_getNumE(hStack.pList);

         // Get size of that element
         if numElements <> -1;
            size = BasicList_getSize(hStack.pList: numElements);
         endif;

         return size;

      /END-FREE
      *
     P BasicStack_getSize...
     P                 E
      *
      *=========================================================================
      *  Returns the number of elements in this stack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   size          - Returns the number of elements in this list on
      *                   success, else -1.
      *=========================================================================
     P BasicStack_getNumE...
     P                 B                   export
      *
     D BasicStack_getNumE...
     D                 PI            10I 0
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D numE            S             10I 0 inz(-1)
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Return number of elements of underlaying list
         numE = BasicList_getNumE(hStack.pList);

         return numE;

      /END-FREE
      *
     P BasicStack_getNumE...
     P                 E
      *
      *=========================================================================
      *  Returns the heap ID of a given BasicStack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   heapID        - ID of the heap this BasicStack belongs to.
      *=========================================================================
     P BasicStack_getHeapID...
     P                 B                   export
      *
     D BasicStack_getHeapID...
     D                 PI            10I 0
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D heapID          S             10I 0 inz(-1)
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Return the heap ID of underlaying list
         heapID = BasicList_getHeapID(hStack.pList);

         return heapID;

      /END-FREE
      *
     P BasicStack_getHeapID...
     P                 E
      *
      *=========================================================================
      *  Removes all entries from a given stack.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicStack_clear...
     P                 B                   export
      *
     D BasicStack_clear...
     D                 PI            10I 0
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(i_pStack);

         // Clear underlaying BasicList
         rc = BasicList_clear(hStack.pList);

         return rc;

      /END-FREE
      *
     P BasicStack_clear...
     P                 E
      *
      *=========================================================================
      *  Deletes a given BasicStack.
      *=========================================================================
      *  Parameters:
      *   io_pStack     - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   rc              Returns 0 success, else -1.
      *=========================================================================
     P BasicStack_delete...
     P                 B                   export
      *
     D BasicStack_delete...
     D                 PI            10I 0
     D  io_pStack                                 like(BasicStack_handle_t  )
      *
      *  Return value
     D rc              S             10I 0 inz(-1)
      *
      *  Memory Manager
      /COPY QBASICS1,MEMMGR
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(io_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         checkStackHandle(io_pStack);

         // Set memory manager
         mm_memMgr = hStack.memMgr;

         // Delete underlaying BasicList.
         rc = BasicList_delete(hStack.pList);

         // Clear stack handle
         clear hStack;
         hStack.intType = 0;
         hStack.intSize = 0;
         hStack.pList   = BasicList_null();
         hStack.heapID  = 0;
         clear hStack.memMgr;

         // Free memory of map handle
         mm_free(io_pStack);

         io_pStack = BasicStack_null();

         return rc;

      /END-FREE
      *
     P BasicStack_delete...
     P                 E
      *
      *=========================================================================
      *  Returns a BasicStack NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pStack        - NULL handle of a BasicStack.
      *=========================================================================
     P BasicStack_null...
     P                 B                   export
      *
     D BasicStack_null...
     D                 PI                         like(BasicStack_handle_t  )
      *
      *  Return value
     D pStack          S                   like(BasicStack_handle_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pStack = *NULL;

         return pStack;

      /END-FREE
      *
     P BasicStack_null...
     P                 E
      *
      *=========================================================================
      *  Checks a given BasicStack handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle is null, else FALSE.
      *=========================================================================
     P BasicStack_isNull...
     P                 B                   export
      *
     D BasicStack_isNull...
     D                 PI              N
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Return value
     D isNull          S               N   inz(cTrue)
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_pStack = BasicStack_null());
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return isNull;

      /END-FREE
      *
     P BasicStack_isNull...
     P                 E
      *
      *=========================================================================
    R *  *** private ***
      *  Checks, whether a given handle is a valid stack handle, or not.
      *  Returns TRUE for a valid stack handle, else FALSE.
      *=========================================================================
     P checkStackHandle...
     P                 B
      *
     D checkStackHandle...
     D                 PI
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Stack handle
     D hStack          DS                  likeds(hStack_t   ) based(i_pStack)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (BasicStack_isNull(i_pStack));
            signalError(cERROR_STACK_HANDLE_NULL: f_caller());
         endif;

         if (hStack.intType <> cHANDLE_TYPE_STACK);
            signalError(cERROR_STACK_HANDLE_INVALID: f_caller());
         endif;

         if (hStack.intSize <> cHANDLE_SIZE);
            signalError(cERROR_STACK_HANDLE_INVALID: f_caller());
         endif;

         return;

      /END-FREE
      *
     P checkStackHandle...
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
                        : 'BasicStack: ERROR - ' + i_text
                        : cMsg_Escape: 'QCPFMSG': '*LIBL');
         f_sndPgmMsg(msg: cMsg_Same: i_proc);

         return;

      /END-FREE
      *
     P signalError...
     P                 E
      *
