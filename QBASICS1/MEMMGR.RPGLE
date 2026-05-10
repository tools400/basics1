**free

dcl-ds mm_memMgr likeds(MemoryManager_manager_t);

dcl-pr mm_allocate pointer extproc(mm_memMgr.pAllocate);
  i_size uns(10) value;
  i_heap int(10) options(*nopass) value;
end-pr;

dcl-pr mm_reallocate pointer extproc(mm_memMgr.pReallocate);
  i_pMem pointer value;
  i_size uns(10) value;
end-pr;

dcl-pr mm_free extproc(mm_memMgr.pFree);
  io_pMem pointer;
end-pr;