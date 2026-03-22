**FREE
/IF NOT DEFINED(HEAPAPI)
/DEFINE HEAPAPI

//  Get Heap Storage (CEEGTST) API
dcl-pr CEEGTST
       extproc('CEEGTST');
  i_heap_id       int(10) const;
  i_size          int(10) const;
  o_address       pointer;
  o_fc            char(12) options(*omit);
end-pr;

//  Reallocate Storage (CEECZST) API
dcl-pr CEECZST
       extproc('CEECZST');
  io_address      pointer;
  i_new_size      int(10) const;
  o_fc            char(12) options(*omit);
end-pr;

//  Free Storage (CEEFRST) API
dcl-pr CEEFRST
       extproc('CEEFRST');
  i_address       pointer const;
  o_fc            char(12) options(*omit);
end-pr;

//  Allocation Strategy Type (CEE4ALC)
dcl-ds CEE4ALC;
  MaxSglAloc      int(10);
  MinBdy          int(10);
  CrtSiz          int(10);
  ExtSiz          int(10);
  res1            int(5);
  AllocBits       uns(3);
  InitValue       uns(3);
  res2            char(5);
end-ds;

//  Use BITON to set on the appropriate bit.
//  For example:   BITON     AllocInit     AllocBits
dcl-c ALC_ABITS_AllocStrat
      x'80';
dcl-c ALC_BITS_NoMark
      x'40';
dcl-c ALC_ABITS_BlkXfer
      x'20';
dcl-c ALC_ABITS_PAG
      x'10';
dcl-c ALC_ABITS_AllocInit
      x'08';

//  Create Heap (CEECRHP) API
dcl-pr CEECRHP
       extproc('CEECRHP');
  o_heap_id       int(10);
  i_initial_size
  int(10) const  options(*omit);
  i_increment     int(10) const  options(*omit);
  i_alloc_start_id
  int(10) const  options(*omit);
  o_fc            char(12) options(*omit);
end-pr;

//  Mark Heap (CEEMKHP) API
dcl-pr CEEMKHP
       extproc('CEEMKHP');
  i_heap_id       int(10) const;
  o_mark          pointer;
  o_fc            char(12) options(*omit);
end-pr;

//  Release Heap (CEERLHP) API
dcl-pr CEERLHP
       extproc('CEERLHP');
  i_mark          pointer const;
  o_fc            char(12) options(*omit);
end-pr;

//  Discard Heap (CEEDSHP) API
dcl-pr CEEDSHP
       extproc('CEEDSHP');
  i_heap_id       int(10) const;
  o_fc            char(12) options(*omit);
end-pr;

/ENDIF
