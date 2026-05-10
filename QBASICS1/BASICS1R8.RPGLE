**free
//=====================================================================*
//  BASICS1R8  - SrvPgm: Basic Routines - Handle/Memory                *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  30.12.2004                                              *
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
//  27.04.2005  Th.Raddatz    Replaced handle_t.value with             *
//                            handle_t.pUserHandle to dynamically      *
//                            allocate storage for user handle.        *
//                                                                     *
//  28.04.2005  Th.Raddatz    Fixed problem that let HANDLE_isNULL()   *
//                            crash, because of wrong assert().        *
//                                                                     *
//  14.02.2006  Th.Raddatz    Added procedures:  MEMORY_allocate()     *
//                                               MEMORY_freeAll()      *
//                                                                     *
//  21.02.2006  Th.Raddatz    Changed HANDLE_isTypeOf() to return      *
//                            'invalid handle' in case the handle      *
//                            is *NULL.                                *
//                                                                     *
//  17.09.2022  Th.Raddatz    Added procedures:  xalloc()              *
//                                               xrealloc()            *
//                                               xdealloc()            *
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
/define INCLUDE_INTERNAL_PROCDURES
/copy QBASICS1,PBASICS1R8
/undefine INCLUDE_INTERNAL_PROCDURES

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

dcl-ds baseHandle_t len(32) qualified based(pDummy) align;
  type char(20);
  size int(10);
end-ds;

/if not defined(*V5R2M0)
dcl-ds handle_t qualified based(pDummy) align;
  baseHandle  like(baseHandle_t);
  pUserHandle pointer;
end-ds;
/else
dcl-ds handle_t qualified based(pDummy) align;
  baseHandle  likeds(baseHandle_t);
  pUserHandle pointer;
end-ds;
/endif

// -----------------------------------------
//  Imported Prototypes
// -----------------------------------------
/copy QBASICS1,HEAPAPI

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

// -----------------------------------------
//  Global constants
// -----------------------------------------

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_handleList pointer dim(32767) inz;

dcl-ds g_mmStatus qualified;
  numAlloc uns(10) inz(0);
end-ds;

//=========================================================================
//  Creates a new handle.
//=========================================================================
//  Parameters:
//   i_type        - The type of the handle.
//   i_size        - The size of memory needed for the handle data.
//
//  Returns:
//   aHandle       - Returns the handle on success, else a NULL handle.
//=========================================================================
dcl-proc HANDLE_new export;
  dcl-pi *n like(HANDLE_handle_t);
    i_type like(HANDLE_type_t) value;
    i_size uns(10) value;
  end-pi;

  //  Return value
  dcl-s aHandle like(HANDLE_handle_t) inz;

  //  Helper fields
  dcl-ds handle likeds(handle_t) based(pHandle);

  // V5R1
  dcl-ds baseHandle likeds(baseHandle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Find a free handle element
  aHandle = %lookup(*NULL: g_handleList);

  // If there is no free element, ...
  if   aHandle = 0;
    // then return a NULL handle
    aHandle = HANDLE_null();
  else;
    // else allocate memory for a base handle
    // and the size of memory requested.
    pHandle = xalloc(%size(baseHandle_t) + i_size);
    g_handleList(aHandle) = pHandle;

    // Initialize handle - V5R3
    // handle.baseHandle.type = i_type;
    // handle.baseHandle.size = i_size;
    // handle.pUserHandle = xalloc(baseHandle.size);
    // memset(handle.pUserHandle: x'00': baseHandle.size);

    // Initialize handle - V5R1
    baseHandle.type = i_type;
    baseHandle.size = i_size;
    handle.baseHandle = baseHandle;
    handle.pUserHandle = xalloc(baseHandle.size);
    memset(handle.pUserHandle: x'00': baseHandle.size);
  endif;

  return   aHandle;

end-proc;

//=========================================================================
//  Returns a NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   aHandle       - Returns a NULL handle.
//=========================================================================
dcl-proc HANDLE_null export;
  dcl-pi *n like(HANDLE_handle_t);
  end-pi;

  //  Return value
  dcl-s aHandle like(HANDLE_handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Return a NULL handle
  aHandle = 0;

  return   aHandle;

end-proc;

//=========================================================================
//  Checks a handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_handle      - A given handle.
//
//  Returns:
//   isNull        - Returns cTrue if the handle is NULL, else cFalse.
//=========================================================================
dcl-proc HANDLE_isNull export;
  dcl-pi *n ind;
    i_handle like(HANDLE_handle_t) value;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(cFalse);

  //  Helper fields
  dcl-ds handle likeds(handle_t) based(pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Checks the type of a given handle.
//=========================================================================
//  Parameters:
//   i_handle      - A given handle.
//   i_type        - The type of the handle.
//
//  Returns:
//   isValid       - Returns cTrue on success, else cFalse.
//=========================================================================
dcl-proc HANDLE_isTypeOf export;
  dcl-pi *n ind;
    i_handle like(HANDLE_handle_t) value;
    i_type   like(HANDLE_type_t) value;
  end-pi;

  //  Return value
  dcl-s isValid ind inz(cFalse);

  //  Helper fields
  dcl-ds handle likeds(handle_t) based(pHandle);

/if not defined(*V5R2M0)
  dcl-ds baseHandle likeds(baseHandle_t) inz;
/endif
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Retrieves a pointer to the handle data from a given handle.
//=========================================================================
//  Parameters:
//   i_handle      - A given handle.
//
//  Returns:
//   pHandle       - Returns the pointer of a given handle.
//=========================================================================
dcl-proc HANDLE_getPointer export;
  dcl-pi *n pointer;
    i_handle like(HANDLE_handle_t) value;
  end-pi;

  //  Return value
  dcl-s pUserHandle pointer inz;

  //  Helper fields
  dcl-ds handle likeds(handle_t) based(pHandle);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(i_handle >= 1 and i_handle <= %elem(g_handleList):
           'Value of io_handle is out of range');

  // Get handle adress
  pHandle = g_handleList(i_handle);

  // Get address of user handle
  pUserHandle = handle.pUserHandle;

  return   pUserHandle;

end-proc;

//=========================================================================
//  Deletes a given handle.
//=========================================================================
//  Parameters:
//   io_handle      - The handle to delete.
//
//  Returns:
//   void
//=========================================================================
dcl-proc HANDLE_delete export;
  dcl-pi *n;
    io_handle like(HANDLE_handle_t);
  end-pi;

  //  Helper fields
  dcl-ds handle likeds(handle_t) based(pHandle);

  // V5R1
  dcl-ds baseHandle likeds(baseHandle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
  xdealloc(handle.pUserHandle);
  baseHandle.size = 0;
  baseHandle.type = *ALLx'00';
  handle.baseHandle = baseHandle;

  // Free handle memory
  xdealloc(pHandle);

  // Free index in handle list
  g_handleList(io_handle) = *NULL;

  // Free user handle
  io_handle = HANDLE_null();

  return;

end-proc;

//=========================================================================
//  Allocates a memory cell and keeps track of it.
//=========================================================================
//  Parameters:
//   i_aMemList    - Pointer to the last cell of the chain of memory call.
//   i_size        - The number of bytes to allocate.
//
//  Returns:
//   pMemory       - A pointer to the memory cell.
//=========================================================================
dcl-proc MEMORY_allocate export;
  dcl-pi *n pointer;
    io_aMemList pointer;
    i_size      int(10) value;
  end-pi;

  //  Return value
  dcl-s pMemory pointer inz;


  dcl-ds cell qualified based(pCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%rem(i_size : %size(pDummy)) <> 0);
    i_size = (%div(i_size : %size(pDummy)) + 1) * %size(pDummy);
  endif;

  if (i_size = 0);
    pMemory = *NULL;
  else;
    pMemory = xalloc(i_size + %size(cell));
    pCell   = pMemory + i_size;            // Position cell right after payload
    cell.pPrvCell    = io_aMemList;        // Remember the address of the prv. cell
    cell.size        = i_size;             // Remember the size of the current cell
    io_aMemList      = pCell;              // Remember this cell
  endif;

  return pMemory;

end-proc;

//=========================================================================
//  Frees all allocated memory cells.
//=========================================================================
//  Parameters:
//   io_aMemList   - Pointer to the last cell of the chain of memory call.
//                   returned from f_gsoap_Environment_new().
//
//  Returns:
//   void
//=========================================================================
dcl-proc MEMORY_freeAll export;
  dcl-pi *n;
    io_aMemList pointer;
  end-pi;

  //  Helper fields
  dcl-s pMemory pointer inz;

  dcl-ds cell qualified based(pCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dow (io_aMemList <> *NULL);
    pCell            = io_aMemList;             // Get last cell allocated
    pMemory          = pCell - cell.size;       // Get start address of this cell
    io_aMemList      = cell.pPrvCell;           // Go back to prv. cell
    cell.size        = 0;                       // Clear size of this cell
    cell.pPrvCell    = *NULL;                   // Clear mem-ptr of this cell
    free(pMemory);                              // Free memory of this cell
  enddo;

  return;

end-proc;

//=========================================================================
//  Frees a given memory cell.
//=========================================================================
//  Parameters:
//   io_pMem       - Pointer to the memory cell to be free.
//
//  Returns:
//   void
//=========================================================================
dcl-proc MEMORY_free export;
  dcl-pi *n;
    io_aMemList pointer;
    io_pMem     pointer;
  end-pi;

  //  Helper fields
  dcl-s pMemory pointer inz;

  dcl-ds prvCell qualified based(pPrvCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;

  dcl-ds cell qualified based(pCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;

  dcl-ds nextCell qualified based(pNextCell);
    pPrvCell pointer;
    size     int(10);
  end-ds;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Return the Tools/400 default memory manager implementation.
//=========================================================================
//  Parameters:
//
//  Returns:
//   memMgr        - The default memory manager.
//=========================================================================
dcl-proc MemoryManager_getDefaultManager export;
  dcl-pi *n likeds(MemoryManager_manager_t);
  end-pi;

  //  Return value
  dcl-ds memMgr likeds(MemoryManager_manager_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  memMgr.pAllocate   = %paddr('BASICS1R8_MemoryManager_allocate');
  memMgr.pReallocate = %paddr('BASICS1R8_MemoryManager_reallocate');
  memMgr.pFree       = %paddr('BASICS1R8_MemoryManager_free');

  return memMgr;

end-proc;

//=========================================================================
//  Reserve Storage Block
//=========================================================================
//  Parameters:
//   i_size        - The size, in bytes, of the desired memory allocation.
//
//  Returns:
//   pMemory       - The reserved storage block.
//=========================================================================
dcl-proc MemoryManager_allocate export;
  dcl-pi *n pointer;
    i_size   uns(10) value;
    i_heapID int(10) options(*nopass) value;
  end-pi;

  //  Return value
  dcl-s pMemory pointer inz;

  //  Parameter positions
  dcl-c p_heapID 2;

  //  Optional parameter fields
  dcl-s heapID like(i_heapID) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Change Reserved Storage Block Size
//=========================================================================
//  Parameters:
//   i_pMem        - Address of a previously allocated memory block.
//   i_size        - The number of bytes of storage to be allocated for
//                   the new storage block.
//
//  Returns:
//   pMemory       - The reserved storage block.
//=========================================================================
dcl-proc MemoryManager_reallocate export;
  dcl-pi *n pointer;
    i_pMem pointer value;
    i_size uns(10) value;
  end-pi;

  //  Return value
  dcl-s pMemory pointer inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pMemory = realloc(i_pMem: i_size);

  return pMemory;

end-proc;

//=========================================================================
//  Release Storage Blocks
//=========================================================================
//  Parameters:
//   io_pMem       - A previously allocated storage block.
//
//  Returns:
//   void
//=========================================================================
dcl-proc MemoryManager_free export;
  dcl-pi *n;
    io_pMem pointer;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(io_pMem <> *NULL);

  free(io_pMem);
  io_pMem = *NULL;

  g_mmStatus.numAlloc = g_mmStatus.numAlloc - 1;

  return;

end-proc;

//=========================================================================
//  Creates a new heap
//=========================================================================
//  Parameters:
//   i_initialSize - The initial amount of storage, in bytes, allocated
//                   for the new heap.
//   i_increment   - The number of bytes by which the heap is extended
//                   when it is necessary to enlarge the heap to satisfy
//                   an allocation request.
//   i_allocStrat  - The allocation strategy used.
//
//  Returns:
//   headID        - The heap identifier of the created heap.
//=========================================================================
dcl-proc MemoryManager_createHeap export;
  dcl-pi *n int(10);
    i_initialSize int(10) options(*nopass: *omit) const;
    i_increment   int(10) options(*nopass: *omit) const;
    i_allocStrat  int(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s heapID int(10) inz;

  //  Parameter positions
  dcl-c p_initialSize 1;
  dcl-c p_increment 2;
  dcl-c p_allocStrat 3;

  //  Fields for optional parameters
  dcl-s initialSize like(i_initialSize) inz;
  dcl-s increment like(i_increment) inz;
  dcl-s allocStrat like(i_allocStrat) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

end-proc;

//=========================================================================
//  Deletes an existing heap.
//=========================================================================
//  Parameters:
//   io_heapID     - The heap identifier of the heap to be deleted.
//
//  Returns:
//   void
//=========================================================================
dcl-proc MemoryManager_deleteHeap export;
  dcl-pi *n;
    io_heapID int(10);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  CEEDSHP(io_heapID: *omit);
  io_heapID = 0;

  return;

end-proc;

//=========================================================================
//  *** Internal use only. ***
//  Returns a pointer to newly allocated heap storage of the length
//  specified. Replacement for RPG %alloc().
//=========================================================================
//  Parameters:
//   i_size        - Size of the newly allocated storage.
//
//  Returns:
//   pMem          - Pointer to the newly allocated storage.
//=========================================================================
dcl-proc xalloc export;
  dcl-pi *n pointer;
    i_size int(10) const;
  end-pi;

  //  Return value
  dcl-s pMem pointer inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pMem = %alloc(i_size);

  return pMem;

end-proc;

//=========================================================================
//  *** Internal use only. ***
//  Changes the heap storage pointed to by the first parameter to be the
//  length specified in the second parameter. Replacement for RPG
//  %realloc().
//=========================================================================
//  Parameters:
//   i_pMem        - Pointer to the heap storage that is reallocated.
//   i_size        - New size of the heap storage.
//
//  Returns:
//   pMem          - Pointer to the resized heap storage.
//=========================================================================
dcl-proc xrealloc export;
  dcl-pi *n pointer;
    i_pMem pointer const;
    i_size int(10) const;
  end-pi;

  //  Return value
  dcl-s pMem pointer inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pMem = %realloc(i_pMem: i_size);

  return pMem;

end-proc;

//=========================================================================
//  *** Internal use only. ***
//  Frees one previous allocation of heap storage.
//  Replacement for RPG dealloc.
//=========================================================================
//  Parameters:
//   i_pMem        - Pointer to the heap storage that is reallocated.
//
//  Returns:
//   void
//=========================================================================
dcl-proc xdealloc export;
  dcl-pi *n;
    io_pMem pointer;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  dealloc(N) io_pMem;

end-proc;