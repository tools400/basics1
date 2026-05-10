**free
/if NOT DEFINED(BASICS1RA)
/define BASICS1RA

dcl-s BasicList_handle_t pointer based(pDummy);
dcl-s BasicList_type_t char(32) based(pDummy);

dcl-c cBASICLIST_REMOVE_ALL -1;

dcl-c cBASICLIST_TYPE_UNKNOWN '*N';
dcl-c cBASICLIST_TYPE_VSTRING '*VSTRING';
dcl-c cBASICLIST_TYPE_CHARACTER '*CHAR';
dcl-c cBASICLIST_TYPE_INTEGER '*INT';
dcl-c cBASICLIST_TYPE_UINTEGER '*UINT';
dcl-c cBASICLIST_TYPE_POINTER '*POINTER';

//  Creates a new BasicList.
dcl-pr BasicList_new like(BasicList_handle_t) extproc('BASICS1RA_BasicList_new');
  i_extType   like(BasicList_type_t) options(*nopass: *omit) const;
  i_increment uns(10) options(*nopass: *omit) const;
  i_heapID    int(10) options(*nopass: *omit) const;
end-pr;

//  Clones a given BasicList.
dcl-pr BasicList_clone like(BasicList_handle_t) extproc('BASICS1RA_BasicList_clone');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Returns the element from the specified position.
dcl-pr BasicList_get pointer extproc('BASICS1RA_BasicList_get');
  i_pList  like(BasicList_handle_t) const;
  i_index  int(10) const;
  i_pEntry pointer options(*nopass) const;
  i_length int(10) options(*nopass) const;
end-pr;

//  Returns the string element from the specified position.
dcl-pr BasicList_getString varchar(4096) extproc('BASICS1RA_BasicList_getString');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Returns the pointer element from the specified position.
dcl-pr BasicList_getPointer pointer extproc('BASICS1RA_BasicList_getPointer');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Returns the type of the list.
dcl-pr BasicList_getListType like(BasicList_type_t) extproc('BASICS1RA_BasicList_getListType');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Returns the type of the list.
dcl-pr BasicList_isListTypeOf ind extproc('BASICS1RA_BasicList_isListTypeOf');
  i_pList like(BasicList_handle_t) const;
  i_type  like(BasicList_type_t) const;
end-pr;

//  Checks an list entry for a given type.
dcl-pr BasicList_isTypeOf ind extproc('BASICS1RA_BasicList_isTypeOf');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
  i_type  like(BasicList_type_t) const;
end-pr;

//  Returns the type of the specified list entry.
dcl-pr BasicList_getType like(BasicList_type_t) extproc('BASICS1RA_BasicList_getType');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Returns the size of of an element.
dcl-pr BasicList_getSize int(10) extproc('BASICS1RA_BasicList_getSize');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Adds an element to a given BasicList.
dcl-pr BasicList_add int(10) extproc('BASICS1RA_BasicList_add');
  i_pList  like(BasicList_handle_t) const;
  i_pEntry pointer options(*string) const;
  i_length int(10) options(*nopass: *omit) const;
  i_type   like(BasicList_type_t) options(*nopass: *omit) const;
end-pr;

//  Adds a NULL value to a given BasicList.
dcl-pr BasicList_addNull int(10) extproc('BASICS1RA_BasicList_addNull');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Adds a string element to a given BasicList.
dcl-pr BasicList_addString int(10) extproc('BASICS1RA_BasicList_addString');
  i_pList  like(BasicList_handle_t) const;
  i_string varchar(4096) const;
end-pr;

//  Adds a pointer element to a given BasicList.
dcl-pr BasicList_addPointer int(10) extproc('BASICS1RA_BasicList_addPointer');
  i_pList   like(BasicList_handle_t) const;
  i_pointer pointer const;
end-pr;

//  Searches the list for a given element.
dcl-pr BasicList_find int(10) extproc('BASICS1RA_BasicList_find');
  i_pList  like(BasicList_handle_t) const;
  i_pEntry pointer options(*string) const;
  i_length int(10) options(*nopass) const;
end-pr;

//  Searches the list for a given string.
dcl-pr BasicList_findString int(10) extproc('BASICS1RA_BasicList_findString');
  i_pList  like(BasicList_handle_t) const;
  i_string varchar(4096) const;
end-pr;

//  Changes the element at the specified position in this list.
dcl-pr BasicList_set int(10) extproc('BASICS1RA_BasicList_set');
  i_pList  like(BasicList_handle_t) const;
  i_index  int(10) const;
  i_pEntry pointer options(*string) const;
  i_length int(10) options(*nopass: *omit) const;
  i_type   like(BasicList_type_t) options(*nopass: *omit) const;
end-pr;

//  Changes the element at the specified position to NULL.
dcl-pr BasicList_setNull int(10) extproc('BASICS1RA_BasicList_setNull');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Changes the string at the specified position in this list.
dcl-pr BasicList_setString int(10) extproc('BASICS1RA_BasicList_setString');
  i_pList  like(BasicList_handle_t) const;
  i_index  int(10) const;
  i_string varchar(4096) const;
end-pr;

//  Changes the pointer at the specified position in this list.
dcl-pr BasicList_setPointer int(10) extproc('BASICS1RA_BasicList_setPointer');
  i_pList   like(BasicList_handle_t) const;
  i_index   int(10) const;
  i_pointer pointer const;
end-pr;

//  Specifies an auto-sort function for this list.
dcl-pr BasicList_setAutoSort ind extproc('BASICS1RA_BasicList_setAutoSort');
  i_pList    like(BasicList_handle_t) const;
  i_pSortFnc pointer(*proc) const;
end-pr;

//  Removes the element at the specified position in this list.
dcl-pr BasicList_remove int(10) extproc('BASICS1RA_BasicList_remove');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

//  Returns the number of lements in this list.
dcl-pr BasicList_getNumE int(10) extproc('BASICS1RA_BasicList_getNumE');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Returns the heap ID of a given BasicList.
dcl-pr BasicList_getHeapID int(10) extproc('BASICS1RA_BasicList_getHeapID');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Sorts a list using the specified sort function.
dcl-pr BasicList_sort ind extproc('BASICS1RA_BasicList_sort');
  i_pList    like(BasicList_handle_t) const;
  i_pSortFnc pointer(*proc) const;
end-pr;

//  Returns cTrue if a given list is sorted.
dcl-pr BasicList_isSorted ind extproc('BASICS1RA_BasicList_isSorted');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Removes all entries from a given list.
dcl-pr BasicList_clear int(10) extproc('BASICS1RA_BasicList_clear');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Returns the total size of memory used by this list.
dcl-pr BasicList_getTotalSize int(20) extproc('BASICS1RA_BasicList_getTotalSize');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Deletes a given BasicList.
dcl-pr BasicList_delete int(10) extproc('BASICS1RA_BasicList_delete');
  io_pList like(BasicList_handle_t);
end-pr;

//  Returns a BasicList NULL handle.
dcl-pr BasicList_null like(BasicList_handle_t) extproc('BASICS1RA_BasicList_null');
end-pr;

//  Checks a given BasicList handle for a NULL value.
dcl-pr BasicList_isNull ind extproc('BASICS1RA_BasicList_isNull');
  i_pList like(BasicList_handle_t) const;
end-pr;

//  Checks a given BasicList entry for a NULL value.
dcl-pr BasicList_isNullValue ind extproc('BASICS1RA_BasicList_isNullValue');
  i_pList like(BasicList_handle_t) const;
  i_index int(10) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1R4
/copy QBASICS1,PBASICS1R8

/endif