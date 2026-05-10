**free
/if NOT DEFINED(BASICS1RG)
/define BASICS1RG

dcl-s BasicProperties_handle_t pointer based(pDummy);

dcl-s BasicProperties_decVal_t packed(31: 10) based(pDummy);

//  Creates a new BasicProperties.
dcl-pr BasicProperties_new like(BasicProperties_handle_t) extproc('BASICS1RG_BasicProperties_new');
  i_increment uns(10) options(*nopass: *omit) const;
  i_heapID    int(10) options(*nopass: *omit) const;
end-pr;

//  Clones a given BasicProperties.
dcl-pr BasicProperties_clone like(BasicProperties_handle_t)
  extproc('BASICS1RG_BasicProperties_clone');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Load properties from a given physical file member.
dcl-pr BasicProperties_loadFromMember int(10) extproc('BASICS1RG_BasicProperties_loadFromMember');
  i_pProperties like(BasicProperties_handle_t) const;
  i_file        varchar(10) const;
  i_lib         varchar(10) options(*nopass: *omit) const;
  i_mbr         varchar(10) options(*nopass: *omit) const;
end-pr;

//  Load properties from a given stream file.
dcl-pr BasicProperties_loadFromStmf int(10) extproc('BASICS1RG_BasicProperties_loadFromStmf');
  i_pProperties like(BasicProperties_handle_t) const;
  i_stmf        varchar(5000) options(*varsize) const;
end-pr;

//  Removes the entry that is associated to the specified key.
dcl-pr BasicProperties_remove int(10) extproc('BASICS1RG_BasicProperties_remove');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
end-pr;

//  Returns true if the list of properties contains a entry matching
//  the specified key value.
dcl-pr BasicProperties_containsKey ind extproc('BASICS1RG_BasicProperties_containsKey');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
end-pr;

//  Returns the string that is associated to the specified key.
dcl-pr BasicProperties_getString varchar(4096) extproc('BASICS1RG_BasicProperties_getString');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_default     varchar(4096) options(*nopass: *varsize) const;
end-pr;

//  Returns the integer value that is associated to the specified key.
dcl-pr BasicProperties_getInteger int(10) extproc('BASICS1RG_BasicProperties_getInteger');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_default     int(10) options(*nopass) const;
end-pr;

//  Returns the boolean value that is associated to the specified key.
dcl-pr BasicProperties_getBoolean ind extproc('BASICS1RG_BasicProperties_getBoolean');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_default     ind options(*nopass) const;
end-pr;

//  Returns the decimal value that is associated to the specified key.
dcl-pr BasicProperties_getDecimal like(BasicProperties_decVal_t)
  extproc('BASICS1RG_BasicProperties_getDecimal');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_default     like(BasicProperties_decVal_t) options(*nopass) const;
end-pr;

//  Associates the specified string value to a given key.
dcl-pr BasicProperties_putString int(10) extproc('BASICS1RG_BasicProperties_putString');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_string      varchar(4096) options(*varsize) const;
end-pr;

//  Associates the specified integer value to a given key.
dcl-pr BasicProperties_putInteger int(10) extproc('BASICS1RG_BasicProperties_putInteger');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_integer     int(10) const;
end-pr;

//  Associates the specified boolean value to a given key.
dcl-pr BasicProperties_putBoolean int(10) extproc('BASICS1RG_BasicProperties_putBoolean');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_boolean     ind const;
end-pr;

//  Associates the specified decimal value to a given key.
dcl-pr BasicProperties_putDecimal like(BasicProperties_decVal_t)
  extproc('BASICS1RG_BasicProperties_putDecimal');
  i_pProperties like(BasicProperties_handle_t) const;
  i_key         like(BasicMap_key_t) options(*varsize) const;
  i_decimal     like(BasicProperties_decVal_t) const;
end-pr;

//  Returns the number of key-value mappings in this properties list.
dcl-pr BasicProperties_getNumE int(10) extproc('BASICS1RG_BasicProperties_getNumE');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Returns the heap ID of a given BasicProperties.
dcl-pr BasicProperties_getHeapID int(10) extproc('BASICS1RG_BasicProperties_getHeapID');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Removes all entries from a given properties list.
dcl-pr BasicProperties_clear int(10) extproc('BASICS1RG_BasicProperties_clear');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Deletes a given BasicProperties.
dcl-pr BasicProperties_delete int(10) extproc('BASICS1RG_BasicProperties_delete');
  io_pProperties like(BasicProperties_handle_t);
end-pr;

//  Returns a BasicProperties NULL handle.
dcl-pr BasicProperties_null like(BasicProperties_handle_t) extproc('BASICS1RG_BasicProperties_null')
  ;
end-pr;

//  Checks a given BasicProperties handle for a NULL value.
dcl-pr BasicProperties_isNull ind extproc('BASICS1RG_BasicProperties_isNull');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

//  Returns the list of key values from a given properties list.
dcl-pr BasicProperties_newKeySet like(BasicKeySet_handle_t)
  extproc('BASICS1RG_BasicProperties_newKeySet');
  i_pProperties like(BasicProperties_handle_t) const;
end-pr;

// -----------------------------------------
//  Imported prototypes
// -----------------------------------------

/endif