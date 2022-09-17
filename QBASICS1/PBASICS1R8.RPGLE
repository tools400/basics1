      /IF NOT DEFINED(BASICS1R8)
      /DEFINE BASICS1R8
      *
     D HANDLE_handle_t...
     D                 S             10I 0                         based(pDummy)
     D HANDLE_type_t...
     D                 S             20A                           based(pDummy)
      *
      *  Creates a new handle.
     D HANDLE_new...
     D                 PR                         like(HANDLE_handle_t)
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_new+
     D                                     ')
     D  i_type                             value  like(HANDLE_type_t  )
     D  i_size                       10U 0 value
      *
      *  Creates a NULL handle.
     D HANDLE_null...
     D                 PR                         like(HANDLE_handle_t)
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_null+
     D                                     ')
      *
      *  Checks a handle for a NULL value.
     D HANDLE_isNull...
     D                 PR              N
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_isNull+
     D                                     ')
     D  i_handle                           value  like(HANDLE_handle_t)
      *
      *  Checks the type of a given handle.
     D HANDLE_isTypeOf...
     D                 PR              N
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_isTypeOf+
     D                                     ')
     D  i_handle                           value  like(HANDLE_handle_t)
     D  i_type                             value  like(HANDLE_type_t  )
      *
      *  Gets the pointer of a given handle.
     D HANDLE_getPointer...
     D                 PR              *
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_getPointer+
     D                                     ')
     D  i_handle                           value  like(HANDLE_handle_t)
      *
      *  Deletes a given handle.
     D HANDLE_delete...
     D                 PR
     D                                     extproc('BASICS1R8+
     D                                     _HANDLE_delete+
     D                                     ')
     D  io_handle                                 like(HANDLE_handle_t)
      *
      *  Allocates a memory cell and keeps track of it.
     D MEMORY_allocate...
     D                 PR              *
     D                                     extproc('BASICS1R8+
     D                                     _MEMORY_allocate+
     D                                     ')
     D  io_aMemList                    *
     D  i_size                       10I 0 value
      *
      *  Frees all allocated memory cells.
     D MEMORY_freeAll...
     D                 PR
     D                                     extproc('BASICS1R8+
     D                                     _MEMORY_freeAll+
     D                                     ')
     D  io_aMemList                    *
      *
      *  Frees all given memory cell.
     D MEMORY_free...
     D                 PR
     D                                     extproc('BASICS1R8+
     D                                     _MEMORY_free+
     D                                     ')
     D  io_aMemList                    *
     D  io_pMem                        *
      *
     D MemoryManager_manager_t...
     D                 DS                         qualified   based(pDummy)
     D  pAllocate                      *          procptr
     D  pReallocate                    *          procptr
     D  pFree                          *          procptr
      *
      *  Memory Manager -- Returns the default memory manager
     D MemoryManager_getDefaultManager...
     D                 PR                  likeds(MemoryManager_manager_t)
     D                                     extproc('BASICS1R8+
     D                                     _MemoryManager_getDefaultManager+
     D                                     ')
      *
      *  Memory Manager -- Reserve Storage Block
     D MemoryManager_allocate...
     D                 PR              *   extproc('BASICS1R8+
     D                                     _MemoryManager_allocate+
     D                                     ')
     D  i_size                       10U 0 value
     D  i_heap                       10I 0 value  options(*nopass)
      *
      *  Memory Manager -- Change Reserved Storage Block Size
     D MemoryManager_reallocate...
     D                 PR              *   extproc('BASICS1R8+
     D                                     _MemoryManager_reallocate+
     D                                     ')
     D  i_pMem                         *   value
     D  i_size                       10U 0 value
      *
      *  Memory Manager -- Release Storage Blocks
     D MemoryManager_free...
     D                 PR                  extproc('BASICS1R8+
     D                                     _MemoryManager_free+
     D                                     ')
     D  io_pMem                        *
      *
      *  Memory Manager -- Creates a new heap.
     D MemoryManager_createHeap...
     D                 PR            10I 0
     D                                     extproc('BASICS1R8+
     D                                     _MemoryManager_createHeap+
     D                                     ')
     D  i_initialSize                10I 0 const  options(*nopass: *omit)
     D  i_increment                  10I 0 const  options(*nopass: *omit)
     D  i_allocStrat                 10I 0 const  options(*nopass: *omit)
      *
      *  Memory Manager -- Deletes an existing heap.
     D MemoryManager_deleteHeap...
     D                 PR
     D                                     extproc('BASICS1R8+
     D                                     _MemoryManager_deleteHeap+
     D                                     ')
     D  io_heapID                    10I 0
      *
      /IF DEFINED(INCLUDE_INTERNAL_PROCDURES)
      *
      *  Returns a pointer to newly allocated heap storage of the length
      *  specified.
     D xalloc...
     D                 PR              *
     D                                     extproc('BASICS1R8+
     D                                     _xalloc+
     D                                     ')
     D  i_size                       10I 0 const
      *
      *  Changes the heap storage pointed to by the first parameter to be the
      *  length specified in the second parameter.
     D xrealloc...
     D                 PR              *
     D                                     extproc('BASICS1R8+
     D                                     _xrealloc+
     D                                     ')
     D  i_pMem                         *   const
     D  i_size                       10I 0 const
      *
      *  Frees one previous allocation of heap storage.
     D xdealloc...
     D                 PR
     D                                     extproc('BASICS1R8+
     D                                     _xdealloc+
     D                                     ')
     D  io_pMem                        *
      /ENDIF
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R4                   Assert/This
      *
      /ENDIF
