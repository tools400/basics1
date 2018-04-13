      /IF NOT DEFINED(BASICS1RG)
      /DEFINE BASICS1RG
      *
     D BasicProperties_handle_t...
     D                 S               *                      based(pDummy)
      *
     D BasicProperties_decVal_t...
     D                 S             31P10                    based(pDummy)
      *
      *  Creates a new BasicProperties.
     D BasicProperties_new...
     D                 PR                         like(BasicProperties_handle_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_new+
     D                                     ')
     D  i_increment                  10U 0 const  options(*nopass: *omit)
     D  i_heapID                     10I 0 const  options(*nopass: *omit)
      *
      *  Clones a given BasicProperties.
     D BasicProperties_clone...
     D                 PR                         like(BasicProperties_handle_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_clone+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Load properties from a given physical file member.
     D BasicProperties_loadFromMember...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_loadFromMember+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_file                       10A   const  varying
     D  i_lib                        10A   const  varying
     D                                            options(*nopass: *omit)
     D  i_mbr                        10A   const  varying
     D                                            options(*nopass: *omit)
      *
      *  Load properties from a given stream file.
     D BasicProperties_loadFromStmf...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_loadFromStmf+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_stmf                     5000A   const  varying options(*varsize)
      *
      *  Removes the entry that is associated to the specified key.
     D BasicProperties_remove...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_remove+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t    )
     D                                            options(*varsize)
      *
      *  Returns true if the list of properties contains a entry matching
      *  the specified key value.
     D BasicProperties_containsKey...
     D                 PR              N
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_containsKey+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
      *
      *  Returns the string that is associated to the specified key.
     D BasicProperties_getString...
     D                 PR          4096A          varying
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getString+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                  4096A   const  varying
     D                                            options(*nopass: *varsize)
      *
      *  Returns the integer value that is associated to the specified key.
     D BasicProperties_getInteger...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getInteger+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                    10I 0 const  options(*nopass)
      *
      *  Returns the boolean value that is associated to the specified key.
     D BasicProperties_getBoolean...
     D                 PR              N
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getBoolean+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                      N   const  options(*nopass)
      *
      *  Returns the decimal value that is associated to the specified key.
     D BasicProperties_getDecimal...
     D                 PR                         like(BasicProperties_decVal_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getDecimal+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_default                          const  like(BasicProperties_decVal_t)
     D                                            options(*nopass)
      *
      *  Associates the specified string value to a given key.
     D BasicProperties_putString...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_putString+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_string                   4096A   const  varying
     D                                            options(*varsize)
      *
      *  Associates the specified integer value to a given key.
     D BasicProperties_putInteger...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_putInteger+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_integer                    10I 0 const
      *
      *  Associates the specified boolean value to a given key.
     D BasicProperties_putBoolean...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_putBoolean+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_boolean                      N   const
      *
      *  Associates the specified decimal value to a given key.
     D BasicProperties_putDecimal...
     D                 PR                         like(BasicProperties_decVal_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_putDecimal+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
     D  i_key                              const  like(BasicMap_key_t          )
     D                                            options(*varsize)
     D  i_decimal                          const  like(BasicProperties_decVal_t)
      *
      *  Returns the number of key-value mappings in this properties list.
     D BasicProperties_getNumE...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getNumE+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Returns the heap ID of a given BasicProperties.
     D BasicProperties_getHeapID...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_getHeapID+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Removes all entries from a given properties list.
     D BasicProperties_clear...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_clear+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Deletes a given BasicProperties.
     D BasicProperties_delete...
     D                 PR            10I 0
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_delete+
     D                                     ')
     D  io_pProperties...
     D                                            like(BasicProperties_handle_t)
      *
      *  Returns a BasicProperties NULL handle.
     D BasicProperties_null...
     D                 PR                         like(BasicProperties_handle_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_null+
     D                                     ')
      *
      *  Checks a given BasicProperties handle for a NULL value.
     D BasicProperties_isNull...
     D                 PR              N
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_isNull+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      *  Returns the list of key values from a given properties list.
     D BasicProperties_newKeySet...
     D                 PR                         like(BasicKeySet_handle_t)
     D                                     extproc('BASICS1RG+
     D                                     _BasicProperties_newKeySet+
     D                                     ')
     D  i_pProperties                      const  like(BasicProperties_handle_t)
      *
      * -----------------------------------------
      *  Imported prototypes
      * -----------------------------------------
      *
      /ENDIF
