      /IF NOT DEFINED(BASICS1RB)
      /DEFINE BASICS1RB
      *
     D BasicStack_handle_t...
     D                 S                   like(BasicList_handle_t)
     D                                     based(pDummy)
      *
      *  Creates a new BasicStack.
     D BasicStack_new...
     D                 PR                         like(BasicStack_handle_t  )
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_new+
     D                                     ')
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10U 0 const  options(*nopass: *omit)
      *
      *  Clones a given BasicStack.   (not yet implemented)
     D BasicStack_clone...
     D                 PR                         like(BasicStack_handle_t  )
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_clone+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Gets the last entry from top of the stack without removing it from stack.
     D BasicStack_peek...
     D                 PR              *
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_peek+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Removes the element at the top of the stack and returnns that element.
     D BasicStack_pop...
     D                 PR              *
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_pop+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
     D  i_pEntry                       *   const
     D  i_length                     10I 0 const
      *
      *  Pushes an item onto the top of the stack.
     D BasicStack_push...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_push+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Returns the size of of the element that is on top of this stack.
     D BasicStack_getSize...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_getSize+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Returns the number of elements in this stack.
     D BasicStack_getNumE...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_getNumE+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Returns the heap ID of a given BasicList.
     D BasicStack_getHeapID...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_getHeapID+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Removes all entries from a given stack.
     D BasicStack_clear...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_clear+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      *  Deletes a given BasicStack.
     D BasicStack_delete...
     D                 PR            10I 0
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_delete+
     D                                     ')
     D  io_pStack                                 like(BasicStack_handle_t  )
      *
      *  Returns a BasicStack NULL handle.
     D BasicStack_null...
     D                 PR                         like(BasicStack_handle_t  )
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_null+
     D                                     ')
      *
      *  Checks a given BasicStack handle for a NULL value.
     D BasicStack_isNull...
     D                 PR              N
     D                                     extproc('BASICS1RB+
     D                                     _BasicStack_isNull+
     D                                     ')
     D  i_pStack                           const  like(BasicStack_handle_t  )
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RA                    BasicList
      /COPY QBASICS1,PBASICS1R4                    Assert/This/Caller
      *
      /ENDIF
