      /IF NOT DEFINED(BASICS1RA)
      /DEFINE BASICS1RA
      *
     D BasicList_handle_t...
     D                 S               *                      based(pDummy)
     D BasicList_type_t...
     D                 S             32A                      based(pDummy)
      *
     D cBASICLIST_REMOVE_ALL...
     D                 C                          const(-1)
      *
     D cBASICLIST_TYPE_UNKNOWN...
     D                 C                          const('*N')
     D cBASICLIST_TYPE_VSTRING...
     D                 C                          const('*VSTRING')
     D cBASICLIST_TYPE_CHARACTER...
     D                 C                          const('*CHAR')
     D cBASICLIST_TYPE_INTEGER...
     D                 C                          const('*INT')
     D cBASICLIST_TYPE_UINTEGER...
     D                 C                          const('*UINT')
     D cBASICLIST_TYPE_POINTER...
     D                 C                          const('*POINTER')
      *
      *  Creates a new BasicList.
     D BasicList_new...
     D                 PR                         like(BasicList_handle_t)
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_new+
     D                                     ')
     D  i_extType                          const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Clones a given BasicList.
     D BasicList_clone...
     D                 PR                         like(BasicList_handle_t)
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_clone+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Returns the element from the specified position.
     D BasicList_get...
     D                 PR              *
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_get+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Returns the string element from the specified position.
     D BasicList_getString...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getString+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Returns the pointer element from the specified position.
     D BasicList_getPointer...
     D                 PR              *
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getPointer+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Returns the type of the list.
     D BasicList_getListType...
     D                 PR                         like(BasicList_type_t  )
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getListType+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Returns the type of the list.
     D BasicList_isListTypeOf...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_isListTypeOf+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Checks an list entry for a given type.
     D BasicList_isTypeOf...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_isTypeOf+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_type                             const  like(BasicList_type_t  )
      *
      *  Returns the type of the specified list entry.
     D BasicList_getType...
     D                 PR                         like(BasicList_type_t  )
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getType+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Returns the size of of an element.
     D BasicList_getSize...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getSize+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Adds an element to a given BasicList.
     D BasicList_add...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_add+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass: *omit)
     D  i_type                             const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
      *
      *  Adds a NULL value to a given BasicList.
     D BasicList_addNull...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_addNull+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Adds a string element to a given BasicList.
     D BasicList_addString...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_addString+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_string                   4096A   const  varying
      *
      *  Adds a pointer element to a given BasicList.
     D BasicList_addPointer...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_addPointer+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pointer                      *   const
      *
      *  Searches the list for a given element.
     D BasicList_find...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_find+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Searches the list for a given string.
     D BasicList_findString...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_findString+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_string                   4096A   const  varying
      *
      *  Changes the element at the specified position in this list.
     D BasicList_set...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_set+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass: *omit)
     D  i_type                             const  like(BasicList_type_t  )
     D                                            options(*nopass: *omit)
      *
      *  Changes the element at the specified position to NULL.
     D BasicList_setNull...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_setNull+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Changes the string at the specified position in this list.
     D BasicList_setString...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_setString+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_string                   4096A   const  varying
      *
      *  Changes the pointer at the specified position in this list.
     D BasicList_setPointer...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_setPointer+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
     D  i_pointer                      *   const
      *
      *  Specifies an auto-sort function for this list.
     D BasicList_setAutoSort...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_setAutoSort+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pSortFnc                     *   const  procptr
      *
      *  Removes the element at the specified position in this list.
     D BasicList_remove...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_remove+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      *  Returns the number of lements in this list.
     D BasicList_getNumE...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getNumE+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Returns the heap ID of a given BasicList.
     D BasicList_getHeapID...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getHeapID+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Sorts a list using the specified sort function.
     D BasicList_sort...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_sort+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_pSortFnc                     *   const  procptr
      *
      *  Returns cTrue if a given list is sorted.
     D BasicList_isSorted...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_isSorted+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Removes all entries from a given list.
     D BasicList_clear...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_clear+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Returns the total size of memory used by this list.
     D BasicList_getTotalSize...
     D                 PR            20I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_getTotalSize+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Deletes a given BasicList.
     D BasicList_delete...
     D                 PR            10I 0
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_delete+
     D                                     ')
     D  io_pList                                  like(BasicList_handle_t)
      *
      *  Returns a BasicList NULL handle.
     D BasicList_null...
     D                 PR                         like(BasicList_handle_t)
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_null+
     D                                     ')
      *
      *  Checks a given BasicList handle for a NULL value.
     D BasicList_isNull...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_isNull+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
      *
      *  Checks a given BasicList entry for a NULL value.
     D BasicList_isNullValue...
     D                 PR              N
     D                                     extproc('BASICS1RA+
     D                                     _BasicList_isNullValue+
     D                                     ')
     D  i_pList                            const  like(BasicList_handle_t)
     D  i_index                      10I 0 const
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1R4
      /COPY QBASICS1,PBASICS1R8
      *
      /ENDIF
