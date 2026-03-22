**FREE
/IF NOT DEFINED(BASICS1RA)
/DEFINE BASICS1RA

dcl-s BasicList_handle_t
      pointer based(pDummy);
dcl-s BasicList_type_t
      char(32) based(pDummy);

dcl-c cBASICLIST_REMOVE_ALL
      const(-1);

dcl-c cBASICLIST_TYPE_UNKNOWN
      const('*N');
dcl-c cBASICLIST_TYPE_VSTRING
      const('*VSTRING');
dcl-c cBASICLIST_TYPE_CHARACTER
      const('*CHAR');
dcl-c cBASICLIST_TYPE_INTEGER
      const('*INT');
dcl-c cBASICLIST_TYPE_UINTEGER
      const('*UINT');
dcl-c cBASICLIST_TYPE_POINTER
      const('*POINTER');

//  Creates a new BasicList.
dcl-pr BasicList_new
       like(BasicList_handle_t)
       extproc('BASICS1RA+
       _BasicList_new+
       ');
  i_extType       const  like(BasicList_type_t  )
       options(*nopass: *omit);
  i_increment     uns(10) const  options(*nopass: *omit);
  i_heapID        int(10) const  options(*nopass: *omit);
end-pr;

//  Clones a given BasicList.
dcl-pr BasicList_clone
       like(BasicList_handle_t)
       extproc('BASICS1RA+
       _BasicList_clone+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Returns the element from the specified position.
dcl-pr BasicList_get
       pointer
       extproc('BASICS1RA+
       _BasicList_get+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pEntry        pointer const  options(*nopass);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Returns the string element from the specified position.
dcl-pr BasicList_getString
       varchar(4096)
       extproc('BASICS1RA+
       _BasicList_getString+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Returns the pointer element from the specified position.
dcl-pr BasicList_getPointer
       pointer
       extproc('BASICS1RA+
       _BasicList_getPointer+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Returns the type of the list.
dcl-pr BasicList_getListType
       like(BasicList_type_t  )
       extproc('BASICS1RA+
       _BasicList_getListType+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Returns the type of the list.
dcl-pr BasicList_isListTypeOf
       ind
       extproc('BASICS1RA+
       _BasicList_isListTypeOf+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_type          const  like(BasicList_type_t  );
end-pr;

//  Checks an list entry for a given type.
dcl-pr BasicList_isTypeOf
       ind
       extproc('BASICS1RA+
       _BasicList_isTypeOf+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_type          const  like(BasicList_type_t  );
end-pr;

//  Returns the type of the specified list entry.
dcl-pr BasicList_getType
       like(BasicList_type_t  )
       extproc('BASICS1RA+
       _BasicList_getType+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Returns the size of of an element.
dcl-pr BasicList_getSize
       int(10)
       extproc('BASICS1RA+
       _BasicList_getSize+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Adds an element to a given BasicList.
dcl-pr BasicList_add
       int(10)
       extproc('BASICS1RA+
       _BasicList_add+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass: *omit);
  i_type          const  like(BasicList_type_t  )
       options(*nopass: *omit);
end-pr;

//  Adds a NULL value to a given BasicList.
dcl-pr BasicList_addNull
       int(10)
       extproc('BASICS1RA+
       _BasicList_addNull+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Adds a string element to a given BasicList.
dcl-pr BasicList_addString
       int(10)
       extproc('BASICS1RA+
       _BasicList_addString+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_string        varchar(4096) const;
end-pr;

//  Adds a pointer element to a given BasicList.
dcl-pr BasicList_addPointer
       int(10)
       extproc('BASICS1RA+
       _BasicList_addPointer+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_pointer       pointer const;
end-pr;

//  Searches the list for a given element.
dcl-pr BasicList_find
       int(10)
       extproc('BASICS1RA+
       _BasicList_find+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Searches the list for a given string.
dcl-pr BasicList_findString
       int(10)
       extproc('BASICS1RA+
       _BasicList_findString+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_string        varchar(4096) const;
end-pr;

//  Changes the element at the specified position in this list.
dcl-pr BasicList_set
       int(10)
       extproc('BASICS1RA+
       _BasicList_set+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass: *omit);
  i_type          const  like(BasicList_type_t  )
       options(*nopass: *omit);
end-pr;

//  Changes the element at the specified position to NULL.
dcl-pr BasicList_setNull
       int(10)
       extproc('BASICS1RA+
       _BasicList_setNull+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Changes the string at the specified position in this list.
dcl-pr BasicList_setString
       int(10)
       extproc('BASICS1RA+
       _BasicList_setString+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_string        varchar(4096) const;
end-pr;

//  Changes the pointer at the specified position in this list.
dcl-pr BasicList_setPointer
       int(10)
       extproc('BASICS1RA+
       _BasicList_setPointer+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pointer       pointer const;
end-pr;

//  Specifies an auto-sort function for this list.
dcl-pr BasicList_setAutoSort
       ind
       extproc('BASICS1RA+
       _BasicList_setAutoSort+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_pSortFnc      pointer(*proc) const;
end-pr;

//  Removes the element at the specified position in this list.
dcl-pr BasicList_remove
       int(10)
       extproc('BASICS1RA+
       _BasicList_remove+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

//  Returns the number of lements in this list.
dcl-pr BasicList_getNumE
       int(10)
       extproc('BASICS1RA+
       _BasicList_getNumE+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Returns the heap ID of a given BasicList.
dcl-pr BasicList_getHeapID
       int(10)
       extproc('BASICS1RA+
       _BasicList_getHeapID+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Sorts a list using the specified sort function.
dcl-pr BasicList_sort
       ind
       extproc('BASICS1RA+
       _BasicList_sort+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_pSortFnc      pointer(*proc) const;
end-pr;

//  Returns cTrue if a given list is sorted.
dcl-pr BasicList_isSorted
       ind
       extproc('BASICS1RA+
       _BasicList_isSorted+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Removes all entries from a given list.
dcl-pr BasicList_clear
       int(10)
       extproc('BASICS1RA+
       _BasicList_clear+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Returns the total size of memory used by this list.
dcl-pr BasicList_getTotalSize
       int(20)
       extproc('BASICS1RA+
       _BasicList_getTotalSize+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Deletes a given BasicList.
dcl-pr BasicList_delete
       int(10)
       extproc('BASICS1RA+
       _BasicList_delete+
       ');
  io_pList        like(BasicList_handle_t);
end-pr;

//  Returns a BasicList NULL handle.
dcl-pr BasicList_null
       like(BasicList_handle_t)
       extproc('BASICS1RA+
       _BasicList_null+
       ');
end-pr;

//  Checks a given BasicList handle for a NULL value.
dcl-pr BasicList_isNull
       ind
       extproc('BASICS1RA+
       _BasicList_isNull+
       ');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Checks a given BasicList entry for a NULL value.
dcl-pr BasicList_isNullValue
       ind
       extproc('BASICS1RA+
       _BasicList_isNullValue+
       ');
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1R4
/COPY QBASICS1,PBASICS1R8

/ENDIF
