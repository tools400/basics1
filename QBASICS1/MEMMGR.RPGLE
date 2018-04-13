      *
     D mm_memMgr       DS                  likeds(MemoryManager...
     D                                            _manager_t)
      *
     D mm_allocate...
     D                 PR              *   extproc(mm_memMgr.pAllocate)
     D  i_size                       10U 0 value
     D  i_heap                       10I 0 value  options(*nopass)
      *
     D mm_reallocate...
     D                 PR              *   extproc(mm_memMgr.pReallocate)
     D  i_pMem                         *   value
     D  i_size                       10U 0 value
      *
     D mm_free...
     D                 PR                  extproc(mm_memMgr.pFree)
     D  io_pMem                        *
      *
