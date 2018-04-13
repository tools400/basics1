 DEF  /IF NOT DEFINED(HEAPAPI)
 DEF  /DEFINE HEAPAPI
      *
      *  Get Heap Storage (CEEGTST) API
     D CEEGTST...
     D                 PR
     D                                            extproc('CEEGTST')
     D  i_heap_id                    10I 0 const
     D  i_size                       10I 0 const
     D  o_address                      *
     D  o_fc                         12A          options(*omit)
      *
      *  Reallocate Storage (CEECZST) API
     D CEECZST...
     D                 PR
     D                                            extproc('CEECZST')
     D  io_address                     *
     D  i_new_size                   10I 0 const
     D  o_fc                         12A          options(*omit)
      *
      *  Free Storage (CEEFRST) API
     D CEEFRST...
     D                 PR
     D                                            extproc('CEEFRST')
     D  i_address                      *   const
     D  o_fc                         12A          options(*omit)
      *
      *  Allocation Strategy Type (CEE4ALC)
     D CEE4ALC         DS
     D   MaxSglAloc                  10I 0
     D   MinBdy                      10I 0
     D   CrtSiz                      10I 0
     D   ExtSiz                      10I 0
     D   res1                         5I 0
     D   AllocBits                    3U 0
     D   InitValue                    3U 0
     D   res2                         5A
      *
      *  Use BITON to set on the appropriate bit.
      *  For example:   BITON     AllocInit     AllocBits
     D ALC_ABITS_AllocStrat...
     D                 C                    x'80'
     D ALC_BITS_NoMark...
     D                 C                    x'40'
     D ALC_ABITS_BlkXfer...
     D                 C                    x'20'
     D ALC_ABITS_PAG...
     D                 C                    x'10'
     D ALC_ABITS_AllocInit...
     D                 C                    x'08'
      *
      *  Create Heap (CEECRHP) API
     D CEECRHP...
     D                 PR
     D                                            extproc('CEECRHP')
     D  o_heap_id                    10I 0
     D  i_initial_size...
     D                               10I 0 const  options(*omit)
     D  i_increment                  10I 0 const  options(*omit)
     D  i_alloc_start_id...
     D                               10I 0 const  options(*omit)
     D  o_fc                         12A          options(*omit)
      *
      *  Mark Heap (CEEMKHP) API
     D CEEMKHP...
     D                 PR
     D                                            extproc('CEEMKHP')
     D  i_heap_id                    10I 0 const
     D  o_mark                         *
     D  o_fc                         12A          options(*omit)
      *
      *  Release Heap (CEERLHP) API
     D CEERLHP...
     D                 PR
     D                                            extproc('CEERLHP')
     D  i_mark                         *   const
     D  o_fc                         12A          options(*omit)
      *
      *  Discard Heap (CEEDSHP) API
     D CEEDSHP...
     D                 PR
     D                                            extproc('CEEDSHP')
     D  i_heap_id                    10I 0 const
     D  o_fc                         12A          options(*omit)
      *
 DEF  /ENDIF
