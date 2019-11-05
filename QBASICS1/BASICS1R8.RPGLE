      *=====================================================================*
      *  BASICS1R8  - SrvPgm: Basic Routines - Handle/Memory                *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  30.12.2004                                              *
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
      *  27.04.2005  Th.Raddatz    Replaced handle_t.value with             *
      *                            handle_t.pUserHandle to dynamically      *
      *                            allocate storage for user handle.        *
      *                                                                     *
      *  28.04.2005  Th.Raddatz    Fixed problem that let HANDLE_isNULL()   *
      *                            crash, because of wrong assert().        *
      *                                                                     *
      *  14.02.2006  Th.Raddatz    Added procedures:  MEMORY_allocate()     *
      *                                               MEMORY_freeAll()      *
      *                                                                     *
      *  21.02.2006  Th.Raddatz    Changed HANDLE_isTypeOf() to return      *
      *                            'invalid handle' in case the handle      *
      *                            is *NULL.                                *
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
      *       >>PARM<< TGTRLS(V7R1M0);                                      *
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
      /COPY QBASICS1,PBASICS1R8
      *
      * -----------------------------------------
      *  Reference fields
      * -----------------------------------------
      /COPY QBASICS1,BASICS1R0
      *
     D baseHandle_t    DS            32    qualified   based(pDummy)   align
     D  type                         20A
     D  size                         10I 0
      *
      /if not defined(*V5R2M0)
     D handle_t        DS                  qualified   based(pDummy)   align
     D  baseHandle                         like(baseHandle_t  )
     D  pUserHandle                    *
      /else
     D handle_t        DS                  qualified   based(pDummy)   align
     D  baseHandle                         likeds(baseHandle_t)
     D  pUserHandle                    *
      /endif
      *
      * -----------------------------------------
      *  Imported Prototypes
      * -----------------------------------------
      /COPY QBASICS1,HEAPAPI
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
     D g_handleList    S               *   dim(32767) inz
      *
     D g_mmStatus      DS                  qualified
     D  numAlloc                     10U 0 inz(0)
      *
      *=========================================================================
      *  Creates a new handle.
      *=========================================================================
      *  Parameters:
      *   i_type        - The type of the handle.
      *   i_size        - The size of memory needed for the handle data.
      *
      *  Returns:
      *   aHandle       - Returns the handle on success, else a NULL handle.
      *=========================================================================
     P HANDLE_new...
     P                 B                   export
      *
     D HANDLE_new...
     D                 PI                         like(HANDLE_handle_t)
     D  i_type                             value  like(HANDLE_type_t  )
     D  i_size                       10U 0 value
      *
      *  Return value
     D aHandle         S                   like(HANDLE_handle_t) inz
      *
      *  Helper fields
     D handle          DS                  likeds(handle_t    ) based(pHandle)
      *
      * V5R1
     D baseHandle      DS                  likeds(baseHandle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Find a free handle element
         aHandle = %lookup(*NULL: g_handleList);

         // If there is no free element, ...
         if   aHandle = 0;
            // then return a NULL handle
            aHandle = HANDLE_null();
         else;
            // else allocate memory for a base handle
            // and the size of memory requested.
            pHandle = %alloc(%size(baseHandle_t) + i_size);
            g_handleList(aHandle) = pHandle;

            // Initialize handle - V5R3
            // handle.baseHandle.type = i_type;
            // handle.baseHandle.size = i_size;
            // handle.pUserHandle = %alloc(baseHandle.size);
            // memset(handle.pUserHandle: x'00': baseHandle.size);

            // Initialize handle - V5R1
            baseHandle.type = i_type;
            baseHandle.size = i_size;
            handle.baseHandle = baseHandle;
            handle.pUserHandle = %alloc(baseHandle.size);
            memset(handle.pUserHandle: x'00': baseHandle.size);
         endif;

         return   aHandle;

      /END-FREE
      *
     P HANDLE_new...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL handle.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   aHandle       - Returns a NULL handle.
      *=========================================================================
     P HANDLE_null...
     P                 B                   export
      *
     D HANDLE_null...
     D                 PI                         like(HANDLE_handle_t)
      *
      *  Return value
     D aHandle         S                   like(HANDLE_handle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Return a NULL handle
         aHandle = 0;

         return   aHandle;

      /END-FREE
      *
     P HANDLE_null...
     P                 E
      *
      *=========================================================================
      *  Checks a handle for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_handle      - A given handle.
      *
      *  Returns:
      *   isNull        - Returns cTrue if the handle is NULL, else cFalse.
      *=========================================================================
     P HANDLE_isNull...
     P                 B                   export
      *
     D HANDLE_isNull...
     D                 PI              N
     D  i_handle                           value  like(HANDLE_handle_t)
      *
      *  Return value
     D isNull          S               N   inz(cFalse)
      *
      *  Helper fields
     D handle          DS                  likeds(handle_t) based(pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Also allow 0 here!
         p_assert(i_handle >= 0 and i_handle <= %elem(g_handleList):
                  'Value of io_handle is out of range');

         // Get handle adress
         if   i_handle = 0;
            pHandle = *NULL;
         else;
            pHandle = g_handleList(i_handle);
         endif;

         // Check handle NULL value
         if   pHandle = *NULL;
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;

         return   isNull;

      /END-FREE
      *
     P HANDLE_isNull...
     P                 E
      *
      *=========================================================================
      *  Checks the type of a given handle.
      *=========================================================================
      *  Parameters:
      *   i_handle      - A given handle.
      *   i_type        - The type of the handle.
      *
      *  Returns:
      *   isValid       - Returns cTrue on success, else cFalse.
      *=========================================================================
     P HANDLE_isTypeOf...
     P                 B                   export
      *
     D HANDLE_isTypeOf...
     D                 PI              N
     D  i_handle                           value  like(HANDLE_handle_t)
     D  i_type                             value  like(HANDLE_type_t  )
      *
      *  Return value
     D isValid         S               N   inz(cFalse)
      *
      *  Helper fields
     D handle          DS                  likeds(handle_t) based(pHandle)
      *
      /if not defined(*V5R2M0)
     D baseHandle      DS                  likeds(baseHandle_t) inz
      /endif
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (i_handle < 1 or i_handle > %elem(g_handleList));
            isValid = cFalse;
            return isValid;
         endif;

         // Get handle adress
         pHandle = g_handleList(i_handle);

         if pHandle <> *NULL;

      /if not defined(*V5R2M0)
            baseHandle = handle.baseHandle;
            if baseHandle.type = i_type;
               isValid = cTrue;
            else;
               isValid = cFalse;
            endif;
      /else
            if handle.baseHandle.type = i_type;
               isValid = cTrue;
            else;
               isValid = cFalse;
            endif;
      /endif
         else;
            isValid = cFalse;
         endif;

         return   isValid;

      /END-FREE
      *
     P HANDLE_isTypeOf...
     P                 E
      *
      *=========================================================================
      *  Retrieves a pointer to the handle data from a given handle.
      *=========================================================================
      *  Parameters:
      *   i_handle      - A given handle.
      *
      *  Returns:
      *   pHandle       - Returns the pointer of a given handle.
      *=========================================================================
     P HANDLE_getPointer...
     P                 B                   export
      *
     D HANDLE_getPointer...
     D                 PI              *
     D  i_handle                           value  like(HANDLE_handle_t)
      *
      *  Return value
     D pUserHandle     S               *   inz
      *
      *  Helper fields
     D handle          DS                  likeds(handle_t) based(pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(i_handle >= 1 and i_handle <= %elem(g_handleList):
                  'Value of io_handle is out of range');

         // Get handle adress
         pHandle = g_handleList(i_handle);

         // Get address of user handle
         pUserHandle = handle.pUserHandle;

         return   pUserHandle;

      /END-FREE
      *
     P HANDLE_getPointer...
     P                 E
      *
      *=========================================================================
      *  Deletes a given handle.
      *=========================================================================
      *  Parameters:
      *   io_handle      - The handle to delete.
      *
      *  Returns:
      *   void
      *=========================================================================
     P HANDLE_delete...
     P                 B                   export
      *
     D HANDLE_delete...
     D                 PI
     D  io_handle                                 like(HANDLE_handle_t)
      *
      *  Helper fields
     D handle          DS                  likeds(handle_t) based(pHandle)
      *
      * V5R1
     D baseHandle      DS                  likeds(baseHandle_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(io_handle >= 1 and io_handle <= %elem(g_handleList):
                  'Value of io_handle is out of range');

         // Get handle adress
         pHandle = g_handleList(io_handle);

         p_assert(pHandle <> *NULL:
                  'Handle address is already *NULL');

         // Initialize handle memory - V5R3
         // memset(handle.pUserHandle: x'00': baseHandle.size);
         // handle.baseHandle.size = 0;
         // handle.baseHandle.type = *ALLx'00';

         // Initialize handle memory - V5R1
         baseHandle = handle.baseHandle;
         memset(handle.pUserHandle: x'00': baseHandle.size);
         dealloc(N) handle.pUserHandle;
         baseHandle.size = 0;
         baseHandle.type = *ALLx'00';
         handle.baseHandle = baseHandle;

         // Free handle memory
         dealloc(N) pHandle;

         // Free index in handle list
         g_handleList(io_handle) = *NULL;

         // Free user handle
         io_handle = HANDLE_null();

         return;

      /END-FREE
      *
     P HANDLE_delete...
     P                 E
      *
      *=========================================================================
      *  Allocates a memory cell and keeps track of it.
      *=========================================================================
      *  Parameters:
      *   i_aMemList    - Pointer to the last cell of the chain of memory call.
      *   i_size        - The number of bytes to allocate.
      *
      *  Returns:
      *   pMemory       - A pointer to the memory cell.
      *=========================================================================
     P MEMORY_allocate...
     P                 B                   export
      *
     D MEMORY_allocate...
     D                 PI              *
     D  io_aMemList                    *
     D  i_size                       10I 0 value
      *
      *  Return value
     D pMemory         S               *   inz
      *
      *
     D cell            DS                  qualified   based(pCell)
     D  pPrvCell                       *
     D  size                         10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%rem(i_size : %size(pDummy)) <> 0);
            i_size = (%div(i_size : %size(pDummy)) + 1) * %size(pDummy);
         endif;

         if (i_size = 0);
            pMemory = *NULL;
         else;
            pMemory = %alloc(i_size + %size(cell));
            pCell   = pMemory + i_size;            // Position cell right after payload
            cell.pPrvCell    = io_aMemList;        // Remember the address of the prv. cell
            cell.size        = i_size;             // Remember the size of the current cell
            io_aMemList      = pCell;              // Remember this cell
         endif;

         return pMemory;

      /END-FREE
      *
     P MEMORY_allocate...
     P                 E
      *
      *=========================================================================
      *  Frees all allocated memory cells.
      *=========================================================================
      *  Parameters:
      *   io_aMemList   - Pointer to the last cell of the chain of memory call.
      *                   returned from f_gsoap_Environment_new().
      *
      *  Returns:
      *   void
      *=========================================================================
     P MEMORY_freeAll...
     P                 B                   export
      *
     D MEMORY_freeAll...
     D                 PI
     D  io_aMemList                    *
      *
      *  Helper fields
     D pMemory         S               *   inz
      *
     D cell            DS                  qualified   based(pCell)
     D  pPrvCell                       *
     D  size                         10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         dow (io_aMemList <> *NULL);
            pCell            = io_aMemList;             // Get last cell allocated
            pMemory          = pCell - cell.size;       // Get start address of this cell
            io_aMemList      = cell.pPrvCell;           // Go back to prv. cell
            cell.size        = 0;                       // Clear size of this cell
            cell.pPrvCell    = *NULL;                   // Clear mem-ptr of this cell
            free(pMemory);                              // Free memory of this cell
         enddo;

         return;

      /END-FREE
      *
     P MEMORY_freeAll...
     P                 E
      *
      *=========================================================================
      *  Frees a given memory cell.
      *=========================================================================
      *  Parameters:
      *   io_pMem       - Pointer to the memory cell to be free.
      *
      *  Returns:
      *   void
      *=========================================================================
     P MEMORY_free...
     P                 B                   export
      *
     D MEMORY_free...
     D                 PI
     D  io_aMemList                    *
     D  io_pMem                        *
      *
      *  Helper fields
     D pMemory         S               *   inz
      *
     D prvCell         DS                  qualified   based(pPrvCell)
     D  pPrvCell                       *
     D  size                         10I 0
      *
     D cell            DS                  qualified   based(pCell)
     D  pPrvCell                       *
     D  size                         10I 0
      *
     D nextCell        DS                  qualified   based(pNextCell)
     D  pPrvCell                       *
     D  size                         10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Return to caller because there's nothing to do.
         if io_aMemList = *NULL;
            return;
         endif;

         // When we start searching for the requested cell,
         // there is no cell before the current cell.
         pPrvCell = *NULL;

         // Point "cell" to last allocated cell.
         pCell = io_aMemList;

         // Spin through chain on allocated memory cells
         // searching for the cell to free:
         dow (pCell <> *NULL);
            pMemory = pCell - cell.size;       // Get start address of this cell

            // If we hit the cell to delete ...
            if pMemory = io_pMem;
               // ... let "nextCel" point to next cell in chain of cells.
               pNextCell        = cell.pPrvCell;

               // If there is no cell before the cell to delete ...
               if pPrvCell = *NULL;
                  // ... set pointer of "nextCell" as the start of the list of cells.
                  io_aMemList = pNextCell;
               else;
                  // ... else link "nextCell" to "prvCell"
                  prvCell.pPrvCell = pNextCell;
               endif;

               // Clear cell data and free memory
               cell.size        = 0;                    // Clear size of this cell
               cell.pPrvCell    = *NULL;                // Clear mem-ptr of this cell
               free(pMemory);                           // Free memory of this cell

               pNextCell = *NULL;
               leave;   // Ready => Leave
            endif;

            // Rememeber this cell as the previous cell.
            pPrvCell  = pCell;

            // Goto next cell
            pCell = cell.pPrvCell;
         enddo;

         return;

      /END-FREE
      *
     P MEMORY_free...
     P                 E
      *
      *=========================================================================
      *  Return the Tools/400 default memory manager implementation.
      *=========================================================================
      *  Parameters:
      *
      *  Returns:
      *   memMgr        - The default memory manager.
      *=========================================================================
     P MemoryManager_getDefaultManager...
     P                 B                   export
      *
     D MemoryManager_getDefaultManager...
     D                 PI                        likeds(MemoryManager_manager_t)
      *
      *  Return value
     D memMgr          DS                  likeds(MemoryManager_manager_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         memMgr.pAllocate   = %paddr('BASICS1R8_MemoryManager_allocate');
         memMgr.pReallocate = %paddr('BASICS1R8_MemoryManager_reallocate');
         memMgr.pFree       = %paddr('BASICS1R8_MemoryManager_free');

         return memMgr;

      /END-FREE
      *
     P MemoryManager_getDefaultManager...
     P                 E
      *
      *=========================================================================
      *  Reserve Storage Block
      *=========================================================================
      *  Parameters:
      *   i_size        - The size, in bytes, of the desired memory allocation.
      *
      *  Returns:
      *   pMemory       - The reserved storage block.
      *=========================================================================
     P MemoryManager_allocate...
     P                 B                   export
      *
     D MemoryManager_allocate...
     D                 PI              *
     D  i_size                       10U 0 value
     D  i_heapID                     10I 0 value  options(*nopass)
      *
      *  Return value
     D pMemory         S               *   inz
      *
      *  Parameter positions
     D p_heapID        C                   const(2)
      *
      *  Optional parameter fields
     D heapID          S                   like(i_heapID ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_heapID);
            heapID = i_heapID;
         else;
            heapID = 0;
         endif;

         select;
         when (heapID = -1);
            // TODO: allocate teraspace memory
         when (heapID > 0);
            CEEGTST(heapID: i_size: pMemory: *omit);
         other;
            pMemory = malloc(i_size);
         endsl;

         if (pMemory <> *NULL);
            g_mmStatus.numAlloc = g_mmStatus.numAlloc + 1;
         endif;

         return pMemory;

      /END-FREE
      *
     P MemoryManager_allocate...
     P                 E
      *
      *=========================================================================
      *  Change Reserved Storage Block Size
      *=========================================================================
      *  Parameters:
      *   i_pMem        - Address of a previously allocated memory block.
      *   i_size        - The number of bytes of storage to be allocated for
      *                   the new storage block.
      *
      *  Returns:
      *   pMemory       - The reserved storage block.
      *=========================================================================
     P MemoryManager_reallocate...
     P                 B                   export
      *
     D MemoryManager_reallocate...
     D                 PI              *
     D  i_pMem                         *   value
     D  i_size                       10U 0 value
      *
      *  Return value
     D pMemory         S               *   inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         pMemory = realloc(i_pMem: i_size);

         return pMemory;

      /END-FREE
      *
     P MemoryManager_reallocate...
     P                 E
      *
      *=========================================================================
      *  Release Storage Blocks
      *=========================================================================
      *  Parameters:
      *   io_pMem       - A previously allocated storage block.
      *
      *  Returns:
      *   void
      *=========================================================================
     P MemoryManager_free...
     P                 B                   export
      *
     D MemoryManager_free...
     D                 PI
     D  io_pMem                        *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         p_assert(io_pMem <> *NULL);

         free(io_pMem);
         io_pMem = *NULL;

         g_mmStatus.numAlloc = g_mmStatus.numAlloc - 1;

         return;

      /END-FREE
      *
     P MemoryManager_free...
     P                 E
      *
      *=========================================================================
      *  Creates a new heap
      *=========================================================================
      *  Parameters:
      *   i_initialSize - The initial amount of storage, in bytes, allocated
      *                   for the new heap.
      *   i_increment   - The number of bytes by which the heap is extended
      *                   when it is necessary to enlarge the heap to satisfy
      *                   an allocation request.
      *   i_allocStrat  - The allocation strategy used.
      *
      *  Returns:
      *   headID        - The heap identifier of the created heap.
      *=========================================================================
     P MemoryManager_createHeap...
     P                 B                   export
      *
     D MemoryManager_createHeap...
     D                 PI            10I 0
     D  i_initialSize                10I 0 const  options(*nopass: *omit)
     D  i_increment                  10I 0 const  options(*nopass: *omit)
     D  i_allocStrat                 10I 0 const  options(*nopass: *omit)
      *
      *  Return value
     D heapID          S             10I 0 inz
      *
      *  Parameter positions
     D p_initialSize   C                   1
     D p_increment     C                   2
     D p_allocStrat    C                   3
      *
      *  Fields for optional parameters
     D initialSize     S                   like(i_initialSize) inz
     D increment       S                   like(i_increment  ) inz
     D allocStrat      S                   like(i_allocStrat ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_initialSize and %addr(i_initialSize) <> *NULL);
            initialSize = i_initialSize;
         else;
            initialSize = 0;
         endif;

         if (%parms() >= p_increment and %addr(i_increment) <> *NULL);
            increment = i_increment;
         else;
            increment = 0;
         endif;

         if (%parms() >= p_allocStrat and %addr(i_allocStrat) <> *NULL);
            allocStrat = i_allocStrat;
         else;
            allocStrat = 0;
         endif;

         CEECRHP(heapID: initialSize: increment: allocStrat: *omit);

         return heapID;

      /END-FREE
      *
     P MemoryManager_createHeap...
     P                 E
      *
      *=========================================================================
      *  Deletes an existing heap.
      *=========================================================================
      *  Parameters:
      *   io_heapID     - The heap identifier of the heap to be deleted.
      *
      *  Returns:
      *   void
      *=========================================================================
     P MemoryManager_deleteHeap...
     P                 B                   export
      *
     D MemoryManager_deleteHeap...
     D                 PI
     D  io_heapID                    10I 0
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         CEEDSHP(io_heapID: *omit);
         io_heapID = 0;

         return;

      /END-FREE
      *
     P MemoryManager_deleteHeap...
     P                 E
      *
