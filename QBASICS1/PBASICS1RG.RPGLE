**FREE
/IF NOT DEFINED(BASICS1RG)
/DEFINE BASICS1RG

dcl-s BasicProperties_handle_t
      pointer based(pDummy);

dcl-s BasicProperties_decVal_t
      packed(31:10) based(pDummy);

//  Creates a new BasicProperties.
dcl-pr BasicProperties_new
       like(BasicProperties_handle_t)
       extproc('BASICS1RG+
       _BasicProperties_new+
       ');
  i_increment     uns(10) const  options(*nopass: *omit);
  i_heapID        int(10) const  options(*nopass: *omit);
end-pr;

//  Clones a given BasicProperties.
dcl-pr BasicProperties_clone
       like(BasicProperties_handle_t)
       extproc('BASICS1RG+
       _BasicProperties_clone+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

//  Load properties from a given physical file member.
dcl-pr BasicProperties_loadFromMember
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_loadFromMember+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_file          varchar(10) const;
  i_lib           varchar(10) const
       options(*nopass: *omit);
  i_mbr           varchar(10) const
       options(*nopass: *omit);
end-pr;

//  Load properties from a given stream file.
dcl-pr BasicProperties_loadFromStmf
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_loadFromStmf+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_stmf          varchar(5000) const   options(*varsize);
end-pr;

//  Removes the entry that is associated to the specified key.
dcl-pr BasicProperties_remove
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_remove+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t    )
       options(*varsize);
end-pr;

//  Returns true if the list of properties contains a entry matching
//  the specified key value.
dcl-pr BasicProperties_containsKey
       ind
       extproc('BASICS1RG+
       _BasicProperties_containsKey+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
end-pr;

//  Returns the string that is associated to the specified key.
dcl-pr BasicProperties_getString
       varchar(4096)
       extproc('BASICS1RG+
       _BasicProperties_getString+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_default       varchar(4096) const
       options(*nopass: *varsize);
end-pr;

//  Returns the integer value that is associated to the specified key.
dcl-pr BasicProperties_getInteger
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_getInteger+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_default       int(10) const  options(*nopass);
end-pr;

//  Returns the boolean value that is associated to the specified key.
dcl-pr BasicProperties_getBoolean
       ind
       extproc('BASICS1RG+
       _BasicProperties_getBoolean+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_default       ind const  options(*nopass);
end-pr;

//  Returns the decimal value that is associated to the specified key.
dcl-pr BasicProperties_getDecimal
       like(BasicProperties_decVal_t)
       extproc('BASICS1RG+
       _BasicProperties_getDecimal+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_default       const  like(BasicProperties_decVal_t)
       options(*nopass);
end-pr;

//  Associates the specified string value to a given key.
dcl-pr BasicProperties_putString
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_putString+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_string        varchar(4096) const
       options(*varsize);
end-pr;

//  Associates the specified integer value to a given key.
dcl-pr BasicProperties_putInteger
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_putInteger+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_integer       int(10) const;
end-pr;

//  Associates the specified boolean value to a given key.
dcl-pr BasicProperties_putBoolean
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_putBoolean+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_boolean       ind const;
end-pr;

//  Associates the specified decimal value to a given key.
dcl-pr BasicProperties_putDecimal
       like(BasicProperties_decVal_t)
       extproc('BASICS1RG+
       _BasicProperties_putDecimal+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
  i_key           const  like(BasicMap_key_t          )
       options(*varsize);
  i_decimal       const  like(BasicProperties_decVal_t);
end-pr;

//  Returns the number of key-value mappings in this properties list.
dcl-pr BasicProperties_getNumE
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_getNumE+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

//  Returns the heap ID of a given BasicProperties.
dcl-pr BasicProperties_getHeapID
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_getHeapID+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

//  Removes all entries from a given properties list.
dcl-pr BasicProperties_clear
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_clear+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

//  Deletes a given BasicProperties.
dcl-pr BasicProperties_delete
       int(10)
       extproc('BASICS1RG+
       _BasicProperties_delete+
       ');
  io_pProperties
       like(BasicProperties_handle_t);
end-pr;

//  Returns a BasicProperties NULL handle.
dcl-pr BasicProperties_null
       like(BasicProperties_handle_t)
       extproc('BASICS1RG+
       _BasicProperties_null+
       ');
end-pr;

//  Checks a given BasicProperties handle for a NULL value.
dcl-pr BasicProperties_isNull
       ind
       extproc('BASICS1RG+
       _BasicProperties_isNull+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

//  Returns the list of key values from a given properties list.
dcl-pr BasicProperties_newKeySet
       like(BasicKeySet_handle_t)
       extproc('BASICS1RG+
       _BasicProperties_newKeySet+
       ');
  i_pProperties   const  like(BasicProperties_handle_t);
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/ENDIF
