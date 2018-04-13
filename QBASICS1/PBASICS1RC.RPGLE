      /IF NOT DEFINED(BASICS1RC)
      /DEFINE BASICS1RC
      *
     D BasicMap_handle_t...
     D                 S                   like(BasicList_handle_t)
     D                                                     based(pDummy)
     D BasicMap_key_t...
     D                 S           4096A   varying         based(pDummy)
      *
     D BasicKeySet_handle_t...
     D                 S               *                   based(pDummy)
      *
      *  Creates a new BasicMap.
     D BasicMap_new...
     D                 PR                         like(BasicMap_handle_t )
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_new+
     D                                     ')
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Clones a given BasicMap.
     D BasicMap_clone...
     D                 PR                         like(BasicMap_handle_t )
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_clone+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Removes the mapping for this key from this map if it is present.
     D BasicMap_remove...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_remove+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns true if this map contains a mapping for the specified key.
     D BasicMap_containsKey...
     D                 PR              N
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_containsKey+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns the value to which this map maps the specified key.
     D BasicMap_get...
     D                 PR              *
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_get+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Returns the string value to which this map maps the specified key.
     D BasicMap_getString...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getString+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns the integer value to which this map maps the specified key.
     D BasicMap_getInteger...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getInteger+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns the value addressed by a given index.
     D BasicMap_getValueByIndex...
     D                 PR              *
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getValueByIndex+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
     D  i_pEntry                       *   const  options(*nopass)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Returns the key addressed by a given index.
     D BasicMap_getKeyByIndex...
     D                 PR                         like(BasicMap_key_t )
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getKeyByIndex+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
     D BasicMap_put...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_put+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_pEntry                       *   const  options(*string)
     D  i_length                     10I 0 const  options(*nopass)
      *
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
     D BasicMap_putString...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_putString+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_string                   4096A   const  varying
      *
      *  Associates the specified value with the specified key in this map.
      *  If the map previously contained a mapping for this key, the old
      *  value is replaced by the specified value.
     D BasicMap_putInteger...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_putInteger+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
     D  i_integer                    10I 0 const
      *
      *  Returns the size of of the element that is associated with this key.
     D BasicMap_getSize...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getSize+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns the size of of the element that is addressed by a given index.
     D BasicMap_getSizeByIndex...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getSizeByIndex+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_index                      10I 0 const
      *
      *  Returns the number of key-value mappings in this map.
     D BasicMap_getNumE...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getNumE+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Returns the heap ID of a given BasicMap.
     D BasicMap_getHeapID...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getHeapID+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Returns a list of all keys that are in a given map.
     D BasicMap_getKeys...
     D                 PR                         like(BasicList_handle_t)
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getKeys+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_pSortFnc                     *   const  procptr
     D                                            options(*nopass)
      *
      *  Returns a list of all values that are in a given map.
     D BasicMap_getValues...
     D                 PR                         like(BasicList_handle_t)
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_getValues+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
     D  i_pSortFnc                     *   const  procptr
     D                                            options(*nopass)
      *
      *  Removes all entries from a given map.
     D BasicMap_clear...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_clear+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Deletes a given BasicMap.
     D BasicMap_delete...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_delete+
     D                                     ')
     D  io_pMap                                   like(BasicMap_handle_t )
      *
      *  Returns a BasicMap NULL handle.
     D BasicMap_null...
     D                 PR                         like(BasicMap_handle_t )
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_null+
     D                                     ')
      *
      *  Checks a given BasicMap handle for a NULL value.
     D BasicMap_isNull...
     D                 PR              N
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_isNull+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Produces a list of keys from a given map.
     D BasicMap_newKeySet...
     D                 PR                         like(BasicKeySet_handle_t)
     D                                     extproc('BASICS1RC+
     D                                     _BasicMap_newKeySet+
     D                                     ')
     D  i_pMap                             const  like(BasicMap_handle_t )
      *
      *  Returns the first entry of a given key set.
     D BasicKeySet_getFirst...
     D                 PR                         like(BasicMap_key_t    )
     D                                     extproc('BASICS1RC+
     D                                     _BasicKeySet_getFirst+
     D                                     ')
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  Returns the next entry of a given key set.
     D BasicKeySet_getNext...
     D                 PR                         like(BasicMap_key_t    )
     D                                     extproc('BASICS1RC+
     D                                     _BasicKeySet_getNext+
     D                                     ')
     D  i_pKeySet                          const  like(BasicKeySet_handle_t)
      *
      *  Deletes the key list associated to a given map.
     D BasicKeySet_delete...
     D                 PR            10I 0
     D                                     extproc('BASICS1RC+
     D                                     _BasicKeySet_delete+
     D                                     ')
     D  io_pKeySet                                like(BasicKeySet_handle_t)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1RA                    BasicList
      /COPY QBASICS1,PBASICS1R4                    Assert/This/Caller
      *
      /ENDIF
