**free
/if NOT DEFINED(BASICS1R8)
/define BASICS1R8

dcl-s HANDLE_handle_t int(10) based(pDummy);
dcl-s HANDLE_type_t char(20) based(pDummy);

//  Creates a new handle.
dcl-pr HANDLE_new like(HANDLE_handle_t) extproc('BASICS1R8_HANDLE_new');
  i_type like(HANDLE_type_t) value;
  i_size uns(10) value;
end-pr;

//  Creates a NULL handle.
dcl-pr HANDLE_null like(HANDLE_handle_t) extproc('BASICS1R8_HANDLE_null');
end-pr;

//  Checks a handle for a NULL value.
dcl-pr HANDLE_isNull ind extproc('BASICS1R8_HANDLE_isNull');
  i_handle like(HANDLE_handle_t) value;
end-pr;

//  Checks the type of a given handle.
dcl-pr HANDLE_isTypeOf ind extproc('BASICS1R8_HANDLE_isTypeOf');
  i_handle like(HANDLE_handle_t) value;
  i_type   like(HANDLE_type_t) value;
end-pr;

//  Gets the pointer of a given handle.
dcl-pr HANDLE_getPointer pointer extproc('BASICS1R8_HANDLE_getPointer');
  i_handle like(HANDLE_handle_t) value;
end-pr;

//  Deletes a given handle.
dcl-pr HANDLE_delete extproc('BASICS1R8_HANDLE_delete');
  io_handle like(HANDLE_handle_t);
end-pr;

//  Allocates a memory cell and keeps track of it.
dcl-pr MEMORY_allocate pointer extproc('BASICS1R8_MEMORY_allocate');
  io_aMemList pointer;
  i_size      int(10) value;
end-pr;

//  Frees all allocated memory cells.
dcl-pr MEMORY_freeAll extproc('BASICS1R8_MEMORY_freeAll');
  io_aMemList pointer;
end-pr;

//  Frees all given memory cell.
dcl-pr MEMORY_free extproc('BASICS1R8_MEMORY_free');
  io_aMemList pointer;
  io_pMem     pointer;
end-pr;

dcl-ds MemoryManager_manager_t qualified based(pDummy);
  pAllocate   pointer(*proc);
  pReallocate pointer(*proc);
  pFree       pointer(*proc);
end-ds;

//  Memory Manager -- Returns the default memory manager
dcl-pr MemoryManager_getDefaultManager likeds(MemoryManager_manager_t)
  extproc('BASICS1R8_MemoryManager_getDefaultManager');
end-pr;

//  Memory Manager -- Reserve Storage Block
dcl-pr MemoryManager_allocate pointer extproc('BASICS1R8_MemoryManager_allocate');
  i_size uns(10) value;
  i_heap int(10) options(*nopass) value;
end-pr;

//  Memory Manager -- Change Reserved Storage Block Size
dcl-pr MemoryManager_reallocate pointer extproc('BASICS1R8_MemoryManager_reallocate');
  i_pMem pointer value;
  i_size uns(10) value;
end-pr;

//  Memory Manager -- Release Storage Blocks
dcl-pr MemoryManager_free extproc('BASICS1R8_MemoryManager_free');
  io_pMem pointer;
end-pr;

//  Memory Manager -- Creates a new heap.
dcl-pr MemoryManager_createHeap int(10) extproc('BASICS1R8_MemoryManager_createHeap');
  i_initialSize int(10) options(*nopass: *omit) const;
  i_increment   int(10) options(*nopass: *omit) const;
  i_allocStrat  int(10) options(*nopass: *omit) const;
end-pr;

//  Memory Manager -- Deletes an existing heap.
dcl-pr MemoryManager_deleteHeap extproc('BASICS1R8_MemoryManager_deleteHeap');
  io_heapID int(10);
end-pr;

/if DEFINED(INCLUDE_INTERNAL_PROCDURES)

//  Returns a pointer to newly allocated heap storage of the length
//  specified.
dcl-pr xalloc pointer extproc('BASICS1R8_xalloc');
  i_size int(10) const;
end-pr;

//  Changes the heap storage pointed to by the first parameter to be the
//  length specified in the second parameter.
dcl-pr xrealloc pointer extproc('BASICS1R8_xrealloc');
  i_pMem pointer const;
  i_size int(10) const;
end-pr;

//  Frees one previous allocation of heap storage.
dcl-pr xdealloc extproc('BASICS1R8_xdealloc');
  io_pMem pointer;
end-pr;
/endif
// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R4                   Assert/This

/endif