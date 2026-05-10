**free
/if NOT DEFINED(BASICS1RB)
/define BASICS1RB

dcl-s BasicStack_handle_t like(BasicList_handle_t) based(pDummy);

//  Creates a new BasicStack.
dcl-pr BasicStack_new like(BasicStack_handle_t) extproc('BASICS1RB_BasicStack_new');
  i_increment uns(10) options(*nopass: *omit) const;
  i_heapID    uns(10) options(*nopass: *omit) const;
end-pr;

//  Clones a given BasicStack.   (not yet implemented)
dcl-pr BasicStack_clone like(BasicStack_handle_t) extproc('BASICS1RB_BasicStack_clone');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Gets the last entry from top of the stack without removing it from stack.
dcl-pr BasicStack_peek pointer extproc('BASICS1RB_BasicStack_peek');
  i_pStack like(BasicStack_handle_t) const;
  i_pEntry pointer options(*nopass) const;
  i_length int(10) options(*nopass) const;
end-pr;

//  Removes the element at the top of the stack and returnns that element.
dcl-pr BasicStack_pop pointer extproc('BASICS1RB_BasicStack_pop');
  i_pStack like(BasicStack_handle_t) const;
  i_pEntry pointer const;
  i_length int(10) const;
end-pr;

//  Pushes an item onto the top of the stack.
dcl-pr BasicStack_push int(10) extproc('BASICS1RB_BasicStack_push');
  i_pStack like(BasicStack_handle_t) const;
  i_pEntry pointer options(*string) const;
  i_length int(10) options(*nopass) const;
end-pr;

//  Returns the size of of the element that is on top of this stack.
dcl-pr BasicStack_getSize int(10) extproc('BASICS1RB_BasicStack_getSize');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Returns the number of elements in this stack.
dcl-pr BasicStack_getNumE int(10) extproc('BASICS1RB_BasicStack_getNumE');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Returns the heap ID of a given BasicList.
dcl-pr BasicStack_getHeapID int(10) extproc('BASICS1RB_BasicStack_getHeapID');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Removes all entries from a given stack.
dcl-pr BasicStack_clear int(10) extproc('BASICS1RB_BasicStack_clear');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Deletes a given BasicStack.
dcl-pr BasicStack_delete int(10) extproc('BASICS1RB_BasicStack_delete');
  io_pStack like(BasicStack_handle_t);
end-pr;

//  Returns a BasicStack NULL handle.
dcl-pr BasicStack_null like(BasicStack_handle_t) extproc('BASICS1RB_BasicStack_null');
end-pr;

//  Checks a given BasicStack handle for a NULL value.
dcl-pr BasicStack_isNull ind extproc('BASICS1RB_BasicStack_isNull');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1RA                    BasicList
/copy QBASICS1,PBASICS1R4                    Assert/This/Caller

/endif