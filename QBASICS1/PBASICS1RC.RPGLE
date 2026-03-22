**FREE
/IF NOT DEFINED(BASICS1RC)
/DEFINE BASICS1RC

dcl-s BasicMap_handle_t
      like(BasicList_handle_t) based(pDummy);
dcl-s BasicMap_key_t
      varchar(4096) based(pDummy);

dcl-s BasicKeySet_handle_t
      pointer based(pDummy);

//  Creates a new BasicMap.
dcl-pr BasicMap_new
       like(BasicMap_handle_t )
       extproc('BASICS1RC+
       _BasicMap_new+
       ');
  i_increment     uns(10) const  options(*nopass: *omit);
  i_heapID        int(10) const  options(*nopass: *omit);
end-pr;

//  Clones a given BasicMap.
dcl-pr BasicMap_clone
       like(BasicMap_handle_t )
       extproc('BASICS1RC+
       _BasicMap_clone+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Removes the mapping for this key from this map if it is present.
dcl-pr BasicMap_remove
       int(10)
       extproc('BASICS1RC+
       _BasicMap_remove+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns true if this map contains a mapping for the specified key.
dcl-pr BasicMap_containsKey
       ind
       extproc('BASICS1RC+
       _BasicMap_containsKey+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns the value to which this map maps the specified key.
dcl-pr BasicMap_get
       pointer
       extproc('BASICS1RC+
       _BasicMap_get+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
  i_pEntry        pointer const  options(*nopass);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Returns the string value to which this map maps the specified key.
dcl-pr BasicMap_getString
       varchar(4096)
       extproc('BASICS1RC+
       _BasicMap_getString+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns the integer value to which this map maps the specified key.
dcl-pr BasicMap_getInteger
       int(10)
       extproc('BASICS1RC+
       _BasicMap_getInteger+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns the value addressed by a given index.
dcl-pr BasicMap_getValueByIndex
       pointer
       extproc('BASICS1RC+
       _BasicMap_getValueByIndex+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_index         int(10) const;
  i_pEntry        pointer const  options(*nopass);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Returns the key addressed by a given index.
dcl-pr BasicMap_getKeyByIndex
       like(BasicMap_key_t )
       extproc('BASICS1RC+
       _BasicMap_getKeyByIndex+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_index         int(10) const;
end-pr;

//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
dcl-pr BasicMap_put
       int(10)
       extproc('BASICS1RC+
       _BasicMap_put+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
  i_pEntry        pointer const  options(*string);
  i_length        int(10) const  options(*nopass);
end-pr;

//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
dcl-pr BasicMap_putString
       int(10)
       extproc('BASICS1RC+
       _BasicMap_putString+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
  i_string        varchar(4096) const;
end-pr;

//  Associates the specified value with the specified key in this map.
//  If the map previously contained a mapping for this key, the old
//  value is replaced by the specified value.
dcl-pr BasicMap_putInteger
       int(10)
       extproc('BASICS1RC+
       _BasicMap_putInteger+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
  i_integer       int(10) const;
end-pr;

//  Returns the size of of the element that is associated with this key.
dcl-pr BasicMap_getSize
       int(10)
       extproc('BASICS1RC+
       _BasicMap_getSize+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns the size of of the element that is addressed by a given index.
dcl-pr BasicMap_getSizeByIndex
       int(10)
       extproc('BASICS1RC+
       _BasicMap_getSizeByIndex+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_index         int(10) const;
end-pr;

//  Returns the number of key-value mappings in this map.
dcl-pr BasicMap_getNumE
       int(10)
       extproc('BASICS1RC+
       _BasicMap_getNumE+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Returns the heap ID of a given BasicMap.
dcl-pr BasicMap_getHeapID
       int(10)
       extproc('BASICS1RC+
       _BasicMap_getHeapID+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Returns a list of all keys that are in a given map.
dcl-pr BasicMap_getKeys
       like(BasicList_handle_t)
       extproc('BASICS1RC+
       _BasicMap_getKeys+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_pSortFnc      pointer(*proc) const
       options(*nopass);
end-pr;

//  Returns a list of all values that are in a given map.
dcl-pr BasicMap_getValues
       like(BasicList_handle_t)
       extproc('BASICS1RC+
       _BasicMap_getValues+
       ');
  i_pMap          const  like(BasicMap_handle_t );
  i_pSortFnc      pointer(*proc) const
       options(*nopass);
end-pr;

//  Removes all entries from a given map.
dcl-pr BasicMap_clear
       int(10)
       extproc('BASICS1RC+
       _BasicMap_clear+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Deletes a given BasicMap.
dcl-pr BasicMap_delete
       int(10)
       extproc('BASICS1RC+
       _BasicMap_delete+
       ');
  io_pMap         like(BasicMap_handle_t );
end-pr;

//  Returns a BasicMap NULL handle.
dcl-pr BasicMap_null
       like(BasicMap_handle_t )
       extproc('BASICS1RC+
       _BasicMap_null+
       ');
end-pr;

//  Checks a given BasicMap handle for a NULL value.
dcl-pr BasicMap_isNull
       ind
       extproc('BASICS1RC+
       _BasicMap_isNull+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Produces a list of keys from a given map.
dcl-pr BasicMap_newKeySet
       like(BasicKeySet_handle_t)
       extproc('BASICS1RC+
       _BasicMap_newKeySet+
       ');
  i_pMap          const  like(BasicMap_handle_t );
end-pr;

//  Returns the first entry of a given key set.
dcl-pr BasicKeySet_getFirst
       like(BasicMap_key_t    )
       extproc('BASICS1RC+
       _BasicKeySet_getFirst+
       ');
  i_pKeySet       const  like(BasicKeySet_handle_t);
end-pr;

//  Returns the next entry of a given key set.
dcl-pr BasicKeySet_getNext
       like(BasicMap_key_t    )
       extproc('BASICS1RC+
       _BasicKeySet_getNext+
       ');
  i_pKeySet       const  like(BasicKeySet_handle_t);
end-pr;

//  Deletes the key list associated to a given map.
dcl-pr BasicKeySet_delete
       int(10)
       extproc('BASICS1RC+
       _BasicKeySet_delete+
       ');
  io_pKeySet      like(BasicKeySet_handle_t);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------
/COPY QBASICS1,PBASICS1RA                    BasicList
/COPY QBASICS1,PBASICS1R4                    Assert/This/Caller

/ENDIF
