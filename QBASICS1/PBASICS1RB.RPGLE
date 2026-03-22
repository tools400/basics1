**FREE
/IF NOT DEFINED(BASICS1RB)
/DEFINE BASICS1RB

dcl-s BasicStack_handle_t
      like(BasicList_handle_t) based(pDummy);

//  Creates a new BasicStack.
dcl-pr BasicStack_new
       like(BasicStack_handle_t  )
       extproc('BASICS1RB+
       _BasicStack_new+
       ');
  i_increment     uns(10) const  options(*nopass: *omit);
  i_heapID        uns(10) const  options(*nopass: *omit);
end-pr;

//  Clones a given BasicStack.   (not yet implemented)
dcl-pr BasicStack_clone
       like(BasicStack_handle_t  )
       extproc('BASICS1RB+
       _BasicStack_clone+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

//  Gets the last entry from top of the stack without removing it from stack.
dcl-pr BasicStack_peek
       pointer
       extproc('BASICS1RB+
       _BasicStack_peek+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
  i_pEntry        pointer const  options(*nopass);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Removes the element at the top of the stack and returnns that element.
dcl-pr BasicStack_pop
       pointer
       extproc('BASICS1RB+
       _BasicStack_pop+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
  i_pEntry        pointer const;
  i_length        int(10) const;
end-pr;

//  Pushes an item onto the top of the stack.
dcl-pr BasicStack_push
       int(10)
       extproc('BASICS1RB+
       _BasicStack_push+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Returns the size of of the element that is on top of this stack.
dcl-pr BasicStack_getSize
       int(10)
       extproc('BASICS1RB+
       _BasicStack_getSize+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

//  Returns the number of elements in this stack.
dcl-pr BasicStack_getNumE
       int(10)
       extproc('BASICS1RB+
       _BasicStack_getNumE+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

//  Returns the heap ID of a given BasicList.
dcl-pr BasicStack_getHeapID
       int(10)
       extproc('BASICS1RB+
       _BasicStack_getHeapID+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

//  Removes all entries from a given stack.
dcl-pr BasicStack_clear
       int(10)
       extproc('BASICS1RB+
       _BasicStack_clear+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

//  Deletes a given BasicStack.
dcl-pr BasicStack_delete
       int(10)
       extproc('BASICS1RB+
       _BasicStack_delete+
       ');
  io_pStack       like(BasicStack_handle_t  );
end-pr;

//  Returns a BasicStack NULL handle.
dcl-pr BasicStack_null
       like(BasicStack_handle_t  )
       extproc('BASICS1RB+
       _BasicStack_null+
       ');
end-pr;

//  Checks a given BasicStack handle for a NULL value.
dcl-pr BasicStack_isNull
       ind
       extproc('BASICS1RB+
       _BasicStack_isNull+
       ');
  i_pStack        const  like(BasicStack_handle_t  );
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1RA                    BasicList
/COPY QBASICS1,PBASICS1R4                    Assert/This/Caller

/ENDIF
