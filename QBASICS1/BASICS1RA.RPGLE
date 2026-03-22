**FREE
//=====================================================================*
//  BASICS1RA  - SrvPgm: Basic Routines - BasicList                    *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  18.05.2004                                              *
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
//  24.08.2006  Th.Raddatz    Changed BasicList_get() to initialize    *
//                            only that bytes of the return buffer     *
//                            that are beyond the length of the list   *
//                            entry.                                   *
//                                                                     *
//  24.04.2008  Th.Raddatz    Enabled BasicList to store NULL data.    *
//                            Fixed problem that sortList() did not    *
//                            return cTrue after having sorted the     *
//                            list.                                    *
//                            Renamed findEntryByDataPointer() to      *
//                            findEntryBySignature() in order to       *
//                            support NULL list entries.               *
//                            Added procedures:                        *
//                               BasicList_isSorted()                  *
//                               BasicList_isNullValue()               *
//                                                                     *
//  28.04.2008  Th.Raddatz    Check type of list handle and send an    *
//                            ESCAPE message for invalid handles.      *
//                                                                     *
//  27.05.2008  Th.Raddatz    Added procedure:                         *
//                               BasicList_clone()                     *
//                                                                     *
//  23.03.2012  Th.Raddatz    Added error message 'Failed to allocate  *
//                            memory' which is sent when the program   *
//                            could not allocate/reallocate memory.    *
//                                                                     *
//  23.03.2012  Th.Raddatz    Changed 'signature_t' to use an epoch    *
//                            time instead of a RPG timestamp value.   *
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
ctl-opt NOMAIN;
ctl-opt BNDDIR('QC2LE');
//  Standard H-Specs
/COPY QBASICS1,H_SPEC
/COPY QBASICS1,COPYRIGHT
//=====================================================================*

// -----------------------------------------
//  Exported functions
// -----------------------------------------
/COPY QBASICS1,PBASICS1RA

// -----------------------------------------
//  Reference fields
// -----------------------------------------
/COPY QBASICS1,BASICS1R0

dcl-ds hList_t qualified   based(pDummy)   align;
  intType         uns(20);
  intSize         uns(10);
  extType         like(BasicList_type_t  );
  memSize         uns(10);
  numE            uns(10);
  maxNumE         uns(10);
  totalMemSize    uns(10);
  increment       uns(10);
/IF NOT DEFINED(*V5R2M0)
  signature       like(signature_t);
  sortSignature   like(signature_t);
/ELSE
  signature       likeds(signature_t);
  sortSignature   likeds(signature_t);
/ENDIF
  heapID          int(10);
  pBase           pointer;
  pAutoSortFnc    pointer(*proc);
  memMgr          likeds(MemoryManager_manager_t);
end-ds;

dcl-ds listE_t qualified   based(pDummy)   align;
  type            like(BasicList_type_t  );
  size            uns(10);
  maxSize         uns(10);
/IF NOT DEFINED(*V5R2M0)
  signature       like(signature_t);
/ELSE
  signature       likeds(signature_t);
/ENDIF
  pData           pointer;
end-ds;

//signature_t     DS                  qualified   based(pDummy)   align
// tmStmp                         Z
// counter                      10U 0

dcl-ds signature_t qualified   based(pDummy)   align;
  time            uns(10);
  millitm         uns(10);
  counter         uns(10);
end-ds;

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Produces a new list entry.
dcl-pr newEntry
       int(10)
       extproc('newEntry');
  io_hList        likeds(hList_t   );
i_type          const  like(BasicList_type_t  );
end-pr;

//  Returns a pointer to the basing pointer of the
//  liste entry.
dcl-pr getPointerArrayE
       pointer
       extproc('getPointerArrayE');
  i_hList         const  likeds(hList_t   );
i_index         int(10) const;
end-pr;

//  Returns a pointer to the element at the specified
//  position in this list.
dcl-pr getPointerListE
       pointer
       extproc('getPointerListE');
  i_hList         const  likeds(hList_t   );
i_index         int(10) const;
end-pr;

//  Frees the memory of a given element in this list.
dcl-pr freeEntryData
       extproc('freeEntryData');
  io_hList        likeds(hList_t   );
io_listE        likeds(listE_t   );
end-pr;

//  Returns TRUE if a given list contains no data.
dcl-pr entryData_isNULL
       ind
       extproc('entryData_isNULL');
  i_listE         const  likeds(listE_t   );
end-pr;

//  Create a very basic list handle.
dcl-pr newListInternal
       pointer
       extproc('newListInternal');
  i_extType       const  like(BasicList_type_t  );
  i_increment     int(10) const;
  i_heapID        int(10) const;
  i_memMgr        const  likeds(MemoryManager...
_manager_t);
end-pr;

//  Set the entry data.
dcl-pr setEntryData
       int(10)
       extproc('setEntryData');
  io_hList        likeds(hList_t  );
i_index         int(10) const;
i_pEntry        pointer const;
i_length        int(10) const;
end-pr;

//  Checks the range of the list index.
dcl-pr isIndexOutOfRange
       ind
       extproc('isIndexOutOfRange');
  i_hList         const  likeds(hList_t  );
i_index         int(10) const;
end-pr;

//  Sorts a given list.
dcl-pr qsortCallback
       int(10)
       extproc('qsortCallback');
  i_pKey          pointer value;
  i_pElement      pointer value;
end-pr;

//  Sorts the list if it is required and if an auto-sort procedure
//  has been specified.
dcl-pr performAutoSort
       ind
       extproc('performAutoSort');
  io_hList        likeds(hList_t  );
end-pr;

//  Sorts the list.
dcl-pr sortList
       ind
       extproc('sortList');
  io_hList        likeds(hList_t  );
i_pSortFnc      pointer(*proc) const;
end-pr;

//  Returns cTrue for a sorted list, else cFalse.                                       R
dcl-pr isSortedInternally
       ind
       extproc('isSortedInternally');
  i_hList         const  likeds(hList_t  );
end-pr;

//  Searches the list for an entry that matches the specified data pointer
dcl-pr findEntryBySignature
       int(10)
       extproc('+
       findEntryBySignature');
  i_hList         const  likeds(hList_t    );
i_signature     const  likeds(signature_t);
end-pr;

//  Returns a new list signature.
dcl-pr Signature_new
       likeds(signature_t )
extproc('Signature_new');
end-pr;

//  Checks, whether a given handle is a valid list handle, or not.
dcl-pr checkListHandle
       extproc('checkListHandle');
  i_pList         const  like(BasicList_handle_t);
end-pr;

//  Sends a DIAG message to signal a problem.
dcl-pr signalProblem
       extproc('signalProblem');
  i_text          varchar(128) const;
  i_proc          varchar(256) const;
end-pr;

//  Sends an ESCAPE message to signal an error condition.
dcl-pr signalError
       extproc('signalError');
  i_text          varchar(128) const;
  i_proc          varchar(256) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cHANDLE_TYPE_LIST
      const(6688841203191988545);                                        // =  *List
dcl-c cHANDLE_SIZE
      const(%size(hList_t));

dcl-c cERROR_LIST_HANDLE_NULL
      const('List handle is NULL');
dcl-c cERROR_LIST_HANDLE_INVALID
      const('List handle is invalid');
dcl-c cERROR_NO_MEMORY
      const('Failed to allocate/+
       reallocate memory');
dcl-c cPROBLEM_LIST_FULL
      const('Maximum number of +
       list items reached');

// -----------------------------------------
//  Global fields
// -----------------------------------------
dcl-s g_pSortFnc      pointer(*proc) inz;

//  Prototype of the external sort function. A procedure pointer
//  of a function that matches this prototype must be passed to
//  BasicList_sort().
//
//     Return Value          Meaning
//     ---------------       -------------------------
//     Less than 0           key less than element
//     0                     key equal to element
//     Greater than 0        key greater than element

dcl-pr sortFnc
       int(10)
       extproc(g_pSortFnc);
  i_pKeyData      pointer value;
  i_keySize       int(10) value;
  i_pElemData     pointer value;
  i_elemSize      int(10) value;
end-pr;

//=========================================================================
//  Creates a new BasicList.
//=========================================================================
//  Parameters:
//   i_extType     - The type of the list.
//   i_increment   - The number of empty elements that are added to the
//                   list when the list needs to be resized.
//   i_memMgr      - The memory manager to use.
//
//  Returns:
//   pList         - Returns the basing pointer of the list on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicList_new export;

dcl-pi BasicList_new
       like(BasicList_handle_t);
  i_extType       const  like(BasicList_type_t  )
       options(*nopass: *omit);
  i_increment     uns(10) const  options(*nopass: *omit);
  i_heapID        int(10) const  options(*nopass: *omit);
end-pi;

//  Return value
dcl-s pList           like(BasicList_handle_t) inz;

//  Parameter positions
dcl-c p_extType const(1);
dcl-c p_increment const(2);
dcl-c p_heapID const(3);

//  Fields for optional parameters
dcl-s extType         like(i_extType   ) inz;
dcl-s increment       like(i_increment ) inz;
dcl-s heapID          like(i_heapID    ) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Memory Manager
/COPY QBASICS1,MEMMGR

//  Helper fields
dcl-s isPresent       int(10) inz;

//  House keeping:
//     List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get values of optional parameters
// ... i_extType
if %parms() >= p_extType;
   CEETSTA(isPresent: p_extType: *omit);
else;
   isPresent = 0;
endif;

if isPresent = 1;
   extType = i_extType;
else;
   extType = '';
endif;

// ... i_increment
if %parms() >= p_increment;
   CEETSTA(isPresent: p_increment: *omit);
else;
   isPresent = 0;
endif;

if isPresent = 1;
   increment = i_increment;
else;
   increment = 256;
endif;

// ... i_heapID
if %parms() >= p_heapID;
   CEETSTA(isPresent: p_heapID: *omit);
else;
   isPresent = 0;
endif;

if isPresent = 1;
   heapID = i_heapID;
else;
   heapID = 0;
endif;

// Set memory manager
mm_memMgr = MemoryManager_getDefaultManager();

// Initialize house keeping fields
pHList = *NULL;

// Do until everything is done or an error occured
dou isDone or isError;

   // Create a very basic list
   pHList = newListInternal(extType: increment: heapID: mm_memMgr);

   // Ready
   isDone = cTrue;
enddo;

// Error!
if isError;
   // Free memory of list handle
   if pHList <> *NULL;
      mm_free(pHList);
      pHList = *NULL;
   endif;
endif;

// Set return value
if isDone;
   pList = pHList;
else;
   pList = BasicList_null();
endif;

return pList;


end-proc BasicList_new;

//=========================================================================
//  Clones a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   pList         - Returns the basing pointer of the cloned list on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicList_clone export;

dcl-pi BasicList_clone
       like(BasicList_handle_t);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s pListRtn        like(BasicList_handle_t) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s x               int(10) inz;
dcl-s numE            int(10) inz;
dcl-s size            int(10) inz;
dcl-s pData           pointer inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);

//  House keeping:
//     List handle
dcl-s pTmpList        like(BasicList_handle_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

pListRtn = BasicList_null();

// Initialize house keeping fields
pTmpList = BasicList_null();

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = i_pList;

   // Create a new and empty list
   pTmpList = BasicList_new(hList.extType: hList.increment);
   if (BasicList_isNull(pTmpList));
      isError = cTrue;
      leave;
   endif;

   // Copy list entries
   numE = BasicList_getNumE(i_pList);
   for x = 1 to numE;
      if (BasicList_isNullValue(i_pList: x));
         BasicList_addNull(pTmpList);
      else;
         size  = BasicList_getSize(i_pList: x);
         pData = BasicList_get(i_pList: x);
         BasicList_add(pTmpList: pData: size);
      endif;
   endfor;

   // Set return value
   pListRtn = pTmpList;
   pTmpList = BasicList_null();

   // Done.
   isDone = cTrue;
enddo;

// House keeping ...
// ... pTmpList
if (not BasicList_isNull(pTmpList));
   BasicList_delete(pTmpList);
endif;

return pListRtn;


end-proc BasicList_clone;

//=========================================================================
//  Returns a given element.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//   i_pEntry      - Address where to copy the entry data to.
//                   If this parameter is not passed, the address
//                   of the list entry data is returned. Hence
//                   you gain direct access to the list entry data!
//   i_length      - The maximum size of the entry data.
//
//  Returns:
//   pEntry        - Returns a pointer to the entry data on
//                   success, else NULL.
//=========================================================================
dcl-proc BasicList_get export;

dcl-pi BasicList_get
       pointer;
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pEntry        pointer const  options(*nopass);
  i_length        int(10) const  options(*nopass);
end-pi;

//  Return value
dcl-s pElemData       pointer inz;

//  Parameter positions
dcl-c p_pEntry const(3);
dcl-c p_length const(4);

//  Fields for optional parameters
dcl-s pEntry          like(i_pEntry     ) inz;
dcl-s length          like(i_length     ) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s maxSize         int(10) inz;
dcl-s numRemBytes     int(10) inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);

//  List entry
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get values of optional parameters
// ... pEntry
p_assert(%parms() <> p_pEntry
         : 'length must be specified if pEntry is passed');

// ... length
if %parms() >= p_length;
   pEntry = i_pEntry;
   length = i_length;
else;
   pEntry = *NULL;
   length = 0;
endif;

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = i_pList;

   // Verify range of i_index
   if isIndexOutOfRange(hList: i_index);
      isError = cTrue;
      leave;
   endif;

   // Get access to entry data
   pListE = getPointerListE(hList: i_index);

   // Determine number of bytes to copy
   if length < listE.size;
      maxSize = length;
   else;
      maxSize = listE.size;
   endif;

   // Initialize return buffer (remaining bytes only)
   numRemBytes = length - listE.size;
   if numRemBytes > 0;
      memset((pEntry + listE.size): x'00': numRemBytes);
   endif;

   // Copy entry data
   if maxSize > 0;
      memcpy(pEntry: listE.pData: maxSize);
      pElemData = pEntry;
   else;
      pElemData = listE.pData;
   endif;

   // Done.
   isDone = cTrue;
enddo;

return pElemData;


end-proc BasicList_get;

//=========================================================================
//  Returns a given string.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   string        - Returns a string on success, else ''.
//=========================================================================
dcl-proc BasicList_getString export;

dcl-pi BasicList_getString
       varchar(4096);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s string          varchar(4096) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BasicList_get(i_pList: i_index: %addr(string): %size(string));

return string;


end-proc BasicList_getString;

//=========================================================================
//  Returns a the pointer element from the specified position.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   pointer       - Returns a pointer on success, else *NULL.
//=========================================================================
dcl-proc BasicList_getPointer export;

dcl-pi BasicList_getPointer
       pointer;
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s pointer         pointer inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

BasicList_get(i_pList: i_index: %addr(pointer): %size(pointer));

return pointer;


end-proc BasicList_getPointer;

//=========================================================================
//  Returns the external type of the list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   type          - Returns the list type on success, else '';
//=========================================================================
dcl-proc BasicList_getListType export;

dcl-pi BasicList_getListType
       like(BasicList_type_t  );
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s type            like(BasicList_type_t  ) inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

type = hList.extType;

return type;


end-proc BasicList_getListType;

//=========================================================================
//  Checks the list for a given external type.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_type        - The type of the list.
//
//  Returns:
//   isOfType      - Returns TRUE if the list matches the specified type,
//                   else, FALSE.
//=========================================================================
dcl-proc BasicList_isListTypeOf export;

dcl-pi BasicList_isListTypeOf
       ind;
  i_pList         const  like(BasicList_handle_t);
  i_type          const  like(BasicList_type_t  );
end-pi;

//  Return value
dcl-s isValid         ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

if i_type = hList.extType;
   isValid  = cTrue;
else;
   isValid  = cFalse;
endif;

return isValid;


end-proc BasicList_isListTypeOf;

//=========================================================================
//  Checks an list entry for a given type.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//   i_type        - The type of the list.
//
//  Returns:
//   isOfType      - Returns TRUE if the list matches the specified type,
//                   else, FALSE.
//=========================================================================
dcl-proc BasicList_isTypeOf export;

dcl-pi BasicList_isTypeOf
       ind;
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_type          const  like(BasicList_type_t  );
end-pi;

//  Return value
dcl-s isValid         ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

// Verify range of i_index
if isIndexOutOfRange(hList: i_index);
   isValid = cFalse;
   return isValid;
endif;

// Get access to entry data
pListE = getPointerListE(hList: i_index);

// Verify entry type
if listE.type = i_type;
   isvalid = cTrue;
else;
   isvalid = cFalse;
endif;

return isValid;


end-proc BasicList_isTypeOf;

//=========================================================================
//  Returns the type of the specified list entry.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   type          - Returns the type on success, else ''.
//=========================================================================
dcl-proc BasicList_getType export;

dcl-pi BasicList_getType
       like(BasicList_type_t  );
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s type            like(BasicList_type_t  ) inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

// Verify range of i_index
if isIndexOutOfRange(hList: i_index);
   type = '';
   return type;
endif;

// Get access to entry data
pListE = getPointerListE(hList: i_index);

// Return entry type
type = listE.type;

return type;


end-proc BasicList_getType;

//=========================================================================
//  Returns the size of of an element.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   size          - Returns the size of the element on success, else -1.
//=========================================================================
dcl-proc BasicList_getSize export;

dcl-pi BasicList_getSize
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s size            int(10) inz(-1);

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);

//  List entry
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = i_pList;

   // Verify range of i_index
   if isIndexOutOfRange(hList: i_index);
      isError = cTrue;
      leave;
   endif;

   // Get access to entry data
   pListE = getPointerListE(hList: i_index);

   // Ready
   isDone = cTrue;
enddo;

// Set return value
if isDone;
   size = listE.size;
else;
   size = -1;
endif;

return size;


end-proc BasicList_getSize;

//=========================================================================
//  Adds a element to a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_pEntry      - The entry to be added to this list.
//   i_length      - Optional. The size of the entry data.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_add export;

dcl-pi BasicList_add
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass: *omit);
  i_type          const  like(BasicList_type_t  )
       options(*nopass: *omit);
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Parameter positions
dcl-c p_length const(3);
dcl-c p_type const(4);

//  Fields for optional parameters
dcl-s length          like(i_length     ) inz;
dcl-s type            like(i_type       ) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s isPresent       int(10) inz;
dcl-s x               uns(10) inz;
dcl-s pEntryData      pointer inz;
dcl-ds prvListSortSignature
       likeds(signature_t) inz;
dcl-ds entrySignature likeds(signature_t) inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get length of entry data
   if %parms() >= p_length;
      CEETSTA(isPresent: p_length: *omit);
   else;
      isPresent = 0;
   endif;

   if isPresent = 1;
      length = i_length;
   else;
      if i_pEntry = *NULL;
         length = 0;
      else;
         length = strlen(i_pEntry);
      endif;
   endif;

   // Get type of entry data
   if %parms() >= p_type;
      CEETSTA(isPresent: p_type: *omit);
   else;
      isPresent = 0;
   endif;

   if isPresent = 1;
      type = i_type;
   else;
      type = cBASICLIST_TYPE_UNKNOWN;
   endif;

   // Get access to list handle
   pHList = i_pList;

   // Produce new entry
   x = newEntry(hList: type);
   if x = 0;
      isError = cTrue;
      leave;
   endif;

   // Get access to entry data
   pListE = getPointerListE(hList: x);

   // Set entry data
   setEntryData(hList: x: i_pEntry: length);

   // Save pointer to entry signature
   entrySignature = listE.signature;

   // Sort list, if required
   prvListSortSignature = hList.sortSignature;
   performAutoSort(hList);

   // Find entry using its signature if the list
   // had been sorted.
   if (prvListSortSignature <> hList.sortSignature);
      x = findEntryBySignature(hList: entrySignature);
   endif;

   // Ready
   isDone = cTrue;
enddo;

// Set return value
if isDone;
   index = x;
else;
   index = -1;
endif;

return index;


end-proc BasicList_add;

//=========================================================================
//  Adds a string to a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_string      - The string to be added to this list.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_addString export;

dcl-pi BasicList_addString
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_string        varchar(4096) const;
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Helper fields
dcl-s string          like(i_string) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = i_string;

index = BasicList_add(i_pList: %addr(string)
                             : %len(i_string) + 2
                             : cBASICLIST_TYPE_VSTRING);

return index;


end-proc BasicList_addString;

//=========================================================================
//  Adds a pointer to a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_pointer     - The pointer to be added to this list.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_addPointer export;

dcl-pi BasicList_addPointer
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_pointer       pointer const;
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Helper fields
dcl-s pointer         like(i_pointer) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pointer = i_pointer;

index = BasicList_add(i_pList: %addr(pointer)
                             : %size(pointer)
                             : cBASICLIST_TYPE_POINTER);

return index;


end-proc BasicList_addPointer;

//=========================================================================
//  Adds a NULL value to a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_addNull export;

dcl-pi BasicList_addNull
       int(10);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

index = BasicList_add(i_pList: *NULL);

return index;


end-proc BasicList_addNull;

//=========================================================================
//  Searches the list for a given element.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_pEntry      - The entry to be added to this list.
//   i_length      - Optional. The size of the entry data.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_find export;

dcl-pi BasicList_find
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass);
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Parameter positions
dcl-c p_length const(3);

//  Fields for optional parameters
dcl-s length          like(i_length     ) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s ignoreCase      ind inz(cFalse);
dcl-s x               uns(10) inz;
dcl-s rc              int(10) inz;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get length of entry data
   if %parms() >= p_length;
      length = i_length;
   else;
      length = strlen(i_pEntry);
   endif;

   // Get access to list handle
   pHList = i_pList;

   // Spin through entries in list searching for the request element
   for x = 1 to hList.numE;

      // Get access to entry data
      pListE = getPointerListE(hList: x);

      // Compare entry attributes
      if (length = listE.size);
         if ignoreCase;
            rc = memicmp(i_pEntry: listE.pData: length);
         else;
            rc = memcmp(i_pEntry: listE.pData: length);
         endif;
      else;
         rc = -1;
      endif;

      if rc = 0;
         index = x;
         leave;
      endif;

   endfor;

   // Ready
   isDone = cTrue;
enddo;

return index;


end-proc BasicList_find;

//=========================================================================
//  Searches the list for a given string.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_string      - The string to be added to this list.
//
//  Returns:
//   index         - Returns the index of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_findString export;

dcl-pi BasicList_findString
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_string        varchar(4096) const;
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s x               uns(10) inz;
dcl-s string          like(i_string) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = i_string;

index = BasicList_find(i_pList: %addr(string): %len(i_string) + 2);

return index;


end-proc BasicList_findString;

//=========================================================================
//  Changes the element at the specified position in this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//   i_pEntry      - The entry to be added to this list.
//   i_length      - Optional. The size of the entry data.
//
//  Returns:
//   length        - Returns the length of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_set export;

dcl-pi BasicList_set
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass: *omit);
  i_type          const  like(BasicList_type_t  )
       options(*nopass: *omit);
end-pi;

//  Return value
dcl-s newLength       int(10) inz(-1);

//  Parameter positions
dcl-c p_length const(4);
dcl-c p_type const(5);

//  Fields for optional parameters
dcl-s length          like(i_length     ) inz;
dcl-s type            like(i_type       ) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s isPresent       int(10) inz;

//  Handle Data
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get length of entry data
   if %parms() >= p_length;
      CEETSTA(isPresent: p_length: *omit);
   else;
      isPresent = 0;
   endif;

   if isPresent = 1;
      length = i_length;
   else;
      if i_pEntry = *NULL;
         length = 0;
      else;
         length = strlen(i_pEntry);
      endif;
   endif;

   // Get type of entry data
   if %parms() >= p_type;
      CEETSTA(isPresent: p_type: *omit);
   else;
      isPresent = 0;
   endif;

   if isPresent = 1;
      type = i_type;
   else;
      type = cBASICLIST_TYPE_UNKNOWN;
   endif;

   // Get access to list handle
   pHList = i_pList;

   // Set entry data
   newLength = setEntryData(hList: i_index: i_pEntry: length);

   // Sort list, if required
   performAutoSort(hList);

   // Ready
   isDone = cTrue;
enddo;

return newLength;


end-proc BasicList_set;

//=========================================================================
//  Changes the element at the specified position to NULL.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   length        - Returns the length (always 0) of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_setNull export;

dcl-pi BasicList_setNull
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s newLength       int(10) inz(-1);

//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

newLength = BasicList_set(i_pList: i_index: *NULL);

return newLength;


end-proc BasicList_setNull;

//=========================================================================
//  Changes the string at the specified position in this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//   i_string      - The string that is changed.
//
//  Returns:
//   length        - Returns the length of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_setString export;

dcl-pi BasicList_setString
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_string        varchar(4096) const;
end-pi;

//  Return value
dcl-s newLength       int(10) inz(-1);

//  Helper fields
dcl-s string          like(i_string) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

string = i_string;

newLength = BasicList_set(i_pList: i_index
                                 : %addr(string)
                                 : %len(i_string) + 2
                                 : cBASICLIST_TYPE_VSTRING);

return newLength;


end-proc BasicList_setString;

//=========================================================================
//  Changes the pointer at the specified position in this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//   i_pointer     - The pointer that is changed.
//
//  Returns:
//   length        - Returns the length of the element on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_setPointer export;

dcl-pi BasicList_setPointer
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
  i_pointer       pointer const;
end-pi;

//  Return value
dcl-s newLength       int(10) inz(-1);

//  Helper fields
dcl-s pointer         like(i_pointer) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pointer = i_pointer;

newLength = BasicList_set(i_pList: i_index
                                 : %addr(pointer)
                                 : %size(pointer)
                                 : cBASICLIST_TYPE_POINTER);

return newLength;


end-proc BasicList_setPointer;

//=========================================================================
//  Removes the element at the specified position in this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Index of a given list element.
//
//  Returns:
//   rc            - Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicList_remove export;

dcl-pi BasicList_remove
       int(10);
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s rc              int(10) inz(-1);

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s pTarget         pointer inz;
dcl-s pSource         pointer inz;
dcl-s size            uns(10) inz;
dcl-s curIndex        uns(10) inz;
dcl-s numDeletedE     uns(10) inz;

dcl-ds range qualified;
  from            uns(10) inz;
  to              uns(10) inz;
end-ds;

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);

//  List entry
dcl-ds listE likeds(listE_t    ) based(pListE);
dcl-s pListE          pointer based(ppListE);

//  Memory Manager
/COPY QBASICS1,MEMMGR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Set memory manager
mm_memMgr = MemoryManager_getDefaultManager();

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = i_pList;

   // Return to caller if there are no entries in this list
   if hList.numE = 0;
      isDone = cTrue;
      leave;
   endif;

   // Determine the range of elements to remove
   if i_index = cBASICLIST_REMOVE_ALL;
      range.from = 1;
      range.to   = hList.numE;
   else;
      range.from = i_index;
      range.to   = i_index;
   endif;

   // Remove all entries within the specified range:
   numDeletedE = 0;

   for curIndex = range.from to range.to;

      // Increment number of removed entries
      numDeletedE = numDeletedE + 1;

      // Get access to entry data
      ppListE = getPointerArrayE(hList: curIndex);

      // Free entry data:
      if (pListE <> *NULL);
         if not entryData_isNULL(listE);
            clear listE.signature;
            freeEntryData(hList: listE);
         endif;

         mm_free(pListE);
         ppListE = *NULL;

         hList.totalMemSize = hList.totalMemSize + %size(listE_t);
      endif;

   endfor;

   // If it was not the last entry that was removed
   // from the list, ...
   if range.to < hList.numE;

      // ... then shifts any subsequent elements to the left
      pTarget = getPointerArrayE(hList: range.from);
      pSource = getPointerArrayE(hList: range.to + 1);
      size    = (hList.numE - range.from) * %size(pDummy);
      memmove(pTarget: pSource: size);

   endif;

   // Compute number of elements remaining in this list
   hList.numE = hList.numE - numDeletedE;

   // Set new signature
   hList.signature = Signature_new();

   // Initialize freed memory
   pSource = getPointerArrayE(hList: hList.numE + 1);
   size    = numDeletedE * %size(pDummy);
   memset(pSource: x'00': size);

   // We just removed an element from the list.
   // Hence we do not need to sort the list again.
   hList.sortSignature = hList.signature;

   // Done.
   isDone = cTrue;
enddo;

// Set return value
if isDone;
   rc = 0;
else;
   rc = -1;
endif;

return rc;


end-proc BasicList_remove;

//=========================================================================
//  Returns the number of elements in this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   size          - Returns the number of elements in this list on
//                   success, else -1.
//=========================================================================
dcl-proc BasicList_getNumE export;

dcl-pi BasicList_getNumE
       int(10);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s numE            int(10) inz(-1);

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = i_pList;

   // Ready
   isDone = cTrue;
enddo;

// Set return value
if isDone;
   numE = hList.numE;
else;
   numE = -1;
endif;

return numE;


end-proc BasicList_getNumE;

//=========================================================================
//  Returns the heap ID of a given BasicList.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   heapID        - ID of the heap this BasicList belongs to.
//=========================================================================
dcl-proc BasicList_getHeapID export;

dcl-pi BasicList_getHeapID
       int(10);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s heapID          int(10) inz(-1);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

heapID = hList.heapID;

return heapID;


end-proc BasicList_getHeapID;

//=========================================================================
//  Sorts a list using the specified sort function.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_pSortFnc    - Procedure pointer of sort procedure.
//
//  Returns:
//   isSorted      - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc BasicList_sort export;

dcl-pi BasicList_sort
       ind;
  i_pList         const  like(BasicList_handle_t);
  i_pSortFnc      pointer(*proc) const;
end-pi;

//  Return value
dcl-s isSorted        ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

// Sort the list.
isSorted = sortList(hList: i_pSortFnc);

return isSorted;


end-proc BasicList_sort;

//=========================================================================
//  Returns cTrue if a given list is sorted.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   isSorted      - Returns TRUE if the list is sorted, else cFalse.
//=========================================================================
dcl-proc BasicList_isSorted export;

dcl-pi BasicList_isSorted
       ind;
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s isSorted        ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

return isSortedInternally(hList);


end-proc BasicList_isSorted;

//=========================================================================
//  Specifies an auto-sort function for this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_pSortFnc    - Procedure pointer of sort procedure.
//
//  Returns:
//   isSet         - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc BasicList_setAutoSort export;

dcl-pi BasicList_setAutoSort
       ind;
  i_pList         const  like(BasicList_handle_t);
  i_pSortFnc      pointer(*proc) const;
end-pi;

//  Return value
dcl-s isSet           ind inz(cFalse);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

// Set auto-sort procedure address
hList.pAutoSortFnc = i_pSortFnc;

// Sort list
if performAutoSort(hList);
   isSet = cTrue;
else;
   isSet = cFalse;
endif;

return isSet;


end-proc BasicList_setAutoSort;

//=========================================================================
//  Removes all entries from a given list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicList_clear export;

dcl-pi BasicList_clear
       int(10);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s rc              int(10) inz(-1);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Return to caller if there are no entries in this list
if BasicList_getNumE(i_pList) = 0;
   rc = 0;
else;
   // Remove all entries from the list
   rc = BasicList_remove(i_pList: cBASICLIST_REMOVE_ALL);
endif;

return rc;


end-proc BasicList_clear;

//=========================================================================
//  Returns the total size of memory used by this list.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   totalSize     - Returns the total size of memory used by the list.
//=========================================================================
dcl-proc BasicList_getTotalSize export;

dcl-pi BasicList_getTotalSize
       int(20);
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s totalSize       int(20) inz(-1);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(i_pList);

// Get access to list handle
pHList = i_pList;

// Set return value
totalSize = hList.totalMemSize;

return totalSize;


end-proc BasicList_getTotalSize;

//=========================================================================
//  Deletes a given BasicList.
//=========================================================================
//  Parameters:
//   io_pList      - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   rc              Returns 0 success, else -1.
//=========================================================================
dcl-proc BasicList_delete export;

dcl-pi BasicList_delete
       int(10);
  io_pList        like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s rc              int(10) inz(-1);

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Memory Manager
/COPY QBASICS1,MEMMGR

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

checkListHandle(io_pList);

// Do until everything is done or an error occured
dou isDone or isError;

   // Get access to list handle
   pHList = io_pList;

   // Set memory manager
   mm_memMgr = hList.memMgr;

   // Free all list entries
   dow hList.numE > 0;
      BasicList_remove(io_pList: hList.numE);
   enddo;

   p_assert(hList.numE = 0);

   // Free memory of list handle
   if hList.pBase <> *NULL;
      hList.totalMemSize = hList.totalMemSize - hList.memSize;
      mm_free(hList.pBase);
      hList.memSize = 0;
   endif;

   p_assert(hList.pBase = *NULL);

   // Clear handle data
   clear hList;
   hList.intType       = 0;
   hList.intSize       = 0;
   hList.extType       = *ALLx'00';
   hList.memSize       = 0;
   hList.numE          = 0;
   hList.maxNumE       = 0;
   hList.totalMemSize  = 0;
   hList.increment     = 0;
   hList.signature     = Signature_new();
   hList.sortSignature = hList.signature;
   hList.pBase         = *NULL;
   hList.pAutoSortFnc  = *NULL;

   // Free memory of list handle
   mm_free(pHList);

   // Ready
   isDone = cTrue;
enddo;

// Set return parameter value
if isDone;
   io_pList = BasicList_null();
endif;

// Set return value
if isDone;
   rc = 0;
else;
   rc = -1;
endif;

return rc;


end-proc BasicList_delete;

//=========================================================================
//  Returns a BasicList NULL handle.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pList         - NULL handle of a BasicList.
//=========================================================================
dcl-proc BasicList_null export;

dcl-pi BasicList_null
       like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s pList           like(BasicList_handle_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pList = *NULL;

return pList;


end-proc BasicList_null;

//=========================================================================
//  Checks a given BasicList handle for a NULL value.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle is null, else FALSE.
//=========================================================================
dcl-proc BasicList_isNull export;

dcl-pi BasicList_isNull
       ind;
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  Return value
dcl-s isNull          ind inz(cTrue);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_pList = BasicList_null();
   isNull = cTrue;
else;
   isNull = cFalse;
endif;

return isNull;


end-proc BasicList_isNull;

//=========================================================================
//  Checks a given BasicList entry for a NULL value.
//=========================================================================
//  Parameters:
//   i_pList       - Basing pointer of the list returned by BasicList_new().
//   i_index       - Position of the element.
//
//  Returns:
//   isNull        - Returns TRUE if the liste entry is null, else FALSE.
//=========================================================================
dcl-proc BasicList_isNullValue export;

dcl-pi BasicList_isNullValue
       ind;
  i_pList         const  like(BasicList_handle_t);
  i_index         int(10) const;
end-pi;

//  Return value
dcl-s isNull          ind inz(cTrue);

//  List handle
dcl-ds hList likeds(hList_t    ) based(pHList);

//  List entry
dcl-ds listE likeds(listE_t    ) based(pListE);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Get access to list handle
pHList = i_pList;

// Verify range of i_index
if isIndexOutOfRange(hList: i_index);
   p_assert(cFalse:
            'Index value (' + %char(i_index) + ') is out of range');
endif;

// Get access to entry data
pListE = getPointerListE(hList: i_index);

if (listE.pData = *NULL);
   isNull = cTrue;
else;
   isNull = cFalse;
endif;

return isNull;


end-proc BasicList_isNullValue;

//=========================================================================
//  *** private ***
//  Produces a new list entry.
//=========================================================================
dcl-proc newEntry;

dcl-pi newEntry
       int(10);
  i_hList         likeds(hList_t   );
i_type          const  like(BasicList_type_t  );
end-pi;

//  Return value
dcl-s index           int(10) inz;

//  Loop control
dcl-s isDone          ind inz(cFalse);
dcl-s isError         ind inz(cFalse);

//  Helper fields
dcl-s newMemSize      like(hList_t.memSize) inz;
dcl-ds listE likeds(listE_t      ) based(pListE);
dcl-s pListE          pointer based(ppListE);

//  Maximum size for a non-Teraspace malloc()
dcl-c MAX_MEM_SIZE 16711568;

//  Memory Manager
/COPY QBASICS1,MEMMGR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Do until everything is done or an error occured
dou isDone or isError;

   // Set memory manager
   mm_memMgr = i_hList.memMgr;

   // If the there are no more free entries in this list, ...
   if i_hList.maxNumE = i_hList.numE;

      // ... then check amout of used memory and
      if i_hList.memSize >= MAX_MEM_SIZE;
         signalError(cPROBLEM_LIST_FULL: f_caller());
         // signalProblem(cPROBLEM_LIST_FULL: f_caller());
         // signalProblem(
         //       '#list items: ' +
         //        %char(i_hList.maxNumE): f_caller());
         // signalProblem(
         //       '#total size of memory: ' +
         //        %char(i_hList.totalMemSize): f_caller());
         // return 0;
      endif;

      // ... (re)allocate additional memory
      newMemSize = i_hList.memSize +
                   (%size(pDummy) * i_hList.increment);

      if (newMemSize > MAX_MEM_SIZE);
         newMemSize =
               %div(MAX_MEM_SIZE: %size(pDummy)) * %size(pDummy);
      endif;

      if i_hList.pBase = *NULL;
         i_hList.pBase = mm_allocate(newMemSize: i_hList.heapID);
      else;
         i_hList.pBase = mm_reallocate(i_hList.pBase: newMemSize);
      endif;

      if i_hList.pBase = *NULL;
         signalError(cERROR_NO_MEMORY: f_caller());
      endif;

      i_hList.totalMemSize = i_hList.totalMemSize - i_hList.memSize;

      i_hList.memSize      = newMemSize;
      i_hList.maxNumE      = i_hList.memSize / %size(pDummy);

      i_hList.totalMemSize = i_hList.totalMemSize + i_hList.memSize;
   endif;

   // Increment number of entries in this list
   i_hList.numE = i_hList.numE + 1;

   // Set new signature
   i_hList.signature = Signature_new();

   // Create liste entry
   ppListE = getPointerArrayE(i_hList: i_hList.numE);
   pListE = mm_allocate(%size(listE_t): i_hList.heapID);

   i_hList.totalMemSize = i_hList.totalMemSize + %size(listE_t);

   // Initialize entry data
   clear listE;
   listE.type      = i_type;
   listE.pData     = *NULL;
   listE.size      = 0;
   listE.maxSize   = 0;
   listE.signature = Signature_new();

   // Ready
   isDone = cTrue;
enddo;

// Set return value
if isDone;
   index = i_hList.numE;
else;
   index = 0;
endif;

return index;


end-proc newEntry;

//=========================================================================
//  *** private ***
//  Returns a pointer to the basing pointer of the
//  liste entry.
//=========================================================================
dcl-proc getPointerArrayE;

dcl-pi getPointerArrayE
       pointer;
  i_hList         const  likeds(hList_t   );
i_index         int(10) const;
end-pi;

//  Return value
dcl-s ppListE         pointer inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Compute memory address of list entry
ppListE = i_hList.pBase + ((i_index-1) * %size(pDummy));

return ppListE;


end-proc getPointerArrayE;

//=========================================================================
//  *** private ***
//  Returns a pointer to the element at the specified
//  position in this list.
//=========================================================================
dcl-proc getPointerListE;

dcl-pi getPointerListE
       pointer;
  i_hList         const  likeds(hList_t   );
i_index         int(10) const;
end-pi;

//  Return value
dcl-s pListE          pointer based(ppListE);
dcl-s ppListE         pointer inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Compute memory address of list entry
ppListE = getPointerArrayE(i_hList: i_index);

return pListE;


end-proc getPointerListE;

//=========================================================================
//  *** private ***
//  Frees the memory of a given element in this list.
//=========================================================================
dcl-proc freeEntryData;

dcl-pi freeEntryData;
  i_hList         likeds(hList_t   );
io_listE        likeds(listE_t   );
end-pi;

//  Memory Manager
/COPY QBASICS1,MEMMGR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Do until everything is done or an error occured
dou '1';

   // Set memory manager
   mm_memMgr = i_hList.memMgr;

   // Keep track of the sized of memory used by the list
   i_hList.totalMemSize = i_hList.totalMemSize - io_listE.maxSize;

   // Initialize entry data
   if io_listE.size > 0;
      memset(io_listE.pData: x'00': io_listE.maxSize);
   endif;

   // Free memory of entry entry
   mm_free(io_listE.pData);
   io_listE.type    = '';
   io_listE.size    = 0;
   io_listE.maxSize = 0;

   i_hList.totalMemSize = i_hList.totalMemSize + io_listE.maxSize;
enddo;

return;


end-proc freeEntryData;

//=========================================================================
//  *** private ***
//  Returns TRUE if a given list contains no data.
//=========================================================================
dcl-proc entryData_isNULL;

dcl-pi entryData_isNULL
       ind;
  i_listE         const  likeds(listE_t   );
end-pi;

//  Return value
dcl-s isNULL          ind inz(cFalse);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (i_listE.size = 0) and (i_listE.pData = *NULL);
   isNULL = cTrue;
else;
   isNULL = cFalse;
endif;

return isNULL;


end-proc entryData_isNULL;

//=========================================================================
//  *** private ***
//  Create a very basic list handle.
//=========================================================================
dcl-proc newListInternal;

dcl-pi newListInternal
       pointer;
  i_extType       const  like(BasicList_type_t  );
  i_increment     int(10) const;
  i_heapID        int(10) const;
  i_memMgr        const  likeds(MemoryManager...
_manager_t);
end-pi;

//  Return value
dcl-ds hList likeds(hList_t    ) based(pHList);

//  Memory Manager
/COPY QBASICS1,MEMMGR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set memory manager
mm_memMgr = i_memMgr;

// Allocate memory for list handle
pHList = mm_allocate(%size(hList_t): i_heapID);

if pHList = *NULL;
   signalError(cERROR_NO_MEMORY: f_caller());
endif;

// Initialize list handle
clear hList;
hList.intType       = cHANDLE_TYPE_LIST;
hList.intSize       = %size(hList);
hList.extType       = i_extType;
hList.memSize       = 0;
hList.numE          = 0;
hList.maxNumE       = 0;
hList.totalMemSize  = 0;
hList.increment     = i_increment;
hList.signature     = Signature_new();
hList.sortSignature = hList.signature;
hList.pBase         = *NULL;
hList.pAutoSortFnc  = *NULL;
hList.memMgr        = i_memMgr;
hList.heapID        = i_heapID;

return pHList;


end-proc newListInternal;

//=========================================================================
//  *** private ***
//  Set the entry data.
//=========================================================================
dcl-proc setEntryData;

dcl-pi setEntryData
       int(10);
  io_hList        likeds(hList_t  );
i_index         int(10) const;
i_pEntry        pointer const;
i_length        int(10) const;
end-pi;

//  Return Value
dcl-s newLength       int(10) inz(-1);

//  Entry Data
dcl-ds listE likeds(listE_t    ) based(pListE);

//  Memory Manager
/COPY QBASICS1,MEMMGR
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set memory manager
mm_memMgr = io_hList.memMgr;

// Get access to entry data
pListE = getPointerListE(io_hList: i_index);

// If the lenth of the entry data exceeds the
// size of the allocated memory ...
if i_length > listE.maxSize;
   // ... (re)allocate memory buffer
   if listE.pData = *NULL;
      listE.pData = mm_allocate(i_length: io_hList.heapID);
   else;
      listE.pData = mm_reallocate(listE.pData: i_length);
   endif;

   if listE.pData = *NULL;
      signalError(cERROR_NO_MEMORY: f_caller());
   endif;

   io_hList.totalMemSize = io_hList.totalMemSize - listE.maxSize;

   listE.maxSize = i_length;

   io_hList.totalMemSize = io_hList.totalMemSize + listE.maxSize;
endif;

// If entry data is available ...
if i_length > 0;
   // ... then copy entry data to buffer
   memcpy(listE.pData: i_pEntry: i_length);
   // ... clear remaining data
   if i_length < listE.maxSize;
      memset(listE.pData + i_length: x'00': listE.maxSize - i_length);
   endif;
else;
   // ... else clear entry data
   memset(listE.pData: x'00': listE.maxSize);
endif;

// Set new signature
io_hList.signature = Signature_new();

// Save current length of entry data
listE.size = i_length;

// Free entry data if applicable:
if not entryData_isNULL(listE) and (listE.size = 0);
   freeEntryData(io_hList: listE);
endif;

newLength = listE.size;

return newLength;


end-proc setEntryData;

//=========================================================================
//  *** private ***
//  Checks the range of the list index.
//=========================================================================
dcl-proc isIndexOutOfRange;

dcl-pi isIndexOutOfRange
       ind;
  i_hList         const  likeds(hList_t  );
i_index         int(10) const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (i_index < 1) or (i_index > i_hList.numE);
   return cTrue;
else;
   return cFalse;
endif;


end-proc isIndexOutOfRange;

//=========================================================================
//  *** private ***
//  Sorts a given list.
//=========================================================================
dcl-proc qsortCallback;

dcl-pi qsortCallback
       int(10);
  i_pKey          pointer value;
  i_pElement      pointer value;
end-pi;

dcl-s pKey            pointer based(i_pKey);
dcl-s pElement        pointer based(i_pElement);

dcl-ds key likeds(listE_t) based(pKey    );
dcl-ds element likeds(listE_t) based(pElement);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return sortFnc(key.pData: key.size: element.pData: element.size);


end-proc qsortCallback;

//=========================================================================
//  *** private ***
//  Sorts the list if it is required and if an auto-sort procedure
//  has been specified.
//=========================================================================
dcl-proc performAutoSort;

dcl-pi performAutoSort
       ind;
  io_hList        likeds(hList_t  );
end-pi;

//  Parameter positions
dcl-c p_currentE const(2);

//  Return value
dcl-s isSorted        ind inz(cFalse);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if io_hList.pAutoSortFnc <> *NULL;
   isSorted = sortList(io_hList: io_hList.pAutoSortFnc);
else;
   isSorted = cTrue;
endif;

return isSorted;


end-proc performAutoSort;

//=========================================================================
//  *** private ***
//  Sorts the list.
//=========================================================================
dcl-proc sortList;

dcl-pi sortList
       ind;
  io_hList        likeds(hList_t  );
i_pSortFnc      pointer(*proc) const;
end-pi;

//  Return value
dcl-s isSorted        ind inz(cFalse);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (isSortedInternally(io_hList));
   isSorted = cTrue;
else;

   p_assert(g_pSortFnc = *NULL
            : 'g_pSortFnc should be NULL');

   // Set global variable to hold address of sort procedure
   g_pSortFnc = i_pSortFnc;

   // Sort list
   qsort(io_hList.pBase: io_hList.numE
                       : %size(pDummy)
                       : %paddr('qsortCallback'));

   // Set sort signature
   io_hList.sortSignature = io_hList.signature;

   // Clear global sort function pointer
   g_pSortFnc = *NULL;

   isSorted = cTrue;
endif;

return isSorted;


end-proc sortList;

//=========================================================================
//  *** private ***
//  Returns cTrue for a sorted list, else cFalse.                                       R
//=========================================================================
dcl-proc isSortedInternally;

dcl-pi isSortedInternally
       ind;
  i_hList         const  likeds(hList_t  );
end-pi;

//  Return value
dcl-s isSorted        ind inz(cFalse);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_hList.signature = i_hList.sortSignature;
   isSorted = cTrue;
else;
   isSorted = cFalse;
endif;

return isSorted;


end-proc isSortedInternally;

//=========================================================================
//  *** private ***
//  Searches the list for an entry using the data pointer of the entry
//=========================================================================
dcl-proc findEntryBySignature;

dcl-pi findEntryBySignature
       int(10);
  i_hList         const  likeds(hList_t    );
i_signature     const  likeds(signature_t);
end-pi;

//  Return value
dcl-s index           int(10) inz(-1);

//  List entry
dcl-ds listE likeds(listE_t    ) based(pListE);

//  Helper fields
dcl-s x               int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for x = 1 to i_hList.numE;
   pListE = getPointerListE(i_hList: x);
   if listE.signature = i_signature;
      index = x;
      leave;
   endif;
endfor;

return index;


end-proc findEntryBySignature;

//=========================================================================
//  *** private ***
//  Returns a new list signature.
//=========================================================================
dcl-proc Signature_new;

dcl-pi Signature_new
       likeds(signature_t );
end-pi;

//  Return value
dcl-ds signature likeds(signature_t ) inz;

//  Endless counter
dcl-s lastCounter     uns(10) inz           static;
dcl-s maxCounter      uns(10) inz(*HIVAL)   static;
dcl-ds now likeds(timeb_t ) inz;

dcl-pr ftime           int(10) extproc('ftime');
  tp              const  likeds(timeb_t);
end-pr;

dcl-ds timeb_t qualified               based(pDummy);
  time            int(10);
  millitm         int(10);
  timezone        int(10);
  dstflag         int(10);
end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// signature.tmStmp  = %timestamp();
/IF NOT DEFINED(*V5R3M0)
signature.time = time(*NULL);
signature.millitm = 0;
/ELSE
ftime(now);   // API introduced: V5R3
signature.time = now.time;
signature.millitm = now.millitm;
/ENDIF

if lastCounter < maxCounter;
   signature.counter = lastCounter + 1;
else;
   signature.counter = 1;
endif;

lastCounter = signature.counter;

return signature;


end-proc Signature_new;

//=========================================================================
//  *** private ***
//  Checks, whether a given handle is a valid list handle, or not.
//  Returns TRUE for a valid list handle, else FALSE.
//=========================================================================
dcl-proc checkListHandle;

dcl-pi checkListHandle;
  i_pList         const  like(BasicList_handle_t);
end-pi;

//  List handle
dcl-ds hList likeds(hList_t    ) based(i_pList);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (BasicList_isNull(i_pList));
   signalError(cERROR_LIST_HANDLE_NULL: f_caller());
endif;

if (hList.intType <> cHANDLE_TYPE_LIST);
   signalError(cERROR_LIST_HANDLE_INVALID: f_caller());
endif;

if (hList.intSize <> cHANDLE_SIZE);
   signalError(cERROR_LIST_HANDLE_INVALID: f_caller());
endif;

return;


end-proc checkListHandle;

//=========================================================================
//  *** private ***
//  Sends a DIAG message to signal a problem.
//=========================================================================
dcl-proc signalProblem;

dcl-pi signalProblem;
  i_text          varchar(128) const;
  i_proc          varchar(256) const;
end-pi;

//  Helper fields
dcl-ds msg likeds(msg_t ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

msg = f_newMsg('CPF9897'
               : 'BasicList: ERROR - ' + i_text
               : cMsg_Diag: 'QCPFMSG': '*LIBL');
f_sndPgmMsg(msg: cMsg_Same: i_proc);

return;


end-proc signalProblem;

//=========================================================================
//  *** private ***
//  Sends an ESCAPE message to signal an error condition.
//=========================================================================
dcl-proc signalError;

dcl-pi signalError;
  i_text          varchar(128) const;
  i_proc          varchar(256) const;
end-pi;

//  Helper fields
dcl-ds msg likeds(msg_t ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

msg = f_newMsg('CPF9898'
               : 'BasicList: ERROR - ' + i_text
               : cMsg_Escape: 'QCPFMSG': '*LIBL');
f_sndPgmMsg(msg: cMsg_Same: i_proc);

return;


end-proc signalError;

