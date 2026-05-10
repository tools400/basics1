**free
//=====================================================================*
//  BASICS1RB  - SrvPgm: Basic Routines - BasicStack                   *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  09.06.2004                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  28.04.2008  Th.Raddatz    Introduced a real stack handle (hStack_t)*
//                                                                     *
//  28.04.2008  Th.Raddatz    Check type of stack handle and send an   *
//                            ESCAPE message for invalid handles.      *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt bnddir('QC2LE');
//  Standard H-Specs
/copy QBASICS1,H_SPEC
/copy QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QBASICS1,PBASICS1RB

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/copy QBASICS1,BASICS1R0

dcl-ds hStack_t qualified based(pDummy) align;
  intType uns(20);
  intSize uns(10);
  heapID  int(10);
  pList   like(BasicList_handle_t);
  memMgr  likeds(MemoryManager_manager_t);
end-ds;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Checks, whether a given handle is a valid stack handle, or not.
dcl-pr checkStackHandle extproc('checkStackHandle');
  i_pStack like(BasicStack_handle_t) const;
end-pr;

//  Sends an ESCAPE message to signal an error condition.
dcl-pr signalError extproc('signalError');
  i_text varchar(128) const;
  i_proc varchar(256) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cHANDLE_TYPE_STACK 6693091772879487297; // =  *Stack
dcl-c cHANDLE_SIZE %size(hStack_t);

dcl-c cERROR_STACK_HANDLE_NULL 'Stack handle is NULL';
dcl-c cERROR_STACK_HANDLE_INVALID 'Stack handle is invalid';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=========================================================================
//  Creates a new BasicStack.
//=========================================================================
//  Parameters:
//   i_increment   - The number of empty elements that are added to the
//                   stack when the stack needs to be resized.
//
//  Returns:
//   pStack        - Returns the basing pointer of the stack on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicStack_new export;
  dcl-pi *n like(BasicStack_handle_t);
    i_increment uns(10) options(*nopass: *omit) const;
    i_heapID    uns(10) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-s pStack like(BasicStack_handle_t) inz;

  //  Parameter positions
  dcl-c p_increment 1;
  dcl-c p_heapID 2;

  //  Fields for optional parameters
  dcl-s increment like(i_increment) inz;
  dcl-s heapID like(i_heapID) inz;

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  // Get values of optional parameters
  // i_increment
  if (%parms() >= p_increment and %addr(i_increment) <> *NULL);
    increment = i_increment;
  else;
    increment = 256;
  endif;

  // ... i_heapID
  if (%parms() >= p_heapID and %addr(i_heapID) <> *NULL);
    heapID = i_heapID;
  else;
    heapID = 0;
  endif;

  // Set memory manager
  mm_memMgr = MemoryManager_getDefaultManager();

  // Allocate memory for stack handle
  pStack = mm_allocate(%size(hStack_t): heapID);

  // Initialize stack handle
  clear hStack;
  hStack.intType = cHANDLE_TYPE_STACK;
  hStack.intSize = %size(hStack);
  hStack.pList   = BasicList_new('*BASICSTACK': increment);
  hStack.heapID  = heapID;
  hStack.memMgr  = mm_memMgr;

  return pStack;


end-proc;

//=========================================================================
//  Clones a given BasicStack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   pStack        - Returns the basing pointer of the cloned stack on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicStack_clone export;
  dcl-pi *n like(BasicStack_handle_t);
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s pStackRtn like(BasicStack_handle_t) inz;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  p_assert(cFalse
           : 'Procedure not yet implemented');

  return pStackRtn;


end-proc;

//=========================================================================
//  Gets the last entry from top of the stack without removing it from stack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//   i_pEntry      - Optional. Address where to copy the entry data to.
//   i_length      - Optional. The maximum size of the entry data.
//
//  Returns:
//   pEntry        - Returns a pointer to the entry data on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicStack_peek export;
  dcl-pi *n pointer;
    i_pStack like(BasicStack_handle_t) const;
    i_pEntry pointer options(*nopass) const;
    i_length int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s pElemData pointer inz;

  //  Parameter positions
  dcl-c p_pEntry 2;
  dcl-c p_length 3;

  //  Fields for optional parameters
  dcl-s pEntry like(i_pEntry) inz;
  dcl-s length like(i_length) inz;

  //  Local fields
  dcl-s numElements int(10) inz;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  p_assert(%parms() <> p_pEntry
           : 'Invalid number of arguments: i_length is missing');

  // Get element from underlaying BasicList
  numElements = BasicList_getNumE(hStack.pList);
  if numElements <> -1;
    if %parms() >= p_length;
      pElemData = BasicList_get(hStack.pList: numElements
                                : i_pEntry: i_length);
    else;
      pElemData = BasicList_get(hStack.pList: numElements);
    endif;
  else;
    pElemData = *NULL;
  endif;

  return pElemData;


end-proc;

//=========================================================================
//  Removes the lement at the top of the stack and returnns that element.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//   i_pEntry      - Address where to copy the entry data to.
//   i_length      - The maximum size of the entry data.
//
//  Returns:
//   pEntry        - Returns a pointer to the entry data on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicStack_pop export;
  dcl-pi *n pointer;
    i_pStack like(BasicStack_handle_t) const;
    i_pEntry pointer const;
    i_length int(10) const;
  end-pi;

  //  Return value
  dcl-s pElemData pointer inz;

  //  Local fields
  dcl-s numElements int(10) inz;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Get element from underlaying BasicList
  numElements = BasicList_getNumE(hStack.pList);
  if numElements <> -1;
    pElemData = BasicList_get(
                     hStack.pList: numElements: i_pEntry: i_length);
    BasicList_remove(hStack.pList: numElements);
  else;
    pElemData = *NULL;
  endif;

  return pElemData;


end-proc;

//=========================================================================
//  Pushes an item onto the top of the stack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//   i_pEntry      - The entry to be added to this stack.
//   i_length      - Optional. The size of the entry data.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicStack_push export;
  dcl-pi *n int(10);
    i_pStack like(BasicStack_handle_t) const;
    i_pEntry pointer options(*string) const;
    i_length int(10) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s index int(10) inz(-1);

  //  Parameter positions
  dcl-c p_length 3;

  //  Fields for optional parameters
  dcl-s length like(i_length) inz;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Get length of entry data
  if %parms() >= p_length;
    length = i_length;
  else;
    length = strlen(i_pEntry);
  endif;

  // Add entry to underlaying BasicList
  index = BasicList_add(hStack.pList: i_pEntry: length);

  return index;


end-proc;

//=========================================================================
//  Returns the size of of the element that is on top of this stack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   size          - Returns the size of the element on success, else -1.
//=========================================================================
dcl-proc BasicStack_getSize export;
  dcl-pi *n int(10);
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s size int(10) inz(-1);

  //  Local fields
  dcl-s numElements int(10) inz;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Get index of last element of this stack
  numElements = BasicList_getNumE(hStack.pList);

  // Get size of that element
  if numElements <> -1;
    size = BasicList_getSize(hStack.pList: numElements);
  endif;

  return size;


end-proc;

//=========================================================================
//  Returns the number of elements in this stack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   size          - Returns the number of elements in this list on
//                   success, else -1.
//=========================================================================
dcl-proc BasicStack_getNumE export;
  dcl-pi *n int(10);
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s numE int(10) inz(-1);

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Return number of elements of underlaying list
  numE = BasicList_getNumE(hStack.pList);

  return numE;


end-proc;

//=========================================================================
//  Returns the heap ID of a given BasicStack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   heapID        - ID of the heap this BasicStack belongs to.
//=========================================================================
dcl-proc BasicStack_getHeapID export;
  dcl-pi *n int(10);
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s heapID int(10) inz(-1);

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Return the heap ID of underlaying list
  heapID = BasicList_getHeapID(hStack.pList);

  return heapID;


end-proc;

//=========================================================================
//  Removes all entries from a given stack.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicStack_clear export;
  dcl-pi *n int(10);
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(i_pStack);

  // Clear underlaying BasicList
  rc = BasicList_clear(hStack.pList);

  return rc;


end-proc;

//=========================================================================
//  Deletes a given BasicStack.
//=========================================================================
//  Parameters:
//   io_pStack     - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicStack_delete export;
  dcl-pi *n int(10);
    io_pStack like(BasicStack_handle_t);
  end-pi;

  //  Return value
  dcl-s rc int(10) inz(-1);

  //  Memory Manager
/copy QBASICS1,MEMMGR

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(io_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  checkStackHandle(io_pStack);

  // Set memory manager
  mm_memMgr = hStack.memMgr;

  // Delete underlaying BasicList.
  rc = BasicList_delete(hStack.pList);

  // Clear stack handle
  clear hStack;
  hStack.intType = 0;
  hStack.intSize = 0;
  hStack.pList   = BasicList_null();
  hStack.heapID  = 0;
  clear hStack.memMgr;

  // Free memory of map handle
  mm_free(io_pStack);

  io_pStack = BasicStack_null();

  return rc;


end-proc;

//=========================================================================
//  Returns a BasicStack NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pStack        - NULL handle of a BasicStack.
//=========================================================================
dcl-proc BasicStack_null export;
  dcl-pi *n like(BasicStack_handle_t);
  end-pi;

  //  Return value
  dcl-s pStack like(BasicStack_handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  pStack = *NULL;

  return pStack;


end-proc;

//=========================================================================
//  Checks a given BasicStack handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_pStack      - Basing pointer of the stack returned by BasicStack_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle is null, else FALSE.
//=========================================================================
dcl-proc BasicStack_isNull export;
  dcl-pi *n ind;
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(cTrue);

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (i_pStack = BasicStack_null());
    isNull = cTrue;
  else;
    isNull = cFalse;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  *** private ***
//  Checks, whether a given handle is a valid stack handle, or not.
//  Returns TRUE for a valid stack handle, else FALSE.
//=========================================================================
dcl-proc checkStackHandle;
  dcl-pi *n;
    i_pStack like(BasicStack_handle_t) const;
  end-pi;

  //  Stack handle
  dcl-ds hStack likeds(hStack_t) based(i_pStack);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (BasicStack_isNull(i_pStack));
    signalError(cERROR_STACK_HANDLE_NULL: f_caller());
  endif;

  if (hStack.intType <> cHANDLE_TYPE_STACK);
    signalError(cERROR_STACK_HANDLE_INVALID: f_caller());
  endif;

  if (hStack.intSize <> cHANDLE_SIZE);
    signalError(cERROR_STACK_HANDLE_INVALID: f_caller());
  endif;

  return;


end-proc;

//=========================================================================
//  *** private ***
//  Sends an ESCAPE message to signal an error condition.
//=========================================================================
dcl-proc signalError;
  dcl-pi *n;
    i_text varchar(128) const;
    i_proc varchar(256) const;
  end-pi;

  //  Helper fields
  dcl-ds msg likeds(msg_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  msg = f_newMsg('CPF9898'
                 : 'BasicStack: ERROR - ' + i_text
                 : cMsg_Escape: 'QCPFMSG': '*LIBL');
  f_sndPgmMsg(msg: cMsg_Same: i_proc);

  return;


end-proc;